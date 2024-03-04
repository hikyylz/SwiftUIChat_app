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
    @Published var chatUser: ChatUserInfo? // log in olmuş insanın bilgileri bu, chatingperson değil.
    @Published var isCurrentlyUserLogedIn: Bool = false
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    func deleteSelectedRecentMessage(recentMessage: RecentMessage){
        let IdwillBeDeleted: String
        guard let userId = chatUser?.uid else {
            return
        }
        
        if userId == recentMessage.fromID{
            // son mesajı chatuser atmıs.
            IdwillBeDeleted = recentMessage.toID
        }else{
            // son mesajı chatingperson atmıs.
            IdwillBeDeleted = recentMessage.fromID
        }
        
        let recentMessageDoc = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(userId)
            .collection("messages")
            .document(IdwillBeDeleted)
        
        recentMessageDoc.delete { err in
            if let err = err{
                print("delete işleminde sorun oldu---------")
                return
            }
            print("delete işlemi başaıyla sonuçlandı --------------")
            self.fetchCurrentRecentMessages()
            return
        }
    }
    
    private func fetchCurrentRecentMessages(){
        guard let userId = chatUser?.uid else {
            return
        }
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(userId)
            .collection("messages")
            .getDocuments { querySnap, err in
                guard let documents = querySnap?.documents else{
                    print("current recent messages yüklenemedi ------------")
                    return
                }
                self.recentMessages.removeAll()
                documents.forEach { docSnap in
                    let docId = docSnap.documentID
                    let docData = docSnap.data()
                    self.recentMessages.append(RecentMessage(documentId: docId, data: docData))
                }
                
            }
    }
    
    /// this func fecth last message of everyones last chat weit me.
    private func fetchRecentMessages(){
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(userId)
            .collection("messages")
            .addSnapshotListener { querySnap, err in
                if let err = err {
                    self.errMessage = "\(err.localizedDescription)"
                    return
                }
                
                querySnap?.documentChanges.forEach({ change in
                    let docID = change.document.documentID
                    
                    // her mesajlaşmanın en son kaydedilmiş mesajını değiştirmem lazım.
                    if let index = self.recentMessages.firstIndex(where: { recentMessage in
                        return recentMessage.documentId == docID
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    let newRecentMessage = RecentMessage(documentId: docID, data: change.document.data())
                    self.recentMessages.insert(newRecentMessage, at: 0)
                })
            }
    }
    
    private func fetchCurrentUser(){
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(userId).getDocument { docSnap, err in
            if let _ = err{
                return
            }
            guard let data = docSnap?.data() else{
                return
            }
            
            let uid = data[FirebaseConstants.uid] as? String ?? ""
            let email = data[FirebaseConstants.email] as? String ?? ""
            let profileUrl = data[FirebaseConstants.profileUrl] as? String ?? ""
            self.chatUser = ChatUserInfo(uid: uid, email: email, profileUrl: profileUrl)
        }
    }
    
    func handleSignout(){
        try? FirebaseManager.shared.auth.signOut()
        isCurrentlyUserLogedIn.toggle()
    }
}

