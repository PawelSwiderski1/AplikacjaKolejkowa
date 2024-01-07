//
//  ContentView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI

struct InQueueView: View{
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        if !webSocketManager.showPopup{
            QueueWaitingView()
        } else {
            GoToCounterView()
        }
    }

}

struct QueueWaitingView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @Environment(\.presentationMode) var presentation
    
    let waitTime = 5 // for now we assume one visit at the counter takes 5 min
    
    var body: some View {
        VStack {
            VStack {
                Text("OBECNIE OBSŁUGIWANE NUMERKI")
                    .foregroundStyle(.black)
                    .font(.system(size: 18))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                HStack{
                    ForEach((1...webSocketManager.queue.countersArray.count), id: \.self){index in
                        Text("\(webSocketManager.queue.countersArray[index - 1].servedTicket ?? "")")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                            .frame(width: 50, height: 50)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: "3c817a")).shadow(radius: 3))
                            .padding(.bottom, 20)
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 2)
                .overlay(.black)
            
            Spacer()
            
            VStack{
                Text("TWÓJ NUMEREK")
                    .foregroundStyle(.black)
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("\(webSocketManager.usersNumber ?? "")")
                    .foregroundStyle(.white)
                    .font(.system(size: 70))
                    .frame(width: 200, height: 150)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex:"3c817a")).shadow(radius: 3))
            }.padding()
            
            VStack{
                HStack{
                    Text("Twoje miejsce w kolejce: \(webSocketManager.usersPlace ?? 0)")
                }
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                
                HStack{
                    Text("Liczba otwartych okienek: \(webSocketManager.queue.countersArray.count)")
                }
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                HStack{
                    Text("Przewidywany czas oczekiwania: \((webSocketManager.usersPlace ?? 0) * waitTime) min")
                }
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
            .background(RoundedRectangle(cornerRadius:7).fill(Color(hex:"E9F3F7")).shadow(radius: 3))
            
            Spacer()
            
            Button{
                webSocketManager.sendLeaveQueueMessage()
                print("sent")
                webSocketManager.shouldCleanStartView = true
                self.presentation.wrappedValue.dismiss()
            } label: {
                Text("OPUŚĆ KOLEJKĘ")
                    .foregroundStyle(.black)
                
            }
            .buttonStyle(CustomButtonStyle(width: 200, color: Color(hex:"F18A84")))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#F1FBFF"))
        .navigationBarBackButtonHidden(true)
        
        
    }
        
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            InQueueView()
        }.environmentObject(PreviewWebSocketManager)
        
    }
}
