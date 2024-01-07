//
//  WybierzMiejsceView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI



struct ChooseOfficeView: View {
    
    @StateObject private var webSocketManager = WebSocketManager()
    
    
    @Environment(\.presentationMode) var presentation
    
    @State private var navigationPath = NavigationPath()
    
    
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
    
    @State var searchText: String = ""
    
    //var offices: [OfficeObject]    //for preview
    var offices: [OfficeObject] {
        return Array(webSocketManager.offices_info.keys.sorted
                     { (office1: OfficeObject, office2: OfficeObject) -> Bool in
            return office1.office < office2.office
        })
    }
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            VStack{
                VStack(){
                    Text("URZĘDY")
                        .font(.custom("Lovelo-Black",size: 25))
                        .foregroundStyle(.white)
                        .padding(.top,20)
                    Spacer()
                    SearchBar(text: $searchText)
                        .padding()
                }
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .background(Color(hex: "#5A7D9A"))
                
                Spacer()
                
                List(offices.filter({ searchText.isEmpty ? true : $0.office.contains(searchText) })) { office in
                    
                    
                    ListRowItem(displayedText: office.office)
                        .listRowBackground(Color(hex:"#F1FBFF"))
                        .listRowSeparator(.hidden)
                        .foregroundColor(Color(hex:"000000"))
                        .onTapGesture {
                            webSocketManager.chosenOffice = office
                            navigationPath.append(office)
                            
                        }
                        .listRowBackground(Color(hex:"#F1FBFF"))
                        .listRowSeparator(.hidden)
                    
                    
                }
                .navigationDestination(for: OfficeObject.self) { office in
                    ChooseMatterView(office: office)
                }
                .listStyle(PlainListStyle())
                .background(Color(hex: "#F1FBFF"))
                
                
                
                Spacer()
                
                HStack{
                    Text("Wybierz urząd")
                        .font(.custom("Lovelo-Black",size: 20))
                        .foregroundStyle(.white)
                        .padding(.top,20)
                }
                .frame(height:40)
                .frame(maxWidth:.infinity)
                .background(Color(hex: "#5A7D9A"))
                
            }
            .onAppear{
                searchText = ""
            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#F1FBFF"))
        }
        .environmentObject(webSocketManager)
    }
}



//#Preview {
//    NavigationStack {
//        ChooseOfficeView(offices: [OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy"), OfficeObject(office: "Urząd dzielnicy Ursynów"), OfficeObject(office: "Poczta, ul. Puławska 456"), OfficeObject(office: "Poczta, ul. Pelikanów 46"), OfficeObject(office: "Centrum kultury Ursynów"), OfficeObject(office: "Szpital Onkologiczny Południowy")]
//        )
//    }
//}
