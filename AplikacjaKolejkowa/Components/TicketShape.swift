//
//  TicketShape.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 30/11/2023.
//

import SwiftUI

struct TicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        let numberOfTeeth = 15
        let toothWidth = rect.width / CGFloat(numberOfTeeth)

        for i in 0..<numberOfTeeth {
            let startX = rect.minX + CGFloat(i) * toothWidth
            let startY = rect.maxY
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX + toothWidth / 2, y: startY + 20))
            path.addLine(to: CGPoint(x: startX + toothWidth, y: startY))
        }

        return path
    }
}


#Preview {
    TicketShape()
        .fill(Color.blue)
        .frame(width: 250, height: 200)
}
