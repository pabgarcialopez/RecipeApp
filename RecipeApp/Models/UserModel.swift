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
    var sex: String
    var age: Int
    var city: String
    var country: String
    var address: String
    var profilePic: ImageModel?
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    init(firstName: String, lastName: String, bio: String, email: String, password: String, sex: String, age: Int, city: String, country: String, address: String, profilePic: ImageModel? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.email = email
        self.password = password
        self.sex = sex
        self.age = age
        self.city = city
        self.country = country
        self.address = address
        self.profilePic = profilePic
    }
}

extension UserModel {
    static let example = UserModel(firstName: "Pablo", lastName: "García", bio: "Cooking is just chemistry you can eat.", email: "pabloskyx13@gmail.com", password: "password123!", sex: "Male", age: 23, city: "Madrid", country: "Spain", address: "Calle Alcalá 68", profilePic: imageModelFromAsset(named: DEFAULT_PROFILE_PICTURE))
}
