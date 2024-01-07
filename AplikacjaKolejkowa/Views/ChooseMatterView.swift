//
//  ChooseMatterView.swift
//  AplikacjaKolejkowa
//
//  Created by Pawel Swiderski on 25/11/2023.
//

import SwiftUI
import PopupView


struct ChooseMatterView: View {
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    @Environment(\.presentationMode) var presentation
    
    var btnBack : some View { Button(action: {
        self.presentation.wrappedValue.dismiss()
    }) {
        HStack(spacing:3) {
            Image(systemName: "chevron.backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)
                .foregroundColor(.white)
            
        }
        }
    }
    
    @State var searchText: String = ""
    @State var showPopup: Bool = false
    
    var office: OfficeObject
    
    var matters : [MatterObject] {
        //   return [MatterObject(matter: "Punkt podawczy – Architektura, Infrastruktura"), MatterObject(matter: "Ochrona Środowiska, Zezwolenia Alkoholowe"), MatterObject(matter: "Świadczenia rodzinne, alimentacyjne"), MatterObject(matter: "Sprawy lokalowe - pomoc mieszkaniowa"), MatterObject(matter: "Warszawski bon żłobkowy"), MatterObject(matter: "Dodatki mieszkaniowe")]  // FOR PREVIEW
        return webSocketManager.offices_info[office]!
    }
    var body: some View {
        
        VStack{
            VStack{
                HStack(){
                    
                    btnBack
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,40)
                        .padding(.top,20)
                    
                    
                    Text("SPRAWY")
                        .font(.custom("Lovelo-Black",size: 25))
                        .foregroundStyle(.white)
                        .padding(.top,20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                
                Spacer()
                SearchBar(text: $searchText)
                    .padding()
            }
            .frame(height: 100)
            .background(Color(hex: "#5A7D9A"))
            
            Text(office.office)
                .foregroundStyle(.black)
                .font(.custom("Lovelo-Black",size: 20))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            Spacer()
            
            List(matters.filter({ searchText.isEmpty ? true : $0.matter.contains(searchText) })) { item in
                ListRowItem(displayedText: item.matter)
                    .foregroundColor(Color(hex:"000000"))
                    .listRowBackground(Color(hex:"#F1FBFF"))
                    .listRowSeparator(.hidden)
                
                    .onTapGesture {
                        webSocketManager.chosenMatter = item
                        
                        webSocketManager.sendGetQueueInfoMessage(matter: item.matter)
                        showPopup = true
                    }
            }
            .listStyle(PlainListStyle())
            .background(Color(hex: "#F1FBFF"))
            
            
            Spacer()
            
            HStack{
                Text("Wybierz sprawę")
                    .font(.custom("Lovelo-Black",size: 20))
                    .foregroundStyle(.white)
                    .padding(.top,20)
            }
            .frame(height:40)
            .frame(maxWidth:.infinity)
            .background(Color(hex: "#5A7D9A"))
            
        }
        .navigationDestination(isPresented: $webSocketManager.visitOver) { InQueueView()}
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#F1FBFF"))
        .popup(isPresented: $showPopup){
            JoinQueuePopupView(showPopup: $showPopup, matter: webSocketManager.chosenMatter?.matter ?? "")
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
    }
}


//#Preview {
//    NavigationStack{
//        ChooseMatterView(office: OfficeObject(office: "Urząd Dzielnicy Ursynów"))
//            .environmentObject(WebSocketManager())
//    }
//
//}




