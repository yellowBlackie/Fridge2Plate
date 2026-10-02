import Foundation

final class MockRecipeService: RecipeServiceProtocol {

    private let recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func findRecipes(
        with availableIngredients: [String]
    ) -> [Recipe] {
        recipes
    }
}