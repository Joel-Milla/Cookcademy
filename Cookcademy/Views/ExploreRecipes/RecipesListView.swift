//
//  ContentView.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import SwiftUI

struct RecipesListView: View {
    @EnvironmentObject private var recipeData: RecipeData
    let viewStyle: ViewStyle

    @AppStorage("listBackgroundColor") private var listBackgroundColor = AppColor.background
    @AppStorage("listTextColor") private var listTextColor = AppColor.foreground
    
    @State private var isPresenting = false
    @State private var newRecipe = Recipe()
    
    var body: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: binding(for: recipe)),
                               label: {
                    Text(recipe.mainInformation.name)
                })
            }
            .listRowBackground(listBackgroundColor)
            .foregroundStyle(listTextColor)
        }
        .navigationTitle(navigationTitle)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    switch (viewStyle) {
                    case .favorites:
                        break
                    case let .singleCategory(category):
                        newRecipe.mainInformation.category = category
                    }
                    isPresenting = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
        .sheet(isPresented: $isPresenting, content: {
            NavigationStack {
                ModifyRecipeView(recipe: $newRecipe)
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresenting = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            if newRecipe.isValid {
                                Button("Add") {
                                    if case .favorites = viewStyle {
                                        newRecipe.isFavorite = true
                                    }
                                    recipeData.add(recipe: newRecipe)
                                    isPresenting = false
                                }
                            }
                        }
                    })
                    .navigationTitle("Add a New Recipe")
            }
        })
    }
}

extension RecipesListView {
    enum ViewStyle {
        case favorites
        case singleCategory(MainInformation.Category)
    }
    
    private var recipes: [Recipe] {
        switch (viewStyle) {
        case .favorites:
            return recipeData.favoriteRecipes
        case let .singleCategory(category):
            return recipeData.recipes(for: category)
        }
    }
    
    private var navigationTitle: String {
        switch (viewStyle) {
        case .favorites:
            return "Favorite Recipes"
        case let .singleCategory(category):
            return "\(category.rawValue) Recipes"
        }
    }
    
    func binding(for recipe: Recipe) -> Binding<Recipe> {
        guard let index = recipeData.index(of: recipe) else {
            fatalError("Recipe not found")
        }
        return $recipeData.recipes[index]
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipesListView(viewStyle: .singleCategory(.breakfast))
        }.environmentObject(RecipeData())
    }
}
