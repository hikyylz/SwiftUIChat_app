//
//  CreateNewMessageView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 9.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageView: View {
    @Environment(\.dismiss) var dissmis
    @ObservedObject var createNewMessageVM = CreateNewMessageVievModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Text(createNewMessageVM.errMessage)
                ForEach(createNewMessageVM.users) { user in
                    HStack{
                        WebImage(url: URL(string: user.profileUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding(.trailing, 10)
                        
                        Text(user.email)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        //dissmis()
                        print("a: \(user.email)")
                    }
                    
                    Divider()
                }
            }
            .navigationTitle("Create new message")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dissmis()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
        }
    }
}

#Preview {
    CreateNewMessageView()
}
