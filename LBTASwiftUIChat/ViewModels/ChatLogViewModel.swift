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
            .order(by: FirebaseConstants.timestamp)
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
        let chattext = self.chatText
        self.chatText = ""
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = ChatingPerson?.id else { return }
        let dateNow : String = Date.now.description
        // firebase de değişkenleri tutma yöntemim benim yaratıcılığım olacaktır.
        // öncelikle course dakine uygun hareket edeceğim sonra istersem değiştirmeye çalışacağım çünkü mantıklı gelmedi
        
        // aynı mesajı her iki insanın uid leri ile kaydediyor kod.
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        
        let docData = [
            FirebaseConstants.fromID : fromID,
            FirebaseConstants.toID : toID,
            FirebaseConstants.text : chattext,
            FirebaseConstants.timestamp : dateNow
        ] as [String: Any]
        
        document.setData(docData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
            self.persistRecentMessages(chattext: chattext, dateNow: dateNow)
            self.messageSend.toggle() // scroll viewreader için proxy değişkeni bu değişken. scroll down yapmama yarıyor.
        }
        
        //--
        let recivierDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toID)
            .collection(fromID)
            .document()
        
        let recivierDocData = [
            FirebaseConstants.fromID : fromID,
            FirebaseConstants.toID : toID,
            FirebaseConstants.text : chattext,
            FirebaseConstants.timestamp : dateNow
        ] as [String: Any]
        
        recivierDocument.setData(recivierDocData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
        }
        //--
    }
    
    func persistRecentMessages(chattext: String, dateNow : String){
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toID = self.ChatingPerson?.id else {return}
        guard let chatingPerson = self.ChatingPerson else {return}
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(fromID)
            .collection("messages")
            .document(toID)
        
        let docData = [
            FirebaseConstants.timestamp : dateNow,
            FirebaseConstants.text : chattext,
            FirebaseConstants.fromID : fromID,
            FirebaseConstants.toID : toID,
            FirebaseConstants.email : chatingPerson.email,
            FirebaseConstants.profileUrl : chatingPerson.profileUrl
        ] as [String: Any]
        
        document.setData(docData) { err in
            if let err = err{
                self.ErrMessage = "\(err.localizedDescription)"
                return
            }
        }
        //
        let recieverDocument = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toID)
            .collection("messages")
            .document(fromID)
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(fromID)
            .getDocument { docSnap, err in
                if let _ = err{
                    self.ErrMessage = "karşı tarafa recent message kaydediyim derken olmadı."
                    return
                }
                let myData = docSnap?.data()
                let profileUrl = myData!["profileUrl"] as? String ?? ""
                let email = myData!["email"] as? String ?? ""
                
                let recieverDocData = [
                    FirebaseConstants.timestamp : dateNow,
                    FirebaseConstants.text : chattext,
                    FirebaseConstants.fromID : fromID,
                    FirebaseConstants.toID : toID,
                    FirebaseConstants.email : email,  // kendi email imi vermem lazım
                    FirebaseConstants.profileUrl : profileUrl  // kendi pp mi vermem lazım.
                ] as [String: Any]
                
                recieverDocument.setData(recieverDocData) { err in
                    if let err = err{
                        self.ErrMessage = "\(err.localizedDescription)"
                        return
                    }
                }
            }
    }
}
