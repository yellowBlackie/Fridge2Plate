import Foundation

final class RecipeService: RecipeServiceProtocol {

    private let fridgeManager: FridgeManager

    init(fridgeManager: FridgeManager) {
        self.fridgeManager = fridgeManager
    }

    func findRecipes(
        with availableIngredients: [String]
    ) -> [Recipe] {
        fridgeManager.findRecipes(
            with: availableIngredients
        )
    }
}   