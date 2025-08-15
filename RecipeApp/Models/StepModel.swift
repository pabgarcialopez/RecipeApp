//
//  Step.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftData



@Model
class StepModel: Hashable, Identifiable {
    private(set) var id: UUID
    var title: String
    var instruction: String
    
    init(title: String, instruction: String) {
        self.id = UUID()
        self.title = title
        self.instruction = instruction
    }
}
