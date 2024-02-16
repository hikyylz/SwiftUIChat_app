//
//  ChatLogViewModel.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import Foundation
class ChatLogViewModel: ObservableObject {
    @Published var chatText: String = ""
    @Published var ChatingPerson: ChatUserInfo?
    @Published var ErrMessage = String()
    @Published var chatMessages = [ChatMessage]()
    @Published var messageSend: Bool = false
    
    init(ChatingPerson: ChatUserInfo?) {
        self.ChatingPerson = ChatingPerson
        fetchMessages()
    }
    
    private func fetchMessages(){
        // bir insanla olan mesajlarımızı çekiyor gerçek zamanlı.
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = ChatingPerson?.id else { return }
        
        
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .order(by: "timestamp")
            .addSnapshotListener { querySnap, err in
                if let err = err {
                    self.ErrMessage = err.localizedDescription
                }
                
                // snapshotlistener her yeni mesajda sıfırdan tüm değerleri çekiyordu, ben ise sadece yeni eklediğim mesajın yüklenmesini istiyorum.
                querySnap?.documentChanges.forEach({ changeDocSnap in
                    if changeDocSnap.type == .added{
                        let messageDocument = changeDocSnap.document.data()
                        let chatMessageBlok = ChatMessage(data: messageDocument)
                        self.chatMessages.append(chatMessageBlok)
                    }
                    self.messageSend.toggle() 
                })
                
//                querySnap?.documents.forEach({ querDocSnap in
//                    let messageDocument = querDocSnap.data()
//                    let chatMessageBlok = ChatMessage(data: messageDocument)
//                    self.chatMessages.append(chatMessageBlok)
//                })
            }
    }
    
    func handleSend(){
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = ChatingPerson?.id else { return }
        // firebase de değişkenleri tutma yöntemim benim yaratıcılığım olacaktır.
        // öncelikle course dakine uygun hareket edeceğim sonra istersem değiştirmeye çalışacağım çünkü mantıklı gelmedi
        
        // aynı mesajı her iki insanın uid leri ile kaydediyor kod.
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        
        let docData = [
            "fromID" : fromID,
            "toID" : toID,
            "text" : chatText,
            "timestamp" : Date() // !
        ] as [String: Any]
        
        document.setData(docData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
            self.messageSend.toggle() // scroll viewreader için proxy değişkeni bu değişken. scroll down yapmama yarıyor.
        }
        
        //--
        let recivierDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toID)
            .collection(fromID)
            .document()
        
        let recivierDocData = [
            "fromID" : fromID,
            "toID" : toID,
            "text" : chatText,
            "timestamp" : Date() // !
        ] as [String: Any]
        
        recivierDocument.setData(recivierDocData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
        }
        //--
        
    }
}
