//
//  MessagesView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessagesView: View {
    @ObservedObject var MainMessageVM : MainMessagesViewModel
    
    var body: some View {
        ScrollView {
            ForEach(MainMessageVM.recentMessages) { recentMessage in
                NavigationLink {
                    ChatView(ChatUser: nil)
                } label: {
                    HStack(spacing: 16){
                        WebImage(url: URL(string: recentMessage.profileUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding(.trailing, 10)
                        
                        
                        VStack(alignment: .leading){
                            Text("\(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: ""))")
                            Text("\(recentMessage.text)")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                        Text("\(recentMessage.timestamp.description)")
                            .font(.system(.caption))
                    }
                    .padding(.vertical, 10)
                }
                .foregroundStyle(Color.black)
                
                Divider()
            }
            
            HStack{
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
//    MessagesView()
    NewMessagesView()
}
