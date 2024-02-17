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
    
    var body: some View {
        NavigationStack {
            NavigationLink("", isActive: $shouldShowChatView) {
                ChatView(ChatUser: CurrentChatPerson)
            }
            VStack{
                CustomNavBar(MainMessageVM: MainMessageVM, shouldShoeLogoutOptions: $shouldShoeLogoutOptions, shoulShorProfileView: $shoulShorProfileView)
                MessagesView(MainMessageVM: MainMessageVM)
                    .overlay(alignment: .bottom) {
                        newMessageButtonView(shouldShowNewMessageScreen: $shouldShowNewMessageScreen)
                    }
            }
            .toolbar(.hidden)
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
