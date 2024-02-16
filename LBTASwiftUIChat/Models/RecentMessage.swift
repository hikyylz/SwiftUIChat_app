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
    
    init(){
        
    }
    
}
