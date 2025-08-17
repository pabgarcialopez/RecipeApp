//
//  AccountView.swift
//  RecipeApp
//
//  Created by Pablo García López on 17/8/25.
//

import SwiftUI

struct AccountView: View {
    
    let user: UserModel
    
    @State private var showingAboutModal = false
    @State private var showingDeleteAccountAlert = false
    
    private var deleteAccountButton: some View {
        Button(action: showDeleteAccountAlert) {
            HStack(spacing: 15) {
                Image(systemName: "trash.fill")
                Text("Delete account")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: UserEditView(user: .example), label: {
                        Label("Personal details", systemImage: "person.fill")
                    })
                    NavigationLink(destination: ChangeEmailView(user: .example), label: {
                        Label("Change email", systemImage: "mail")
                    })
                    NavigationLink(destination: ChangePasswordView(user: .example), label: {
                        Label("Change password", systemImage: "key")
                    })
                }
                 
                deleteAccountButton
            }
            .alert("Sure to delete your account?", isPresented: $showingDeleteAccountAlert, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive, action: deleteAccount)
            }, message: {
                Text("All your data will be lost!")
            })
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func deleteAccount() {
        
    }
    
    func showDeleteAccountAlert() {
        showingDeleteAccountAlert = true
    }
}

#Preview {
    AccountView(user: .example)
}
