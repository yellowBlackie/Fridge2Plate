import Foundation

final class MissingIngredientsStrategy: RecipeSearchStrategy {

    private let maximumMissingIngredients: Int

    init(maximumMissingIngredients: Int = 1) {
        self.maximumMissingIngredients = maximumMissingIngredients
    }

    func findRecipes(
        in recipes: [Recipe],
        with availableIngredients: [String]
    ) -> [Recipe] {

        let normalizedIngredients = availableIngredients.map {
            $0.lowercased()
        }

        return recipes.filter { recipe in
            let missingIngredients = recipe.ingredients.filter { ingredient in
                !normalizedIngredients.contains(
                    ingredient.name.lowercased()
                )
            }

            return missingIngredients.count <= maximumMissingIngredients
        }
    }
}