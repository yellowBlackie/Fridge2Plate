
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
                    strMealThumb: nil
                ),
                RemoteMeal(
                    idMeal: "2",
                    strMeal: "Mock Chicken Soup",
                    strMealThumb: nil
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
