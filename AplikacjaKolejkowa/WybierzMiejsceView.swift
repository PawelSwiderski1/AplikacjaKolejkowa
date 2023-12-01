//
//  WybierzMiejsceView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI

struct NameObject: Identifiable {
    var id = UUID()
    var name: String = ""
}

struct WybierzMiejsceView: View {
    let names = [NameObject(name: "Urząd dzielnicy Ursynów"), NameObject(name: "Poczta, ul. Puławska 456"), NameObject(name:"Poczta, ul. Pelikanów 46"), NameObject(name: "Centrum kultury Ursynów"),NameObject(name: "Urząd dzielnicy Ursynów"), NameObject(name: "Poczta, ul. Puławska 456"), NameObject(name:"Poczta, ul. Pelikanów 46"), NameObject(name: "Centrum kultury Ursynów"), NameObject(name: "Szpital Onkologiczny Południowy"),NameObject(name: "Urząd dzielnicy Ursynów"), NameObject(name: "Poczta, ul. Puławska 456"), NameObject(name:"Poczta, ul. Pelikanów 46"), NameObject(name: "Centrum kultury Ursynów"), NameObject(name: "Szpital Onkologiczny Południowy"),NameObject(name: "Urząd dzielnicy Ursynów"), NameObject(name: "Poczta, ul. Puławska 456"), NameObject(name:"Poczta, ul. Pelikanów 46"), NameObject(name: "Centrum kultury Ursynów"), NameObject(name: "Szpital Onkologiczny Południowy")]
    
    @EnvironmentObject var webSocketManager: WebSocketManager

    
    @Environment(\.presentationMode) var presentation
    
    @Binding var searchText: String
    @Binding var hasSelected: Bool
    
    var body: some View {
        
        VStack{
            SearchBar(text: $searchText)
                .padding(.top, -30)
            
            List(names.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
                Text(item.name)
                    .listRowBackground(Color(.systemGray6))
                    .onTapGesture {
                        webSocketManager.setupWebSocket()
                        searchText = item.name
                        hasSelected = true
                        self.presentation.wrappedValue.dismiss()
                    }
            }
            .background(Color(hex: "CBE2E2"))
            .scrollContentBackground(.hidden)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "CBE2E2"))
        .padding()
        .padding(.top, 15)
        .background(Color(hex: "CBE2E2"))
    }
}

#Preview {
    WybierzMiejsceView(searchText: .constant(""), hasSelected: .constant(false))
}
