import Foundation

final class TheMealDBService: OnlineRecipeServiceProtocol {

    private let client: HTTPClientProtocol

    private let baseURL = "https://www.themealdb.com/api/json/v1/1/"

    /// The free API filters by one ingredient at a time and returns
    /// short results, so full details are loaded for the first few matches.
    private let maximumDetailedResults = 12

    init(client: HTTPClientProtocol) {
        self.client = client
    }

    func searchMeals(
        query: String
    ) async throws -> [RemoteMeal] {
        try await fetchMeals(
            endpoint: "search.php",
            queryName: "s",
            value: query
        )
    }

    func searchMeals(
        containing ingredients: [String]
    ) async throws -> [RemoteMeal] {

        guard !ingredients.isEmpty else {
            return []
        }

        var matchingIDs: [String]?

        for ingredient in ingredients {
            let meals = try await fetchMeals(
                endpoint: "filter.php",
                queryName: "i",
                value: ingredient.replacingOccurrences(of: " ", with: "_")
            )

            let ids = meals.map(\.idMeal)

            if let current = matchingIDs {
                let idSet = Set(ids)
                matchingIDs = current.filter { idSet.contains($0) }
            } else {
                matchingIDs = ids
            }

            if matchingIDs?.isEmpty == true {
                return []
            }
        }

        let ids = Array((matchingIDs ?? []).prefix(maximumDetailedResults))

        return try await withThrowingTaskGroup(
            of: (Int, RemoteMeal?).self
        ) { group in

            for (index, id) in ids.enumerated() {
                group.addTask {
                    let meal = try await self.fetchMeals(
                        endpoint: "lookup.php",
                        queryName: "i",
                        value: id
                    ).first

                    return (index, meal)
                }
            }

            var results: [(Int, RemoteMeal)] = []

            for try await (index, meal) in group {
                if let meal {
                    results.append((index, meal))
                }
            }

            return results
                .sorted { $0.0 < $1.0 }
                .map(\.1)
        }
    }

    private func fetchMeals(
        endpoint: String,
        queryName: String,
        value: String
    ) async throws -> [RemoteMeal] {

        guard var components = URLComponents(
            string: baseURL + endpoint
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(
                name: queryName,
                value: value
            )
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let data = try await client.get(from: url)

        do {
            let response = try JSONDecoder().decode(
                MealSearchResponse.self,
                from: data
            )

            return response.meals ?? []

        } catch {
            throw NetworkError.decoding
        }
    }
}
