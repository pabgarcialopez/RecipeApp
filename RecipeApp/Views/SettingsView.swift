//
//  SettingsView.swift
//  RecipeApp
//
//  Created by Pablo García López on 15/8/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.requestReview) var requestReview
    
    @State private var showingAboutModal = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingChangeEmailView = false
    @State private var showingChangePasswordView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                NavigationLink { ChangeEmailView(user: .example) }
                label: { buttonContent("Change email", strokeColor: Color.black) }
                
                NavigationLink { ChangePasswordView(user: .example) }
                label: { buttonContent("Change password", strokeColor: Color.black) }
                
                Button(action: logout) { buttonContent("Log out", foregroundColor: .white, backgroundColor: .red) }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: showAboutModal) { buttonContent("About", foregroundColor: .white, backgroundColor: .green.opacity(0.7)) }
                                    
                    Button(action: {requestReview()}) { buttonContent("Rate app", foregroundColor: .white, backgroundColor: .blue.opacity(0.7)) }
                }
                
                Button(action: showDeleteAccountAlert) { buttonContent("Delete account", foregroundColor: .red, strokeColor: .red)
                    
                }.padding(.top, 10)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showingAboutModal) { AboutView() }
            .alert("Sure to delete your account?", isPresented: $showingDeleteAccountAlert, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive, action: deleteAccount)
            }, message: {
                Text("All your data will be lost!")
            })
        }
    }
    
    func buttonContent(_ title: String, foregroundColor: Color = .black, backgroundColor: Color = .clear, strokeColor: Color = .clear) -> some View {
        return Text(title)
            .bold()
            .frame(maxWidth: .infinity)
            .foregroundStyle(foregroundColor)
            .padding()
            .background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(strokeColor, lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    func showAboutModal() {
        showingAboutModal = true
        // TODO: implement modal
    }
    
    func showDeleteAccountAlert() {
        showingDeleteAccountAlert = true
    }
    
    func showChangeEmailView() {
        showingChangeEmailView = true
    }
    
    func showChangePasswordView() {
        showingChangePasswordView = true
    }
    
    func deleteAccount() {
        
    }
    
    func logout() {
        
    }
    
}

#Preview {
    SettingsView()
}
