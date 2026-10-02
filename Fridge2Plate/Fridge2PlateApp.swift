import SwiftUI

@main
struct Fridge2PlateApp: App {

    private let viewModel: FridgeViewModel

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

        let omelette = RecipeBuilder()
            .setName("Omelette")
            .addIngredient(eggs)
            .addIngredient(cheese)
            .addIngredient(tomato)
            .setBaseServings(1)
            .build()

        let chickenOmelette = RecipeBuilder()
            .setName("Chicken Omelette")
            .addIngredient(eggs)
            .addIngredient(cheese)
            .addIngredient(chicken)
            .setBaseServings(1)
            .build()

        let fridgeManager = FridgeManager(
            recipes: [
                omelette,
                chickenOmelette
            ]
        )

        self.viewModel = FridgeViewModel(
            fridgeManager: fridgeManager
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}