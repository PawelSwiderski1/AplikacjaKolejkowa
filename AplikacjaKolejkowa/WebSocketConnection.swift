//
//  WebSocketConnection.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 26/11/2023.
//

import Foundation
import Starscream

import Starscream
import SwiftUI

class WebSocketManager: WebSocketDelegate, ObservableObject {
    var socket: WebSocket!
    @Published var queue = Queue()
    @Published var usersNumber: Int? = nil

    var usersPlace: Int? {
        if (usersNumber != nil){
            return 1 + queue.numbersArray.firstIndex(where: { $0 == usersNumber })!
        }
        return nil
    }


//    init() {
//        setupWebSocket()
//    }

    func setupWebSocket() {
        let urlString = "ws://localhost:3000"
        guard let url = URL(string: urlString) else { return }
        socket = WebSocket(request: URLRequest(url: url))
        socket.delegate = self
        socket.connect()
    }

//    func sendGetNumbersMessage() {
//        // Send a message to request the current array from the server
//        let message = ["action": "get_numbers"]
//        sendJSONMessage(message)
//        objectWillChange.send()
//    }

//    func sendUpdateArrayMessage() {
//        // Send a message to update the array on the server
//        let newNumbersArray = [6, 7, 8, 9, 10]
//        let message = ["action": "update_numbers", "numbers": newNumbersArray] as [String : Any]
//        sendJSONMessage(message)
//        objectWillChange.send()
//    }
    func sendGetQueueInfoMessage() {
        print("sent info")
            // Send a message to the server to add a number
            let message = ["action": "get_queue_info"]
            sendJSONMessage(message)
        }
    
    func sendAddNumberMessage() {
            // Send a message to the server to add a number
            let message = ["action": "add_number"]
            sendJSONMessage(message)
        }
    
    func sendLeaveQueueMessage() {
            // Send a message to the server to add a number
        let message = ["action": "leave_queue", "number": usersNumber!] as [String : Any]
            sendJSONMessage(message)
        usersNumber = nil
        }


    func sendJSONMessage(_ message: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: message)
            socket.write(data: data)
        } catch {
            print("Error encoding JSON message: \(error)")
        }
    }

    // MARK: - WebSocketDelegate methods

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("WebSocket is connected with headers: \(headers)")

        case .disconnected(let reason, let code):
            print("WebSocket is disconnected: \(reason) with code \(code)")

        case .text(let string):
            print("Received text: \(string)")

            // Parse the received JSON message
            do {
                if let data = string.data(using: .utf8),
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    // Check if the message contains an 'action' key
                    if let action = json["action"] as? String {
                        if action == "sent_queue_info" {
                           // Get information about the queue
                            
                            if let queue_server = json["queue"] as? [String: Any] {
                               queue.update(with: queue_server)
                               //countersArray = counters
                           }
                       }
                        else if action == "update_numbers" {
                            // Update the numbers array
                            if let numbers = json["numbers"] as? [Int] {
                                queue.numbersArray = numbers
                            }
                        }
//                        else if action == "update_counters" {
//                            // Update the counters array
//                            if let counters = json["counters"] as? [Int] {
//                                queue.countersArray = counters
//                            }
//                        }
                        else if action == "added_number" {
                            // Get users ticket
                            if let newNumber = json["number"] as? Int {
                                usersNumber = newNumber
                                print("new_number")
                            }
                        }
                    }
                }
            } catch {
                print("Error decoding JSON message: \(error)")
            }

        // Handle other WebSocket events as needed

        default:
            break
        }
    }
}

struct Counter {
    var servedTicket: Int? = nil
    let idNumber: Int
    init(idNumber: Int){
        self.idNumber = idNumber
    }
}

struct Queue {
    var numbersArray: [Int] = []
    var countersArray: [Counter] = []
    
    mutating func update(with dictionary: [String: Any]) {
            if let numbersArray = dictionary["tickets"] as? [Int] {
                self.numbersArray = numbersArray
            }

            if let countersArrayDict = dictionary["counters"] as? [[String: Any]] {
                self.countersArray = countersArrayDict.compactMap { dict in
                    guard let idNumber = dict["idNumber"] as? Int else {
                        return nil
                    }

                    var counter = Counter(idNumber: idNumber)
                    counter.servedTicket = dict["servedTicket"] as? Int
                    return counter
                }
            }
        }
}

extension PreviewProvider{
    
    static var PreviewWebSocketManager: WebSocketManager{
        let manager = WebSocketManager()
        manager.queue.numbersArray = [1,2,3,4,5,6,7,8,9]
        manager.queue.countersArray = [Counter(idNumber: 3), Counter(idNumber: 5)]
        manager.usersNumber = 7
        return manager
    }
}

