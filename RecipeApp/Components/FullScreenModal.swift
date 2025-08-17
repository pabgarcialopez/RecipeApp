//
//  FullScreenModal.swift
//  RecipeApp
//
//  Created by Pablo García López on 17/8/25.
//

import SwiftUI

struct FullScreenModal<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    private var closingButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(.systemGray2))
        }
        .padding(.trailing, 15)
    }
    
    var body: some View {
        ZStack {
            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Top band with closing button
            VStack {
                HStack {
                    Spacer()
                    closingButton
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FullScreenModal {
        VStack {
            Text("About This App")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("This modal is reusable 🚀")
                .foregroundColor(.gray)
        }
    }
}
