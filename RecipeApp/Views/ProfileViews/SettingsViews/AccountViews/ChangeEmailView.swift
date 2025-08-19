//
//  ChangeEmailView.swift
//  RecipeApp
//
//  Created by Pablo García López on 16/8/25.
//

import SwiftUI

struct ChangeEmailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var newEmail = ""
    @State private var indication = ""
    
    @State private var alertShowing = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let user: UserModel
    
    var body: some View {
        Form {
            Section {
                Text(user.email)
                TextField("New email", text: Binding(
                    get: { newEmail },
                    set: { newEmail = $0.lowercased() }
                ))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
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
        }
        .alert(alertTitle, isPresented: $alertShowing, actions: {
            Button("OK") { dismiss() }
        }, message: {
            Text(alertMessage)
        })
        .onChange(of: newEmail, updateIndication)
        .navigationTitle("Change your email")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func isValidEmail() -> Bool {
        let regex = try! Regex(#"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)
        return newEmail.firstMatch(of: regex) != nil
    }
    
    func updateIndication() {
        
        if newEmail == user.email {
            indication = "Your new email cannot be the same as your current one"
        }
        
        else if !isValidEmail() && !newEmail.isEmpty {
            indication = "Please, enter a valid email"
        }
        
        else { indication = "" }
    }
    
    func disableSaveButton() -> Bool {
        return newEmail.isEmpty || newEmail == user.email || !isValidEmail()
    }
    
    func saveChanges() {
        alertShowing = true
        
        do {
            user.email = newEmail
            try modelContext.save()
            newEmail = ""
            showAlert(title: "Successfully changed email")
        } catch {
            showAlert(title: "An unexpected error ocurred", message: "Please, try again later")
        }
    }
    
    func showAlert(title: String, message: String = "") {
        alertShowing = true
        alertTitle = title
        alertMessage = message
    }
}

#Preview {
    ChangeEmailView(user: .example)
}
