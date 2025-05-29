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
    
    private var users: [User] = []

    private init() {
        loadUsers()
    }

    
    private func loadUsers() {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Failed to load users.json")
            return
        }

        do {
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("❌ JSON decoding error: \(error)")
        }
    }

    
    func login(username: String, password: String, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        if let matchedUser = findUser(username: username, password: password, users: users) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentUser = matchedUser
                self.isAuthenticated = true
                print("✅ Login successful for \(matchedUser.username)")
                onSuccess()
            }
        } else {
            print("❌ Invalid credentials")
            onFailure()
        }
    }



    
    func signup(firstName: String, lastName: String, email: String, password: String, cpassword: String) {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, !cpassword.isEmpty else {
            print("⚠️ All fields must be filled")
            return
        }

        
        print("📝 Signup requested")
    }

    
    func logout() {
        currentUser = nil
        isAuthenticated = false
    }
}
