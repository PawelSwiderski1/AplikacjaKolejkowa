import tkinter as tk
import asyncio
import json
import websockets
import time

class WebSocketManager:
    def __init__(self, uri):
        self.socket = None
        self.id_number = None
        self.matter = None
        self.matters = None
        self.uri = uri
        self.current_number = None

    async def send_message(self, message):
        try:
            data = json.dumps(message)
            await self.socket.send(data)
            print(f"Sent message: {message}")
        except Exception as e:
            print(f"Error sending message: {e}")

    async def open_counter(self, id_number, matter):
        message = {
            'client_type': 'operator',
            'action': 'open_counter',
            'matter': matter,
            'id_number' : id_number
        }
        self.id_number = id_number
        self.matter = matter
        await self.send_message(message)
        # await self.handle_messages()
        try:
            message = await self.socket.recv()
            print(f"Received message from server: {message}")

            # Parse the received JSON message
            try:
                json_data = json.loads(message)
                print(json_data)
                if 'current_number' in json_data:
                    self.current_number = json_data['current_number']

                
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON message: {e}")

        except websockets.exceptions.ConnectionClosedOK:
            print("Server disconnected")
    
    async def serve_next_number(self):
        if not self.matter:
            print('Unable to perform action')
            return
        if not self.id_number:
            print('Unable to perform action')
            return
        message = {
            'client_type': 'operator',
            'action': 'serve_next_number',
            'matter': self.matter,
            'id_number' : self.id_number
        }
        # self.counter_id = id_number
        # self.matter = matter
        await self.send_message(message)
        await self.handle_messages()
    
    
    async def close_counter(self):
        if not self.matter:
            print('Unable to perform action')
            return
        if not self.id_number:
            print('Unable to perform action')
            return
        message = {
            'client_type': 'operator',
            'action': 'close_counter',
            'matter': self.matter,
            'id_number' : self.id_number
        }
        self.number_id = None
        self.matter = None
        await self.send_message(message)
        await self.handle_messages()

    async def connect(self):
        self.socket = await websockets.connect(self.uri)
        try:
                message = await self.socket.recv()
                # print(f"Received message: {message}")
                # return message
                self.matters = json.loads(message)
        except websockets.exceptions.ConnectionClosedOK:
            print("Server disconnected")

    async def disconnect(self):
        if self.socket:
            await self.socket.close()
            self.socket = None

    async def handle_messages(self):
        # while True:
        try:
            message = await self.socket.recv()
            print(f"Received message from server: {message}")

            # Parse the received JSON message
            try:
                json_data = json.loads(message)
                print(json_data)
                if 'current_number' in json_data:
                    self.current_number = json_data['current_number']

                
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON message: {e}")

        except websockets.exceptions.ConnectionClosedOK:
            print("Server disconnected")
            



def click_1():
    # tutaj otwieranie kolejki i ładowanie pierwszego numerka
    # asyncio.get_event_loop().run_until_complete(self.send_message_async(message))
    # asyncio.get_event_loop().run_until_complete(manager.open_counter(4, 'R: ODBIÓR DOWODÓW REJESTRACYJNYCH | ZBYCIE POJAZDU'))

    id = id_var.get()
    case = case_var.get()
    asyncio.get_event_loop().run_until_complete(manager.connect())
    asyncio.get_event_loop().run_until_complete(manager.open_counter(id, case))
    asyncio.get_event_loop().run_until_complete(manager.disconnect())
    # office_name = 'Urząd Dzielnicy Ursynów'
    # print(manager.matters['offices_info'][office_name])

    napis1 = f"AKTUALNY NUMEREK PRZY OKIENKU {id}: " 
    napis2 = "RODZAJ SPRAWY: " + case
    start.pack_forget()
    id_text.pack_forget()
    id_entry.pack_forget()
    case_text.pack_forget()
    case_menu.pack_forget()
    label1.config(text=napis1)
    label1.pack()
    label2.config(text=str(manager.current_number))
    label2.pack()
    label3.config(text=napis2)
    label3.pack()
    spacer.pack()
    button.pack()
    end.pack()


def click_2():
    # tutaj zmiana numerka
    # asyncio.get_event_loop().run_until_complete(manager.serve_next_number())
    asyncio.get_event_loop().run_until_complete(manager.connect())
    asyncio.get_event_loop().run_until_complete(manager.serve_next_number())
    asyncio.get_event_loop().run_until_complete(manager.disconnect())
    label2.config(text=str(manager.current_number))


def click_3():
    asyncio.get_event_loop().run_until_complete(manager.connect())
    asyncio.get_event_loop().run_until_complete(manager.close_counter())
    asyncio.get_event_loop().run_until_complete(manager.disconnect())
    label1.pack_forget()
    label2.pack_forget()
    label3.pack_forget()
    spacer.pack_forget()
    button.pack_forget()
    end.pack_forget()
    id_text.pack()
    id_entry.pack()
    case_text.pack()
    case_menu.pack()
    start.pack()

uri = "ws://localhost:4000"  # Replace with your WebSocket server URI
manager = WebSocketManager(uri)
# await manager.connect()
asyncio.get_event_loop().run_until_complete(manager.connect())
asyncio.get_event_loop().run_until_complete(manager.disconnect())
office_name = 'Urząd Dzielnicy Ursynów'
# print(manager.matters['offices_info'][office_name])
# await manager.open_counter(4, 'R: ODBIÓR DOWODÓW REJESTRACYJNYCH | ZBYCIE POJAZDU')
# asyncio.get_event_loop().run_until_complete(manager.open_counter(4, 'R: ODBIÓR DOWODÓW REJESTRACYJNYCH | ZBYCIE POJAZDU'))

root = tk.Tk()
root.title("Aplikacja kolejkowa")
root.geometry("1400x600")
root.config(bg='#f0f8f8')
id_var = tk.StringVar()

id_text = tk.Label(root, text="ID OKIENKA", font="18", bg='#f0f8f8', width=20, height=2, fg="black")
id_text.pack()
id_entry = tk.Entry(root, textvariable=id_var)
id_entry.pack()

case_text = tk.Label(root, text="RODZAJ SPRAWY", font="18", bg='#f0f8f8', width=20, height=2, fg="black")
case_text.pack()
options_list = manager.matters['offices_info'][office_name]  # tutaj te rodzaje spraw mają się znaleźć
case_var = tk.StringVar()
case_var.set("Wybierz rodzaj sprawy")
case_menu = tk.OptionMenu(root, case_var, *options_list)
case_menu.pack()

start = tk.Button(root, text="OTWÓRZ OKIENKO", command=click_1, width=20, height=2, bg="green", font="18", fg="black")
start.pack()

label1 = tk.Label(root, text="AKTUALNY NUMEREK PRZY OKIENKU", height=3, bg='#f0f8f8', font="Arial 18 bold", fg="black")
# img1 = tk.PhotoImage(file="bg1.png")
label2 = tk.Label(root, text=str(manager.current_number), width=5, height=2, bg='#f0f8f8', fg="black", font="Arial 50 bold")
label3 = tk.Label(root, text="RODZAJ SPRAWY", height=3, bg='#f0f8f8', font="Arial 14 bold", fg="black")
spacer = tk.Label(root, height=3)
button = tk.Button(root, text="KOLEJNY NUMEREK", command=click_2, width=20, height=2, bg="green", font="18", fg="black")
end = tk.Button(root, text="ZAMKNIJ OKIENKO", command=click_3, width=20, height=2, bg="red", font="18", fg="black")

root.mainloop()
