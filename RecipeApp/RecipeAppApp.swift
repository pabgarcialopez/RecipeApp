//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

@main
struct RecipeAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RecipeModel.self, UserModel.self])
    }
}


