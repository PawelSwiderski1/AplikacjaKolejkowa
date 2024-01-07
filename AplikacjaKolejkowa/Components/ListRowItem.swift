//
//  ListRowItem.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 05/01/2024.
//

import SwiftUI

struct ListRowItem: View {
    var displayedText: String
    
    var body: some View {
        ZStack(alignment: .leading){
            HStack{
                Text(displayedText)
                    .padding(.leading,30)
                    .font(.system(size:15))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color(hex:"#ffffff"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .padding(.horizontal,20)
            
            Rectangle()
                .fill(Color(hex:"#5A7D9A"))
                .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                .frame(width: 20, height:55)
                .padding(.horizontal,20)
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    ListRowItem(displayedText: "Urząd dzielnicy Ursynów")
}
