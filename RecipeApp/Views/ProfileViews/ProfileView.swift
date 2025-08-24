//
//  ProfileView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

enum SettingsDestination {
    case settings, account, userEdit // , changeEmail, changePassword
}

struct ProfileView: View {
    
//    @EnvironmentObject var auth: AuthViewModel
    
    let user: UserModel
    
    @State private var path = NavigationPath()
        
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        // Profile picture
//                        (user.picture?.image ?? Image(DEFAULT_PROFILE_PICTURE))
//                            .resizable()
//                            .scaledToFit()
//                            .padding()
//                            .overlay(Circle().stroke(Color.black))
//                            .clipShape(Circle())
//                            .frame(width: 80, height: 80)
                        
                        Text(user.fullName)
                            .font(.largeTitle)
                            
                    }.padding(.bottom, 10)
                                        
                    VStack(alignment: .leading, spacing: 20) {
                        userDetail("Biography") { Text(user.bio) }
                        userDetail("Email") { Text(user.email) }
                        
                        // TODO: input more info about user
                        // For instance: num recipes, followers, likes.
                    }
                    .padding([.top, .bottom], 10)
                }
            }
            .padding(.init(top: 15, leading: 30, bottom: 15, trailing: 30))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: SettingsDestination.settings) {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                    case .settings:
                        SettingsView(path: $path)
                    case .account:
                        AccountView(user: .example, path: $path)
                    case .userEdit:
                        UserEditView(user: .example, path: $path)
//                    case .changePassword:
//                        ChangePasswordView(user: .example)
//                    case .changeEmail:
//                        ChangeEmailView(user: .example)
                }
            }
        }
    }
    
    func userDetail<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3.bold())
            content()
        }
    }

}

#Preview {
    ProfileView(user: .example)
//        .environmentObject(AuthViewModel())
}
