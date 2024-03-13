//
//  ChatUser.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 9.02.2024.
//

import Foundation

// Model
struct ChatUserInfo : Identifiable{
    var id: String { uid } // bu şu demek, uid değişkenini olduğu gibi id isimli değilşene eşitle.
    let uid, email, profileUrl: String
}
