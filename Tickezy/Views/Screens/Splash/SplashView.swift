//
//  SplashView.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import SwiftUI

struct SplashView: View {
    @State private var ready = false
    @State private var animateLogo = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if ready {
                ContentView()
                    .transition(.opacity.animation(.easeInOut(duration: 0.6)))
            } else {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .scaleEffect(animateLogo ? 1.05 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                            animateLogo = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation {
                                ready = true
                            }
                        }
                    }
            }
        }
    }
}
