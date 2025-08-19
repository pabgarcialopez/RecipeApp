//
//  UserModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 8/8/25.
//

import Foundation
import SwiftData


@Model
class UserModel {
    var firstName: String
    var lastName: String
    var bio: String
    var email: String
    var password: String
    var profilePic: ImageModel?
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    init(firstName: String, lastName: String, bio: String, email: String, password: String, profilePic: ImageModel? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.email = email
        self.password = password
        self.profilePic = profilePic
    }
}

extension UserModel {
    static let example = UserModel(firstName: "Pablo", lastName: "García", bio: "Cooking is just chemistry you can eat.", email: "pabloskyx13@gmail.com", password: "password123!", profilePic: imageModelFromAsset(named: DEFAULT_PROFILE_PICTURE))
}
