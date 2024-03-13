//
//  FirebaseManager.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 7.02.2024.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore : Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}

struct FirebaseConstants{
    static let fromID = "fromID"
    static let toID = "toID"
    static let text = "text"
    static let timestamp = "timestamp"
    static let uid = "uid"
    static let email = "email"
    static let profileUrl = "profileUrl"
    static let photoUrl = "photoUrl"
}

