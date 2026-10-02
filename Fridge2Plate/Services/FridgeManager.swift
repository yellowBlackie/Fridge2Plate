import Foundation

class FridgeManager {
    private var recipes: [Recipe]

    init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }

    func findRecipes(with availableIngredients: [String]) -> [Recipe] {
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