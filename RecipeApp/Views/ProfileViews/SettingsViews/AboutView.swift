//
//  AboutView.swift
//  RecipeApp
//
//  Created by Pablo García López on 15/8/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Centered text
            Text("About This App")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()

            // Close button in top right
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color(.systemGray2))
                    }
                    .padding(.trailing, 15)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AboutView()
}
