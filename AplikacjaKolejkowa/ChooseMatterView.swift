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
            
            List(matters.filter({ searchText.isEmpty ? true : $0.matter.contains(searchText) })) { item in
                Text(item.matter)
                    .foregroundColor(.black)
                    .listRowBackground(Color(hex:"FFFFFF"))
                    .onTapGesture {
                        webSocketManager.chosenMatter = item
                        webSocketManager.sendGetQueueInfoMessage(matter: item.matter)
                        searchText = item.matter
                        hasSelected = true
                        self.presentation.wrappedValue.dismiss()
                    }
            }
            .scrollContentBackground(.hidden)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: "F1f8f8"))
    }
}

#Preview {
    WybierzMiejsceView(searchText: .constant(""), hasSelected: .constant(false),offices: [OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy"), OfficeObject(office: "office: Urząd dzielnicy Ursynów"), OfficeObject(office: "office: Poczta, ul. Puławska 456"), OfficeObject(office: "office: Poczta, ul. Pelikanów 46"), OfficeObject(office: "office: Centrum kultury Ursynów"), OfficeObject(office: "office: Szpital Onkologiczny Południowy")]
)
}
