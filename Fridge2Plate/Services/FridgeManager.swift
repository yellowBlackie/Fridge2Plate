import Foundation

final class FridgeManager {

    private var recipes: [Recipe]
    private var searchStrategy: RecipeSearchStrategy

    init(
        recipes: [Recipe] = [],
        searchStrategy: RecipeSearchStrategy = ExactMatchStrategy()
    ) {
        self.recipes = recipes
        self.searchStrategy = searchStrategy
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }

    func setSearchStrategy(
        _ strategy: RecipeSearchStrategy
    ) {
        searchStrategy = strategy
    }

    func findRecipes(
        with availableIngredients: [String]
    ) -> [Recipe] {
        searchStrategy.findRecipes(
            in: recipes,
            with: availableIngredients
        )
    }
}