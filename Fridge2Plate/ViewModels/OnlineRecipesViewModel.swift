
import Foundation
import Combine

enum OnlineRecipesState {
    case idle
    case loading
    case success([RemoteMeal])
    case empty
    case failure(String)
}

@MainActor
final class OnlineRecipesViewModel: ObservableObject {

    @Published var searchText: String = "chicken"

    @Published private(set) var state: OnlineRecipesState = .idle

    private let service: OnlineRecipeServiceProtocol

    init(service: OnlineRecipeServiceProtocol) {
        self.service = service
    }

    func search() async {

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            state = .empty
            return
        }

        state = .loading

        do {
            let meals = try await service.searchMeals(
                query: query
            )

            if meals.isEmpty {
                state = .empty
            } else {
                state = .success(meals)
            }

        } catch {
            state = .failure(
                error.localizedDescription
            )
        }
    }

    func retry() async {
        await search()
    }
}
