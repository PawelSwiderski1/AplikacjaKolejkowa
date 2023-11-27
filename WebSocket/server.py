import asyncio
import json
import websockets
from json import JSONEncoder

class Counter:
    def __init__(self, idNumber):
        self.idNumber = idNumber
        self.servedTicket = None
class Queue:
    def __init__(self):
        self.numbers_array = [1,2,3,4,5,6]
        self.counters_array = [Counter(3),Counter(5)]

class QueueEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__

queue_1 = Queue()
connections = set()

async def handle_websocket(websocket, path):
    global queue_1
    connections.add(websocket)
    print(f"Client connected from {websocket.remote_address}")

    try:

        while True:
            message = await websocket.recv()
            print(f"Received message: {message}")

            # Parse the received JSON message
            try:
                data = json.loads(message)

                # Check if the message contains an 'action' key
                if 'action' in data:
                    action = data['action']

                    if action == 'get_queue_info':
                        # Send the current array to the client
                        response = {'action': 'sent_queue_info', 'queue': json.loads(QueueEncoder().encode(queue_1))}
                        await websocket.send(json.dumps(response))

                    elif action == 'add_number':
                        # Add a number one larger than the largest number to the array
                        new_number = max(queue_1.numbers_array) + 1
                        queue_1.numbers_array.append(new_number)

                        # Send the new number to the client
                        response = {'action': 'added_number', 'number': new_number}
                        await websocket.send(json.dumps(response))

                        # Broadcast the updated array to all connected clients
                        response = {'action': 'update_numbers', 'numbers': queue_1.numbers_array}
                        await asyncio.gather(*[client.send(json.dumps(response)) for client in connections])

                    elif action == 'leave_queue':

                        if 'number' in data:
                            queue_1.numbers_array.remove(data['number'])

                        # Broadcast the updated array to all connected clients
                        response = {'action': 'update_numbers', 'numbers': queue_1.numbers_array}
                        await asyncio.gather(*[client.send(json.dumps(response)) for client in connections])


            except json.JSONDecodeError:
                print("Invalid JSON format")

    except websockets.exceptions.ConnectionClosedOK:
        print("Client disconnected")


start_server = websockets.serve(handle_websocket, "localhost", 3000)

print("WebSocket server is running...")
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
