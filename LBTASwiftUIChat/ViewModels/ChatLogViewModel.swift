//
//  ChatLogViewModel.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import Foundation
class ChatLogViewModel: ObservableObject {
    @Published var chatText: String = ""
    @Published var ChatingPerson: ChatUserInfo?
    
    init(ChatingPerson: ChatUserInfo?) {
        self.ChatingPerson = ChatingPerson
    }
    
    
    func handleSend(){
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
    }
}
