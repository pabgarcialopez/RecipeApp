//
//  UserModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 8/8/25.
//

import Foundation
import SwiftData

enum Sex: String, Codable {
    case male = "Male", female = "Female", other = "Other"
}

struct Mobile: Codable {
    var number: String
    var countryCode: String
}

struct Address: Codable {
    var street: String                // Street name
    var streetNumber: String          // Use String in case of letters, e.g., "12B"
    var city: String
    var stateOrProvince: String?      // Optional for countries without states
    var postalCode: String?           // Optional for countries without postal codes
    var country: String
    var apartmentOrUnit: String?      // Optional, e.g., "Apt 4B"
    
    var fullAddress: String {
        var components = [street + " " + streetNumber]
        if let apt = apartmentOrUnit { components.append(apt) }
        components.append(city)
        if let state = stateOrProvince { components.append(state) }
        if let postal = postalCode { components.append(postal) }
        components.append(country)
        return components.joined(separator: ", ")
    }
}


@Model
class UserModel {
    var firstName: String
    var lastName: String
    var bio: String
    var email: String
    var password: String
    var sex: Sex
    var age: Int
    var address: Address
    var mobile: Mobile
    var profilePic: ImageModel?
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    init(firstName: String, lastName: String, bio: String, email: String, password: String, sex: Sex, age: Int, address: Address, mobile: Mobile, profilePic: ImageModel? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.email = email
        self.password = password
        self.sex = sex
        self.age = age
        self.address = address
        self.mobile = mobile
        self.profilePic = profilePic
    }
}

extension UserModel {
    static let example = UserModel(firstName: "Pablo", lastName: "García", bio: "Cooking is just chemistry you can eat.", email: "pabloskyx13@gmail.com", password: "password123!", sex: .male, age: 23, address: Address(street: "Alcalá", streetNumber: "68", city: "Madrid", country: "Spain"), mobile: Mobile(number: "617425341", countryCode: "+34"), profilePic: imageModelFromAsset(named: DEFAULT_PROFILE_PICTURE))
}
