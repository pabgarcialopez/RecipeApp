//
//  CustomTextField.swift
//  RecipeApp
//
//  Created by Pablo García López on 18/8/25.
//

import SwiftUI

struct CustomTextField: View {
    
    let title: String
    let prompt: String
    let axis: Axis?
    
    @Binding var text: String
    
    init(title: String, prompt: String, text: Binding<String>, axis: Axis? = nil) {
        self.title = title
        self.prompt = prompt
        self._text = text
        self.axis = axis
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title3.bold())
            
            if let axis {
                TextField(prompt, text: $text, axis: axis)
            } else {
                TextField(prompt, text: $text)
            }
        }
        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black, lineWidth: 2)
        }
    }
}

#Preview {
    @Previewable @State var text = "Hello"
    
    VStack(spacing: 20) {
        // Default (no axis)
        CustomTextField(title: "Title", prompt: "Prompt", text: $text)
        
        // With vertical axis
        CustomTextField(title: "Title", prompt: "Prompt", text: $text, axis: .vertical)
        
        // With vertical axis
        CustomTextField(title: "Title", prompt: "Prompt", text: $text, axis: .horizontal)
    }
    .padding()
}
