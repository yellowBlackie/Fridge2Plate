import Foundation

struct Recipe: Displayable {
    let name: String
    let ingredients: [Ingredient]
    let baseServings: Int

    init(
        name: String,
        ingredients: [Ingredient],
        baseServings: Int = 1
    ) {
        self.name = name
        self.ingredients = ingredients
        self.baseServings = baseServings
    }

    func totalCalories() -> Double? {
        var total = 0.0

        for ingredient in ingredients {
            guard let calories = ingredient.calories else {
                return nil
            }

            total += calories
        }

        return total
    }

    func calories(for servings: Int) -> Double? {
        guard let total = totalCalories() else {
            return nil
        }

        return total * Double(servings) / Double(baseServings)
    }
}