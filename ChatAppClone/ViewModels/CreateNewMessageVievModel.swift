//
//  CreateNewMessageVievModel.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 9.02.2024.
//

import Foundation

class CreateNewMessageVievModel: ObservableObject {
    @Published var users = [ChatUserInfo]()
    @Published var errMessage = ""
    
    init() {
        fetchAllUser()
    }
    
    private func fetchAllUser(){
        FirebaseManager.shared.firestore.collection("users").getDocuments(source: .default) { qurySnap, err in
            if let err = err{
                self.errMessage = "\(err.localizedDescription)"
                return
            }
            qurySnap?.documents.forEach({ docSnap in
                let userData = docSnap.data()
    
                let uid = userData["uid"]
                let email = userData["email"]
                let profileUrl = userData["profileUrl"]
                let newUser = ChatUserInfo(uid: uid as! String, email: email as! String, profileUrl: profileUrl as! String)
                self.users.append(newUser)
            })
        }
    }
}

