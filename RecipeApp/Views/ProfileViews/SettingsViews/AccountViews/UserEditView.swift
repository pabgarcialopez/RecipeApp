//
//  UserEditView.swift
//  RecipeApp
//
//  Created by Pablo García López on 17/8/25.
//

import SwiftUI
import PhotosUI

struct UserEditView: View {
    
    @ObservedObject var user: UserModel
    @Binding var path: NavigationPath
    
    @State private var draftProfilePic: UIImage? = nil
    @State private var pickerItem: PhotosPickerItem? = nil
    
    private var profilePicture: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Show draft if available, else show persisted image
                Group {
//                    if let draftProfilePic {
//                        Image(uiImage: draftProfilePic)
//                            .resizable()
//                            .scaledToFill()
//                    } else {
//                        (user.picture?.image ?? Image(DEFAULT_PROFILE_PICTURE))
//                            .resizable()
//                            .scaledToFill()
//                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black))

                // Small edit icon (but not interactive by itself anymore)
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 14))
                    )
                    .offset(x: 5, y: 5)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edit profile")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                profilePicture
            }
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    titledField("First name", field: TextField("First name", text: $user.firstName))
                        .stroked(cornerRadius: 18)
                    titledField("Last name", field: TextField("Last name", text: $user.lastName))
                        .stroked(cornerRadius: 18)
                }
                
                titledField("Bio", field:TextField("Tell us about you", text: $user.bio, axis: .vertical))
                    .stroked(cornerRadius: 18)
                
//                HStack {
//                    Button("Change email", action: goToChangeEmailView)
//                        .stroked(cornerRadius: 18)
//                    Spacer()
//                    Button("Change password", action: goToChangePasswordView)
//                        .stroked(cornerRadius: 18)
//                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onChange(of: pickerItem) {
            loadImage(from: pickerItem)
        }
        
    }
    
    func goToChangeEmailView() {
//        path = NavigationPath([SettingsDestination.changeEmail])
    }
    
    func goToChangePasswordView() {
//        path = NavigationPath([SettingsDestination.changePassword])
    }
    
    func titledField<Field: View>(_ title: String, field: Field) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title3.bold())
            field
        }
    }
    
    func loadImage(from item: PhotosPickerItem?) {
        Task {
            if let data = try? await item?.loadTransferable(type: Data.self) {
//            TODO: refactor!!!! We now need to give user.pictureURL a String.
//                user.picture = ImageModel(data: data)
            }
        }
    }
}

#Preview {
    UserEditView(user: .example, path: .constant(NavigationPath()))
}
