//
//  StepCard.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import SwiftUI

struct StepCard: View {
    @Binding private var step: StepModel
    
    let order: Int
    let editingDisabled: Bool
    let powderBlueColor = Color(red: 0.80, green: 0.90, blue: 1.0)

    // Initializer for binding (editable mode)
    init(step: Binding<StepModel>, order: Int) {
        self._step = step
        self.order = order
        self.editingDisabled = false
    }

    // Initializer for read-only mode
    init(step: StepModel, order: Int) {
        self._step = .constant(step)
        self.order = order
        self.editingDisabled = true
    }

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Text("\(order)")
                .font(.body.bold())
                .frame(width: 35, height: 35)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 10) {
                if editingDisabled {
                    Text(step.title)
                        .font(.body.bold())
                    Text(step.instruction)
                        .font(.body)
                } else {
                    TextField("Title", text: $step.title)
                        .font(.body.bold())
                    TextField("Instruction", text: $step.instruction, axis: .vertical)
                        .font(.body)
                }
            }
            .disabled(editingDisabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(editingDisabled ? powderBlueColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


#Preview {
    StepCard(
        step: .constant(StepModel(title: "Preview Step", instruction: "Do something important")),
        order: 1,
    )
    .padding()
}

