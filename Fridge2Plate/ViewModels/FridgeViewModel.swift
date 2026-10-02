import Foundation
import Combine

final class FridgeViewModel: ObservableObject {

    @Published var availableIngredients: [String]
    @Published var availableRecipes: [Recipe] = []

    private let fridgeManager: FridgeManager

    init(fridgeManager: FridgeManager) {
        self.fridgeManager = fridgeManager

        self.availableIngredients = [
            "Eggs",
            "Cheese",
            "Tomato"
        ]

        findAvailableRecipes()
    }

    func findAvailableRecipes() {
        availableRecipes = fridgeManager.findRecipes(
            with: availableIngredients
        )
    }
}