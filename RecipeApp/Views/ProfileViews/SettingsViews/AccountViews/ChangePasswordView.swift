//
//  ChangePasswordView.swift
//  RecipeApp
//
//  Created by Pablo García López on 16/8/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var newPasswordRepeated = ""
    
    @State private var alertShowing = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var indication = ""
    
    let user: UserModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField("Current password", text: $currentPassword)
                    SecureField("New password", text: $newPassword)
                    SecureField("Type your new password again", text: $newPasswordRepeated)
                }
                
                Section {
                    
                    if !indication.isEmpty {
                        Text(indication)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    Button("Save", action: saveChanges)
                        .disabled(disableSaveButton())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .onChange(of: newPasswordRepeated, updateIndication)
            }
            .alert(alertTitle, isPresented: $alertShowing, actions: {
                Button("OK") { dismiss() }
            }, message: {
                Text(alertMessage)
            })
            .navigationTitle("Change your password")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    func updateIndication() {
                
        if newPassword != newPasswordRepeated && !newPasswordRepeated.isEmpty && newPassword.count == newPasswordRepeated.count {
            indication = "Your new password does not match in both fields"
        }
        
        else { indication = "" }
        
    }
    
    func saveChanges() {
        
        if currentPassword != user.password {
            currentPassword = ""
            showAlert(title: "Incorrect current password", message: "Please, try again")
            return
        }
        
        if newPassword == user.password {
            showAlert(title: "Your new password cannot be your current one", message: "Please, try with another password")
            newPassword = ""
            newPasswordRepeated = ""
            return
        }
        
        // Save user password
        do {
            user.password = newPassword
            try modelContext.save()
            currentPassword = ""
            newPassword = ""
            newPasswordRepeated = ""
            showAlert(title: "Password changed successfully")
            
        } catch {
            showAlert(title: "An unexpected error ocurred", message: "Please, try again later")
        }
    }
    
    func disableSaveButton() -> Bool {
        return currentPassword.isEmpty || newPassword.isEmpty || newPasswordRepeated.isEmpty || newPassword != newPasswordRepeated
    }
    
    func showAlert(title: String, message: String = "") {
        alertShowing = true
        alertTitle = title
        alertMessage = message
    }
}

#Preview {
    ChangePasswordView(user: .example)
}
