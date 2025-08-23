//
//  LoginView.swift
//  RecipeApp
//
//  Created by Pablo García López on 21/8/25.
//

import SwiftUI
import Auth0

struct LoginView: View {
    
    @EnvironmentObject var auth: AuthViewModel
    
    private var loginButton: some View {
        Button(action: login) {
            Text("Log in or register")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 30)
                Text(APP_NAME)
                    .font(.largeTitle.bold())
                
                Spacer()
                
                loginButton

                Spacer().frame(height: 50)
            }
        }
    }
    
    func login() {
        auth.login()
    }
    
    
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
