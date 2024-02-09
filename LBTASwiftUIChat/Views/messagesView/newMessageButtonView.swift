//
//  newMessageView.swift
//  LBTASwiftUIChat
//
//  Created by Kaan Yıldız on 8.02.2024.
//

import SwiftUI

struct newMessageButtonView: View {
    @Binding var shouldShowNewMessageScreen: Bool
    
    var body: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack(){
                Spacer()
                Text("+ new message")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.vertical, 10)
                Spacer()
            }
            .foregroundStyle(Color.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .padding()
            .shadow(radius: 10)
        }
    }
}

//#Preview {
//    newMessageView()
//}
