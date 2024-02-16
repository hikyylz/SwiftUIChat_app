//
//  ChatView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import SwiftUI

struct ChatView: View {
    @State var ChatUser: ChatUserInfo?
    @ObservedObject var ChatLogVM: ChatLogViewModel
    
    
    init(ChatUser: ChatUserInfo?) {
        self.ChatUser = ChatUser
        self.ChatLogVM = ChatLogViewModel(ChatingPerson: ChatUser)
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.opacity(0.2).ignoresSafeArea()
                
                VStack{
                    Text("\(ChatLogVM.ErrMessage)") 
                    chatMessagesView
                    ChatButtonBar
                }
            }
             
            .navigationTitle(ChatUser?.email ?? "person")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private let endofscrolview: String = "endofscrolview"
    
    private var chatMessagesView: some View{
        ScrollView{
            ScrollViewReader(content: { proxy in  // bu rerader scroll view için bir ayar mekanızması gibi çalıştığını düşünebiliriz. proxy değişkeniyle scrollV için scrol etme özelliğiyle oynayabiliyorum.
                VStack{
                    ForEach(self.ChatLogVM.chatMessages) { messageBlok in
                        messageView(messageBlok: messageBlok)
                    }
                    HStack{}
                        .id(endofscrolview)
                }
                .onReceive(ChatLogVM.$messageSend, perform: { _ in  // bu blok bu view un kullandığı bir değişken değiştiğinde çalışması için bir takım aksiyonlar yazabilmeme yarıyoır.
                    
                    withAnimation(.easeOut(duration: 0.5)) {
                        proxy.scrollTo(endofscrolview, anchor: .bottom)
                    }
                })
                
            })
            
        }
    }
    
    struct messageView: View {
        var messageBlok : ChatMessage
        
        var body: some View{
            VStack{
                if FirebaseManager.shared.auth.currentUser?.uid == messageBlok.fromID{
                    HStack{
                        Spacer()
                        HStack{
                            Text(messageBlok.text)
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    }
                }else{
                    HStack{
                        HStack{
                            Text(messageBlok.text)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
    
    private var ChatButtonBar: some View{
        HStack(spacing: 20){
            Image(systemName: "square.and.arrow.up.on.square")
                .onTapGesture {
                    
                }
            TextField("Description", text: $ChatLogVM.chatText)
            Button("Send") {
                self.ChatLogVM.handleSend()
                self.ChatLogVM.chatText = ""
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.5))
    }
}

#Preview {
//    ChatView(ChatUser: nil)
    NewMessagesView()
}
