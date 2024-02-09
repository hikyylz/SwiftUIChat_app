//
//  LBTASwiftUIChatApp.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 6.02.2024.
//

import SwiftUI

@main
struct LBTASwiftUIChatApp: App {
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
