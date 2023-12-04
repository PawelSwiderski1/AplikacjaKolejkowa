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
            
            List(offices.filter({ searchText.isEmpty ? true : $0.office.contains(searchText) })) { item in
                Text(item.office)
                    .foregroundColor(.black)
                    .listRowBackground(Color(hex:"FFFFFF"))
                    .onTapGesture {
                        webSocketManager.chosenOffice = item
                        searchText = item.office
                        hasSelected = true
                        self.presentation.wrappedValue.dismiss()
                    }
            }
            .scrollContentBackground(.hidden)
            //.background(Color(hex:"#f1f8f8"))

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: "F1f8f8"))
    }
}

#Preview {
    WybierzMiejsceView(searchText: .constant(""), hasSelected: .constant(false),offices: [OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy")]
)
}
