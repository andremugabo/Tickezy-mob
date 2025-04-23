//
//  LoginView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var user = ""
    @State private var pass = ""
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Text("Login")
                    .font(.title)
                    .foregroundColor(.white)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                
                Text("Events, Tickets, Moments")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
                
                VStack(spacing: 16) {
                    CustomInputField(icon: "person", placeholder: "Username", text: $user)
                    CustomInputField(icon: "lock", placeholder: "Password", text: $pass, isSecure: true)
                    HStack {
                        Spacer()
                        Button("Forgot Your Password?"){
                            //forgot password logic
                        }
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                    }
                }
                ButtonPrimary(title: "Continue"){
                    auth.login(username: user, password: pass)
                }
                .disabled(user.isEmpty || pass.isEmpty)
                
                Spacer()
                
                Text("or continue with")
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                
                HStack(spacing: 16){
                    SocialLoginButton(title: "Facebook", icon: "Facebook", bgColor: Color(hex: "#3b5998"))
                    SocialLoginButton(title: "Google", icon: "google", bgColor: Color.white)
                }
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    Button("Sign Up") {
                        // Naviagete to signup
                    }
                    .foregroundColor(.blue)
                    .bold()
                }
                .font(.footnote)
            }
            .padding(20)
        }
    }
}

#Preview {
    LoginView()
}
