//
//  StartView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 26/11/2023.
//

import SwiftUI

struct StartView: View {
    @State private var searchTextPlace = ""
    @State private var hasSelectedPlace = false
    @State private var searchTextIssue = ""
    @State private var hasSelectedIssue = false

    @StateObject private var webSocketManager = WebSocketManager()

      

    var body: some View {
        let _ = print(webSocketManager.queue.ticketsInQueue)
        NavigationStack{
            VStack{
                Spacer()

                Text("Wybierz gdzie chcesz stanąć w kolejce")
                    .font(.system(size: 20))
                    .padding()
                
                NavigationLink{
                    WybierzMiejsceView(searchText: $searchTextPlace, hasSelected: $hasSelectedPlace)
                } label : {
                    SearchBar(text: $searchTextPlace)
                        .padding(.bottom,20)
                    
                }
                
                if hasSelectedPlace{
                    Text("Wybierz sprawę, w której jesteś")
                        .font(.system(size: 20))
                        .padding()
                    
                    NavigationLink{
                        WybierzMiejsceView(searchText: $searchTextIssue, hasSelected: $hasSelectedIssue)
                    } label : {
                        SearchBar(text: $searchTextIssue)
                            .padding(.bottom, 20)
                        
                    }
                }
                
                if hasSelectedPlace && hasSelectedIssue{
                    VStack {
                        VStack{
                            HStack{
                                Text("Liczba osób w kolejce:  \(webSocketManager.queue.ticketsInQueue.count)")
                            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                            
                            HStack{
                                Text("Liczba otwartych okienek: \(webSocketManager.queue.countersArray.count)")
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                            HStack{
                                Text("Przewidywany czas oczekiwania: 30 min")
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        }
                        .background(RoundedRectangle(cornerRadius:7).fill(Color(hex:"DEF0F0")).shadow(radius: 3))
                        .padding()
                        .padding(.bottom,20)
                        
                        NavigationLink{
                            ContentView()
                        } label: {
                            Text("DOŁĄCZ DO KOLEJKI")
                                .foregroundStyle(.black)
                                .padding()
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "CBE2E2"))
          
        }.environmentObject(webSocketManager)
    }
}

#Preview {
    StartView()
}
