//
//  ProfileView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 9.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var MainMessageVM : MainMessagesViewModel
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 20){
                WebImage(url: URL(string: MainMessageVM.chatUser?.profileUrl ?? "" ))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                
                Text(MainMessageVM.chatUser?.email ?? "")
                    .font(.system(size: 24, weight: .semibold))
                
                Spacer()
            }
            .padding(.top, 20)
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
        }
        
        
    }
}

//#Preview {
//    ProfileView()
//}
