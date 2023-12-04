import asyncio
import json
import websockets
from json import JSONEncoder

# Specify the path to Json file with Offices infomrations
json_file_path = 'Urzedy.json'


# Read the JSON file
with open(json_file_path, 'r') as file:
    offices_information = json.load(file)


# This is an example of server for Urząd Dzielnicy Ursynów
office_name = 'Urząd Dzielnicy Ursynów'
office_matters = offices_information[office_name]

class Office:
    def __init__(self, name, matters):
        self.name = name
        self.matters = matters
        self.queues = self.generateQueues()

    def generateQueues(self):
        queues = {}
        for matter in self.matters:
            queues[matter] = Queue(matter)
        return queues


class Counter:
    def __init__(self, idNumber, servedTicket=None):
        self.idNumber = idNumber
        self.servedTicket = servedTicket


class Queue:
    def __init__(self, matter):
        self.queue = [Person("1", None), Person("2", None), Person("3", None), Person("4", None), Person("5", None),
                      Person("6", None)]
        self.counters = [Counter(3,servedTicket=Person("1",None)), Counter(5,servedTicket=Person("2",None))]
        self.matter = matter
        self.connections = set()


    def ticketsInQueue(self):
        return [person.ticketNumber for person in self.queue if person.ticketNumber is not None]

    def find_counter_by_id(self, id_number):
        for counter in self.counters:
            if counter.idNumber == id_number:
                return counter
        return None


class QueueToSendInfo:
    def __init__(self, queue):
        self.tickets = queue.ticketsInQueue()
        self.counters = []

        for counter in queue.counters:
            new_counter = Counter(counter.idNumber,
                                  counter.servedTicket.ticketNumber if counter.servedTicket else None)
            self.counters.append(new_counter)


class Person:
    def __init__(self, ticketNumber, connection):
        self.ticketNumber = ticketNumber
        self.connection = connection


class QueueEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__

# def validateMessage(message):
#     keys = ["matter", "client_type", "action"]
#     values = {"matter": office_matters, "client_type": ["operator", "person"], "action": }
#     if all(element in message for element in keys):
#

office = Office(office_name, office_matters)
queues = office.generateQueues()


async def handle_websocket(websocket, path):
    global queues

    print(f"Client connected from {websocket.remote_address}")

    try:
        response = {'action': 'sent_offices_info', 'offices_info': offices_information}
        await websocket.send(json.dumps(response))

        while True:
            message = await websocket.recv()
            print(f"Received message: {message}")

            # Parse the received JSON message
            try:
                data = json.loads(message)

                if 'matter' in data and data['matter'] in queues.keys():
                    print("correct")
                    matter = data['matter']
                    queue = queues[matter]

                    queue.connections.add(websocket)

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
                                    response = {'action': 'sent_queue_info',
                                                'queue': json.loads(QueueEncoder().encode(QueueToSendInfo(queue)))}
                                    await websocket.send(json.dumps(response))

                                elif action == 'add_number':
                                    # Add a number one larger than the largest number to the array
                                    new_number = str(int(queue.ticketsInQueue()[-1]) + 1)
                                    queue.queue.append(Person(new_number, websocket))

                                    # Send the new number to the client
                                    response = {'action': 'added_number', 'number': new_number}
                                    await websocket.send(json.dumps(response))

                                    # Broadcast the updated array to all connected clients
                                    response = {'action': 'update_numbers', 'numbers': queue.ticketsInQueue()}
                                    await asyncio.gather(*[client.send(json.dumps(response)) for client in queue.connections])

                                elif action == 'leave_queue':

                                    if 'number' in data:
                                        del queue.queue[queue.ticketsInQueue().index(data['number'])]

                                    # Broadcast the updated array to all connected clients
                                    response = {'action': 'update_numbers', 'numbers': queue.ticketsInQueue()}
                                    await asyncio.gather(*[client.send(json.dumps(response)) for client in queue.connections])

                        # Check if message comes from an operator, person at the counter (using web page)
                        elif client_type == 'operator':
                            # Check if the message contains an 'action' key
                            if 'action' in data:
                                action = data['action']

                                if action == 'open_counter':

                                    if 'id_number' in data:
                                        id_number = data['id_number']
                                        new_counter = Counter(id_number)
                                        queue.counters.append(new_counter)

                                        # Broadcast the updated counters to all connected clients
                                        response = {'action': 'update_counters',
                                                    'new_counters': json.loads(QueueEncoder().encode(queue.counters))}
                                        print(queue.connections)
                                        await asyncio.gather(*[client.send(json.dumps(response)) for client in queue.connections])

                                elif action == 'close_counter':

                                    if 'id_number' in data:
                                        id_number_to_close = data['id_number']

                                        queue.counters = [counter for counter in queue.counters if
                                                            counter.idNumber != id_number_to_close]

                                        # Broadcast the updated counters to all connected clients
                                        response = {'action': 'update_counters',
                                                    'new_counters': json.loads(QueueEncoder().encode(queue.counters))}
                                        await asyncio.gather(*[client.send(json.dumps(response)) for client in queue.connections])

                                elif action == 'serve_next_number':

                                    if 'id_number' in data:
                                        id_number = data['id_number']
                                        new_person = queue.queue[0]
                                        queue.find_counter_by_id(id_number).servedTicket = queue.queue[0]
                                        del queue.queue[0]

                                        response = {'action': 'sent_queue_info',
                                                    'queue': json.loads(QueueEncoder().encode(QueueToSendInfo(queue)))}
                                        await asyncio.gather(*[client.send(json.dumps(response)) for client in queue.connections])

                                        if new_person.connection:
                                            response = {'action': 'go_to_counter',
                                                        'counter_id': id_number}
                                            await new_person.connection.send(json.dumps(response))


                                    else:
                                        print("Missing the id_number key")

                                else:
                                    print("The action provided is not possible as a value")

                            else:
                                print("Missing the action key")

                        else:
                            print("The client_type provided is not possible as a value")

                    else:
                        print("Missing the client_type key")

                else:
                    print("Invalid key or value for specifying the matter")

            except json.JSONDecodeError:
                print("Invalid JSON format")

    except websockets.exceptions.ConnectionClosedOK:
        print("Client disconnected")


start_server = websockets.serve(handle_websocket, "192.168.1.107", 3000)

print("WebSocket server is running...")
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
