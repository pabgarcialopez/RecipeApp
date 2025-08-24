//
//  SignUpView.swift
//  RecipeApp
//
//  Created by Pablo García López on 24/8/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            
            Text("Register to get started!")
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
                Text("Sign up")
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
        auth.signUp(email: email, password: password) { result in
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
    SignUpView()
        .environmentObject(AuthViewModel())
}
