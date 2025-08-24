//
//  AuthModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 21/8/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isAuthenticated: Bool = false
        
    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign Up Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            self.user = result?.user
            completion(.success("Successfully signed up"))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isAuthenticated = true
            }

        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign In Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            self.user = result?.user
            completion(.success("Successfully signed in"))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isAuthenticated = true
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
}
