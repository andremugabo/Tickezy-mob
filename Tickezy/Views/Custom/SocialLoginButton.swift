//
//  SocialLoginButton.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct SocialLoginButton: View {
    var title: String
    var icon: String
    var bgColor: Color
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            Text(title)
                .font(.subheadline)
                .bold()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(bgColor)
        .foregroundColor(bgColor == .white ? .black : .white)
        .cornerRadius(8)
    }
}

