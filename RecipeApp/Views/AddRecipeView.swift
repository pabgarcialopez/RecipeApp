//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    
    private enum Field: Int, CaseIterable {
        case name, details, time
    }
    
    @Environment(\.selectedTab) var selectedTab
    @Environment(\.modelContext) private var modelContext

    // Main variables
    @State private var name = ""
    @State private var details = ""
    @State private var time: Int? = nil
    @State private var cost: Cost = .cheap
    @State private var difficulty: Difficulty = .easy
    @State private var numPeople = 4
    @State private var steps = [StepModel]()
    @State private var ingredients = [IngredientModel]()
    @State private var imageData: Data? = nil

    // Other useful variables for images
    @State private var selectedPic: PhotosPickerItem?
    
    // Other useful general variables
    let allIngredients = ["None"] + IngredientModel.ingredients
    let allMeasurements = ["None"] + IngredientModel.measurements
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section {
                    VStack {
                        PhotosPicker(selection: $selectedPic) {
                            if let data = imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
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
                    Stepper("^[\(numPeople) person](inflect: true)", value: $numPeople, in: 1...16)
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
                        StepCard(step: $step, order: index + 1, editingDisabled: false)
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
                                ForEach(IngredientModel.ingredients, id: \.self) { item in
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
                                
                                // Measurement picker
                                Picker("Unit", selection: Binding(
                                    get: { ingredient.measure },
                                    set: { ingredient.measure = $0 }
                                )) {
                                    Text("None").tag(Optional<String>.none)
                                    ForEach(IngredientModel.measurements, id: \.self) { unit in
                                        Text(unit).tag(Optional(unit))
                                    }
                                }
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    Button("Add ingredient", systemImage: "plus", action: addIngredient)
                }
            }
            .navigationTitle("New recipe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveRecipe)
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
        
        let recipe = RecipeModel(name: name, details: details, cost: cost, time: time, difficulty: difficulty, numPeople: numPeople)

        for step in steps {
            recipe.steps.append(StepModel(title: step.title, instruction: step.instruction))
        }
        for ing in ingredients {
            recipe.ingredients.append(IngredientModel(name: ing.name, quantity: ing.quantity, measure: ing.measure))
        }
        
        if let data = imageData {
            let imageModel = ImageModel(data: data)
            modelContext.insert(imageModel)
            recipe.photo = imageModel
        }
            
        modelContext.insert(recipe)
        
        // Programatically travel to Home
        selectedTab?.wrappedValue = 0
        
        // To make the fields empty for next recipe.
        resetData()
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
    }
    
    func resetData() {
        name = ""
        details = ""
        time = nil
        cost = .cheap
        difficulty = .easy
        numPeople = 4
        steps = [StepModel]()
        ingredients = [IngredientModel]()
        selectedPic = nil
        imageData = nil
    }
}



#Preview {
    AddRecipeView()
        .modelContainer(for: [
            RecipeModel.self,
            IngredientModel.self,
            StepModel.self,
            ImageModel.self
        ])
}
