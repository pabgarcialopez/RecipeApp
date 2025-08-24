//
//  UserModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 8/8/25.
//

import Foundation
//import FirebaseFirestore

class UserModel: Identifiable, Codable, ObservableObject {
//    @DocumentID var id: String?
    var id: String?
    @Published var firstName: String
    @Published var lastName: String
    @Published var bio: String
    @Published var email: String
    @Published var pictureURL: String?

    var fullName: String { firstName + " " + lastName }
    
    init(id: String? = nil, firstName: String = "", lastName: String = "", bio: String = "", email: String, pictureURL: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.email = email
        self.pictureURL = pictureURL
    }
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case bio
        case email
        case pictureURL
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        bio = try container.decode(String.self, forKey: .bio)
        email = try container.decode(String.self, forKey: .email)
        pictureURL = try container.decodeIfPresent(String.self, forKey: .pictureURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(bio, forKey: .bio)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(pictureURL, forKey: .pictureURL)
    }
}



extension UserModel {
    static let example = UserModel(id: "123", firstName: "Pablo", lastName: "García", bio: "Cooking is just chemistry you can eat.", email: "pabloskyx13@gmail.com", pictureURL: DEFAULT_PROFILE_PICTURE)
    
    static let empty = UserModel(id: "123", firstName: "", lastName: "", bio: "", email: "", pictureURL: DEFAULT_PROFILE_PICTURE)
}
