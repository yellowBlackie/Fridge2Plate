import Foundation

struct Ingredient: Displayable {
    let name: String
    let category: Category
    var calories: Double?

    init(
        name: String,
        category: Category,
        calories: Double? = nil
    ) {
        self.name = name
        self.category = category
        self.calories = calories
    }
}