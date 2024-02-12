//
//  ChatView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import SwiftUI

struct ChatView: View {
    @State var ChatUser: ChatUserInfo?
    @State var chatText: String = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.opacity(0.2).ignoresSafeArea()
                
                VStack{
                    chatMessagesView
                    ChatButtonBar
                }
            }
             
            .navigationTitle(ChatUser?.email ?? "person")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var chatMessagesView: some View{
        ScrollView{
            ForEach(0..<10, content: { _ in
                HStack{
                    Spacer()
                    VStack{
                        Text("mesage fake")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
                .padding(.horizontal, 10)
                
            })
        }
    }
    
    private var ChatButtonBar: some View{
        HStack(spacing: 20){
            Image(systemName: "square.and.arrow.up.on.square")
                .onTapGesture {
                    
                }
            TextField("Description", text: $chatText)
            Button("Send") {
                
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.5))
    }
}

#Preview {
    ChatView()
}
