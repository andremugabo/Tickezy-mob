//
//  OTPVerificationView.swift
//  Tickezy
//
//  Created by M.A on 5/26/25.
//

import SwiftUI

struct OTPVerificationView: View {
    @State private var otpCode: String = ""
    @State private var isCodeValid = true
    @State private var isResendDisabled = false
    @State private var timer: Int = 60

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("Enter OTP")
                    .font(.title)
                    .foregroundColor(.white)

                Text("We sent a code to your phone/email.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                TextField("6-digit code", text: $otpCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isCodeValid ? Color.clear : Color.red, lineWidth: 1)
                    )
                    .onChange(of: otpCode) { newValue in
                        otpCode = String(newValue.prefix(6))
                    }

                ButtonPrimary(title: "Verify Code") {
                    if otpCode == "123456" {
                        // Replace with actual OTP verification logic
                        print("OTP verified!")
                    } else {
                        isCodeValid = false
                    }
                }
                .disabled(otpCode.count != 6)

                if !isCodeValid {
                    Text("Invalid code. Please try again.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: {
                    resendOTP()
                }) {
                    Text(isResendDisabled ? "Resend in \(timer)s" : "Resend Code")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .disabled(isResendDisabled)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
    }

    private func startTimer() {
        isResendDisabled = true
        timer = 60

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            timer -= 1
            if timer <= 0 {
                t.invalidate()
                isResendDisabled = false
            }
        }
    }

    private func resendOTP() {
        // Insert real resend logic here
        print("Resending OTP...")
        startTimer()
    }
}

#Preview {
    OTPVerificationView()
}
