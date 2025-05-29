//
//  ForgotPasswordView.swift
//  Tickezy
//
//  Created by M.A on 4/30/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var selectedMethod: String? = "sms"

    var body: some View {
        VStack(spacing: 24) {
        
//            HStack {
//                Button(action: {
//                    // Handle back action
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.white)
//                        .padding(10)
//                        .background(Color.white.opacity(0.2))
//                        .clipShape(Circle())
//                }
//                
//                Spacer()
//            }

            
            Text("Forgot Password")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Select which contact detail should we use to reset your password")
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            VStack(spacing: 16) {
                ContactOptionCard(
                    icon: "message.fill",
                    method: "SMS",
                    maskedValue: "+250788****99",
                    isSelected: selectedMethod == "sms"
                )
                .onTapGesture {
                    selectedMethod = "sms"
                }

                ContactOptionCard(
                    icon: "envelope.fill",
                    method: "Email",
                    maskedValue: "exa***@example.com",
                    isSelected: selectedMethod == "email"
                )
                .onTapGesture {
                    selectedMethod = "email"
                }
            }

            Spacer()

            ButtonPrimary(title: "Continue"){
                
            }


        }
        .padding()
        .background(Color(hex: "#091746").ignoresSafeArea())
    }
}
