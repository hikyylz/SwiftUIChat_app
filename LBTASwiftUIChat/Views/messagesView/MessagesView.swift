//
//  MessagesView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import SwiftUI

struct MessagesView: View {
    
    var body: some View {
        ScrollView {
            ForEach(0..<20) { _ in
                NavigationLink {
                    ChatView(ChatUser: nil)
                } label: {
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .padding(10)
                            .overlay {
                                Circle()
                                    .stroke()
                                    .foregroundColor(.black.opacity(0.5))
                            }
                        
                        
                        VStack(alignment: .leading){
                            Text("user name")
                            Text("user message")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(.caption))
                    }
                    .padding(.vertical, 10)
                }
                .foregroundStyle(Color.black)
                
                Divider()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
//    MessagesView()
    NewMessagesView()
}
