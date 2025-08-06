//
//  StepCard.swift
//  RecipeApp
//
//  Created by Pablo García López on 5/8/25.
//

import Foundation
import SwiftUI

struct StepCard: View {
    @Binding var step: Step
    
    let order: Int
    
    // Lets us switch between an editable and a fixed only-read StepCard.
    let editingDisabled: Bool
    
    let powderBlueColor = Color(red: 0.80, green: 0.90, blue: 1.0)
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            
            Text("\(order)")
                .font(.body.bold())
                .frame(width: 35, height: 35)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("Title", text: $step.title)
                    .font(.body.bold())
                TextField("Instruction", text: $step.instruction, axis: .vertical)
                    .font(.body)
            }
            .disabled(editingDisabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .bottom], 8)
        .background(editingDisabled ? powderBlueColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


#Preview {
    @Previewable @State var previewStep = Step(title: "Step X", instruction: "Blablablablablabla")
    StepCard(step: $previewStep, order: 5, editingDisabled: false)
}
