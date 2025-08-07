//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftData

@Model
class IngredientModel: Hashable, Identifiable {
    private(set) var id = UUID()
    var name: String?
    var quantity: Double?
    var measure: String?
    
    init(name: String? = nil, quantity: Double? = nil, measure: String? = nil) {
        self.name = name
        self.quantity = quantity
        self.measure = measure
    }
}

extension IngredientModel {
    static let ingredients = [
        "Water", "Salt", "Sugar", "Olive oil", "Vegetable oil", "Butter",
        "Flour", "Milk", "Eggs", "Onion", "Garlic", "Tomato", "Potato", "Rice",
        "Pasta", "Chicken", "Beef", "Pork", "Fish", "Shrimp", "Lentils", "Beans",
        "Carrot", "Bell pepper", "Celery", "Cream", "Yogurt", "Cheese",
        "Vinegar", "Honey", "Mustard", "Soy sauce", "Basil", "Parsley",
        "Thyme", "Oregano", "Cumin", "Black pepper", "Paprika", "Cinnamon",
        "Ginger", "Chili powder", "Broth", "Stock", "Coconut milk", "Mushrooms",
        "Spinach", "Zucchini", "Broccoli", "Corn", "Peas", "Lemon", "Orange",
        "Apple", "Banana", "Flour (whole wheat)", "Cocoa powder", "Vanilla extract",
        "Baking powder", "Baking soda"
    ].sorted()

    static let measurements = [
        "teaspoon", "tablespoon", "cup", "pint", "quart", "gallon",
        "milliliter", "liter", "gram", "kilogram", "ounce", "pound",
        "pinch", "dash", "smidgen", "drop"
    ].sorted()
}
