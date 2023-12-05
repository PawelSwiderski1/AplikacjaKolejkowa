//
//  WybierzMiejsceView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI



struct ChooseOfficeView: View {
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    @Environment(\.presentationMode) var presentation
    
    var btnBack : some View { Button(action: {
        self.presentation.wrappedValue.dismiss()
           }) {
               HStack(spacing:3) {
               Image(systemName: "chevron.backward")
                   .aspectRatio(contentMode: .fit)
                   .foregroundColor(.blue)
                   Text("Wróć")
                       .foregroundColor(.blue)
               }
           }
       }
    
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

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: "F1f8f8"))
    }
}



#Preview {
    NavigationStack {
        ChooseOfficeView(searchText: .constant(""), hasSelected: .constant(false),offices: [OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy")]
        )
    }
}
