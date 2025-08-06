//
//  ContentView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var recipes = Recipe.sampleRecipes
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeView(recipes: recipes)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            AddRecipeView(recipes: $recipes)
                .tabItem { Label("New", systemImage: "plus") }
                .tag(1)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(2)
        }
        .environment(\.selectedTab, $selectedTab)
        
    }
}

#Preview {
    ContentView()
}
