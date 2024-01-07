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
    
    let waitTime = 5 // for now we assume one visit at the counter takes 5 min

    var body: some View {
        GeometryReader { geometry in
            NavigationStack{
                VStack{
                    HStack{
                        Text("APLIKACJA KOLEJKOWA")
                            .font(.custom("Lovelo-Black",size: 20))
                            .foregroundStyle(.black)

                    }
                    .frame(width: geometry.size.width, height: 70)
                    .background(Color(hex: "f1f8f1"))

                    Spacer()

                    Text("Wybierz gdzie chcesz stanąć w kolejce")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                        .padding()
//                    
//                    NavigationLink {
//                        ChooseOfficeView(
//                            searchText: $searchTextPlace,
//                            hasSelected: $hasSelectedPlace,
//                            offices: Array(webSocketManager.offices_info.keys.sorted { (office1: OfficeObject, office2: OfficeObject) -> Bool in
//                                return office1.office < office2.office
//                            })
//                        )
//                    } label : {
//                        SearchBar(text: $searchTextPlace)
//                            .padding(.bottom,20)
//                        
//                    }
//                    
                    if hasSelectedPlace{
                        Text("Wybierz sprawę")
                            .foregroundStyle(.black)
                            .font(.system(size: 20))
                            .padding()
                        
//                        NavigationLink{
//                            ChooseMatterView(
//                                searchText: $searchTextIssue, hasSelected: $hasSelectedIssue, matters: webSocketManager.offices_info[webSocketManager.chosenOffice!]!)
//                        } label : {
//                            SearchBar(text: $searchTextIssue)
//                                .padding(.bottom, 20)
//                            
//                        }
                    }
                    
                    if hasSelectedPlace && hasSelectedIssue{
                        VStack {
                            VStack{
                                HStack{
                                    Text("Liczba osób w kolejce:  \(webSocketManager.queue.ticketsInQueue.count)")
                                }
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                                
                                HStack{
                                    Text("Liczba otwartych okienek: \(webSocketManager.queue.countersArray.count)")
                                }
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                                
                                HStack{
                                    Text("Przewidywany czas oczekiwania: \((webSocketManager.queue.ticketsInQueue.count + 1) * waitTime) min")
                                }
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                            }
                            .background(RoundedRectangle(cornerRadius:7).fill(Color(hex:"DEF0F0")).shadow(radius: 3))
                            .padding()
                            .padding(.bottom,20)
                            
                            Button {
                                webSocketManager.sendAddNumberMessage()
                                webSocketManager.visitOver = true
                            } label: {
                                Text("DOŁĄCZ DO KOLEJKI")
                                    .foregroundStyle(.black)
                                    .padding()
                            }.buttonStyle(CustomButtonStyle(width: 200, color: .green))
                            
                        }
                    }
                    
                    Spacer()
                    
                    Image("Footer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                }
                .onAppear{
                    if webSocketManager.shouldCleanStartView{
                        searchTextPlace = ""
                        hasSelectedPlace = false
                        searchTextIssue = ""
                        hasSelectedIssue = false
                        
                        webSocketManager.shouldCleanStartView = false
                    }
                }
                .navigationDestination(isPresented: $webSocketManager.visitOver) { InQueueView()}
                .ignoresSafeArea(edges: .bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#f1f8f8"))
              
            }.environmentObject(webSocketManager)
        }
    }
}

#Preview {
    StartView()
}
