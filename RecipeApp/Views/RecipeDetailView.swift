//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Pablo García López on 31/7/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    // Mutations of the recipe are handled via the modelContext.
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var recipe: RecipeModel
    @State private var newNumPeople: Int
    @State private var deleteAlertShowing: Bool
    @State private var showEditRecipeSheet: Bool
        
    var sharingURL: String { return "\(recipe.name)" }
    var multiplier: Double { Double(newNumPeople) / Double(recipe.numPeople) }
    
    init(recipe: RecipeModel) {
        _recipe = .init(wrappedValue: recipe)
        _newNumPeople = State(initialValue: recipe.numPeople) // To avoid error about property initializer
        _deleteAlertShowing = State(initialValue: false)
        _showEditRecipeSheet = State(initialValue: false)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack { // To apply padding. Padding on ScrollView looks weird.
                    
                    // Recipe photo, name and details
                    VStack(alignment: .leading) {
                        (recipe.imageModel?.image ?? Image(DEFAULT_RECIPE_COVER))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(recipe.name)
                                .font(.title).bold()
                            HStack(spacing: 25) {
                                specificsBox(systemName: "clock", text: Text("\(recipe.time) mins"))
                                specificsBox(systemName: "chart.bar", text: Text(recipe.difficulty.description))
                                specificsBox(systemName: "dollarsign", text: Text(recipe.cost.description))
                            }
                            .padding()
                            .background(Color.cyan.opacity(0.2))
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                        .padding([.top, .bottom], 10)
                        
                        Text(recipe.details)
                            .font(.system(size: 18))
                        
                        Divider()
                            .overlay(.cyan)
                            .padding(.top, 10)
                        
                        // Ingredients
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack {
                                Text("Ingredients")
                                    .font(.title3).bold()
                                
                                Spacer()
                                                                
                                Stepper(value: $newNumPeople, in: DEFAULT_RECIPE_NUM_PEOPLE_RANGE) {
                                    Text("^[\(newNumPeople) person](inflect: true)")
                                }
                                .fixedSize()
                            }
                            
                            ForEach(recipe.ingredients, id: \.id) { ingredient in
                                IngredientCard(ingredient: ingredient, multiplier: multiplier)
                            }
                        }
                        .padding(.top)
                        
                        // Steps
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Steps")
                                .font(.title3).bold()
                                .padding(.top)
                            
                            ForEach(Array(recipe.steps.enumerated()), id: \.element.id) { index, step in
                                StepCard(step: step, order: index + 1)
                            }
                        }
                    }
                }
                .padding()
            }
            .alert("Sure to delete this recipe?", isPresented: $deleteAlertShowing, actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive, action: deleteRecipe)
            }, message: { Text("You won't be able to get it back!") })
            .sheet(isPresented: $showEditRecipeSheet) {
                RecipeEditView(recipe: recipe)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Button("Edit", systemImage: "pencil", action: editRecipe)
                            Button("Delete", systemImage: "trash", role: .destructive, action: toggleDeletionAlert)
                        }
                        
                        ShareLink(item: sharingURL) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    func editRecipe() {
        showEditRecipeSheet = true
    }
    
    func toggleDeletionAlert() {
        deleteAlertShowing = true
    }
    
    func deleteRecipe() {
        
        do {
            recipe.steps.removeAll()
            recipe.ingredients.removeAll()
            recipe.imageModel = nil
            modelContext.delete(recipe)
            try modelContext.save()
            
        } catch {
            print("Failed to delete recipe: \(error)")
        }
        
        dismiss()
    }

    
    func specificsBox(systemName: String, text: Text) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemName)
            text
        }
        .font(.subheadline)
        .foregroundStyle(.primary)
    }
}

#Preview {
    RecipeDetailView(recipe: RecipeModel.sampleRecipes[0])
        .modelContainer(for: RecipeModel.self, inMemory: true)
}
