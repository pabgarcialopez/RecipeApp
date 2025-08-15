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
    @State private var showingChangeEmailPasswordSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button(action: showChangeEmailPasswordSheet) {
                    Text("Change email or password").bold()
                        .foregroundStyle(.black)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: showAboutModal) {
                        Text("About").bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.green.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button(action: {requestReview()}) {
                        Text("Rate app").bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                
                Button(action: showDeleteAccountAlert) {
                    Text("Delete account").bold()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.red)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.red, lineWidth: 2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }.padding(.top, 20)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert("Sure to delete your account?", isPresented: $showingDeleteAccountAlert, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive, action: deleteAccount)
            }, message: {
                Text("All your data will be lost!")
            })
            .sheet(isPresented: $showingChangeEmailPasswordSheet) {
                EmailPasswordEditView()
            }
            .fullScreenCover(isPresented: $showingAboutModal) {
                AboutView()
            }
            
            .navigationTitle("Settings")
        }
        
    }
    
    func showAboutModal() {
        showingAboutModal = true
        // TODO: implement modal
    }
    
    func showDeleteAccountAlert() {
        showingDeleteAccountAlert = true
    }
    
    func showChangeEmailPasswordSheet() {
        showingChangeEmailPasswordSheet = true
    }
    
    func deleteAccount() {
        
    }
    
}

#Preview {
    SettingsView()
}
