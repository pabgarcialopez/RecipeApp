//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    
    @Environment(\.selectedTab) var selectedTab
    
    @State private var name = ""
    @State private var description = ""
    @State private var time: Int? = nil
    @State private var cost: Cost = .cheap
    @State private var difficulty: Difficulty = .easy
    @State private var numPeople = 4
    @State private var steps = [Step]()
    @State private var ingredients = [Ingredient]()
    @State private var imageName: String? = nil
    // Other useful variables
    @State private var selectedPic: PhotosPickerItem?
    @State private var image: Image? = nil
    
    @Binding var recipes: [Recipe]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Upload picture") {
                    VStack {
                        PhotosPicker(selection: $selectedPic) {
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    
                            } else {
                                ContentUnavailableView("Upload image", systemImage: "fork.knife.circle", description: Text("Better in landscape orientation"))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .onChange(of: selectedPic) {
                            loadImage(from: selectedPic)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                        
                    if image != nil {
                        Button("Delete current picture", role: .destructive, action: deleteCurrentPicture)
                        .frame(maxWidth: .infinity, alignment: .center) // Center button
                    }
                }
                
                
                
                Section("Recipe basics") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                }
                
                Section("Time (minutes)") {
                    TextField("20", value: $time, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section("Difficulty") {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Cost") {
                    Picker("Cost", selection: $cost) {
                        ForEach(Cost.allCases, id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Steps")) {
                    ForEach(Array($steps.enumerated()), id: \.element.id) { index, $step in
                        StepCard(step: $step, order: index + 1, editingEnabled: true)
                    }
                    .onDelete(perform: deleteStep)
                    Button("Add step", systemImage: "plus", action: addStep)
                }
                
                Section("Ingredients") {
                    ForEach($ingredients, id: \.id) { $ingredient in
                        VStack(alignment: .leading, spacing: 3) {
                            // Top row: Ingredient Picker
                            Picker("Pick an ingredient", selection: $ingredient.name) {
                                ForEach(Ingredient.ingredients, id: \.self) { item in
                                    Text(item)
                                }
                            }
                            
                            // Second row: Quantity + Measurement
                            HStack {
                                // Quantity input
                                HStack {
                                    Image(systemName: "number")
                                        .foregroundStyle(.gray)
                                    Text("Qty")
                                    TextField("Quantity", value: $ingredient.quantity, format: .number)
                                        .keyboardType(.decimalPad)
                                }
                                                                
                                // Measurement picker
                                HStack {
                                    Picker("Unit", selection: $ingredient.measure) {
                                        ForEach(Ingredient.measurements, id: \.self) { unit in
                                            Text(unit)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    Button("Add ingredient", systemImage: "plus", action: addIngredient)
                        .disabled(addIngredientDisable())
                }
                
                Section("Number of people") {
                    Stepper("^[\(numPeople) person](inflect: true)", value: $numPeople, in: 1...16)
                }
            }
            .navigationTitle("New recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveRecipe)
                        .disabled(saveRecipeDisable())
                }
            }
        }
    }
    
    func addStep() {
        steps.append(Step(title: "", instruction: ""))
    }
    
    func deleteStep(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets)
    }
    
    func addIngredient() {
        ingredients.append(Ingredient(name: "", quantity: 1, measure: "gram"))
    }
    
    func addIngredientDisable() -> Bool {
        return !ingredients.isEmpty && ingredients.last!.name.isEmpty
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    func saveRecipe() {
        guard time != nil else { return }
            
        recipes.append(Recipe(name: name, description: description, cost: cost, time: time!, difficulty: difficulty, numPeople: numPeople, steps: steps, ingredients: ingredients, imageName: imageName))
        
        // Programatically travel to Home
        selectedTab?.wrappedValue = 0
        
        resetData()
    }
    
    func saveRecipeDisable() -> Bool {
        return name.isEmpty || time == nil
    }
    
    func loadImage(from item: PhotosPickerItem?) {
        Task {
            if let data = try? await item?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            }
        }
    }
    
    func deleteCurrentPicture() {
       image = nil
       selectedPic = nil
    }
    
    func resetData() {
        name = ""
        description = ""
        time = nil
        cost = .cheap
        difficulty = .easy
        numPeople = 4
        steps = [Step]()
        ingredients = [Ingredient]()
        imageName = nil
        selectedPic = nil
        image = nil
    }
}



#Preview {
    AddRecipeView(recipes: .constant(Recipe.sampleRecipes))
}
