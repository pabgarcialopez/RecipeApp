//
//  HomeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

struct HomeView: View {
    
    let recipes: [RecipeModel]
    
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
            .navigationDestination(for: RecipeModel.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
        
    }
}

#Preview {
    HomeView(recipes: RecipeModel.sampleRecipes)
}
