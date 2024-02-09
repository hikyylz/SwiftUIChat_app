//
//  ContentView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 6.02.2024.
//

import SwiftUI


struct loginView: View {
    @State var isLoaginMode = false
    @State var email : String = ""
    @State var password : String = ""
    @State var shouldShowImagePicker : Bool = false
    @State var logInSucces : Bool = false
    @State var selectedImage: UIImage?
    @State var logInstatusMessage = ""
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    Picker(selection: $isLoaginMode) {
                        Text("log in account")
                            .tag(true)
                        Text("create account")
                            .tag(false)
                    } label: {
                        Text("picher here")
                    }
                    .pickerStyle(.segmented)
                    .padding(10)
                    
                    if !isLoaginMode{
                        Button(action: {
                            shouldShowImagePicker.toggle()
                        }, label: {
                            VStack{
                                if let myImage = self.selectedImage{
                                    Image(uiImage: myImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 60))
                                        
                                }else{
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 60))
                                        .padding()
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 60.0)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                    .shadow(color: .black, radius: 5.0, x: 2, y: 0)
                            }
                        })
                    }
                    
                    // her view componentine aynı etkiyi yapmak istiyorsam böyle yazabilirim.
                    Group {
                        TextField("email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                        SecureField("password", text: $password) // şifrenin gizli yazılmasını sağlıyor.
                    }
                    .padding(10)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    
                    Button(action: {
                        handleAction()
                    }, label: {
                        HStack{
                            Spacer()
                            Text(isLoaginMode ? "Log in" : "Create")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                        }
                        .padding(10)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    })
                    
                }
                .padding(10)
                
                Text(logInstatusMessage)
                    .foregroundStyle(.red)
            }
            .navigationTitle(isLoaginMode ? "Login" : "Create Account")
            .background(.gray.opacity(0.2))
            .fullScreenCover(isPresented: $shouldShowImagePicker) {  // tüm ekranı  kaplayacak başka bir view açmamı sağlıyor.
                ImagePicker(image: $selectedImage)
            }
            .fullScreenCover(isPresented: $logInSucces) {
                NewMessagesView()
            }
            

        }
    }//MARK: body end
    
    private func handleAction() {
        if isLoaginMode{
            // log in operations..
            loginUser()
        }else{
            // create account operations..
            createNewAccount()
        }
    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { dataResult, err in
            if let err = err{
                self.logInstatusMessage = "user did not loged in \(err.localizedDescription)"
                return
            }
//            self.logInstatusMessage = "user loged in, uid: \(dataResult?.user.uid ?? "" ) "
            logInSucces.toggle()
        }
    }
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) { dataResult, err in
            if let err = err{
                self.logInstatusMessage = "user did not loged in \(err.localizedDescription)"
                return
            }
//            self.logInstatusMessage = "user created, uid: \(dataResult?.user.uid ?? "" ) "
            presistUserImageToStorage()
        }
    }
    
    private func presistUserImageToStorage() {
        guard let userUid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        let ref = FirebaseManager.shared.storage.reference(withPath: userUid)
        guard let imageData = self.selectedImage?.jpegData(compressionQuality: 0.5) else{
            self.logInstatusMessage = "Select user photo"
            FirebaseManager.shared.auth.currentUser?.delete(completion: { err in
                if let err = err{
                    self.logInstatusMessage = "user did not deleted, he did not choose phtoto thats the reason of attemp of deleting."
                    return
                }
            })
            return
        }
        ref.putData(imageData) { metadata, err in
            if let err = err{
                self.logInstatusMessage = "user photo did not uploaded, \(err.localizedDescription)"
                return
            }
            ref.downloadURL { retrivedURL, err in
                if let err = err{
                    self.logInstatusMessage = "user photo url did not retrived,  \(err.localizedDescription)"
                    return
                }
                self.logInstatusMessage = "url: \(retrivedURL?.absoluteString ?? "no url" )"
                guard let profileUrl = retrivedURL else {
                    return
                }
                saveUserInfo(imageUrl: profileUrl)
            }
        }
    }
    
    private func saveUserInfo(imageUrl: URL) {
        guard let userUid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let DocData : [String: Any] = [
            "email": self.email,
            "uid": userUid,
            "profileUrl": imageUrl.absoluteString
        ]
        FirebaseManager.shared.firestore.collection("users").document(userUid).setData(DocData) { err in
            if let err = err{
                self.logInstatusMessage = "err while saving user info to firebase firestore : \(err.localizedDescription)"
                return
            }
            self.logInstatusMessage = "suscces."
            self.logInSucces.toggle()
        }
    }
}

#Preview {
    loginView()
}
