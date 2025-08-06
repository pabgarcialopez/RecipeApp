//
//  HomeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

struct HomeView: View {
    
    let recipes: [Recipe]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    ForEach(recipes, id: \.id) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 15)
                .padding(.bottom, 25)
            }
            .navigationTitle("My recipes")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
        
    }
}

#Preview {
    HomeView(recipes: Recipe.sampleRecipes)
}
