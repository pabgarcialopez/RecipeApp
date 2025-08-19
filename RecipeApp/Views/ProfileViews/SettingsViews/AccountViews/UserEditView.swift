//
//  UserEditView.swift
//  RecipeApp
//
//  Created by Pablo García López on 17/8/25.
//

import SwiftUI
import PhotosUI
import CountryKit

struct UserEditView: View {
    
    @Bindable var user: UserModel
    
    // Local, unsaved copy of the profile picture
    @State private var draftProfilePic: UIImage? = nil
    @State private var pickerItem: PhotosPickerItem? = nil
    
    private var profilePicture: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Show draft if available, else show persisted image
                Group {
                    if let draftProfilePic {
                        Image(uiImage: draftProfilePic)
                            .resizable()
                            .scaledToFill()
                    } else {
                        (user.profilePic?.image ?? Image(DEFAULT_PROFILE_PICTURE))
                            .resizable()
                            .scaledToFill()
                    }
                }
                .padding(.top, 10)
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
                CustomTextField(title: "First name", prompt: "John", text: $user.firstName)
                CustomTextField(title: "Last name", prompt: "Doe", text: $user.lastName)
                CustomTextField(title: "Bio", prompt: "Tell us about you", text: $user.bio, axis: .vertical)
                CustomTextField(title: "Email", prompt: "johnDoe@example.com", text: $user.email)
                
            }
            
//            var password: String
//            var sex: Sex
//            var age: Int
//            var address: String
                    
                
            

            
            Spacer()
            
//            Button("Save changes", action: saveChanges)
//                .buttonStyle(.borderedProminent)
        }
        .padding()
        .onChange(of: pickerItem) {
            loadImage(from: pickerItem)
        }
    }
    
    
    
    func loadImage(from item: PhotosPickerItem?) {
        Task {
            if let data = try? await item?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                draftProfilePic = uiImage
            }
        }
    }
    
    func saveChanges() {
        // TODO: implement saving profile
        
        // Save profile pic if changed
        if let draftProfilePic,
           let data = draftProfilePic.pngData() {
            user.profilePic = ImageModel(data: data)
        }
    }
}

#Preview {
    UserEditView(user: .example)
}
