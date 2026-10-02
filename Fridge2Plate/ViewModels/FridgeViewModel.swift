import Foundation
import Combine

final class FridgeViewModel: ObservableObject {

    @Published var availableIngredients: [String]
    @Published var availableRecipes: [Recipe] = []

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService

        self.availableIngredients = [
            "Eggs",
            "Cheese",
            "Tomato"
        ]

        findAvailableRecipes()
    }

    func findAvailableRecipes() {
        availableRecipes = recipeService.findRecipes(
            with: availableIngredients
        )
    }
}