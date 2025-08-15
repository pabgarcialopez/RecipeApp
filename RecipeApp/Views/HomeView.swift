//
//  HomeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query private var recipes: [RecipeModel]
    @State private var showNewRecipeSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    ContentUnavailableView("No recipes yet", systemImage: "carrot", description: Text("Add some now!"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
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
                }
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
