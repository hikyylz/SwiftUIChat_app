//
//  NewMessagesView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 7.02.2024.
//

import SwiftUI

struct NewMessagesView: View {
    @State var shouldShoeLogoutOptions: Bool = false
    @State var shouldShowNewMessageScreen : Bool = false
    @State var shoulShorProfileView: Bool = false
    @StateObject private var MainMessageVM = MainMessagesViewModel()
    @State var CurrentChatPerson: ChatUserInfo?
    @State var shouldShowChatView: Bool = false
    @State var newMessagesBackgoundColor: Color = Color.blue.opacity(0.2)
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                newMessagesBackgoundColor.ignoresSafeArea()
                
                VStack{
                    CustomNavBar(MainMessageVM: MainMessageVM, shouldShoeLogoutOptions: $shouldShoeLogoutOptions, shoulShorProfileView: $shoulShorProfileView)
                    MessagesView(MainMessageVM: MainMessageVM)
                        .overlay(alignment: .bottom) {
                            newMessageButtonView(shouldShowNewMessageScreen: $shouldShowNewMessageScreen)
                        }
                }
                .toolbar(.hidden)
            }
            
            // bu yazımı geç fark ettim, ios17 sonrası böyle geçiş yapılabiliyor ara view kullanarak iki view arasında.
            .navigationDestination(isPresented: $shouldShowChatView) {
                ChatView(ChatUser: CurrentChatPerson)
            }
        }
        .fullScreenCover(isPresented: $MainMessageVM.isCurrentlyUserLogedIn, content: {
            loginView()
        })
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, content: {
            CreateNewMessageView { user in
                self.CurrentChatPerson = user
                self.shouldShowChatView.toggle()
            
            }
        })
        .fullScreenCover(isPresented: $shoulShorProfileView, content: {
            ProfileView(MainMessageVM: MainMessageVM)
        })
        
    }
}

#Preview {
    NewMessagesView()
}
