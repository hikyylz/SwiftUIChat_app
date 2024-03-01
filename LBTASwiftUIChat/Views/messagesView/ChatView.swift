//
//  ChatView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {
    @State var ChatUser: ChatUserInfo?
    @ObservedObject var ChatLogVM: ChatLogViewModel
    @State var shouldShowImagePicker: Bool = false
    var selectedImageViewBackgroundColor: Color = Color.gray.opacity(1.5)
    
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
                
                if ChatLogVM.selectedImageToShare != nil {
                    PhotoShareView
                        .padding()
                }
            }
             
            .navigationTitle(ChatUser?.email ?? "person")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, content: {
            ImagePicker(image: $ChatLogVM.selectedImageToShare )
        })
    }
    
    
    private var PhotoShareView: some View{
        RoundedRectangle(cornerRadius: 15.0)
            .foregroundStyle(selectedImageViewBackgroundColor.opacity(0.8))
            .overlay {
                VStack(spacing: 50){
                    Image(uiImage: ChatLogVM.selectedImageToShare!)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
                    Button(action: {
                        self.ChatLogVM.handleSendPhoto()
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Send")
                                .padding()
                            Spacer()
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    })
                }
                .padding(.horizontal)
            }
    }
    
    private let endofscrolview: String = "endofscrolview"
    
    private var chatMessagesView: some View{
        ScrollView{
            ScrollViewReader(content: { proxy in  // bu rerader scroll view için bir ayar mekanızması gibi çalıştığını düşünebiliriz. proxy değişkeniyle scrollV için scrol etme özelliğiyle oynayabiliyorum.
                VStack{
                    
                    ForEach(self.ChatLogVM.chatMessages, id: \.id) { messageBlok in
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
                    if messageBlok.messageType == .text{
                        HStack{
                            Spacer()
                            HStack{
                                Text(messageBlok.getmessageValue())
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                    }else if messageBlok.messageType == .photo{
                        HStack{
                            Spacer()
                            HStack{
                                WebImage(url: URL(string: messageBlok.getmessageValue()))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                            }
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                    }
                    
                }else{
                    if messageBlok.messageType == .text{
                        HStack{
                            HStack{
                                Text(messageBlok.getmessageValue())
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            Spacer()
                        }
                    }else if messageBlok.messageType == .photo{
                        HStack{
                            HStack{
                                WebImage(url: URL(string: messageBlok.getmessageValue()))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                            }
                            .padding()
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            Spacer()
                        }
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
                    self.shouldShowImagePicker.toggle()
                }
            TextField("Description", text: $ChatLogVM.chatText)
            Button("Send") {
                self.ChatLogVM.handleSendText()
            }
            .disabled(ChatLogVM.disableTextSendButton)
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
