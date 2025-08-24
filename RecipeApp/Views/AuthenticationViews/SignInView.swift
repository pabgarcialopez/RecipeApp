//
//  SignInView.swift
//  RecipeApp
//
//  Created by Pablo García López on 24/8/25.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Welcome back!")
                .font(.largeTitle.bold())
                .padding(.bottom, 30)
            
            VStack(spacing: 15) {
                TextField("Enter your email", text: $email)
                    .stroked(cornerRadius: 15)
                SecureField("Enter your password", text: $password)
                    .stroked(cornerRadius: 15)
            }
            
            
            Spacer()
            
            Button(action: signUp) {
                Text("Sign in")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
        }
        .padding(50)
    }
    
    func signUp() {
        auth.signIn(email: email, password: password) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let message):
                print(message)
                dismiss()
            }
            
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
