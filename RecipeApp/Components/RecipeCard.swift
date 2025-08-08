//
//  RecipeCard.swift
//  RecipeApp
//
//  Created by Pablo García López on 31/7/25.
//

import Foundation
import SwiftUI

struct RecipeCard: View {
    
    let recipe: RecipeModel
        
    var shadowColor: Color {
        switch recipe.difficulty {
            case .easy: .green
            case .intermediate: .orange
            case .hard: .red
        }
    }
    
    var cost: some View {
        Text(recipe.cost.symbol)
            .padding(8)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
            )
    }

    var time: some View {
        HStack(spacing: 5) {
            Image(systemName: "clock")
            Text("\(recipe.time) mins")
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
        )
    }
    
    var recipeImage: some View {
        if let data = recipe.imageModel?.data,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            return Image(DEFAULT_RECIPE_COVER)
                .resizable()
                .scaledToFill()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            recipeImage
                .frame(height: 180)
                .clipped()
                .overlay(
                    HStack {
                        cost
                        Spacer()
                        time
                    }
                    .padding(), alignment: .top)

            Text(recipe.name)
                .font(.title3.bold())
                .padding(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: shadowColor, radius: 5)
        .padding([.leading, .trailing], 15)
    }
    
}

#Preview {
    RecipeCard(recipe: .sampleRecipes[0])
}
