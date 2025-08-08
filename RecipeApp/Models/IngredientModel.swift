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
