//
//  ChatLogViewModel.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 12.02.2024.
//

import Foundation
import SwiftUI

class ChatLogViewModel: ObservableObject {
    @Published var chatText: String = ""
    @Published var selectedImageToShare : UIImage?
    @Published var ChatingPerson: ChatUserInfo?
    @Published var ErrMessage = String()
    @Published var chatMessages = [ChatMessage]()
    @Published var messageSend: Bool = false
    @Published var disableTextSendButton: Bool = false
    @Published var shouldShowPhotoSendingProgresBar : Bool = false
    
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
                        
                        // recent mesage text veya photo olabilir..
                        if let _ = messageDocument[FirebaseConstants.text]{
                            // text ise
                            let chatMessageBlok = ChatTextMessage(data: messageDocument)
                            self.chatMessages.append(chatMessageBlok)
                        }else{
                            // phtot ise
                            let chatPhotoBlok = ChatPhotoMessage(data: messageDocument)
                            self.chatMessages.append(chatPhotoBlok)
                        }
                    }
                    self.messageSend.toggle() 
                })
            }
    }
    
    
    
    func handleSendPhoto(){
        guard let photoData = self.selectedImageToShare?.jpegData(compressionQuality: 0.2) else{ return }
        self.selectedImageToShare = nil
        self.shouldShowPhotoSendingProgresBar.toggle()
        let firebaseReferance = FirebaseManager.shared.storage.reference()
        let sharedPhotosStorage = firebaseReferance.child("sharedPhotos/\(UUID())")
        sharedPhotosStorage.putData(photoData) { _ , err in
            if let _ = err{
                return
            }
            
            sharedPhotosStorage.downloadURL { sharedPhotoURL, err in
                if let _ = err{
                    return
                }
                guard let sharedPhotoURL = sharedPhotoURL else{
                    return
                }
                self.savePhotoMessage(photoURL: sharedPhotoURL.absoluteString)
            }
            
        }
    }
    
    func savePhotoMessage(photoURL : String){
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = ChatingPerson?.id else { return }
        let dateNow : String = Date.now.description
        
        // aynı mesajı her iki insanın uid leri ile kaydediyor kod.
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        
        let docData = [
            FirebaseConstants.fromID : fromID,
            FirebaseConstants.toID : toID,
            FirebaseConstants.photoUrl : photoURL,
            FirebaseConstants.timestamp : dateNow
        ] as [String: Any]
        
        document.setData(docData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
            self.persistRecentPhotoMessages(photoURL: photoURL, dateNow: dateNow)
            self.shouldShowPhotoSendingProgresBar.toggle()
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
            FirebaseConstants.photoUrl : photoURL,
            FirebaseConstants.timestamp : dateNow
        ] as [String: Any]
        
        recivierDocument.setData(recivierDocData) { err in
            if let err = err{
                self.ErrMessage = err.localizedDescription
            }
        }
        //--
    }
    
    
    func handleSendText(){
        if self.chatText.isEmpty {
            return
        }
        let chattext : String = self.chatText
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
            self.persistRecentTextMessages(chattext: chattext, dateNow: dateNow)
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
    
    func persistRecentTextMessages(chattext: String, dateNow : String){
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
    
    
    func persistRecentPhotoMessages(photoURL: String, dateNow : String){
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
            FirebaseConstants.photoUrl : photoURL,
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
                    FirebaseConstants.photoUrl : photoURL,
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
