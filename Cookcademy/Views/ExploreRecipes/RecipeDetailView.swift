//
//  RecipeDetailView.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var recipeData: RecipeData

    @Binding var recipe: Recipe
    
    @AppStorage("listBackgroundColor") private var listBackgroundColor = AppColor.background
    @AppStorage("listTextColor") private var listTextColor = AppColor.foreground
    @AppStorage("hideOptionalSteps") private var hideOptionalSteps: Bool = false
    
    @State private var isPresenting = false
    
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
                        if direction.isOptional && hideOptionalSteps {
                            EmptyView()
                        } else {
                            let index = recipe.index(of: direction, excludingOptionalDirections: hideOptionalSteps) ?? 0
                            HStack {
                                Text("\(index + 1). ").bold()
                                Text("\(direction.isOptional ? "(Optional) " : "")"
                                     + "\(direction.description)")
                            }
                        }
                    }.listRowBackground(listBackgroundColor)
                        .foregroundStyle(listTextColor)
                } header: {
                    Text("Directions")
                }
            }
        }
        .navigationTitle("\(recipe.mainInformation.name)")
        .toolbar {
            ToolbarItem {
                HStack {
                    Button {
                        recipe.isFavorite.toggle()
                        recipeData.savesRecipes()
                    } label: {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    }
                    Button("Edit") {
                        isPresenting = true
                    }
                }
            }
        }
        .sheet(isPresented: $isPresenting) {
            NavigationStack {
                ModifyRecipeView(recipe: $recipe)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                isPresenting = false
                            }
                        }
                    }
                    .navigationTitle("Edit Recipe")
            }
            .onDisappear {
                recipeData.savesRecipes()
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[4]
    static var previews: some View {
        NavigationStack {
            RecipeDetailView(recipe: $recipe)
        }
    }
}
