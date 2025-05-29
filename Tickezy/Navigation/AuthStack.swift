//
//  AuthStack.swift
//  Tickezy
//
//  Created by M.A on 4/30/25.
//

import SwiftUI

struct AuthStack: View {
    let route: AuthRoute

    var body: some View {
        switch route {
        case .splash:
            SplashView()
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .forgotPassword:
           ForgotPasswordView()
        case .otpVerification:
           OTPVerificationView()
        case .resetPassword:
           ResetPasswordFormView()
        }
    }
}

