//
//  Recipe.swift
//  Cookcademy
//
//  Created by Alumno on 11/11/23.
//

import Foundation

struct Recipe: Identifiable {
    var id = UUID()
    
    var mainInformation: MainInformation
    var ingredients: [Ingredient]
    var directions: [Direction]
    var isFavorite = false
    
    init(mainInformation: MainInformation, ingredients:[Ingredient], directions:[Direction]) {
        self.mainInformation = mainInformation
        self.ingredients = ingredients
        self.directions = directions
    }
    
    init() {
        self.init(mainInformation: MainInformation(name: "", description: "", author: "", category: .breakfast),
                  ingredients: [],
                  directions: [])
    }
    
    var isValid: Bool {
        mainInformation.isValid && !ingredients.isEmpty && !directions.isEmpty
    }
    
    func index(of direction: Direction, excludingOptionalDirections: Bool) -> Int? {
        let directions = directions.filter { excludingOptionalDirections ? !$0.isOptional : true } // If hiding directions, then it will retain all the directions that isOptional==false. If not, retain all
        // From the array after filtering, obtain the index that matches the description and return it
        let index = directions.firstIndex { $0.description == direction.description }
        return index
    }
}

struct MainInformation {
    var name: String
    var description: String
    var author: String
    var category: Category
    
    enum Category: String, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case dessert = "Dessert"
    }
    
    var isValid: Bool {
        !name.isEmpty && !description.isEmpty && !author.isEmpty
    }
}

struct Ingredient: RecipeComponent {
    var name:String
    var quantity: Double
    var unit: Unit
    
    var description: String {
        let formattedQuantity = String(format: "%g", quantity)
        switch unit {
        case .none:
            let formattedName = quantity == 1 ? name : "\(name)s"
            return "\(formattedQuantity) \(formattedName)"
        default:
            if quantity == 1 {
                return "1 \(unit.singularName) \(name)"
            } else {
                return "\(formattedQuantity) \(unit.rawValue) \(name)"
            }
        }
    }
    
    enum Unit: String, CaseIterable {
        case oz = "Ounces"
        case g = "Grams"
        case cups = "Cups"
        case tbs = "Tablespoons"
        case tsp = "Teaspoons"
        case lb = "Pounds"
        case none = "No units"
        
        var singularName: String { String(rawValue.dropLast()) }
    }
    
    init(name: String, quantity: Double, unit: Unit) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
    
    init() {
        self.init(name: "", quantity: 0.0, unit: .none)
    }
}

struct Direction: RecipeComponent {
    var description: String
    var isOptional: Bool
    
    init(description: String, isOptional: Bool) {
        self.description = description
        self.isOptional = isOptional
    }
    
    init() {
        self.init(description: "", isOptional: false)
    }
}

extension Recipe {
    static let testRecipes: [Recipe] = [
        Recipe(mainInformation: MainInformation(name: "Dad's Mashed Potatoes",
                                                description: "Buttery salty mashed potatoes!",
                                                author: "Josh",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Potatoes", quantity: 454, unit: .g),
                Ingredient(name: "Butter", quantity: 1, unit: .tbs),
                Ingredient(name: "Milk", quantity: 0.5, unit: .cups),
                Ingredient(name: "Salt", quantity: 2, unit: .tsp)
               ],
               directions:  [
                Direction(description: "Put peeled potatoes in water and bring to boil ~15 min (once you can cut them easily", isOptional: false),
                Direction(description: "In the meantime, Soften the butter by heading in a microwave for 30 seconds", isOptional: false),
                Direction(description: "Drain the now soft potatoes", isOptional: false),
                Direction(description: "Mix vigorously with milk, salt, and butter", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Beet and Apple Salad",
                                                description: "Light and refreshing summer salad made of beets, apples and fresh mint",
                                                author: "Deb Szajngarten",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Large beets chopped into a large dice", quantity: 3, unit: .none),
                Ingredient(name: "Large apples chopped into a large dice", quantity: 2, unit: .none),
                Ingredient(name: "Lemon zest", quantity: 0.5, unit: .tbs),
                Ingredient(name: "Lemon juice", quantity: 1.5, unit: .tbs),
                Ingredient(name: "Olive Oil", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt and Pepper to taste", quantity: 1, unit: .none)
               ],
               directions:  [
                Direction(description: "Cook the beets", isOptional: false),
                Direction(description: "Sous vide the beets - To accomplish this, add beets to food safe plastic storage bags with apples, tsp of course stal and teaspoon of ground black pepper", isOptional: true),
                Direction(description: "Then vacuum seal the bag of beets and submerge into 185F water until tender; if no vacuum seal, weigh them down so they submerge", isOptional: true),
                Direction(description: "Alternately, you can steam the beets until tender or roast them in a 400F oven until tender", isOptional: false),
                Direction(description: "Once cooked, the skins will come off quite easily (gloves are preferred)", isOptional: false),
                Direction(description: "Wait until cooled completely, then cut beets into a medium dice", isOptional: false),
                Direction(description: "Peel and medium dice the apples", isOptional: false),
                Direction(description: "Chiffonade the mint", isOptional: false),
                Direction(description: "Combine all ingredients with lemon juice and olive oil and serve", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Braised Beef Brisket",
                                                description: "Slow cooked brisket in a savory braise that makes an amazing gravy.",
                                                author: "Deb Szajngarten",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Brisket", quantity: 1815, unit: .g),
                Ingredient(name: "Large red onion", quantity: 1, unit: .none),
                Ingredient(name: "Garlic, minced", quantity: 6, unit: .none),
                Ingredient(name: "Large Carrot", quantity: 1, unit: .none),
                Ingredient(name: "Parsnip", quantity: 1, unit: .none),
                Ingredient(name: "Stalks Celery", quantity: 3, unit: .none),
                Ingredient(name: "Caul, Duck, or Chicken Fat", quantity: 3, unit: .tbs),
                Ingredient(name: "Bay Leaves", quantity: 2, unit: .none),
                Ingredient(name: "Apple Cider Vinegar", quantity: 0.33, unit: .cups),
                Ingredient(name: "Red Wine", quantity: 1, unit: .cups),
                Ingredient(name: "Jar/Can of Tomato Paste", quantity: 1, unit: .none),
                Ingredient(name: "Spoonful of Honey", quantity: 1, unit: .none),
                Ingredient(name: "Chicken Stock", quantity: 30, unit: .oz),
               ],
               directions:  [
                Direction(description: "In a small bowl, combine the honey, tomato paste and wine, and mix into paste", isOptional: false),
                Direction(description: "In an oval dutch oven, melt the fat over a medium to high heat.", isOptional: false),
                Direction(description: "Sear the brisket on both side then remove the heat", isOptional: false),
                Direction(description: "Add a bit more fat or vegetable oil and sear the vegetables until the onions become translucent", isOptional: false),
                Direction(description: "Add the wine mixture, return the beef to the pot, add the chicken stock until it come 1/2 way up the beef", isOptional: false),
                Direction(description: "Close the lid and bake at 250 until fork tender (4-6 hrs)", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Best Brownies Ever",
                                                description: "Five simple ingredients make these brownies easy to make and delicious to consume!",
                                                author: "Pam Broda",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "Condensed Milk", quantity: 14, unit: .oz),
                Ingredient(name: "Crushed Graham Crackers", quantity: 2.5, unit: .cups),
                Ingredient(name: "Bag of Chocolate Chips (Semi-Sweet)", quantity: 12, unit: .oz),
                Ingredient(name: "Vanilla Extract", quantity: 1, unit: .tsp),
                Ingredient(name: "Milk", quantity: 2, unit: .tbs)
               ],
               directions:  [
                Direction(description: "Preheat oven to 350 degrees F", isOptional: false),
                Direction(description: "Crush graham cracker in large mixing bowl with clean hands, not in food processor! (Make sure pieces are chunky)", isOptional: false),
                Direction(description: "Smei-melt the chocolate chips, keep some in tact", isOptional: false),
                Direction(description: "Stir in rest of ingredients (vanilla, milk)", isOptional: false),
                Direction(description: "Grease an 8x8 in. pan with butter and pour in brownie mix", isOptional: false),
                Direction(description: "Bake for 23-25min - DO NOT OVERBAKE", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Omelet and Greens",
                                                description: "Quick, crafty omelet with greens!",
                                                author: "Taylor Murray",
                                                category: .breakfast),
               ingredients: [
                Ingredient(name: "Olive Oil", quantity: 3, unit: .tbs),
                Ingredient(name: "Onion, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Large Eggs", quantity: 8, unit: .none),
                Ingredient(name: "Kosher Salt", quantity: 1, unit: .none),
                Ingredient(name: "Unsalted Butter", quantity: 2, unit: .tbs),
                Ingredient(name: "Parmesan, finely grated", quantity: 1, unit: .oz),
                Ingredient(name: "Fresh Lemon Juice", quantity: 2, unit: .tbs),
                Ingredient(name: "Baby Spinach", quantity: 3, unit: .oz)
               ],
               directions:  [
                Direction(description: "Heat 1 tbsp olive oil in large non stick skillet on medium heat", isOptional: false),
                Direction(description: "Add onions until tender, about 6 minutes then transfer to a small bowl", isOptional: false),
                Direction(description: "In a different bowl, whisk eggs, 1 tbs water, and 0.5 tsp salt", isOptional: false),
                Direction(description: "Return skillet to medium heat and butter", isOptional: false),
                Direction(description: "Add eggs, constantly stirring until eggs partially set", isOptional: false),
                Direction(description: "Turn heat to low and cover", isOptional: false),
                Direction(description: "Continue cooking till eggs are just set, 4-5min", isOptional: false),
                Direction(description: "Top with parmesan and onions, fold in half", isOptional: true),
                Direction(description: "In a medium bowl, whisk lemon juice, 2 tbs olive oil, toss with spinach and serve with omelet", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Vegetarian Chili",
                                                description: "Warm, comforting, and filling vegetarian chili",
                                                author: "Makeinze Gore",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Onions, Chopped", quantity: 1, unit: .none),
                Ingredient(name: "Red Bell Pepper, Chopped", quantity: 1, unit: .none),
                Ingredient(name: "Carrots, peeled and finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Cloves Garlic, Minced", quantity: 3, unit: .none),
                Ingredient(name: "Jalapeno, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Tomato Paste", quantity: 2, unit: .tbs),
                Ingredient(name: "Can of Pinto Beans, Drained and Rinsed", quantity: 1, unit: .none),
                Ingredient(name: "Can of Black Beans, Drained and Rinsed", quantity: 1, unit: .none),
                Ingredient(name: "Can of Kidney Beans, Drained and Rinsed", quantity: 1, unit: .none),
                Ingredient(name: "Can of Fire Roasted Tomatoes", quantity: 1, unit: .none),
                Ingredient(name: "Vegetable Broth", quantity: 3, unit: .cups),
                Ingredient(name: "Chili Powder", quantity: 2, unit: .tbs),
                Ingredient(name: "Cumin", quantity: 1, unit: .tbs),
                Ingredient(name: "Oregano", quantity: 2, unit: .tsp),
                Ingredient(name: "Kosher Salt", quantity: 1, unit: .none),
                Ingredient(name: "Ground Black Pepper", quantity: 1, unit: .none),
                Ingredient(name: "Shredded Cheddar", quantity: 1, unit: .none),
                Ingredient(name: "Sour Cream", quantity: 1, unit: .none),
                Ingredient(name: "Cilantro", quantity: 1, unit: .none)
               ],
               directions:  [
                Direction(description: "In a large pot over medium heat, heat olive oil then add onions, bell peppers and carrots", isOptional: false),
                Direction(description: "Saute until soft - about 5 min", isOptional: false),
                Direction(description: "Add garlic and jalapeno and cool until fragrant - about 1 min", isOptional: false),
                Direction(description: "Add tomato paste and stir to coat vegetables", isOptional: false),
                Direction(description: "Add tomatoes, beans, broth, and seasonings", isOptional: false),
                Direction(description: "Season with salt and pepper to desire", isOptional: false),
                Direction(description: "Bring to a boil then reduce heat and let simmer for 30min", isOptional: false),
                Direction(description: "Serve with cheese, sour cream, and cilantro", isOptional: true)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Classic Shrimp Scampi",
                                                description: "Simple, delicate shrimp bedded in a delicious set of pasta that will melt your tastebuds!",
                                                author: "Sarah Taller",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Kosher Salt", quantity: 1, unit: .none),
                Ingredient(name: "Linguine", quantity: 12, unit: .oz),
                Ingredient(name: "Large shrimp, peeled", quantity: 20, unit: .oz),
                Ingredient(name: "Extra-virgin olive oil", quantity: 0.33, unit: .cups),
                Ingredient(name: "Cloves garlic, minced", quantity: 5, unit: .none),
                Ingredient(name: "Red pepper flakes", quantity: 0.5, unit: .tsp),
                Ingredient(name: "White Wine", quantity: 0.33, unit: .cups),
                Ingredient(name: "Lemons Squeezed + Wedges", quantity: 0.5, unit: .none),
                Ingredient(name: "Unsalted butter, cut into pieces", quantity: 4, unit: .tbs),
                Ingredient(name: "Finely Chopped Fresh Parsley", quantity: 0.25, unit: .cups)
               ],
               directions:  [
                Direction(description: "Bring large pot of salt water to a boil", isOptional: false),
                Direction(description: "Add the linguini and cook as label directs", isOptional: false),
                Direction(description: "Reserve 1 cup cooking water, then drain", isOptional: false),
                Direction(description: "Season shrimp with salt", isOptional: false),
                Direction(description: "Heat olive oil in large skillet over medium-heat", isOptional: false),
                Direction(description: "Add garlic and red pepper flakes and cook until garlic is golden, 30sec-1min", isOptional: false),
                Direction(description: "Add shrimp and cook, stirring occasionally, until pink and just cooked through: 1-2min per side", isOptional: false),
                Direction(description: "Remove shrimp from plate", isOptional: false),
                Direction(description: "Add the wine and lemon juice to skillet and simmer slightly reduced, 2 min", isOptional: false),
                Direction(description: "Return shrimp and any juices from place to skillet alongside linguine, butter, and a 0.5 cup of cooking water", isOptional: false),
                Direction(description: "Continue to cook, tossing, until the butter is melted and the shrimp is hot, about 2 min", isOptional: false),
                Direction(description: "Add water as needed", isOptional: false),
                Direction(description: "Season with salt, stir in parsley", isOptional: false),
                Direction(description: "Serve with lemon wedges!", isOptional: true)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chocolate Billionaires",
                                                description: "Chocolate and caramel candies that are to die for!",
                                                author: "Jack B",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "1 package of caramels", quantity: 14, unit: .oz),
                Ingredient(name: "Water", quantity: 3, unit: .tbs),
                Ingredient(name: "Chopped Pecans", quantity: 1.25, unit: .cups),
                Ingredient(name: "Rice Krispies", quantity: 1, unit: .cups),
                Ingredient(name: "Milk Chocolate Chips", quantity: 3, unit: .cups),
                Ingredient(name: "Shortening", quantity: 1.25, unit: .tsp)
               ],
               directions:  [
                Direction(description: "Line 2 baking sheets with waxed paper", isOptional: false),
                Direction(description: "Grease paper and set aside", isOptional: false),
                Direction(description: "In a large heavy saucepan, combine caramel and water", isOptional: false),
                Direction(description: "Cook and stir over low heat until smooth", isOptional: false),
                Direction(description: "Stir in pecans and cereal until coated", isOptional: false),
                Direction(description: "Drops teaspoons onto prepared pans", isOptional: false),
                Direction(description: "Refrigerate for 10 mins or until firm", isOptional: false),
                Direction(description: "Melt chocolate chips and shortening", isOptional: false),
                Direction(description: "Stir until smooth", isOptional: false),
                Direction(description: "Dip candy into chocolate, coating all sides", isOptional: false),
                Direction(description: "Allow excess to drip off", isOptional: false),
                Direction(description: "Place on prepared pans and refrigerate until set", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Mac & Cheese",
                                                description: "Macaroni & Cheese",
                                                author: "Travis B",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Elbow Macaroni", quantity: 12, unit: .oz),
                Ingredient(name: "Butter, divided", quantity: 2, unit: .tbs),
                Ingredient(name: "Small onion, chopped", quantity: 1, unit: .none),
                Ingredient(name: "Milk, divided", quantity: 4, unit: .cups),
                Ingredient(name: "Flour", quantity: 0.33, unit: .cups),
                Ingredient(name: "Bay Leaves", quantity: 2, unit: .none),
                Ingredient(name: "Thyme", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Pepper", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Shredded Sharp Cheddar", quantity: 1, unit: .cups)
               ],
               directions:  [
                Direction(description: "Heat oven to 375. Lightly coat 13 x 9 baking dish with vegetable cooking spray", isOptional: false),
                Direction(description: "Start to cook pasta", isOptional: false),
                Direction(description: "Meanwhile, melt 1 tablespoon butter in a saucepan over medium heat. Add onion, and cook until softened, about 3 min.", isOptional: false),
                Direction(description: "Whisk together 1/2 cup milk and flour until smooth", isOptional: false),
                Direction(description: "Add milk texture to onion, then whisk in remaining 3.5 cups milk, bay leaves, thyme, salt, and pepper.", isOptional: false),
                Direction(description: "Cook over medium-low heat 10-12min, stirring occasionally, until slight thickened", isOptional: false),
                Direction(description: "With slotted spoon, remove bay leaves. Stir in cheese until melted", isOptional: false),
                Direction(description: "Drain pasta and stir into cheese mixture", isOptional: false),
                Direction(description: "Drain pasta and stir into cheese mixture. Pour into prepared dish and bake for 35 minutes, or until cheese is bubbly", isOptional: false),
                Direction(description: "Eat!", isOptional: true)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Veggie Soup",
                                                description: "Vegetable Soup",
                                                author: "Travis B",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Yellow Onion, diced", quantity: 1, unit: .none),
                Ingredient(name: "Cloves Garlic, minced", quantity: 4, unit: .none),
                Ingredient(name: "Stock Celery, diced", quantity: 1, unit: .none),
                Ingredient(name: "Carrots, shredded", quantity: 1, unit: .cups),
                Ingredient(name: "Broccoli florets", quantity: 1, unit: .cups),
                Ingredient(name: "Zucchini, cubed", quantity: 1, unit: .none),
                Ingredient(name: "Spinach", quantity: 3, unit: .cups),
                Ingredient(name: "Potato skinned and cubed", quantity: 1, unit: .none),
                Ingredient(name: "Can of Kidney Beans", quantity: 1, unit: .none),
                Ingredient(name: "Box Vegetable Stock", quantity: 1, unit: .none),
                Ingredient(name: "Can Diced Tomatoes", quantity: 1, unit: .none)
               ],
               directions:  [
                Direction(description: "Cook onion and garlic on high heat until onion is translucent, about 5 min", isOptional: false),
                Direction(description: "Add celery, carrots, parsley, and cook for 5-7min", isOptional: false),
                Direction(description: "Add can diced tomatoes, vegetable stock, and potato. Bring to boil and let simmer for 45min", isOptional: false),
                Direction(description: "Add broccoli, zucchini, and kidney beans. Bring back to boil and then let simmer for 15 more min", isOptional: false),
                Direction(description: "Serve with spinach and parmesan cheese", isOptional: true)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "White Clam Sauce",
                                                description: "A simple recipe for quick comfort food",
                                                author: "Henry Minden",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Cans of Clams", quantity: 4, unit: .none),
                Ingredient(name: "Cloves of Garlic", quantity: 8, unit: .none),
                Ingredient(name: "Onion", quantity: 1, unit: .none),
                Ingredient(name: "Salt and Pepper", quantity: 1, unit: .none),
                Ingredient(name: "White Wine", quantity: 2, unit: .tbs),
                Ingredient(name: "Butter", quantity: 4, unit: .tbs)
               ],
               directions:  [
                Direction(description: "Chop garlic and onions", isOptional: false),
                Direction(description: "Saute garlic and onions in olive oil", isOptional: false),
                Direction(description: "Add clams and 1/2 juice in cans", isOptional: false),
                Direction(description: "Add butter, wine, and salt pepper to taste", isOptional: false),
                Direction(description: "Simmer for 15min until sauce deduces 1/2", isOptional: false),
                Direction(description: "Serve over favorite pasta", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Granola Bowl",
                                                description: "A dense and delicious breakfast",
                                                author: "Ben",
                                                category: .breakfast),
               ingredients: [
                Ingredient(name: "Granola", quantity: 0.5, unit: .cups),
                Ingredient(name: "Banana", quantity: 1, unit: .none),
                Ingredient(name: "Peanut Butter", quantity: 2, unit: .tbs),
               ],
               directions:  [
                Direction(description: "Slice the banana", isOptional: false),
                Direction(description: "Combine all ingredients in a bowl", isOptional: false),
                Direction(description: "Add chocolate chips", isOptional: true),
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Banana Bread",
                                                description: "Easy to put together, and a family favorite!",
                                                author: "Lisbeth",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "Ripe bananas", quantity: 3, unit: .none),
                Ingredient(name: "Sugar", quantity: 1, unit: .cups),
                Ingredient(name: "Egg", quantity: 1, unit: .none),
                Ingredient(name: "Flour", quantity: 1.5, unit: .cups),
                Ingredient(name: "Melted Butter", quantity: 0.25, unit: .cups),
                Ingredient(name: "Baking Soda", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Chocolate Chips", quantity: 1, unit: .cups)
               ],
               directions:  [
                Direction(description: "Preheat oven to 325", isOptional: false),
                Direction(description: "Mash banana with fork", isOptional: false),
                Direction(description: "Stir in sugar, egg, flour, melted butter, soda, and salt", isOptional: false),
                Direction(description: "Stir in chocolate chips", isOptional: false),
                Direction(description: "Pour in buttered loaf and bake 1 hour or until knife inserted comes out clean", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chicken Alfredo Pasta",
                                                description: "Creamy and classic chicken Alfredo pasta",
                                                author: "Maria Lopez",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Fettuccine Pasta", quantity: 16, unit: .oz),
                Ingredient(name: "Boneless Chicken Breast", quantity: 2, unit: .none),
                Ingredient(name: "Butter", quantity: 2, unit: .tbs),
                Ingredient(name: "Heavy Cream", quantity: 1, unit: .cups),
                Ingredient(name: "Grated Parmesan Cheese", quantity: 1.5, unit: .cups),
                Ingredient(name: "Garlic, minced", quantity: 2, unit: .none),
                Ingredient(name: "Salt", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Black Pepper", quantity: 0.25, unit: .tsp)
               ],
               directions: [
                Direction(description: "Cook pasta according to package instructions", isOptional: false),
                Direction(description: "Season chicken with salt and pepper, grill until cooked through", isOptional: false),
                Direction(description: "In a saucepan, melt butter, add garlic and cook for 1 minute", isOptional: false),
                Direction(description: "Add heavy cream and simmer for 5 minutes", isOptional: false),
                Direction(description: "Stir in parmesan cheese until it melts", isOptional: false),
                Direction(description: "Slice chicken and add to the sauce", isOptional: false),
                Direction(description: "Toss cooked pasta in the sauce and serve", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Classic Tomato Soup",
                                                description: "A warm and comforting tomato soup, perfect for any season.",
                                                author: "Chef Anna",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Tomatoes, chopped", quantity: 4, unit: .none),
                Ingredient(name: "Onion, diced", quantity: 1, unit: .none),
                Ingredient(name: "Vegetable stock", quantity: 2, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Basil leaves", quantity: 5, unit: .none),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 1, unit: .tsp)
               ],
               directions: [
                Direction(description: "Heat olive oil in a pot over medium heat", isOptional: false),
                Direction(description: "Add onions and garlic, sauté until translucent", isOptional: false),
                Direction(description: "Add chopped tomatoes and cook for 10 minutes", isOptional: false),
                Direction(description: "Pour in vegetable stock, bring to a boil", isOptional: false),
                Direction(description: "Simmer for 20 minutes", isOptional: false),
                Direction(description: "Blend the soup until smooth", isOptional: false),
                Direction(description: "Return to pot, add basil, salt, and pepper", isOptional: false),
                Direction(description: "Serve hot with croutons or bread", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Classic Tomato Soup",
                                                description: "A warm and comforting tomato soup, perfect for any season.",
                                                author: "Chef Anna",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Tomatoes, chopped", quantity: 4, unit: .none),
                Ingredient(name: "Onion, diced", quantity: 1, unit: .none),
                Ingredient(name: "Vegetable stock", quantity: 2, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Basil leaves", quantity: 5, unit: .none),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 1, unit: .tsp)
               ],
               directions: [
                Direction(description: "Heat olive oil in a pot over medium heat", isOptional: false),
                Direction(description: "Add onions and garlic, sauté until translucent", isOptional: false),
                Direction(description: "Add chopped tomatoes and cook for 10 minutes", isOptional: false),
                Direction(description: "Pour in vegetable stock, bring to a boil", isOptional: false),
                Direction(description: "Simmer for 20 minutes", isOptional: false),
                Direction(description: "Blend the soup until smooth", isOptional: false),
                Direction(description: "Return to pot, add basil, salt, and pepper", isOptional: false),
                Direction(description: "Serve hot with croutons or bread", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Lemon Herb Roasted Chicken",
                                                description: "A succulent roasted chicken with a citrusy, herb-infused flavor.",
                                                author: "Chef Gordon",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Whole chicken", quantity: 4, unit: .lb),
                Ingredient(name: "Lemons", quantity: 2, unit: .none),
                Ingredient(name: "Fresh thyme", quantity: 1, unit: .tbs),
                Ingredient(name: "Fresh rosemary", quantity: 1, unit: .tbs),
                Ingredient(name: "Garlic cloves, minced", quantity: 4, unit: .none),
                Ingredient(name: "Butter, softened", quantity: 4, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 1, unit: .tsp),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs)
               ],
               directions: [
                Direction(description: "Preheat oven to 425°F (220°C)", isOptional: false),
                Direction(description: "In a bowl, mix butter, minced garlic, chopped herbs, salt, and pepper", isOptional: false),
                Direction(description: "Rub the mixture all over the chicken, including under the skin and inside the cavity", isOptional: false),
                Direction(description: "Stuff the cavity with halved lemons", isOptional: false),
                Direction(description: "Truss the chicken legs and tuck the wing tips", isOptional: false),
                Direction(description: "Place the chicken breast-side up in a roasting pan", isOptional: false),
                Direction(description: "Roast in the oven for about 1 hour and 15 minutes or until the juices run clear", isOptional: false),
                Direction(description: "Let the chicken rest for 10 minutes before carving", isOptional: false),
                Direction(description: "Serve with roasted vegetables or a green salad", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Beef Stroganoff",
                                                description: "A rich and creamy beef stroganoff with mushrooms and a hint of Dijon.",
                                                author: "Chef Irina",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Beef sirloin", quantity: 1, unit: .lb),
                Ingredient(name: "Mushrooms, sliced", quantity: 2, unit: .cups),
                Ingredient(name: "Onion, diced", quantity: 1, unit: .none),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Beef broth", quantity: 2, unit: .cups),
                Ingredient(name: "Sour cream", quantity: 1, unit: .cups),
                Ingredient(name: "Dijon mustard", quantity: 1, unit: .tbs),
                Ingredient(name: "Worcestershire sauce", quantity: 1, unit: .tbs),
                Ingredient(name: "Butter", quantity: 2, unit: .tbs),
                Ingredient(name: "All-purpose flour", quantity: 2, unit: .tbs),
                Ingredient(name: "Egg noodles", quantity: 8, unit: .oz),
                Ingredient(name: "Parsley, chopped", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 1, unit: .tsp)
               ],
               directions: [
                Direction(description: "Cook the egg noodles according to package instructions, set aside", isOptional: false),
                Direction(description: "In a large skillet, melt butter over medium heat. Add onions and mushrooms, cook until tender", isOptional: false),
                Direction(description: "Add garlic and cook for an additional minute", isOptional: false),
                Direction(description: "Season the beef with salt and pepper, add to the skillet, and cook until browned", isOptional: false),
                Direction(description: "Sprinkle flour over the beef and vegetables, stir to combine", isOptional: false),
                Direction(description: "Pour in beef broth, bring to a simmer, and cook until the sauce thickens", isOptional: false),
                Direction(description: "Reduce heat to low, stir in sour cream, Dijon mustard, and Worcestershire sauce", isOptional: false),
                Direction(description: "Serve the beef mixture over the cooked noodles, garnished with chopped parsley", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Spicy Thai Noodles",
                                                description: "A flavorful dish with a kick, combining rice noodles, vegetables, and a spicy sauce.",
                                                author: "Chef Ming",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Rice noodles", quantity: 8, unit: .oz),
                Ingredient(name: "Carrots, julienned", quantity: 1, unit: .none),
                Ingredient(name: "Red bell pepper, thinly sliced", quantity: 1, unit: .none),
                Ingredient(name: "Green onions, chopped", quantity: 4, unit: .none),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Soy sauce", quantity: 3, unit: .tbs),
                Ingredient(name: "Sesame oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Honey", quantity: 2, unit: .tbs),
                Ingredient(name: "Crushed red pepper flakes", quantity: 1, unit: .tsp),
                Ingredient(name: "Peanuts, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Cilantro, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Lime, juiced", quantity: 1, unit: .none)
               ],
               directions: [
                Direction(description: "Cook rice noodles according to package instructions, drain and set aside", isOptional: false),
                Direction(description: "In a large skillet, heat sesame oil over medium heat and sauté garlic, carrots, and bell pepper until tender", isOptional: false),
                Direction(description: "Whisk together soy sauce, honey, and red pepper flakes in a small bowl", isOptional: false),
                Direction(description: "Add the cooked noodles and sauce to the skillet, tossing to combine", isOptional: false),
                Direction(description: "Cook for an additional 2-3 minutes until everything is heated through", isOptional: false),
                Direction(description: "Remove from heat, stir in green onions, peanuts, cilantro, and lime juice", isOptional: false),
                Direction(description: "Serve hot, garnished with extra peanuts and cilantro", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Quinoa Salad with Avocado",
                                                description: "A light and refreshing salad with quinoa, avocado, and a lemon vinaigrette.",
                                                author: "Chef Emily",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Quinoa", quantity: 1, unit: .cups),
                Ingredient(name: "Water", quantity: 2, unit: .cups),
                Ingredient(name: "Cherry tomatoes, halved", quantity: 1, unit: .cups),
                Ingredient(name: "Cucumber, diced", quantity: 1, unit: .none),
                Ingredient(name: "Red onion, finely chopped", quantity: 0.5, unit: .none),
                Ingredient(name: "Avocado, diced", quantity: 1, unit: .none),
                Ingredient(name: "Olive oil", quantity: 3, unit: .tbs),
                Ingredient(name: "Lemon, juiced", quantity: 1, unit: .none),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Fresh parsley, chopped", quantity: 0.25, unit: .cups)
               ],
               directions: [
                Direction(description: "Rinse quinoa under cold water and drain", isOptional: false),
                Direction(description: "In a pot, bring water to a boil, add quinoa, reduce heat to low, cover, and simmer for 15 minutes", isOptional: false),
                Direction(description: "Let quinoa cool to room temperature", isOptional: false),
                Direction(description: "In a large bowl, combine cooled quinoa, tomatoes, cucumber, red onion, and avocado", isOptional: false),
                Direction(description: "In a small bowl, whisk together olive oil, lemon juice, salt, and pepper", isOptional: false),
                Direction(description: "Pour the dressing over the salad and gently toss to combine", isOptional: false),
                Direction(description: "Garnish with chopped parsley before serving", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Baked Salmon with Dill",
                                                description: "Simple yet elegant baked salmon seasoned with dill and lemon.",
                                                author: "Chef Olivia",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Salmon fillets", quantity: 4, unit: .none),
                Ingredient(name: "Fresh dill, chopped", quantity: 3, unit: .tbs),
                Ingredient(name: "Lemon, sliced", quantity: 1, unit: .none),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Garlic, minced", quantity: 2, unit: .none),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Preheat the oven to 375°F (190°C)", isOptional: false),
                Direction(description: "Place the salmon fillets in a baking dish", isOptional: false),
                Direction(description: "Drizzle olive oil and sprinkle garlic, salt, and pepper over the salmon", isOptional: false),
                Direction(description: "Top each fillet with lemon slices and fresh dill", isOptional: false),
                Direction(description: "Bake in the preheated oven for 15-20 minutes, or until salmon flakes easily with a fork", isOptional: false),
                Direction(description: "Serve hot, garnished with additional dill and lemon slices if desired", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Mushroom Risotto",
                                                description: "A creamy and savory Italian risotto loaded with mushrooms.",
                                                author: "Chef Marco",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Arborio rice", quantity: 1, unit: .cups),
                Ingredient(name: "Mixed mushrooms, sliced", quantity: 2, unit: .cups),
                Ingredient(name: "Chicken or vegetable broth", quantity: 4, unit: .cups),
                Ingredient(name: "White wine", quantity: 0.5, unit: .cups),
                Ingredient(name: "Onion, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Garlic, minced", quantity: 2, unit: .none),
                Ingredient(name: "Butter", quantity: 2, unit: .tbs),
                Ingredient(name: "Olive oil", quantity: 1, unit: .tbs),
                Ingredient(name: "Parmesan cheese, grated", quantity: 0.5, unit: .cups),
                Ingredient(name: "Fresh parsley, chopped", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "In a saucepan, heat the broth over low heat", isOptional: false),
                Direction(description: "In a large skillet, heat olive oil and 1 tablespoon of butter over medium heat. Add onion and garlic, and sauté until translucent", isOptional: false),
                Direction(description: "Add mushrooms and cook until they are soft and browned", isOptional: false),
                Direction(description: "Stir in the rice and cook for 2 minutes to lightly toast it, stirring constantly", isOptional: false),
                Direction(description: "Pour in the wine and cook until it's mostly absorbed", isOptional: false),
                Direction(description: "Add the warm broth, one ladle at a time, stirring frequently. Wait until the broth is mostly absorbed before adding the next ladle", isOptional: false),
                Direction(description: "Continue until the rice is creamy and cooked through", isOptional: false),
                Direction(description: "Remove from heat, stir in the remaining butter, parmesan cheese, and parsley", isOptional: false),
                Direction(description: "Season with salt and pepper to taste", isOptional: false),
                Direction(description: "Serve warm with additional grated parmesan", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Pulled Pork Sandwiches",
                                                description: "Tender, slow-cooked pulled pork served on a soft bun with coleslaw.",
                                                author: "Chef Jim",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Pork shoulder", quantity: 3, unit: .lb),
                Ingredient(name: "Barbecue sauce", quantity: 1, unit: .cups),
                Ingredient(name: "Brown sugar", quantity: 0.25, unit: .cups),
                Ingredient(name: "Apple cider vinegar", quantity: 0.5, unit: .cups),
                Ingredient(name: "Garlic, minced", quantity: 2, unit: .none),
                Ingredient(name: "Onion, chopped", quantity: 1, unit: .none),
                Ingredient(name: "Paprika", quantity: 1, unit: .tbs),
                Ingredient(name: "Mustard powder", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 1, unit: .tsp),
                Ingredient(name: "Hamburger buns", quantity: 6, unit: .none),
                Ingredient(name: "Coleslaw", quantity: 2, unit: .cups)
               ],
               directions: [
                Direction(description: "Combine brown sugar, paprika, mustard powder, salt, and pepper. Rub the mixture all over the pork shoulder", isOptional: false),
                Direction(description: "In a slow cooker, place the pork shoulder, garlic, and onion. Pour in apple cider vinegar and barbecue sauce", isOptional: false),
                Direction(description: "Cook on low for 8 hours until the pork is tender and shreds easily", isOptional: false),
                Direction(description: "Shred the pork with two forks and stir it into the sauce", isOptional: false),
                Direction(description: "Serve the pulled pork on hamburger buns, topped with coleslaw", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Raspberry Cheesecake",
                                                description: "A creamy cheesecake topped with fresh raspberries and a raspberry sauce.",
                                                author: "Chef Maria",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "Cream cheese", quantity: 16, unit: .oz),
                Ingredient(name: "Granulated sugar", quantity: 1, unit: .cups),
                Ingredient(name: "Vanilla extract", quantity: 1, unit: .tsp),
                Ingredient(name: "Eggs", quantity: 3, unit: .none),
                Ingredient(name: "Sour cream", quantity: 0.5, unit: .cups),
                Ingredient(name: "Graham cracker crumbs", quantity: 1.5, unit: .cups),
                Ingredient(name: "Butter, melted", quantity: 0.25, unit: .cups),
                Ingredient(name: "Fresh raspberries", quantity: 1, unit: .cups),
                Ingredient(name: "Raspberry sauce", quantity: 0.5, unit: .cups)
               ],
               directions: [
                Direction(description: "Preheat oven to 325°F (165°C). Mix graham cracker crumbs with melted butter and press into the bottom of a springform pan to form the crust", isOptional: false),
                Direction(description: "Beat the cream cheese, sugar, and vanilla extract until smooth. Add eggs one at a time, beating after each addition. Stir in sour cream", isOptional: false),
                Direction(description: "Pour the cream cheese mixture over the crust in the springform pan", isOptional: false),
                Direction(description: "Bake for 45-50 minutes until the center is almost set. Allow to cool, then refrigerate for 4 hours", isOptional: false),
                Direction(description: "Top with fresh raspberries and raspberry sauce before serving", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chicken Caesar Salad",
                                                description: "A classic Caesar salad with grilled chicken, croutons, and Parmesan cheese.",
                                                author: "Chef Elena",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Romaine lettuce, chopped", quantity: 6, unit: .cups),
                Ingredient(name: "Chicken breast", quantity: 2, unit: .none),
                Ingredient(name: "Croutons", quantity: 1, unit: .cups),
                Ingredient(name: "Parmesan cheese, shredded", quantity: 0.5, unit: .cups),
                Ingredient(name: "Caesar dressing", quantity: 0.75, unit: .cups),
                Ingredient(name: "Lemon juice", quantity: 1, unit: .tbs),
                Ingredient(name: "Garlic powder", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Season the chicken breasts with salt, pepper, and garlic powder. Grill until cooked through", isOptional: false),
                Direction(description: "In a large bowl, toss the chopped romaine lettuce with Caesar dressing", isOptional: false),
                Direction(description: "Slice the grilled chicken and add to the salad", isOptional: false),
                Direction(description: "Add croutons and Parmesan cheese to the salad", isOptional: false),
                Direction(description: "Drizzle with lemon juice and toss gently", isOptional: false),
                Direction(description: "Serve immediately", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Vegetable Stir-Fry",
                                                description: "A quick and healthy stir-fry with a variety of colorful vegetables and a savory sauce.",
                                                author: "Chef Mei",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Broccoli florets", quantity: 2, unit: .cups),
                Ingredient(name: "Carrot, sliced", quantity: 1, unit: .none),
                Ingredient(name: "Bell pepper, sliced", quantity: 1, unit: .none),
                Ingredient(name: "Snow peas", quantity: 1, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Ginger, grated", quantity: 1, unit: .tbs),
                Ingredient(name: "Soy sauce", quantity: 3, unit: .tbs),
                Ingredient(name: "Sesame oil", quantity: 1, unit: .tbs),
                Ingredient(name: "Vegetable oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Cornstarch", quantity: 1, unit: .tbs),
                Ingredient(name: "Water", quantity: 2, unit: .tbs)
               ],
               directions: [
                Direction(description: "In a bowl, mix cornstarch and water to create a slurry. Set aside", isOptional: false),
                Direction(description: "Heat vegetable oil in a large skillet or wok over high heat", isOptional: false),
                Direction(description: "Add garlic and ginger, stir-fry for 30 seconds", isOptional: false),
                Direction(description: "Add broccoli, carrots, bell peppers, and snow peas. Stir-fry for 5 minutes", isOptional: false),
                Direction(description: "Stir in soy sauce and sesame oil, cook for another minute", isOptional: false),
                Direction(description: "Add the cornstarch slurry, stir well until the sauce thickens", isOptional: false),
                Direction(description: "Serve hot with rice or noodles", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chocolate Chip Pancakes",
                                                description: "Fluffy pancakes with melted chocolate chips, perfect for a sweet breakfast treat.",
                                                author: "Chef Danny",
                                                category: .breakfast),
               ingredients: [
                Ingredient(name: "All-purpose flour", quantity: 1.5, unit: .cups),
                Ingredient(name: "Granulated sugar", quantity: 2, unit: .tbs),
                Ingredient(name: "Baking powder", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Milk", quantity: 1.25, unit: .cups),
                Ingredient(name: "Egg", quantity: 1, unit: .none),
                Ingredient(name: "Unsalted butter, melted", quantity: 3, unit: .tbs),
                Ingredient(name: "Vanilla extract", quantity: 1, unit: .tsp),
                Ingredient(name: "Chocolate chips", quantity: 0.5, unit: .cups)
               ],
               directions: [
                Direction(description: "In a large bowl, whisk together flour, sugar, baking powder, and salt", isOptional: false),
                Direction(description: "In another bowl, mix milk, egg, melted butter, and vanilla extract", isOptional: false),
                Direction(description: "Pour the wet ingredients into the dry ingredients and stir until just combined", isOptional: false),
                Direction(description: "Fold in the chocolate chips", isOptional: false),
                Direction(description: "Heat a griddle or skillet over medium heat and lightly grease it", isOptional: false),
                Direction(description: "Pour 1/4 cup of batter for each pancake, cook until bubbles form on top, then flip and cook until golden brown", isOptional: false),
                Direction(description: "Serve with syrup, extra chocolate chips, or your favorite toppings", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Margherita Pizza",
                                                description: "A classic Italian pizza with a simple yet delicious combination of fresh tomatoes, mozzarella, and basil.",
                                                author: "Chef Giovanni",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Pizza dough", quantity: 1, unit: .lb),
                Ingredient(name: "Tomato sauce", quantity: 0.5, unit: .cups),
                Ingredient(name: "Fresh mozzarella, sliced", quantity: 8, unit: .oz),
                Ingredient(name: "Ripe tomatoes, sliced", quantity: 2, unit: .none),
                Ingredient(name: "Fresh basil leaves", quantity: 10, unit: .none),
                Ingredient(name: "Olive oil", quantity: 1, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Preheat the oven to 475°F (245°C) with a pizza stone inside", isOptional: false),
                Direction(description: "Roll out the pizza dough on a floured surface to your desired thickness", isOptional: false),
                Direction(description: "Spread tomato sauce evenly over the dough, leaving a border for the crust", isOptional: false),
                Direction(description: "Arrange mozzarella slices and tomato slices on top of the sauce", isOptional: false),
                Direction(description: "Drizzle with olive oil and season with salt and pepper", isOptional: false),
                Direction(description: "Transfer the pizza to the preheated pizza stone and bake for 12-15 minutes until the crust is golden and cheese is bubbly", isOptional: false),
                Direction(description: "Garnish with fresh basil leaves before serving", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Greek Salad",
                                                description: "A refreshing and healthy salad featuring classic Greek ingredients.",
                                                author: "Chef Alexis",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Cucumber, diced", quantity: 1, unit: .none),
                Ingredient(name: "Tomatoes, diced", quantity: 3, unit: .none),
                Ingredient(name: "Red onion, thinly sliced", quantity: 0.5, unit: .none),
                Ingredient(name: "Kalamata olives, pitted", quantity: 0.5, unit: .cups),
                Ingredient(name: "Feta cheese, crumbled", quantity: 0.75, unit: .cups),
                Ingredient(name: "Olive oil", quantity: 0.25, unit: .cups),
                Ingredient(name: "Red wine vinegar", quantity: 2, unit: .tbs),
                Ingredient(name: "Dried oregano", quantity: 1, unit: .tsp),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "In a large bowl, combine cucumbers, tomatoes, red onion, olives, and feta cheese", isOptional: false),
                Direction(description: "In a small bowl, whisk together olive oil, red wine vinegar, oregano, salt, and pepper", isOptional: false),
                Direction(description: "Pour dressing over the salad and gently toss to combine", isOptional: false),
                Direction(description: "Serve immediately or chill in the refrigerator before serving", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Lemon Garlic Shrimp Pasta",
                                                description: "A light and zesty pasta dish featuring succulent shrimp, lemon, and garlic.",
                                                author: "Chef Laura",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Spaghetti", quantity: 8, unit: .oz),
                Ingredient(name: "Shrimp, peeled and deveined", quantity: 1, unit: .lb),
                Ingredient(name: "Garlic cloves, minced", quantity: 4, unit: .none),
                Ingredient(name: "Lemon, juiced and zested", quantity: 1, unit: .none),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Butter", quantity: 2, unit: .tbs),
                Ingredient(name: "Red pepper flakes", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Fresh parsley, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Cook spaghetti according to package instructions until al dente. Drain and set aside", isOptional: false),
                Direction(description: "In a skillet, heat olive oil and butter over medium heat", isOptional: false),
                Direction(description: "Add garlic and red pepper flakes, cook for 1 minute", isOptional: false),
                Direction(description: "Add shrimp, salt, and pepper, cooking until shrimp turn pink", isOptional: false),
                Direction(description: "Stir in lemon juice, zest, and half of the parsley", isOptional: false),
                Direction(description: "Toss the cooked spaghetti with the shrimp mixture", isOptional: false),
                Direction(description: "Garnish with remaining parsley and serve", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "BBQ Chicken Pizza",
                                                description: "A flavorful pizza with barbecue chicken, red onions, and cheese.",
                                                author: "Chef Tyler",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Pizza dough", quantity: 1, unit: .lb),
                Ingredient(name: "BBQ sauce", quantity: 0.5, unit: .cups),
                Ingredient(name: "Cooked chicken breast, shredded", quantity: 1, unit: .cups),
                Ingredient(name: "Red onion, thinly sliced", quantity: 0.5, unit: .none),
                Ingredient(name: "Mozzarella cheese, shredded", quantity: 1.5, unit: .cups),
                Ingredient(name: "Cilantro, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Olive oil", quantity: 1, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Preheat the oven to 475°F (245°C) with a pizza stone inside", isOptional: false),
                Direction(description: "Roll out the pizza dough on a floured surface to your desired thickness", isOptional: false),
                Direction(description: "Spread BBQ sauce evenly over the dough", isOptional: false),
                Direction(description: "Top with shredded chicken, red onion, and mozzarella cheese", isOptional: false),
                Direction(description: "Drizzle with olive oil and season with salt and pepper", isOptional: false),
                Direction(description: "Transfer the pizza to the preheated pizza stone and bake for 12-15 minutes until the crust is golden and cheese is bubbly", isOptional: false),
                Direction(description: "Garnish with chopped cilantro before serving", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Butternut Squash Soup",
                                                description: "A creamy and comforting soup made with roasted butternut squash and a hint of nutmeg.",
                                                author: "Chef Anne",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Butternut squash, peeled and diced", quantity: 2, unit: .lb),
                Ingredient(name: "Carrot, diced", quantity: 1, unit: .none),
                Ingredient(name: "Onion, chopped", quantity: 1, unit: .none),
                Ingredient(name: "Vegetable broth", quantity: 4, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Heavy cream", quantity: 0.5, unit: .cups),
                Ingredient(name: "Nutmeg", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Preheat oven to 400°F (200°C). Toss butternut squash with olive oil, salt, and pepper, and roast for 25 minutes", isOptional: false),
                Direction(description: "In a large pot, sauté onions, carrot, and garlic until soft", isOptional: false),
                Direction(description: "Add roasted squash and vegetable broth, bring to a boil, then simmer for 20 minutes", isOptional: false),
                Direction(description: "Puree the soup using a blender or immersion blender", isOptional: false),
                Direction(description: "Stir in heavy cream and nutmeg, heat through", isOptional: false),
                Direction(description: "Serve warm, garnished with a swirl of cream or fresh herbs", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chicken Tikka Masala",
                                                description: "A popular Indian curry dish with marinated grilled chicken in a rich and creamy tomato sauce.",
                                                author: "Chef Raj",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Chicken breast, cubed", quantity: 1.5, unit: .lb),
                Ingredient(name: "Yogurt", quantity: 1, unit: .cups),
                Ingredient(name: "Tomato puree", quantity: 1, unit: .cups),
                Ingredient(name: "Onion, finely chopped", quantity: 1, unit: .none),
                Ingredient(name: "Garlic cloves, minced", quantity: 3, unit: .none),
                Ingredient(name: "Ginger, grated", quantity: 1, unit: .tbs),
                Ingredient(name: "Garam masala", quantity: 1, unit: .tbs),
                Ingredient(name: "Turmeric", quantity: 1, unit: .tsp),
                Ingredient(name: "Cumin", quantity: 1, unit: .tsp),
                Ingredient(name: "Heavy cream", quantity: 0.5, unit: .cups),
                Ingredient(name: "Cilantro, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Vegetable oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "Marinate chicken in yogurt, half of the garlic, half of the ginger, and spices for at least 1 hour", isOptional: false),
                Direction(description: "Grill the marinated chicken until cooked through", isOptional: false),
                Direction(description: "In a large pan, heat oil over medium heat, sauté onions, remaining garlic, and ginger until soft", isOptional: false),
                Direction(description: "Add tomato puree, grilled chicken, and bring to a simmer", isOptional: false),
                Direction(description: "Add heavy cream and simmer for 10 minutes", isOptional: false),
                Direction(description: "Season with salt and pepper, garnish with cilantro", isOptional: false),
                Direction(description: "Serve with rice or naan bread", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Chocolate Lava Cake",
                                                description: "A decadent dessert featuring a warm and gooey chocolate center.",
                                                author: "Chef Emily",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "Dark chocolate", quantity: 6, unit: .oz),
                Ingredient(name: "Unsalted butter", quantity: 0.5, unit: .cups),
                Ingredient(name: "Powdered sugar", quantity: 1, unit: .cups),
                Ingredient(name: "Eggs", quantity: 2, unit: .none),
                Ingredient(name: "Egg yolks", quantity: 2, unit: .none),
                Ingredient(name: "Vanilla extract", quantity: 1, unit: .tsp),
                Ingredient(name: "All-purpose flour", quantity: 0.5, unit: .cups),
                Ingredient(name: "Salt", quantity: 0.25, unit: .tsp)
               ],
               directions: [
                Direction(description: "Preheat oven to 425°F (220°C). Grease ramekins with butter", isOptional: false),
                Direction(description: "Melt chocolate and butter together, and let it cool slightly", isOptional: false),
                Direction(description: "Whisk in powdered sugar, eggs, egg yolks, and vanilla extract", isOptional: false),
                Direction(description: "Fold in flour and salt until just combined", isOptional: false),
                Direction(description: "Pour batter into prepared ramekins", isOptional: false),
                Direction(description: "Bake for 12-14 minutes until edges are firm but center is soft", isOptional: false),
                Direction(description: "Let cool for 1 minute, then invert onto plates and serve immediately", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Creamy Tomato Basil Pasta",
                                                description: "A rich and flavorful pasta dish with a creamy tomato basil sauce.",
                                                author: "Chef Julia",
                                                category: .dinner),
               ingredients: [
                Ingredient(name: "Penne pasta", quantity: 12, unit: .oz),
                Ingredient(name: "Canned crushed tomatoes", quantity: 15, unit: .oz),
                Ingredient(name: "Heavy cream", quantity: 0.5, unit: .cups),
                Ingredient(name: "Fresh basil, chopped", quantity: 0.25, unit: .cups),
                Ingredient(name: "Garlic cloves, minced", quantity: 2, unit: .none),
                Ingredient(name: "Olive oil", quantity: 2, unit: .tbs),
                Ingredient(name: "Parmesan cheese, grated", quantity: 0.5, unit: .cups),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Red pepper flakes", quantity: 0.25, unit: .tsp)
               ],
               directions: [
                Direction(description: "Cook the penne pasta according to package instructions until al dente. Drain and set aside", isOptional: false),
                Direction(description: "In a skillet, heat olive oil over medium heat. Add garlic and red pepper flakes, cook for 1 minute", isOptional: false),
                Direction(description: "Add crushed tomatoes, simmer for 10 minutes", isOptional: false),
                Direction(description: "Stir in heavy cream, parmesan cheese, and half of the basil. Cook until the sauce is heated through", isOptional: false),
                Direction(description: "Add cooked pasta to the sauce, tossing to coat evenly", isOptional: false),
                Direction(description: "Serve garnished with remaining basil and additional parmesan cheese", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Grilled Vegetable Skewers",
                                                description: "Colorful and delicious skewers of marinated vegetables, perfect for grilling.",
                                                author: "Chef Aaron",
                                                category: .lunch),
               ingredients: [
                Ingredient(name: "Zucchini, cut into rounds", quantity: 2, unit: .none),
                Ingredient(name: "Red bell pepper, cut into pieces", quantity: 1, unit: .none),
                Ingredient(name: "Yellow bell pepper, cut into pieces", quantity: 1, unit: .none),
                Ingredient(name: "Red onion, cut into chunks", quantity: 1, unit: .none),
                Ingredient(name: "Mushrooms, whole", quantity: 1, unit: .cups),
                Ingredient(name: "Cherry tomatoes", quantity: 1, unit: .cups),
                Ingredient(name: "Olive oil", quantity: 3, unit: .tbs),
                Ingredient(name: "Balsamic vinegar", quantity: 2, unit: .tbs),
                Ingredient(name: "Garlic, minced", quantity: 2, unit: .none),
                Ingredient(name: "Italian seasoning", quantity: 1, unit: .tbs),
                Ingredient(name: "Salt", quantity: 1, unit: .tsp),
                Ingredient(name: "Black pepper", quantity: 0.5, unit: .tsp)
               ],
               directions: [
                Direction(description: "In a large bowl, whisk together olive oil, balsamic vinegar, garlic, Italian seasoning, salt, and pepper", isOptional: false),
                Direction(description: "Add vegetables to the bowl and toss to coat. Marinate for at least 30 minutes", isOptional: false),
                Direction(description: "Preheat the grill to medium-high heat", isOptional: false),
                Direction(description: "Thread the marinated vegetables onto skewers", isOptional: false),
                Direction(description: "Grill skewers for 10-12 minutes, turning occasionally, until vegetables are tender and lightly charred", isOptional: false),
                Direction(description: "Serve hot, either as a side dish or a main course", isOptional: false)
               ]
        ),
        Recipe(mainInformation: MainInformation(name: "Classic Apple Pie",
                                                description: "A traditional apple pie with a flaky crust and a sweet, cinnamon-spiced apple filling.",
                                                author: "Chef Martha",
                                                category: .dessert),
               ingredients: [
                Ingredient(name: "Pie crust dough", quantity: 2, unit: .none),
                Ingredient(name: "Apples, peeled, cored, and sliced", quantity: 6, unit: .none),
                Ingredient(name: "Granulated sugar", quantity: 0.75, unit: .cups),
                Ingredient(name: "Brown sugar", quantity: 0.25, unit: .cups),
                Ingredient(name: "Ground cinnamon", quantity: 1, unit: .tbs),
                Ingredient(name: "Nutmeg", quantity: 0.5, unit: .tsp),
                Ingredient(name: "Lemon juice", quantity: 1, unit: .tbs),
                Ingredient(name: "Cornstarch", quantity: 2, unit: .tbs),
                Ingredient(name: "Unsalted butter, cut into small pieces", quantity: 2, unit: .tbs),
                Ingredient(name: "Egg, beaten", quantity: 1, unit: .none)
               ],
               directions: [
                Direction(description: "Preheat oven to 375°F (190°C)", isOptional: false),
                Direction(description: "In a large bowl, combine apples, granulated sugar, brown sugar, cinnamon, nutmeg, lemon juice, and cornstarch", isOptional: false),
                Direction(description: "Roll out one piece of pie dough and place it in a pie dish. Fill with the apple mixture and dot with butter", isOptional: false),
                Direction(description: "Roll out the second piece of dough and place it over the filling. Trim and crimp the edges to seal", isOptional: false),
                Direction(description: "Brush the top crust with beaten egg and make slits for steam to escape", isOptional: false),
                Direction(description: "Bake for about 50 minutes, or until the crust is golden brown and the filling is bubbling", isOptional: false),
                Direction(description: "Let cool before serving", isOptional: false)
               ]
        )
    ]
}
