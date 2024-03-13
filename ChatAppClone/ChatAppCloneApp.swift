//
//  ChatAppCloneApp.swift
//  ChatAppClone
//
//  Created by Kaan Yıldız on 13.03.2024.
//

import SwiftUI

@main
struct ChatAppCloneApp: App {
    var body: some Scene {
        WindowGroup {
            if FirebaseManager.shared.auth.currentUser != nil{
                NewMessagesView()
            }else{
                loginView()
            }
            
        }
    }
}
