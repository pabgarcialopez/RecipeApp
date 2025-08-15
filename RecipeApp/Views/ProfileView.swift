//
//  ProfileView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    @State private var showEditProfileSheet = false
    
    private var logoutButton: some View {
        return Button(action: logout) {
            Text("Log out")
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        // Profile picture
                        (user.profilePic?.image ?? Image(DEFAULT_PROFILE_PICTURE))
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .overlay(Circle().stroke(Color.black))
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                        
                        Text(user.fullName)
                            .font(.largeTitle)
                            
                    }.padding(.bottom, 10)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        userDetail("Biography") { Text(user.bio) }
                        HStack(spacing: 20) {
                            userDetail("City") { Text(user.city) }
                            userDetail("Email") { Text(user.email) }
                            userDetail("Age") { Text(user.age.description) }
                        }
                        
                        // TODO: input more info about user
                        // For instance: num recipes, followers, likes.
                    }
                    .padding([.top, .bottom], 10)
                                        
                    Spacer()
                    
                    logoutButton
                }
            }
            .padding(.init(top: 15, leading: 30, bottom: 15, trailing: 30))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .sheet(isPresented: $showEditProfileSheet) {
                UserEditView()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: editUserProfile) { Text("Edit profile") }
                    Button("Edit profile", systemImage: "pencil", action: editUserProfile)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
            }
        }
    }
    
    func editUserProfile() {
        showEditProfileSheet = true
    }
    
    func userDetail<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3.bold())
            content()
        }
    }
    
    func logout() {
        
    }

}

#Preview {
    ProfileView(user: .example)
}
