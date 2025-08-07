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
    case cheap = "Cheap", intermediate = "Intermediate", pricy = "Pricy"
    
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


enum Difficulty: String, Codable, CaseIterable, Hashable {
    case easy = "Easy", intermediate = "Intermediate", hard = "Hard"
    
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

@Model
class RecipeModel: Identifiable, Hashable {
    private(set) var id: UUID = UUID()
    var name: String
    var details: String
    var cost: Cost
    var time: Int
    var difficulty: Difficulty
    var numPeople: Int

    @Relationship(deleteRule: .nullify)
    var ingredients: [IngredientModel] = []

    @Relationship(deleteRule: .cascade)
    var steps: [StepModel] = []

    @Relationship(deleteRule: .nullify)
    var photo: ImageModel?

    init(name: String, details: String, cost: Cost, time: Int, difficulty: Difficulty, numPeople: Int) {
        self.name = name
        self.details = details
        self.cost = cost
        self.time = time
        self.difficulty = difficulty
        self.numPeople = numPeople
    }
}

extension RecipeModel {
    static let sampleRecipes: [RecipeModel] = {
        let taco = RecipeModel(
            name: "Tacos",
            details: "Crispy corn tacos...",
            cost: Cost.intermediate,
            time: 30,
            difficulty: Difficulty.easy,
            numPeople: 3
        )
        taco.steps = [
            StepModel(title: "Prep", instruction: "Dice..."),
            StepModel(title: "Cook", instruction: "Brown beef"),
            StepModel(title: "Assemble", instruction: "Fill shells")
        ]
        taco.ingredients = [
            IngredientModel(name: "Beef", quantity: 300, measure: "grams"),
            IngredientModel(name: "Tomato", quantity: 1, measure: "unit")
        ]
        return [taco]
    }()
}
