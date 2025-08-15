//
//  Recipe.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import Foundation
import SwiftUI
import SwiftData

enum Cost: String, Codable, CaseIterable, Hashable {
    case cheap = "Cheap", medium = "Medium", pricy = "Pricy"
    
    var symbol: String {
        switch self {
            case .cheap: return "$"
            case .medium: return "$$"
            case .pricy: return "$$$"
        }
    }
    
    var description: String {
        rawValue
    }
}


enum Difficulty: String, Codable, CaseIterable, Hashable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
    
    var color: Color {
        switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
        }
    }
    
    var description: String {
        rawValue
    }
}

@Model
class RecipeModel: Identifiable, Hashable {
    private(set) var id: UUID = UUID()
    var name: String
    var details: String
    var cost: Cost
    var time: Int
    var difficulty: Difficulty
    var numPeople: Int

    @Relationship(deleteRule: .cascade)
    var ingredients: [IngredientModel]

    @Relationship(deleteRule: .cascade)
    var steps: [StepModel]

    @Relationship(deleteRule: .cascade)
    var imageModel: ImageModel?

    init(
        name: String = DEFAULT_RECIPE_NAME,
        details: String = DEFAULT_RECIPE_DETAILS,
        cost: Cost = DEFAULT_RECIPE_COST,
        time: Int = DEFAULT_RECIPE_TIME,
        difficulty: Difficulty = DEFAULT_RECIPE_DIFFICULTY,
        numPeople: Int = DEFAULT_RECIPE_NUM_PEOPLE,
        steps: [StepModel] = [],
        ingredients: [IngredientModel] = [],
        imageModel: ImageModel? = nil
    ) {
        self.name = name
        self.details = details
        self.time = time
        self.cost = cost
        self.difficulty = difficulty
        self.numPeople = numPeople
        self.steps = steps
        self.ingredients = ingredients
        self.imageModel = imageModel
    }

}

extension RecipeModel {
    static let sampleRecipes: [RecipeModel] = {
        let taco = RecipeModel(
            name: "Tacos with a lot lot of cheese",
            details: "Crispy corn tacos filled with a deliciously seasoned blend of ground beef, fresh vegetables, and melted cheese, topped with a tangy salsa and a dollop of sour cream. Perfect for a festive dinner or a casual weeknight meal, these tacos are packed with flavor and guaranteed to satisfy your cravings.",
            cost: Cost.medium,
            time: 30,
            difficulty: Difficulty.easy,
            numPeople: 3
        )
        
        taco.steps = [
            StepModel(title: "Prep", instruction: "Dice the onions, tomatoes, and lettuce. Grate the cheese and set aside all toppings in individual bowls for easy access."),
            StepModel(title: "Cook", instruction: "Heat a skillet over medium heat. Add the ground beef and cook until browned, breaking it apart with a spatula. Stir in taco seasoning and a splash of water. Simmer for 5–7 minutes until the mixture thickens."),
            StepModel(title: "Assemble", instruction: "Warm the taco shells in the oven or microwave. Spoon the beef mixture into each shell, then layer with lettuce, tomato, cheese, salsa, and a dollop of sour cream. Serve immediately.")
        ]

        taco.ingredients = [
            IngredientModel(name: "Beef", quantity: 300, measure: "grams"),
            IngredientModel(name: "Tomato", quantity: 1, measure: "unit")
        ]
        return [taco]
    }()
}
