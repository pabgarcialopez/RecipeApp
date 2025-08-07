//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

@main
struct RecipeAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        .modelContainer(for: [RecipeModel.self, IngredientModel.self, StepModel.self, ImageModel.self])
    }
}

//extension UIApplication {
//    func addTapGestureRecognizer() {
//        guard let window = windows.first else { return }
//        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
//        tapGesture.requiresExclusiveTouchType = false
//        tapGesture.cancelsTouchesInView = false
//        tapGesture.delegate = self
//        window.addGestureRecognizer(tapGesture)
//    }
//}
//
//extension UIApplication: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true // set to `false` if you don't want to detect tap during other gestures
//    }
//}
