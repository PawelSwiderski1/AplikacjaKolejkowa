//
//  ContentView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @Environment(\.presentationMode) var presentation

    
    
    var body: some View {
        VStack {
            VStack {
                Text("Obecnie obsługiwane numerki")
                HStack{
                    ForEach((1...webSocketManager.queue.countersArray.count), id: \.self){index in
                        Text("\(webSocketManager.queue.numbersArray[index - 1])")
                            .font(.system(size: 15))
                            .frame(width: 20, height: 20)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Rectangle().fill(Color.white).shadow(radius: 3))
                    }
                }
            }
            
            .padding()
            .padding(.top,20)
            
            Spacer()
            
            VStack{
                Text("TWÓJ NUMEREK")
                
                Text("\(webSocketManager.usersNumber ?? 0)")
                    .font(.system(size: 30))
                    .frame(width: 150, height: 150)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Rectangle().fill(Color.white).shadow(radius: 3))
            }.padding()
            
            VStack{
                HStack{
                    Text("Twoje miejsce w kolejce: \(webSocketManager.usersPlace ?? 0)")
                }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                
                HStack{
                    Text("Liczba otwartych okienek: \(webSocketManager.queue.countersArray.count)")
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                HStack{
                    Text("Przewidywany czas oczekiwania: 30 min")
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            }
            .background(RoundedRectangle(cornerRadius:5).fill(Color.white).shadow(radius: 3))
            
            Spacer()
            
            Button{
                webSocketManager.sendLeaveQueueMessage()
                self.presentation.wrappedValue.dismiss()
            } label: {
                Text("OPUŚĆ KOLEJKĘ")
                    .foregroundStyle(.black)
            }
            .buttonStyle(CustomButtonStyle(width: 200, color: .red))
            Spacer()
        }
      
        
        
    }
        
}

//#Preview {
//    
//    ContentView()
//    .environmentObject(WebSocketManager())
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }.environmentObject(PreviewWebSocketManager)
        
    }
}
