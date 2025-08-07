//
//  HomeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var recipes: [RecipeModel]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    ForEach(recipes, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe) 
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 15)
                .padding(.bottom, 25)
            }
            .navigationTitle("My recipes")
        }
        
    }
}

#Preview {
    HomeView()
}
