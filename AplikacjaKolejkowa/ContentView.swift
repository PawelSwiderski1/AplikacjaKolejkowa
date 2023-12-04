//
//  ContentView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI
import PopupView

struct ContentView: View{
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        if webSocketManager.showPopup{
            QueueWaitingView()
        } else {
            GoToCounterView()
        }
    }

}

struct QueueWaitingView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @Environment(\.presentationMode) var presentation
    //@State var showingPopup = true


    
    
    var body: some View {
        VStack {
            VStack {
                Text("OBECNIE OBSŁUGIWANE NUMERKI")
                    .foregroundStyle(.black)
                    .font(.system(size: 18))
                    .padding()
                HStack{
                    ForEach((1...webSocketManager.queue.countersArray.count), id: \.self){index in
                        Text("\(webSocketManager.queue.countersArray[index - 1].servedTicket ?? "")")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                            .frame(width: 20, height: 20)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: "3c817a")).shadow(radius: 3))
                            .padding(.bottom, 20)
                    }
                }
            }
            .frame(width:500)
            //.background(Color(hex: "#f2f1f8"))
            
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
                    Text("Przewidywany czas oczekiwania: 30 min")
                }
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
            .background(RoundedRectangle(cornerRadius:7).fill(Color(hex:"e0f0f0")).shadow(radius: 3))
            
            Spacer()
            
            Button{
                webSocketManager.sendLeaveQueueMessage()
                self.presentation.wrappedValue.dismiss()
            } label: {
                Text("OPUŚĆ KOLEJKĘ")
                    .foregroundStyle(.black)
                
            }
            .buttonStyle(CustomButtonStyle(width: 200, color: Color(hex:"E22424")))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#f1f8f8"))
        .navigationBarBackButtonHidden(true)
        //        .popup(isPresented: $webSocketManager.showPopup) {
        //                        Text("The popup")
        //                                            .frame(width: 200, height: 60)
        //                                            .background(Color(red: 0.85, green: 0.8, blue: 0.95))
        //                                            .cornerRadius(30.0)
        //                                    } customize: {
        //                                        $0.autohideIn(2)
        //                                    }
        //            GoToCounterView()
        //        }
        
        
    
        
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
