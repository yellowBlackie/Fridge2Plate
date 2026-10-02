import Foundation

final class RecipeBuilder {

    private var name: String = ""
    private var ingredients: [Ingredient] = []
    private var baseServings: Int = 1

    @discardableResult
    func setName(_ name: String) -> RecipeBuilder {
        self.name = name
        return self
    }

    @discardableResult
    func addIngredient(_ ingredient: Ingredient) -> RecipeBuilder {
        ingredients.append(ingredient)
        return self
    }

    @discardableResult
    func setBaseServings(_ servings: Int) -> RecipeBuilder {
        self.baseServings = servings
        return self
    }

    func build() -> Recipe {
        Recipe(
            name: name,
            ingredients: ingredients,
            baseServings: baseServings
        )
    }
}