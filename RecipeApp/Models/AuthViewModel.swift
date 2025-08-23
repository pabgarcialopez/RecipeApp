//
//  AuthModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 21/8/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userModel: UserModel? = nil
    @Published var isSignedIn: Bool = false
    
    private let db = Firestore.firestore()
    
    init() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserModel(uid: currentUser.uid)
        }
    }
    
    func signUp(email: String, password: String, displayName: String? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("Sign Up Error: \(error.localizedDescription)")
                return
            }
            guard let firebaseUser = result?.user else { return }
            
            // Create UserModel in Firestore
            let newUser = UserModel(id: firebaseUser.uid, firstName: displayName!, email: email)
            do {
                try self.db.collection("users").document(firebaseUser.uid).setData(from: newUser)
                self.userModel = newUser
                self.isSignedIn = true
            } catch {
                print("Firestore Save Error: \(error)")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("Sign In Error: \(error.localizedDescription)")
                return
            }
            guard let firebaseUser = result?.user else { return }
            
            fetchUserModel(uid: firebaseUser.uid)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userModel = nil
            self.isSignedIn = false
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
    
    private func fetchUserModel(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Fetch User Error: \(error)")
                return
            }
            if let snapshot = snapshot, snapshot.exists {
                do {
                    self.userModel = try snapshot.data(as: UserModel.self)
                    self.isSignedIn = true
                } catch {
                    print("Decoding Error: \(error)")
                }
            }
        }
    }
}
