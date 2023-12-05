//
//  BackButton.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 05/12/2023.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding
      
        public var body : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("ic_back") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                Text("<")
            }
            }
        }
}

#Preview {
    BackButton()
}
