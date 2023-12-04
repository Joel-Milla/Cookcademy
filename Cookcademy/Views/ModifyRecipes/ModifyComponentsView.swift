import SwiftUI

protocol RecipeComponent {
    init()
}

protocol ModifyComponentView: View {
    associatedtype Component
    init(component: Binding<Component>, createAction: @escaping (Component) -> Void)
}

struct ModifyComponentsView<Component: RecipeComponent, DestinationView: ModifyComponentView>: View {
    @Binding var ingredients: [Ingredient]
    @State private var newIngredient = Ingredient(name: "",
                                                  quantity: 0.0,
                                                  unit: .none)
    
    var body: some View {
        VStack {
            if ingredients.isEmpty {
                Spacer()
                NavigationLink("Add the first ingredient",
                               destination: ModifyIngredientView(component:
                                                                    $newIngredient) {
                    ingredient in
                    ingredients.append(ingredient)
                    newIngredient = Ingredient(name: "", quantity: 0.0, unit: .none)
                })
                Spacer()
            } else {
                List {
                    ForEach(ingredients.indices, id: \.self) { index in
                        let ingredient = ingredients[index]
                        Text(ingredient.description)
                    }
                    NavigationLink("Add another ingredient",
                                   destination: ModifyIngredientView(component:
                                                                        $newIngredient
                                                                    ){
                        ingredient in
                        ingredients.append(ingredient)
                        newIngredient = Ingredient(name: "", quantity: 0.0, unit: .none)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ModifyIngredientsView_Previews: PreviewProvider {
    @State static var emptyIngredients = [Ingredient]()
    @State static var recipe = Recipe.testRecipes[1]

    static var previews: some View {
        NavigationView {
            ModifyComponentsView<Ingredient, ModifyIngredientView>(ingredients: $emptyIngredients)
        }
        NavigationView {
            ModifyComponentsView<Ingredient, ModifyIngredientView>(ingredients: $recipe.ingredients)
        }
    }
}
