//
//  WybierzMiejsceView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI



struct WybierzMiejsceView: View {
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var searchText: String
    @Binding var hasSelected: Bool
    
    let offices: [OfficeObject]
    
    var body: some View {
        
        VStack{
            SearchBar(text: $searchText)
                .padding(.top, -30)
            
            List(offices.filter({ searchText.isEmpty ? true : $0.office.contains(searchText) })) { item in
                Text(item.office)
                    .listRowBackground(Color(.systemGray6))
                    .onTapGesture {
                        //webSocketManager.setupWebSocket()
                        webSocketManager.chosenOffice = item
                        searchText = item.office
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
    WybierzMiejsceView(searchText: .constant(""), hasSelected: .constant(false),offices: [OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy")]
)
}
