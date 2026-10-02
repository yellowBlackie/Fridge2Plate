import Foundation

protocol RecipeServiceProtocol {
    func findRecipes(
        with availableIngredients: [String]
    ) -> [Recipe]
}