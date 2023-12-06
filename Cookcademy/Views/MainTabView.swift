//
//  MainTabView.swift
//  Cookcademy
//
//  Created by Joel Alejandro Milla Lopez on 05/12/23.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var recipeData = RecipeData()
    
    var body: some View {
        TabView {
            RecipeCategoryGridView()
                .tabItem {
                    Label("Recipes", systemImage: "list.dash")
                }
            NavigationStack {
                RecipesListView(category: .breakfast)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
        }
        .environmentObject(recipeData)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainTabView()
        }
    }
}
