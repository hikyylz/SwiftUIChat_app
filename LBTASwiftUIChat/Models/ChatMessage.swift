//
//  ChatMessage.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 13.02.2024.
//

import Foundation

struct ChatMessage : Identifiable{
    let id = UUID()
    let fromID, toID, text : String
    let timestamp: Date
    
    init(data: [String: Any]){
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Date ?? Date()
    }
}
