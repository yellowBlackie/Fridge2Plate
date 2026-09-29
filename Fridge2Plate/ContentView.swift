//
//  ContentView.swift
//  Fridge2Plate
//
//  Created by Nadia on 29.09.2026.
//

import SwiftUI

struct ContentView: View {
    let availableIngredients = [
        "Eggs",
        "Cheese",
        "Tomato"
    ]

    let availableRecipes: [Recipe]

    init() {
        let eggs = Ingredient(
            name: "Eggs",
            category: .eggs,
            calories: 155
        )

        let cheese = Ingredient(
            name: "Cheese",
            category: .dairy,
            calories: 402
        )

        let tomato = Ingredient(
            name: "Tomato",
            category: .vegetables,
            calories: 18
        )

        let chicken = Ingredient(
            name: "Chicken",
            category: .meat,
            calories: 165
        )

        let omelette = Recipe(
            name: "Omelette",
            ingredients: [eggs, cheese, tomato],
            baseServings: 1
        )

        let chickenOmelette = Recipe(
            name: "Chicken Omelette",
            ingredients: [eggs, cheese, chicken],
            baseServings: 1
        )

        let manager = FridgeManager()

        manager.addRecipe(omelette)
        manager.addRecipe(chickenOmelette)

        availableRecipes = manager.findRecipes(
            with: availableIngredients
        )

        print("=== Fridge2Plate Demo ===")
        print("Available ingredients: \(availableIngredients)")

        if availableRecipes.isEmpty {
            print("No recipes available")
        } else {
            for recipe in availableRecipes {
                print("You can cook: \(recipe.name)")

                if let calories = recipe.totalCalories() {
                    print("Calories: \(calories)")
                } else {
                    print("Calories are unknown")
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("My Fridge") {
                    ForEach(availableIngredients, id: \.self) { ingredient in
                        Label(ingredient, systemImage: "refrigerator")
                    }
                }

                Section("Recipes You Can Cook") {
                    if availableRecipes.isEmpty {
                        Text("No recipes available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(availableRecipes, id: \.name) { recipe in
                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.headline)

                                Text(
                                    "\(recipe.ingredients.count) ingredients"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Fridge2Plate")
        }
    }
}

#Preview {
    ContentView()
}
