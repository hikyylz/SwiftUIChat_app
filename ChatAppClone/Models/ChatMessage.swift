//
//  ChatMessage.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 13.02.2024.
//

import Foundation




enum messageType {
    case text
    case photo
}

// buradaki modeller çok güzel interface kullanım örneği :)
protocol ChatMessage{
    var id: UUID { get }
    var fromID: String { get }
    var toID: String { get }
    var timestamp: String { get }
    var messageType: messageType { get }
    
    func getmessageValue() -> String
}


struct ChatTextMessage : Identifiable, ChatMessage{
    var messageType: messageType = .text
    let id = UUID()
    let fromID, toID: String
    var timestamp: String
    let text: String
    
    init(data: [String: Any]){
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""
    }
    
    func getmessageValue() -> String{
        return text
    }
}

struct ChatPhotoMessage : Identifiable, ChatMessage{
    var messageType: messageType = .photo
    let id = UUID()
    let fromID, toID : String
    let timestamp: String
    let photoUrl: String?
    
    init(data: [String: Any]){
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.photoUrl = data["photoUrl"] as? String
        self.timestamp = data["timestamp"] as? String ?? ""
    }
    
    func getmessageValue() -> String {
        guard let photoUrl = photoUrl else{
            return ""
        }
        return photoUrl
    }
}
