//
//  MainMessagesViewModel.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import Foundation

// view model ın amacı , view da kullanacağım elementlerin oluşturulması ve gösterime hazır hale getirilmesini saglamaktır. ObservableObject olması da içerinden bazı değişkenleri publish edebilmemi garantiliyor.
class MainMessagesViewModel: ObservableObject {
    @Published var errMessage: String = ""
    @Published var chatUser: ChatUserInfo?
    @Published var isCurrentlyUserLogedIn: Bool = false
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errMessage = "auth did not work"
            return
        }
//        self.errMessage = "\(userId)"
        
        FirebaseManager.shared.firestore.collection("users").document(userId).getDocument { docSnap, err in
            if let _ = err{
//                self.errMessage = "failed to fetch user \(err.localizedDescription)"
                return
            }
            guard let data = docSnap?.data() else{
//                self.errMessage = "no docSnap"
                return
            }
//            self.errMessage = data.debugDescription
            
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileUrl = data["profileUrl"] as? String ?? ""
            self.chatUser = ChatUserInfo(uid: uid, email: email, profileUrl: profileUrl)
        }
    }
    
    func handleSignout(){
        try? FirebaseManager.shared.auth.signOut()
        isCurrentlyUserLogedIn.toggle()
    }
}

