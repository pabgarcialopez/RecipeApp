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
    @State private var showNewRecipeSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    ForEach(recipes, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe) {
                                modelContext.delete(recipe)
                                try? modelContext.save()
                            }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New recipe", systemImage: "plus", action: createNewRecipe)
                }
            }
            .sheet(isPresented: $showNewRecipeSheet) {
                RecipeEditView()
            }
        }
    }
    
    func createNewRecipe() {
        showNewRecipeSheet = true
    }
}

#Preview {
    HomeView()
}
