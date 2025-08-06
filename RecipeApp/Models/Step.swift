//
//  Step.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation

struct Step: Hashable, Identifiable {
    let id = UUID()
    var title: String
    var instruction: String
}
