import Foundation

final class ExactMatchStrategy: RecipeSearchStrategy {

    func findRecipes(
        in recipes: [Recipe],
        with availableIngredients: [String]
    ) -> [Recipe] {

        let normalizedIngredients = availableIngredients.map {
            $0.lowercased()
        }

        return recipes.filter { recipe in
            recipe.ingredients.allSatisfy { ingredient in
                normalizedIngredients.contains(
                    ingredient.name.lowercased()
                )
            }
        }
    }
}