//
//  ImageModel.swift
//  RecipeApp
//
//  Created by Pablo García López on 6/8/25.
//

import Foundation
import SwiftData
import SwiftUI

// We use a different model for Image's so they don't pose a performance issue.

@Model
class ImageModel: Identifiable {
    private(set) var id: UUID = UUID()
    
    @Attribute(.externalStorage)
    var data: Data
    
    var image: Image? {
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }

    init(data: Data) {
        self.data = data
    }
}
