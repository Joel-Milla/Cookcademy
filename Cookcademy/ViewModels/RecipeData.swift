//
//  RecipeData.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import Foundation

class RecipeData: ObservableObject {
    @Published var recipes = Recipe.testRecipes
}