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