import Foundation

struct RemoteMeal: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?

    var id: String {
        idMeal
    }
}

struct MealSearchResponse: Decodable {
    let meals: [RemoteMeal]?
}