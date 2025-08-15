//
//  AddRecipeView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct RecipeEditView: View {
    
    private enum Field: Int, CaseIterable {
        case name, details, time
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    // Main variables
    @Bindable var recipe: RecipeModel

    // Keep image transient state locally
    @State private var imageData: Data? = nil
    @State private var selectedPic: PhotosPickerItem?

    // Other useful general variables
    let allIngredients = ["None"] + INGREDIENTS
    let allMeasurements = ["None"] + MEASUREMENTS

    // Track whether this view created the recipe (so we insert only on save)
    private let isNew: Bool
    
    // MARK: - Initializers
    
    init() {
        // Create a new blank recipe using defaults in RecipeModel
        self._recipe = .init(wrappedValue: RecipeModel())
        self.isNew = true
    }

    init(recipe: RecipeModel) {
        self._recipe = .init(wrappedValue: recipe)
        self.isNew = false

        // Seed transient image data from model if present
        if let imageModel = recipe.imageModel {
            _imageData = State(initialValue: imageModel.data)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Photo section
                Section {
                    VStack {
                        PhotosPicker(selection: $selectedPic) {
                            if let imageData = imageData {
                                if let image = ImageModel(data: imageData).image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                }
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
                
                // MARK: - Basics
                Section("Basics") {
                    TextField("Name", text: $recipe.name)
                        .keyboardType(.default)
                    
                    TextField("Details", text: $recipe.details, axis: .vertical)
                        .keyboardType(.default)
                }
                
                // MARK: - Time
                Section("Time (minutes)") {
                    // Bind directly to model's time
                    TextField("\(recipe.time)", value: $recipe.time, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                // MARK: - Number of people
                Section("Number of people") {
                    Stepper("^[\(recipe.numPeople) person](inflect: true)", value: $recipe.numPeople, in: DEFAULT_RECIPE_NUM_PEOPLE_RANGE)
                }
                
                // MARK: - Difficulty
                Section("Difficulty") {
                    Picker("Difficulty", selection: $recipe.difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // MARK: - Cost
                Section("Cost") {
                    Picker("Cost", selection: $recipe.cost) {
                        ForEach(Cost.allCases, id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // MARK: - Steps
                Section("Steps") {
                    // Iterate indices and create Binding(get:set:) for each element
                    ForEach(recipe.steps.indices, id: \.self) { index in
                        StepCard(
                            step: Binding(
                                get: { recipe.steps[index] },
                                set: { recipe.steps[index] = $0 }
                            ),
                            order: index + 1
                        )
                    }
                    .onDelete(perform: deleteStep)
                    Button("Add step", systemImage: "plus", action: addStep)
                }
                
                // MARK: - Ingredients
                Section("Ingredients") {
                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        // Local bindings to specific ingredient fields
                        let nameBinding = Binding<String?>(
                            get: { recipe.ingredients[index].name },
                            set: { recipe.ingredients[index].name = $0 }
                        )
                        let quantityBinding = Binding<Double?>(
                            get: { recipe.ingredients[index].quantity },
                            set: { recipe.ingredients[index].quantity = $0 }
                        )
                        let measureBinding = Binding<String?>(
                            get: { recipe.ingredients[index].measure },
                            set: { recipe.ingredients[index].measure = $0 }
                        )

                        VStack(alignment: .leading, spacing: 3) {
                            // Ingredient name picker
                            Picker("Pick an ingredient", selection: nameBinding) {
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
                                    TextField("Quantity", value: quantityBinding, format: .number)
                                        .keyboardType(.decimalPad)
                                }
                                
                                Spacer()
                                
                                // Measurement picker
                                Picker("Unit", selection: measureBinding) {
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
            .navigationTitle(isNew ? "New recipe" : "Edit recipe")
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
            .onAppear {
                // Ensure transient imageData is set from model if not already set
                if imageData == nil {
                    imageData = recipe.imageModel?.data
                }
            }
        }
    }
    
    // MARK: - Actions for steps / ingredients
    
    func addStep() {
        recipe.steps.append(StepModel(title: "", instruction: ""))
    }
    
    func deleteStep(at offsets: IndexSet) {
        recipe.steps.remove(atOffsets: offsets)
    }
    
    func addIngredient() {
        recipe.ingredients.append(IngredientModel(name: nil, quantity: nil, measure: nil))
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        recipe.ingredients.remove(atOffsets: offsets)
    }
    
    // MARK: - Save / Reset / Helpers

    func saveRecipe() {
        // Update image model (create / update / delete) using transient imageData
        if let data = imageData {
            if let imageModel = recipe.imageModel {
                imageModel.data = data
            } else {
                let imageModel = ImageModel(data: data)
                modelContext.insert(imageModel)
                recipe.imageModel = imageModel
            }
        } else {
            if let imageModel = recipe.imageModel {
                modelContext.delete(imageModel)
                recipe.imageModel = nil
            }
        }
        
        // Insert recipe if it was newly created in this view
        if isNew {
            modelContext.insert(recipe)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save recipe: \(error)")
        }
        
        // Navigate back
        dismiss()
    }
    
    func saveRecipeDisable() -> Bool {
        return recipe.name.isEmpty
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
        recipe.name = DEFAULT_RECIPE_NAME
        recipe.details = DEFAULT_RECIPE_DETAILS
        recipe.time = DEFAULT_RECIPE_TIME
        recipe.cost = DEFAULT_RECIPE_COST
        recipe.difficulty = DEFAULT_RECIPE_DIFFICULTY
        recipe.numPeople = DEFAULT_RECIPE_NUM_PEOPLE
        recipe.steps = []
        recipe.ingredients = []
        selectedPic = nil
        imageData = nil
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
