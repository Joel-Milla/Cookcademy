//
//  ContentView.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject var recipeData = RecipeData()
    
    private let listBackgroundColor = AppColor.background
    private let listTextColor = AppColor.foreground

    var body: some View {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe), 
                    label: {
                        Text(recipe.mainInformation.name)
                    })
                }
                .listRowBackground(listBackgroundColor)
                .foregroundStyle(listTextColor)
            }
            .navigationTitle(navigationTitle)
    }
}

extension RecipesListView {
  var recipes: [Recipe] {
    recipeData.recipes
  }
  
  var navigationTitle: String {
    "All Recipes"
  }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipesListView()
        }
    }
}
