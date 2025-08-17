//
//  AccountView.swift
//  RecipeApp
//
//  Created by Pablo García López on 17/8/25.
//

import SwiftUI

struct AccountView: View {
    
    let user: UserModel
    
    @State private var showingDeleteAccountAlert = false
    
    @State private var modalContent = ""
    @State private var isShowingModal = false
    
    
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
                
                Section("App Policies") {
                    Button(action: showPrivacyPolicyModal) {
                        Label("Privacy policy", systemImage: "lock.shield")
                    }
                    
                    Button(action: showLegalDisclaimerModal) {
                        Label("Legal disclaimer", systemImage: "doc.text")
                    }
                    
                    Button(action: showTermsAndConditionsModal) {
                        Label("Terms and conditions", systemImage: "list.bullet")
                    }
                }
                 
                deleteAccountButton
            }
            .alert("Sure to delete your account?", isPresented: $showingDeleteAccountAlert, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive, action: deleteAccount)
            }, message: {
                Text("All your data will be lost!")
            })
            .fullScreenCover(isPresented: $isShowingModal) {
                FullScreenModal { Text(modalContent) }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    func deleteAccount() {
        // TODO: implement delete account logic
    }
    
    func showDeleteAccountAlert() {
        showingDeleteAccountAlert = true
    }
    
    func showPrivacyPolicyModal() {
        isShowingModal = true
        modalContent = PRIVACY_POLICY
    }
    
    func showLegalDisclaimerModal() {
        isShowingModal = true
        modalContent = LEGAL_DISCLAIMER
    }
    
    func showTermsAndConditionsModal() {
        isShowingModal = true
        modalContent = TERMS_AND_CONDITIONS
    }
}

#Preview {
    AccountView(user: .example)
}
