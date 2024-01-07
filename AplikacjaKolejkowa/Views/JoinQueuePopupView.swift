//
//  JoinQueuePopupView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 06/01/2024.
//

import SwiftUI

struct JoinQueuePopupView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @Binding var showPopup: Bool
    @State var showAlert: Bool = false
    
    var matter: String
    
    var body: some View {
        VStack {
            Text(matter)
                .foregroundStyle(.black)
                .font(.system(size: 22))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 40)
                .padding(.horizontal, 20)
            
            Spacer()
            
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
                    Text("Przewidywany czas oczekiwania: \((webSocketManager.queue.ticketsInQueue.count + 1) * 5) min")
                }
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
            .background(RoundedRectangle(cornerRadius:7).fill(Color(hex:"D1ECED")).shadow(radius: 3))
            .padding()
            .padding(.bottom,20)
            
            
            Button {
                if (webSocketManager.chosenOffice?.office == "Urząd Dzielnicy Ursynów") {       // servers only made                                for Urzad Dzielnicy Ursynow
                    webSocketManager.sendAddNumberMessage()
                    webSocketManager.visitOver = true
                    showPopup = false
                } else {
                    showAlert = true
                }
            } label: {
                Text("DOŁĄCZ DO KOLEJKI")
                    .foregroundStyle(.black)
                    .padding()
            }
            .buttonStyle(CustomButtonStyle(width: 200, color: Color(hex:"#7FD1AE")))
            .padding(.bottom, 30)
            .alert("Proszę wybrać Urząd Dzielnicy Ursynów, aby móc dołączyć do kolejki", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            
        }
        .frame(width: 370, height:370)
        .background(Color(hex: "#F1FBFF"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    JoinQueuePopupView(showPopup: .constant(true), matter: "Ochrona Środowiska, Zezwolenia Alkoholowe")
        .environmentObject(WebSocketManager())
}
