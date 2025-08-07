//
//  AddRecipeTestView.swift
//  RecipeApp
//
//  Created by Pablo García López on 6/8/25.
//

import SwiftUI

struct AddRecipeTestView: View {
    @FocusState private var focusedField: Bool
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .focused($focusedField)
                    .keyboardType(.default)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = false
                    }
                }
            }
        }
    }
}


#Preview {
    AddRecipeTestView()
}
