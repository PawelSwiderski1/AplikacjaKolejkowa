//
//  GoToCounterView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 04/12/2023.
//

import SwiftUI


struct GoToCounterView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        VStack(spacing:40){
            //Spacer()
            
            Text("TWOJA KOLEJ!")
                .foregroundStyle(.black)
                .font(.system(size: 25))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 100)
            
            
            VStack{
                VStack(spacing:10){
                    Text("Podejdź do:")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                    
                    Text("Okienko nr 2")
                        .foregroundStyle(.black)
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                }
                .padding()
                
                Text("\("5")")
                    .foregroundStyle(.white)
                    .font(.system(size: 70))
                    .frame(width: 280, height: 200)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex:"3c817a")).shadow(radius: 3))
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#f1f8f8"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GoToCounterView()
}
