import Foundation

protocol RecipeSearchStrategy {
    func findRecipes(
        in recipes: [Recipe],
        with availableIngredients: [String]
    ) -> [Recipe]
}