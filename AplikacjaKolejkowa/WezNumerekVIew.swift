//
//  WezNumerekVIew.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI

struct WezNumerekVIew: View {
    var body: some View {
        VStack {
            Text("Obecnie obsługiwane numerki")
            HStack{
                ForEach((1...6), id: \.self){_ in
                    Text("43")
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
        .padding(.bottom,100)

        
        //Spacer()
        
       
        VStack(spacing:20){
            Button{
                print("tapped")
            } label: {
                Text("WEŹ NUMEREK")
                    .foregroundStyle(.black)
            }
            .buttonStyle(CustomButtonStyle(width: 200, color: .green))
            
            Text("BĘDZIESZ 14-TY W KOLEJCE")
        }
        Spacer()
    }
}

#Preview {
    WezNumerekVIew()
}
