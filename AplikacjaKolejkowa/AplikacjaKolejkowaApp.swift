//
//  AplikacjaKolejkowaApp.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI

@main
struct AplikacjaKolejkowaApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
               //.environmentObject(WebSocketManager())
        }
    }
}
