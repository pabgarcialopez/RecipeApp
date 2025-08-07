//
//  IngredientCard.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftUI

struct IngredientCard: View {
    let ingredient: IngredientModel
    
    var body: some View {
        VStack {
            Text(ingredient.name!).bold()
            // An ingredient might have nil quantity and measure.
            if ingredient.quantity != nil && ingredient.measure != nil {
                Text("^[\(ingredient.quantity!, specifier: "%.2f") \(ingredient.measure!)](inflect: true)")
            }
            
        }
        .padding()
        .background(Color.randomPastel)
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
    }
}

#Preview {
    IngredientCard(ingredient: IngredientModel(name: "Salt", quantity: 20, measure: "gram"))
}
