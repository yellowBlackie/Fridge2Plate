import Foundation

protocol OnlineRecipeServiceProtocol {

    func searchMeals(
        query: String
    ) async throws -> [RemoteMeal]

    /// Full recipes that contain every one of the given ingredients.
    func searchMeals(
        containing ingredients: [String]
    ) async throws -> [RemoteMeal]
}