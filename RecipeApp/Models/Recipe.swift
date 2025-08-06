//
//  Recipe.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import Foundation
import SwiftUI

enum Cost: String, Hashable, CaseIterable {
    case cheap = "Cheap"
    case intermediate = "Intermediate"
    case pricy = "Pricy"
    
    var symbol: String {
        switch self {
            case .cheap: return "$"
            case .intermediate: return "$$"
            case .pricy: return "$$$"
        }
    }
    
    var description: String {
        rawValue
    }
}


enum Difficulty: String, Hashable, CaseIterable {
    case easy = "Easy"
    case intermediate = "Intermediate"
    case hard = "Hard"
    
    var color: Color {
        switch self {
            case .easy: return .green
            case .intermediate: return .orange
            case .hard: return .red
        }
    }
    
    var description: String {
        rawValue
    }
}

struct Recipe: Identifiable, Hashable {
    
    let id = UUID()
    var name: String
    var description: String
    var cost: Cost
    var time: Int
    var difficulty: Difficulty
    var numPeople: Int
    
    var steps: [Step]
    var ingredients: [Ingredient]
    var imageName: String?
    
    init(name: String, description: String, cost: Cost, time: Int, difficulty: Difficulty, numPeople: Int, steps: [Step], ingredients: [Ingredient], imageName: String?) {
        self.name = name
        self.description = description
        self.cost = cost
        self.time = time
        self.difficulty = difficulty
        self.numPeople = numPeople
        self.steps = steps
        self.ingredients = ingredients
        self.imageName = imageName
    }
}

extension Recipe {
    static let sampleRecipes: [Recipe] = [
        Recipe(
            name: "Tacos",
            description: "Crispy corn tacos filled with spiced beef, fresh veggies, and creamy sauce.",
            cost: .intermediate,
            time: 30,
            difficulty: .easy,
            numPeople: 3,
            steps: [
                Step(title: "Prep Ingredients", instruction: "Dice tomatoes, onions, and lettuce."),
                Step(title: "Cook Beef", instruction: "Brown the beef with taco seasoning."),
                Step(title: "Assemble Tacos", instruction: "Fill taco shells with beef and toppings.")
            ],
            ingredients: [
                Ingredient(name: "Ground Beef", quantity: 300, measure: "grams"),
                Ingredient(name: "Taco Shells", quantity: 6, measure: "units"),
                Ingredient(name: "Tomato", quantity: 1, measure: "unit"),
                Ingredient(name: "Lettuce", quantity: 1, measure: "cup"),
                Ingredient(name: "Sour Cream", quantity: 0.25, measure: "cup")
            ],
            imageName: "tacos"
        ),
        
        Recipe(
            name: "Fajitas",
            description: "Sizzling chicken fajitas with colorful bell peppers and onions.",
            cost: .intermediate,
            time: 25,
            difficulty: .easy,
            numPeople: 2,
            steps: [
                Step(title: "Prepare Ingredients", instruction: "Slice chicken and vegetables."),
                Step(title: "Cook Chicken", instruction: "Sauté chicken until golden."),
                Step(title: "Add Vegetables", instruction: "Cook with peppers and onions.")
            ],
            ingredients: [
                Ingredient(name: "Chicken Breast", quantity: 300, measure: "grams"),
                Ingredient(name: "Bell Peppers", quantity: 2, measure: "units"),
                Ingredient(name: "Onion", quantity: 1, measure: "unit"),
                Ingredient(name: "Tortillas", quantity: 4, measure: "units")
            ],
            imageName: "fajitas"
        ),
        
        Recipe(
            name: "Garlic Pasta",
            description: "Creamy garlic pasta with a rich and flavorful sauce.",
            cost: .cheap,
            time: 20,
            difficulty: .easy,
            numPeople: 2,
            steps: [
                Step(title: "Boil Pasta", instruction: "Cook pasta until al dente."),
                Step(title: "Make Sauce", instruction: "Sauté garlic and mix with cream."),
                Step(title: "Combine", instruction: "Toss pasta with sauce and serve.")
            ],
            ingredients: [
                Ingredient(name: "Spaghetti", quantity: 200, measure: "grams"),
                Ingredient(name: "Garlic", quantity: 3, measure: "cloves"),
                Ingredient(name: "Cream", quantity: 0.5, measure: "cup"),
                Ingredient(name: "Parmesan", quantity: 0.25, measure: "cup")
            ],
            imageName: "garlic-pasta"
        ),
        
        Recipe(
            name: "Honey Soy Salmon",
            description: "Glazed salmon with a sweet and savory honey-soy sauce.",
            cost: .pricy,
            time: 30,
            difficulty: .intermediate,
            numPeople: 2,
            steps: [
                Step(title: "Marinate Salmon", instruction: "Soak salmon in honey-soy mix."),
                Step(title: "Cook Salmon", instruction: "Pan-sear until golden."),
                Step(title: "Glaze & Serve", instruction: "Brush glaze on top and serve.")
            ],
            ingredients: [
                Ingredient(name: "Salmon Fillets", quantity: 2, measure: "pieces"),
                Ingredient(name: "Soy Sauce", quantity: 0.25, measure: "cup"),
                Ingredient(name: "Honey", quantity: 2, measure: "tbsp"),
                Ingredient(name: "Garlic", quantity: 2, measure: "cloves")
            ],
            imageName: "honey-soy-salmon"
        ),
        
        Recipe(
            name: "Lemon Chicken",
            description: "Juicy chicken breasts with a zesty lemon herb marinade.",
            cost: .intermediate,
            time: 35,
            difficulty: .intermediate,
            numPeople: 4,
            steps: [
                Step(title: "Make Marinade", instruction: "Mix lemon juice and herbs."),
                Step(title: "Marinate Chicken", instruction: "Let chicken rest in mixture."),
                Step(title: "Grill Chicken", instruction: "Cook until golden and juicy.")
            ],
            ingredients: [
                Ingredient(name: "Chicken Breast", quantity: 500, measure: "grams"),
                Ingredient(name: "Lemon Juice", quantity: 0.25, measure: "cup"),
                Ingredient(name: "Rosemary", quantity: 1, measure: "tsp"),
                Ingredient(name: "Olive Oil", quantity: 2, measure: "tbsp")
            ],
            imageName: "lemon-chicken"
        ),
        
        Recipe(
            name: "Veggie Bowl",
            description: "A healthy grain bowl packed with fresh vegetables and protein.",
            cost: .cheap,
            time: 15,
            difficulty: .easy,
            numPeople: 1,
            steps: [
                Step(title: "Cook Base", instruction: "Prepare rice or quinoa."),
                Step(title: "Chop Veggies", instruction: "Dice fresh vegetables."),
                Step(title: "Assemble Bowl", instruction: "Layer base, veggies, and sauce.")
            ],
            ingredients: [
                Ingredient(name: "Quinoa", quantity: 100, measure: "grams"),
                Ingredient(name: "Cucumber", quantity: 0.5, measure: "unit"),
                Ingredient(name: "Tomatoes", quantity: 1, measure: "unit"),
                Ingredient(name: "Chickpeas", quantity: 0.5, measure: "cup")
            ],
            imageName: "vegie-bowl"
        )
    ]
}

