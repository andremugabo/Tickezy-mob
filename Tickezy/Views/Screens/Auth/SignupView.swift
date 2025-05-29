//
//  SignupView.swift
//  Tickezy
//
//  Created by M.A on 4/29/25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var auth: AuthService
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var cpassword = ""
    var body: some View {
        NavigationStack{
            
            ZStack {
                        Color.appBackground.ignoresSafeArea()
                        VStack(spacing: 20){
                            Spacer()
                            Text("Sign Up")
                                .font(.title)
                                .foregroundColor(.white)
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text("Event, Tickets, Moments")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.subheadline)
                            
                            VStack(spacing:16){
                                CustomInputField(icon: "person", placeholder: "Firstname", text: $firstName)
                                CustomInputField(icon: "person", placeholder: "Lastname", text: $lastName)
                                CustomInputField(icon:"envelope",placeholder: "Email",text: $email)
                                CustomInputField(icon: "lock", placeholder: "Password", text: $password,isSecure: true)
                                CustomInputField(icon: "lock", placeholder: "Confirm Password", text: $cpassword)
                                ButtonPrimary(title: "Create account"){  auth.signup(firstName: firstName, lastName: lastName, email: email, password: password, cpassword: cpassword)}
                                Spacer()
                                Text("or continue with")
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                
                                HStack(spacing:16){
                                    SocialLoginButton(title: "Facebook", icon: "Facebook", bgColor: Color(hex:"#3b5998"))
                                    SocialLoginButton(title: "Google", icon: "google", bgColor: Color.white)
                                }
                                
                                Spacer()
                                
                                HStack{
                                    Text("Already have account ? ")
                                        .foregroundColor(.white.opacity(0.8))
                                    NavigationLink(destination: LoginView()){
                                        Text("Login")
                                            .foregroundColor(.blue)
                                            .bold()
                                    }
                                }
                                .font(.footnote)
                            }
                            
                            
                        }
                        .padding(20)
                    }
        }
        
        
    }
}

#Preview {
    SignupView()
}
