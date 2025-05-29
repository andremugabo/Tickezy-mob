//
//  RootView.swift
//  Tickezy
//
//  Created by M.A on 4/30/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        switch router.currentRoute {
        case .auth(let authRoute):
            AuthStack(route: authRoute)
        case .main(let mainRoute):
            MainStack(route: mainRoute)
        }
    }
}
