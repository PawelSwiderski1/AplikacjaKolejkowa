//
//  StartView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 26/11/2023.
//

import SwiftUI

struct StartView: View {
    @State private var searchText = ""
    @State private var hasSelected = false

    @StateObject private var webSocketManager = WebSocketManager()

      

    var body: some View {
        let _ = print(webSocketManager.queue.numbersArray)
        NavigationStack{
            VStack{
                Spacer()

                Text("Wybierz miejsce")
                NavigationLink{
                    WybierzMiejsceView(searchText: $searchText, hasSelected: $hasSelected)
                } label : {
                    SearchBar(text: $searchText)
                }
                
                if hasSelected{
                    VStack {
                        VStack{
                            HStack{
                                Text("Liczba osób w kolejce:  \(webSocketManager.queue.numbersArray.count)")
                            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            
                            HStack{
                                Text("Liczba otwartych okienek: \(webSocketManager.queue.countersArray.count)")
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                            HStack{
                                Text("Przewidywany czas oczekiwania: 30 min")
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                        }
                        .background(RoundedRectangle(cornerRadius:5).fill(Color.white).shadow(radius: 3))
                    .padding()
                        
                        NavigationLink{
                            ContentView()
                        } label: {
                            Text("DOŁĄCZ DO KOLEJKI")
                                .foregroundStyle(.black)
                        }
                        .buttonStyle(CustomButtonStyle(width: 200, color: .green))
                        .simultaneousGesture(TapGesture().onEnded{
                            print("tapped")
                            webSocketManager.sendAddNumberMessage()
                        })
                    }
                }
                
                
                Spacer()
            }
            
          
        }.environmentObject(webSocketManager)
    }
}

#Preview {
    StartView()
}
