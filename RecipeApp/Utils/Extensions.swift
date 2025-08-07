//
//  Extensions.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftUI

// --------- For pastel colors in IngredientCard's. -----------------
extension Color {
    static var randomPastel: Color {
        let hue = Double.random(in: 0...1)
        let saturation = Double.random(in: 0.4...0.6) // softer tones
        let brightness = Double.random(in: 0.85...1.0)

        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}
// ------------------------------------------------------------------

// --------- Allow easy programatic navigation between tabs ---------
struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<Int>? = nil
}

extension EnvironmentValues {
    var selectedTab: Binding<Int>? {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}
// ------------------------------------------------------------------

// --------- Hide keyboard functionality ----------------------------

#if canImport(UIKit)
import UIKit

/// Global function to dismiss the keyboard
func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
#endif
// ------------------------------------------------------------------
