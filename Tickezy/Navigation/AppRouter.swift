//
//  AppRouter.swift
//  Tickezy
//
//  Created by M.A on 4/30/25.
//

import Foundation

class AppRouter: ObservableObject {
    enum Route {
        case auth(AuthRoute)
        case main(MainRoute)
    }

    @Published var currentRoute: Route = .auth(.splash) 

    func goToAuth(_ route: AuthRoute) {
        currentRoute = .auth(route)
    }

    func goToMain(_ route: MainRoute) {
        currentRoute = .main(route)
    }
}

enum AuthRoute {
    case splash
    case login
    case signup
    case forgotPassword
    case otpVerification
    case resetPassword
}

enum MainRoute {
    case home
    case bookmarks
    case notifications
    case profile
}
