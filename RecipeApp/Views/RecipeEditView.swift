//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import PhotosUI

struct RecipeEditView: View {
    
    private enum Field: Int, CaseIterable {
        case name, details, time
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    // Main variables
    @State var existingRecipe: RecipeModel? = nil
    @State private var name = DEFAULT_RECIPE_NAME
    @State private var details = DEFAULT_RECIPE_DETAILS
    @State private var time: Int? = DEFAULT_RECIPE_TIME
    @State private var cost: Cost = DEFAULT_RECIPE_COST
    @State private var difficulty: Difficulty = DEFAULT_RECIPE_DIFFICULTY
    @State private var numPeople = DEFAULT_RECIPE_NUM_PEOPLE
    @State private var steps = [StepModel]()
    @State private var ingredients = [IngredientModel]()
    @State private var imageData: Data? = nil

    // Other useful variables for images
    @State private var selectedPic: PhotosPickerItem?
    
    // Other useful general variables
    let allIngredients = ["None"] + INGREDIENTS
    let allMeasurements = ["None"] + MEASUREMENTS
    
    // Allows editing existing recipes
    init(existingRecipe: RecipeModel? = nil) {
        self.existingRecipe = existingRecipe
        
        // If editing, initialize @State vars with recipe data
        if let recipe = existingRecipe {
            _name = State(initialValue: recipe.name)
            _details = State(initialValue: recipe.details)
            _time = State(initialValue: recipe.time)
            _cost = State(initialValue: recipe.cost)
            _difficulty = State(initialValue: recipe.difficulty)
            _numPeople = State(initialValue: recipe.numPeople)
            _steps = State(initialValue: Array(recipe.steps))
            _ingredients = State(initialValue: Array(recipe.ingredients))
            if let imageModel = recipe.imageModel {
                _imageData = State(initialValue: imageModel.data)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        PhotosPicker(selection: $selectedPic) {
                            if let imageData = imageData, let image = ImageModel(data: imageData).image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else {
                                ContentUnavailableView("Upload image", systemImage: "fork.knife.circle", description: Text("Better in landscape orientation"))
                            }
                        }
                        .onChange(of: selectedPic) {
                            loadImage(from: selectedPic)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    if self.imageData != nil {
                        Button("Delete current picture", role: .destructive, action: deleteCurrentPicture)
                            .frame(maxWidth: .infinity, alignment: .center) // Center button
                    }
                }
                
                Section("Basics") {
                    TextField("Name", text: $name)
                        .keyboardType(.default)
                    
                    TextField("Details", text: $details, axis: .vertical)
                        .keyboardType(.default)
                }
                
                Section("Time (minutes)") {
                    TextField("20", value: $time, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section("Number of people") {
                    Stepper("^[\(numPeople) person](inflect: true)", value: $numPeople, in: DEFAULT_RECIPE_NUM_PEOPLE_RANGE)
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
                
                Section("Steps") {
                    ForEach(Array($steps.enumerated()), id: \.element.id) { index, $step in
                        StepCard(step: $step, order: index + 1)
                    }
                    .onDelete(perform: deleteStep)
                    Button("Add step", systemImage: "plus", action: addStep)
                }
                
                Section("Ingredients") {
                    ForEach($ingredients, id: \.id) { $ingredient in
                        VStack(alignment: .leading, spacing: 3) {
                            
                            // Ingredient name picker
                            Picker("Pick an ingredient", selection: Binding(
                                get: { ingredient.name },
                                set: { ingredient.name = $0 }
                            )) {
                                Text("None").tag(Optional<String>.none)
                                ForEach(INGREDIENTS, id: \.self) { item in
                                    Text(item).tag(Optional(item))
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
                                
                                Spacer()
                                
                                // Measurement picker
                                Picker("Unit", selection: Binding(
                                    get: { ingredient.measure },
                                    set: { ingredient.measure = $0 }
                                )) {
                                    Text("None").tag(Optional<String>.none)
                                    ForEach(MEASUREMENTS, id: \.self) { unit in
                                        Text(unit).tag(Optional(unit))
                                    }
                                }
                                .fixedSize() // To make the Picker not expand
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    Button("Add ingredient", systemImage: "plus", action: addIngredient)
                }
            }
            .navigationTitle("New recipe")
            .toolbar {
                ToolbarItem(placement: .principal) { EmptyView() }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveRecipe)
                        .buttonStyle(.borderedProminent)
                        .disabled(saveRecipeDisable())
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset", action: resetData)
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                      hideKeyboard()
                    }
                }
            }
        }
    }
    
    func addStep() {
        steps.append(StepModel(title: "", instruction: ""))
    }
    
    func deleteStep(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets)
    }
    
    func addIngredient() {
        ingredients.append(IngredientModel(name: nil, quantity: nil, measure: nil))
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    func saveRecipe() {
        guard let time = time else { return }
        
        let recipeToSave = existingRecipe ?? RecipeModel(name: name, details: details, cost: cost, time: time, difficulty: difficulty, numPeople: numPeople)
        
        // Update fields
        recipeToSave.name = name
        recipeToSave.details = details
        recipeToSave.time = time
        recipeToSave.cost = cost
        recipeToSave.difficulty = difficulty
        recipeToSave.numPeople = numPeople
        
        // Replace steps and ingredients
        recipeToSave.steps = []
        for step in steps {
            recipeToSave.steps.append(StepModel(title: step.title, instruction: step.instruction))
        }
        
        recipeToSave.ingredients = []
        for ing in ingredients {
            recipeToSave.ingredients.append(IngredientModel(name: ing.name, quantity: ing.quantity, measure: ing.measure))
        }
        
        if let data = imageData {
            if let existingImageModel = recipeToSave.imageModel {
                existingImageModel.data = data
            } else {
                let imageModel = ImageModel(data: data)
                modelContext.insert(imageModel)
                recipeToSave.imageModel = imageModel
            }
        } else {
            // Optionally delete the image if user removed it
            if let existingImageModel = recipeToSave.imageModel {
                modelContext.delete(existingImageModel)
                recipeToSave.imageModel = nil
            }
        }
        
        // New recipe (not existing one)
        if existingRecipe == nil {
            modelContext.insert(recipeToSave)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save recipe: \(error)")
        }
        
        // Navigate back and reset values.
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            resetData()
        }
    }
    
    func saveRecipeDisable() -> Bool {
        let someIngredientHasName = ingredients.contains(where: { ingredient in
            ingredient.name != nil && ingredient.name != ""
        })
        
        let someStepHasTitle = steps.contains(where: { step in
            step.title != ""
        })
        
        return name.isEmpty || time == nil || !someIngredientHasName || !someStepHasTitle
    }
    
    func loadImage(from item: PhotosPickerItem?) {
        Task {
            if let data = try? await item?.loadTransferable(type: Data.self) {
                if UIImage(data: data) != nil {
                    self.imageData = data // Store image data for saving
                }
            }
        }
    }
    
    func deleteCurrentPicture() {
        selectedPic = nil
        imageData = nil
    }
    
    func resetData() {
        if existingRecipe == nil {
            name = DEFAULT_RECIPE_NAME
            details = DEFAULT_RECIPE_DETAILS
            time = DEFAULT_RECIPE_TIME
            cost = DEFAULT_RECIPE_COST
            difficulty = DEFAULT_RECIPE_DIFFICULTY
            numPeople = DEFAULT_RECIPE_NUM_PEOPLE
            steps = []
            ingredients = []
            selectedPic = nil
            imageData = nil
        }
    }
}



#Preview {
    RecipeEditView()
        .modelContainer(for: [
            RecipeModel.self,
            IngredientModel.self,
            StepModel.self,
            ImageModel.self
        ])
}
