//
//  Extensions.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftUI
import UIKit

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

// --------- Hide keyboard functionality ----------------------------

func hideKeyboard() { // Global function to dismiss the keyboard
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

// --------- Image from its name in the Asset Catalog ---------------
func imageModelFromAsset(named name: String) -> ImageModel? {
    guard let uiImage = UIImage(named: name) else { return nil }
    guard let data = uiImage.pngData() else { return nil }
    return ImageModel(data: data)
}

