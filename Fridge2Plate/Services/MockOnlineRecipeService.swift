
import Foundation

final class MockOnlineRecipeService: OnlineRecipeServiceProtocol {

    enum Scenario {
        case success
        case empty
        case transportError
        case httpError
        case decodingError
    }

    private let scenario: Scenario

    init(scenario: Scenario) {
        self.scenario = scenario
    }

    func searchMeals(
        query: String
    ) async throws -> [RemoteMeal] {

        // Short delay to make Loading visible in the demo.
        try await Task.sleep(
            nanoseconds: 700_000_000
        )

        switch scenario {

        case .success:
            return [
                RemoteMeal(
                    idMeal: "1",
                    strMeal: "Mock Chicken Recipe",
                    strMealThumb: nil,
                    strCategory: "Chicken",
                    strArea: "Demo",
                    strInstructions: "Season the chicken.\nFry for 10 minutes on each side.\nServe hot.",
                    ingredients: [
                        RemoteIngredient(name: "Chicken", measure: "500 g"),
                        RemoteIngredient(name: "Salt", measure: "1 tsp"),
                        RemoteIngredient(name: "Olive Oil", measure: "2 tbs")
                    ]
                ),
                RemoteMeal(
                    idMeal: "2",
                    strMeal: "Mock Chicken Soup",
                    strMealThumb: nil,
                    strCategory: "Soup",
                    strArea: "Demo",
                    strInstructions: "Boil the chicken in water for 40 minutes.\nAdd carrots and onion.\nCook for 15 more minutes.",
                    ingredients: [
                        RemoteIngredient(name: "Chicken", measure: "300 g"),
                        RemoteIngredient(name: "Carrots", measure: "2"),
                        RemoteIngredient(name: "Onion", measure: "1")
                    ]
                )
            ]

        case .empty:
            return []

        case .transportError:
            throw NetworkError.transport(
                URLError(.notConnectedToInternet)
            )

        case .httpError:
            throw NetworkError.httpStatus(503)

        case .decodingError:
            throw NetworkError.decoding
        }
    }
}
