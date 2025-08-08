//
//  Constants.swift
//  RecipeApp
//
//  Created by Pablo García López on 7/8/25.
//

import Foundation

let defaultRecipeCover: String = "defaultRecipeCover"

let defaultNumPeople: Int = 4
let numPeopleRange: ClosedRange<Int> = 1...16

let INGREDIENTS = [
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

let MEASUREMENTS = [
    "teaspoon", "tablespoon", "cup", "pint", "quart", "gallon",
    "milliliter", "liter", "gram", "kilogram", "ounce", "pound",
    "pinch", "dash", "smidgen", "drop"
].sorted()
