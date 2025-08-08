//
//  UserModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 8/8/25.
//

import Foundation
import SwiftData

@Model
class User {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var sex: Int
    var age: Int
    var city: String
    var country: String
    var address: String
    var profilePic: ImageModel?
    
    init(firstName: String, lastName: String, email: String, password: String, sex: Int, age: Int, city: String, country: String, address: String, profilePic: ImageModel? = nil) {
        self.firstName = firstName
        self.lastName = lastName
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
