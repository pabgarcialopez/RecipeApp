//
//  IngredientCard.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import SwiftUI

struct IngredientCard: View {
    let ingredient: IngredientModel
    var multiplier: Double = 1

    var body: some View {
        HStack {
            Text(ingredient.name ?? "?")
                .bold()
            Spacer()
            scaledQuantityText
        }
        .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
        .background(
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.cyan.opacity(0.5), lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
    }
}

private extension IngredientCard {
    
    var scaledQuantityText: Text {
        guard let qty = ingredient.quantity,
              let unit = ingredient.measure else {
            return Text("?")
        }

        let (convertedValue, convertedUnit) = convertValueAndUnit(qty * multiplier, unit: unit)

        // If dividing by 1 gives remainder of 0, it means convertedValue is really an Int
        if convertedValue.truncatingRemainder(dividingBy: 1) == 0 {
            let intValue = Int(convertedValue)
            return Text("^[\(intValue) \(convertedUnit)](inflect: true)")
        } else { // Otherwise, it contains significant decimals
            return Text("^[\(convertedValue, specifier: "%.2f") \(convertedUnit)](inflect: true)")
        }
    }

    func convertValueAndUnit(_ value: Double, unit: String) -> (Double, String) {
        switch unit.lowercased() {
        case "gram", "grams":
            return value >= 1000 ? (value / 1000, "kilogram") : (value, "gram")
        case "kilogram", "kilograms":
            return value < 1 ? (value * 1000, "gram") : (value, "kilogram")
        case "milliliter", "milliliters", "ml":
            return value >= 1000 ? (value / 1000, "liter") : (value, "milliliter")
        case "liter", "liters", "l":
            return value < 1 ? (value * 1000, "milliliter") : (value, "liter")
        case "ounce", "ounces", "oz":
            return value >= 16 ? (value / 16, "pound") : (value, "ounce")
        case "pound", "pounds", "lb", "lbs":
            return value < 1 ? (value * 16, "ounce") : (value, "pound")

        default:
            // Return a cleaned singular form by default if caller passed a plural
            let lower = unit.lowercased()
            if lower.hasSuffix("s") && lower.count > 1 {
                return (value, String(lower.dropLast()))
            }
            return (value, lower)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        IngredientCard(ingredient: IngredientModel(name: "Salt", quantity: 20, measure: "gram"))
        IngredientCard(ingredient: IngredientModel(name: "Flour", quantity: 300, measure: "gram"), multiplier: 4)
        IngredientCard(ingredient: IngredientModel(name: "Milk", quantity: 1200, measure: "milliliter"))
        IngredientCard(ingredient: IngredientModel(name: "Sugar", quantity: 1.3333333, measure: "kilogram"))
    }
    .padding()
}
