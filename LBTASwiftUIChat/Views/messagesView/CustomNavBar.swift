//
//  CustomNavBar.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomNavBar: View {
    @ObservedObject var MainMessageVM : MainMessagesViewModel
    @Binding var shouldShoeLogoutOptions : Bool
    @Binding var shoulShorProfileView: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: MainMessageVM.chatUser?.profileUrl ?? "" ))
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .shadow(radius: 10)
                .onTapGesture {
                    shoulShorProfileView.toggle()
                }
            
            VStack(alignment: .leading, spacing: 4){
                let displayName : String = "\(MainMessageVM.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")"
                 
                Text(displayName)
                    .font(.system(size: 20, weight: .semibold))
                HStack{
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 10)
                        
                    Text("online")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.gray)
                }
            }
            Spacer()
            Button(action: {
                shouldShoeLogoutOptions.toggle()
            }, label: {
                Image(systemName: "gear")
                    .foregroundStyle(Color.primary)
            })
        }
        .padding(.horizontal)
        .confirmationDialog("Settings", isPresented: $shouldShoeLogoutOptions, titleVisibility: .visible) {
            Button(action: {
                MainMessageVM.handleSignout()
            }, label: {
                Text("Sign out")
            })
        } message: {
            Text("What do you want to do?")
        }
    }
}

#Preview {
    //CustomNavBar()
    NewMessagesView()
}


