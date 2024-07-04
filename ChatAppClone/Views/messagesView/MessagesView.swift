//
//  MessagesView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI


enum whichMessageType{
    case achived
    case recent
}

struct MessagesView: View {
    @StateObject var MainMessageVM : MainMessagesViewModel
    @State var whichMessages : whichMessageType = .recent
    
    var body: some View {
        ScrollView {
            Picker(selection: $whichMessages) {
                Text("Recents").tag(whichMessageType.recent)
                Text("Archived").tag(whichMessageType.achived)
            } label: {
                Text("picher here")
            }
            .pickerStyle(.segmented)
            
            if whichMessages == .recent {
                RecentMessageBloks(MainMessageVM: MainMessageVM)
                HStack{
                    Spacer()
                }
            }else{
                Text("achived message view")
            }
            
            
        }
        .padding()
    }
}

struct ArchivedMessageBloks: View {
    @ObservedObject var MainMessageVM : MainMessagesViewModel
    
    var body: some View{
        ForEach(MainMessageVM.archivedMessages) { recentMessage in
            NavigationLink {
                if MainMessageVM.chatUser?.uid == recentMessage.fromID{
                    ChatView(ChatUser: .init(uid: recentMessage.toID, email: recentMessage.email, profileUrl: recentMessage.profileUrl))
                }else{
                    ChatView(ChatUser: .init(uid: recentMessage.fromID, email: recentMessage.email, profileUrl: recentMessage.profileUrl))
                }
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
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    let timestampValue : String = recentMessage.timestamp
                    Text(timestampValue.replacingOccurrences(of: "+0000", with: ""))
                        .font(.system(.caption))
                }
                .padding(.vertical, 10)
            }
            .foregroundStyle(Color.black)
            .contextMenu(menuItems: {
                Button(action: {
                    
                }, label: {
                    Text("un archive")
                })
            })
            Divider()
        }
    }
    
}

struct RecentMessageBloks: View {
    @ObservedObject var MainMessageVM : MainMessagesViewModel
    
    var body: some View {
        ForEach(MainMessageVM.recentMessages) { recentMessage in
            NavigationLink {
                if MainMessageVM.chatUser?.uid == recentMessage.fromID{
                    ChatView(ChatUser: .init(uid: recentMessage.toID, email: recentMessage.email, profileUrl: recentMessage.profileUrl))
                }else{
                    ChatView(ChatUser: .init(uid: recentMessage.fromID, email: recentMessage.email, profileUrl: recentMessage.profileUrl))
                }
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
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    let timestampValue : String = recentMessage.timestamp
                    Text(timestampValue.replacingOccurrences(of: "+0000", with: ""))
                        .font(.system(.caption))
                }
                .padding(.vertical, 10)
            }
            .foregroundStyle(Color.black)
            .contextMenu(menuItems: {
                Button(action: {
                    MainMessageVM.deleteSelectedRecentMessage(recentMessage: recentMessage)
                }, label: {
                    Text("Delete Shadow")
                })
                
                Button(action: {
                    
                }, label: {
                    Text("Archive")
                })
            })
            Divider()
        }
    }
}



#Preview {
//    MessagesView()
    NewMessagesView()
}


