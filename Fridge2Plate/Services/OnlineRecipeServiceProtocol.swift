import Foundation

protocol OnlineRecipeServiceProtocol {

    func searchMeals(
        query: String
    ) async throws -> [RemoteMeal]
}