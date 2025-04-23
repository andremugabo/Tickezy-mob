//
//  AuthService.swift
//  Tickezy
//
//  Created by M.A on 4/23/25.
//

import Foundation
import Combine


final class AuthService: ObservableObject {
    static let shared = AuthService()
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    
    private init(){}
    
    
    func login(username: String, password: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.currentUser  = User(username: username, displayName: username.capitalized)
            self.isAuthenticated = true
        }
    }
    
    func logout() {
    currentUser = nil
    isAuthenticated = false
        
    }
    
}
