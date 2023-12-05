//
//  RecipeDetailView.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @Binding var recipe: Recipe
    
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground
    
    var body: some View {
        VStack {
            HStack {
                Text("Author: \(recipe.mainInformation.author)")
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            HStack {
                Text(recipe.mainInformation.description)
                    .font(.subheadline)
                    .padding()
                Spacer()
            }
            List {
                Section {
                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        let ingredient = recipe.ingredients[index]
                        Text(ingredient.description)
                    }.listRowBackground(listBackgroundColor)
                     .foregroundStyle(listTextColor)
                } header: {
                    Text("Ingredients")
                }
                Section {
                    ForEach(recipe.directions.indices, id: \.self) { index in
                        let direction = recipe.directions[index]
                        HStack {
                            Text("\(index + 1). ").bold()
                            Text("\(direction.isOptional ? "(Optional) " : "")"
                                 + "\(direction.description)")
                        }
                    }.listRowBackground(listBackgroundColor)
                     .foregroundStyle(listTextColor)
                } header: {
                    Text("Directions")
                }
            }
        }
        .navigationTitle("\(recipe.mainInformation.name)")
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[0]
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipe: $recipe)
        }
    }
}
