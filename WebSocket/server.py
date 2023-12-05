import asyncio
import json
from json import JSONEncoder

import websockets

# Specify the path to Json file with Offices infomrations
json_file_path = 'Urzedy.json'

# Read the JSON file
with open(json_file_path, 'r') as file:
    offices_information = json.load(file)

# This is an example of server for Urząd Dzielnicy Ursynów
office_name = 'Urząd Dzielnicy Ursynów'
office_matters = offices_information[office_name]


# Class holding information about Office (Urząd)
class Office:
    def __init__(self, name, matters):
        self.name = name  # Name of the office (Nazwa urzędu)
        self.matters = matters  # List of matters in the office (Lista spraw w urzędzie)
        self.queues = self.generateQueues()  # We generate queue for every matter in the office

    def generateQueues(self):
        queues = {}
        for matter in self.matters:
            queues[matter] = Queue(matter)
        return queues


# Class holding information about a Counter (Okienko)
class Counter:
    def __init__(self, idNumber, servedTicket=None):
        self.idNumber = idNumber  # Counter is initialized with id and ticket that its serving
        self.servedTicket = servedTicket

    # Class holding information about a Queue (Kolejka)


class Queue:
    def __init__(self, matter):  # We initialize queue with matter because there is a seperate queue for every matter
        self.people = [Person("3", None), Person("4", None), Person("5", None), Person("6", None)]
        # People waiting in the queue. In the final product this should be an empty array, but for presentation
        # we want to show user joining to a non-empty array

        self.counters = [Counter(3, servedTicket=Person("1", None)), Counter(5, servedTicket=Person("2", None))]
        # Same here, in the final product this should be an empty array

        self.matter = matter
        self.connections = set()  # We keep track of the clients connected to the queue

    # We want to extract tickets form people in queue, because we don't want to send to the
    # app People objects, because the app doesn't need connections
    def ticketsInQueue(self):
        return [person.ticketNumber for person in self.people if person.ticketNumber is not None]

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


# Class holding information about a person waiting in a queue (Osoba w kolejce)
class Person:
    def __init__(self, ticketNumber, connection):
        self.ticketNumber = ticketNumber  # The ticket of a person in a queue
        self.connection = connection
        # Connection, so that server knows where to send message to a specific person


class QueueEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__


# We want to check if message coming to server contains certain keys and values
def validateMessage(message, valid_matters, valid_actions, valid_client_types):
    # Check if the "matter" key is present and its value is in the valid_matters array
    if "matter" in message and message["matter"] in valid_matters:
        # Check if the "client_type" key is present and its value is in the valid_actions array
        if "client_type" in message and message["client_type"] in valid_client_types:
            # Check if the "action" key is present and its value is in the valid_client_types array
            if "action" in message and message["action"] in valid_actions[message["client_type"]]:
                # If the "client_type" key is "operator" than check if "id_number" key is present
                if message["client_type"] == "operator":
                    if "id_number" in message:
                        return True
                    return False
                return True

    # If any condition fails, return False
    return False


# Server client can be either the person waiting in a queue are an operator at the counter
valid_client_types = ["operator", "person"]

# Dictionary of valid actions for given client_type
valid_actions = {"operator": ["get_queue_info", "open_counter", "close_counter", "serve_next_number"],
                 "person": ["get_queue_info", "add_number", "leave_queue"]}

# We initialize our office, in our case its Urząd Dzielnicy Ursynów, and the queues
office = Office(office_name, office_matters)
queues = office.generateQueues()


async def handle_websocket(websocket, path):
    global queues

    print(f"Client connected from {websocket.remote_address}")

    try:
        # Instantly after connecting information about offices is sent, so that app
        # can display the list of offices and matters
        response = {'action': 'sent_offices_info', 'offices_info': offices_information}
        await websocket.send(json.dumps(response))

        while True:
            message = await websocket.recv()
            print(f"Received message: {message}")

            # Parse the received JSON message
            try:
                data = json.loads(message)

                if validateMessage(data, office_matters, valid_actions, valid_client_types):
                    action = data['action']
                    client_type = data['client_type']
                    matter = data['matter']
                    queue = queues[matter]

                    queue.connections.add(websocket)
                    print(queue.connections)

                    match client_type:
                        # Check if message comes from a person standing in queue (using the app)
                        case 'person':
                            # Check if the message contains an 'action' key

                            match action:

                                case 'get_queue_info':
                                    # Send the current array to the client
                                    response = {'action': 'sent_queue_info',
                                                'queue': json.loads(QueueEncoder().encode(QueueToSendInfo(queue)))}
                                    await websocket.send(json.dumps(response))

                                case 'add_number':
                                    # We check if the person that want to join the queue isn't already in it
                                    if not any(person.connection == websocket for person in queue.people):
                                        # Add a number one larger than the largest number
                                        # to the array or 1 if array is empty
                                        if queue.ticketsInQueue():
                                            new_number = str(int(queue.ticketsInQueue()[-1]) + 1)
                                        else:
                                            new_number = "1"
                                        queue.people.append(Person(new_number, websocket))

                                        # Send the new number to the client
                                        response = {'action': 'added_number', 'number': new_number}
                                        await websocket.send(json.dumps(response))

                                        # Broadcast the updated array to all connected clients
                                        response = {'action': 'update_numbers', 'numbers': queue.ticketsInQueue()}
                                        await asyncio.gather(
                                            *[client.send(json.dumps(response)) for client in queue.connections])

                                case 'leave_queue':
                                    # Check if 'number' is provided so that we know who leaves the queue
                                    if 'number' in data:
                                        del queue.people[queue.ticketsInQueue().index(data['number'])]

                                        # Broadcast the updated array to all connected clients
                                        response = {'action': 'update_numbers', 'numbers': queue.ticketsInQueue()}
                                        await asyncio.gather(
                                            *[client.send(json.dumps(response)) for client in queue.connections])

                        # Check if message comes from an operator, person at the counter (using web page)
                        case 'operator':

                            counter_id = data['id_number']
                            counter = queue.find_counter_by_id(counter_id)

                            match action:

                                case 'open_counter':

                                    new_counter = Counter(counter_id)
                                    queue.counters.append(new_counter)

                                    # Broadcast the updated counters to all connected clients
                                    response = {'action': 'update_counters',
                                                'new_counters': json.loads(QueueEncoder().encode(queue.counters))}
                                    await asyncio.gather(
                                        *[client.send(json.dumps(response)) for client in queue.connections])

                                case 'close_counter':

                                    queue.counters = [counter for counter in queue.counters if
                                                      counter.idNumber != counter_id]

                                    # Broadcast the updated counters to all connected clients
                                    response = {'action': 'update_counters',
                                                'new_counters': json.loads(QueueEncoder().encode(queue.counters))}
                                    await asyncio.gather(
                                        *[client.send(json.dumps(response)) for client in queue.connections])

                                case 'serve_next_number':

                                    if queue.people:

                                        if counter.servedTicket and counter.servedTicket.connection:
                                            response = {'action': 'visit_over'}
                                            await counter.servedTicket.connection.send(json.dumps(response))

                                            queue.connections.discard(counter.servedTicket.connection)

                                        new_person = queue.people[0]
                                        counter.servedTicket = queue.people[0]
                                        del queue.people[0]

                                        response = {'action': 'sent_queue_info',
                                                    'queue': json.loads(QueueEncoder().encode(QueueToSendInfo(queue)))}
                                        await asyncio.gather(
                                            *[client.send(json.dumps(response)) for client in queue.connections])

                                        if new_person.connection:
                                            response = {'action': 'go_to_counter',
                                                        'counter_id': counter_id}
                                            await new_person.connection.send(json.dumps(response))

                else:
                    print("Invalid message format")

            except json.JSONDecodeError:
                print("Invalid JSON format")

    except websockets.exceptions.ConnectionClosedError as e:

        print(f"Connection closed: {e}")
        try:
            if websocket in queue.connections:
                queue.connections.discard(websocket)

                queue.people = [person for person in queue.people if person.connection != websocket]

        except:
            pass

    except websockets.exceptions.ConnectionClosedOK:

        print("Client disconnected")
        try:
            if websocket in queue.connections:
                queue.connections.discard(websocket)

                queue.people = [person for person in queue.people if person.connection != websocket]

        except:
            pass

    finally:

        print("Cleaning up resources")

        # Add any cleanup code or resource release here if needed


start_server = websockets.serve(handle_websocket, "192.168.1.106", 3000)

print("WebSocket server is running...")
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
