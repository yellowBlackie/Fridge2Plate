import Foundation

final class TheMealDBService: OnlineRecipeServiceProtocol {

    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol) {
        self.client = client
    }

    func searchMeals(
        query: String
    ) async throws -> [RemoteMeal] {

        guard var components = URLComponents(
            string: "https://www.themealdb.com/api/json/v1/1/search.php"
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(
                name: "s",
                value: query
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