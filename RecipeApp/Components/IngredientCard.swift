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
    
    var quantityAndMeasure: Text {
        if let qty = ingredient.quantity, let unit = ingredient.measure {
            
            // An ingredient might have nil quantity and measure.
            if qty.truncatingRemainder(dividingBy: 1) == 0 {
                return Text("^[\(Int(qty)) \(unit)](inflect: true)")
            }
            else {
                return Text("^[\(qty, specifier: "%.2f") \(unit)](inflect: true)")
            }
        }
        return Text("?")
    }
    
    var body: some View {
        HStack {
            Text(ingredient.name!).bold()
            Spacer()
            quantityAndMeasure
        }
        .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
        .background(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.cyan.opacity(0.5), lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    IngredientCard(ingredient: IngredientModel(name: "Salt", quantity: 20, measure: "gram"))
}
