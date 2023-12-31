import SwiftUI

protocol RecipeComponent: CustomStringConvertible, Codable {
    init()
    static func singularName() -> String
    static func pluralName() -> String
}

extension RecipeComponent {
    static func singularName() -> String {
        String(describing: self).lowercased()
    }
    
    static func pluralName() -> String {
        self.singularName() + "s"
    }
}

protocol ModifyComponentView: View {
    associatedtype Component
    init(component: Binding<Component>, createAction: @escaping (Component) -> Void)
}

struct ModifyComponentsView<Component: RecipeComponent, DestinationView: ModifyComponentView>: View where DestinationView.Component == Component {
    @Binding var components: [Component]
    @State private var newComponent = Component()
    
    var body: some View {
        VStack {
            let addComponentsView = DestinationView(component: $newComponent) { component in
                components.append(component)
                newComponent = Component()
            }.navigationTitle("Add \(Component.singularName().capitalized)")
            if components.isEmpty {
                Spacer()
                NavigationLink("Add the first \(Component.singularName())", destination: addComponentsView)
                Spacer()
            } else {
                HStack {
                    Text(Component.pluralName().capitalized)
                        .font(.title)
                        .padding()
                    Spacer()
                    EditButton()
                        .padding()
                }
                List {
                    ForEach(components.indices, id: \.self) { index in
                        let component = components[index]
                        //Text(component.description)
                        let editComponentView = DestinationView(component: $components[index]) { _ in
                            return
                        }.navigationTitle("Edit " + "\(Component.singularName().capitalized)")
                        NavigationLink("\(component.description)", destination: editComponentView)
                    }
                    .onDelete { indexSet in
                        components.remove(atOffsets: indexSet)
                    }
                    .onMove { index, newOffset in
                        components.move(fromOffsets: index, toOffset: newOffset)
                    }
                }
            }
        }
    }
}

struct ModifyIngredientsView_Previews: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[1]
    @State static var emptyIngredients = [Ingredient]()
    @State static var emptyDirection = [Direction]()
    
    static var previews: some View {
        NavigationStack {
            ModifyComponentsView<Ingredient, ModifyIngredientView>(components: $emptyIngredients)
        }
        NavigationStack {
            ModifyComponentsView<Ingredient, ModifyIngredientView>(components: $recipe.ingredients)
        }
        NavigationStack {
            ModifyComponentsView<Direction, ModifyDirectionView>(components: $emptyDirection)
        }
        NavigationStack {
            ModifyComponentsView<Direction, ModifyDirectionView>(components: $recipe.directions)
        }
    }
}
