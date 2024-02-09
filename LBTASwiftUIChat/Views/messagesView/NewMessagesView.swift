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
    
    
    var body: some View {
        NavigationStack {
            VStack{
                CustomNavBar(MainMessageVM: MainMessageVM, shouldShoeLogoutOptions: $shouldShoeLogoutOptions, shoulShorProfileView: $shoulShorProfileView)
                MessagesView()
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
            CreateNewMessageView()
        })
        .fullScreenCover(isPresented: $shoulShorProfileView, content: {
            ProfileView(MainMessageVM: MainMessageVM)
        })
    }
}

#Preview {
    NewMessagesView()
}
