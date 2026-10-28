import Foundation
import Combine

/// Finds online recipes that contain all selected fridge ingredients.
@MainActor
final class IngredientRecipesViewModel: ObservableObject {

    @Published private(set) var state: OnlineRecipesState = .idle

    let ingredients: [String]

    private let service: OnlineRecipeServiceProtocol

    init(
        ingredients: [String],
        service: OnlineRecipeServiceProtocol
    ) {
        self.ingredients = ingredients
        self.service = service
    }

    func load() async {
        state = .loading

        do {
            let meals = try await service.searchMeals(
                containing: ingredients
            )

            state = meals.isEmpty ? .empty : .success(meals)

        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}
