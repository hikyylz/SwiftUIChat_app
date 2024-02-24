//
//  RecentMessage.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 16.02.2024.
//

import Foundation

struct RecentMessage: Identifiable {
    var id : String { documentId }
    let documentId: String
    let text, fromID, toID: String
    let email, profileUrl: String
    let timestamp: String
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.profileUrl = data["profileUrl"] as? String ?? ""
        if let datesaved = data["timestamp"] as? String{
            self.timestamp = datesaved
        }else{
            self.timestamp = "amk date()"
            print("amk------------ burdaymıs------------")
        }
    }
    
}
