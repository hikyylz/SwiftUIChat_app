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
                .padding(5)
                .frame(width: 62, height: 62)
                .clipShape(Circle())
                .shadow(radius: 5)
                .onTapGesture {
                    shoulShorProfileView.toggle()
                }
            
            VStack(alignment: .leading, spacing: 4){
                let displayName : String = "\(MainMessageVM.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")"
                 
                Text(displayName)
                    .font(.system(size: 20, weight: .semibold))
                HStack{
                    Circle()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.green)
                        
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

//#Preview {
//    CustomNavBar()
//}


