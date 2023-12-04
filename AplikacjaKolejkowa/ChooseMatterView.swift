//
//  ChooseMatterView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI



struct ChooseMatterView: View {
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var searchText: String
    @Binding var hasSelected: Bool
    
    let matters: [MatterObject]
    
    var body: some View {
        
        VStack{
            SearchBar(text: $searchText)
                .padding(.top, -30)
            
            List(matters.filter({ searchText.isEmpty ? true : $0.matter.contains(searchText) })) { item in
                Text(item.matter)
                    .listRowBackground(Color(.systemGray6))
                    .onTapGesture {
                        webSocketManager.chosenMatter = item
                        webSocketManager.sendGetQueueInfoMessage(matter: item.matter)
                        searchText = item.matter
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
    WybierzMiejsceView(searchText: .constant(""), hasSelected: .constant(false),offices: [OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy")]
)
}
