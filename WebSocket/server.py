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
        self.queue = [Person(1,None),Person(2,None),Person(3,None),Person(4,None),Person(5,None),Person(6,None)]
        self.counters = [Counter(3),Counter(5)]
    def ticketsInQueue(self):
        return  [person.ticketNumber for person in self.queue if person.ticketNumber is not None]

class QueueToSendInfo:
    def __init__(self, queue):
        self.tickets = queue.ticketsInQueue()
        self.counters = queue.counters


class Person:
    def __init__(self, ticketNumber, connection):
        self.ticketNumber = ticketNumber
        self.connection = connection

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
        response = {'action': 'sent_queue_info', 'queue': json.loads(QueueEncoder().encode(QueueToSendInfo(queue_1)))}
        await websocket.send(json.dumps(response))

        while True:
            message = await websocket.recv()
            print(f"Received message: {message}")

            # Parse the received JSON message
            try:
                data = json.loads(message)

                # Check if the message contains a 'client_type' key
                if 'client_type' in data:
                    client_type = data['client_type']

                    # Check if message comes from a person standing in queue (using the app)
                    if client_type == 'person':
                        # Check if the message contains an 'action' key
                        if 'action' in data:
                            action = data['action']

                            if action == 'get_queue_info':
                                # Send the current array to the client
                                response = {'action': 'sent_queue_info', 'queue': json.loads(QueueEncoder().encode(queue_1))}
                                await websocket.send(json.dumps(response))

                            elif action == 'add_number':
                                # Add a number one larger than the largest number to the array
                                new_number = queue_1.ticketsInQueue()[-1] + 1
                                queue_1.queue.append(Person(new_number, websocket))

                                # Send the new number to the client
                                response = {'action': 'added_number', 'number': new_number}
                                await websocket.send(json.dumps(response))

                                # Broadcast the updated array to all connected clients
                                response = {'action': 'update_numbers', 'numbers': queue_1.ticketsInQueue()}
                                await asyncio.gather(*[client.send(json.dumps(response)) for client in connections])

                            elif action == 'leave_queue':

                                if 'number' in data:
                                    del queue_1.queue[queue_1.ticketsInQueue().index(data['number'])]

                                # Broadcast the updated array to all connected clients
                                response = {'action': 'update_numbers', 'numbers': queue_1.ticketsInQueue()}
                                await asyncio.gather(*[client.send(json.dumps(response)) for client in connections])

                    # Check if message comes from an operator, person at the counter (using web page)
                    elif client_type == 'operator':
                        # Check if the message contains an 'action' key
                        if 'action' in data:
                            action = data['action']

                            if action == 'open_counter':

                                if 'id_number' in data:
                                    idNumber = data['id_number']
                                    newCounter = Counter(idNumber)
                                    queue_1.counters.append(newCounter)

                                    # Broadcast the updated counters to all connected clients
                                    response = {'action': 'update_counters', 'counters': json.loads(QueueEncoder().encode(newCounter))}
                                    await asyncio.gather(*[client.send(json.dumps(response)) for client in connections])




            except json.JSONDecodeError:
                print("Invalid JSON format")

    except websockets.exceptions.ConnectionClosedOK:
        print("Client disconnected")


start_server = websockets.serve(handle_websocket, "localhost", 3000)

print("WebSocket server is running...")
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
