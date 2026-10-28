import SwiftUI
import Combine

enum AppRoute: Hashable {
    case recipes
    case recipeDetails(String)
    case onlineRecipes
}

enum AppSheet: String, Identifiable {
    case addIngredient

    var id: String {
        rawValue
    }
}

final class AppRouter: ObservableObject {

    @Published var path: [AppRoute] = []
    @Published var activeSheet: AppSheet?

    func showRecipes() {
        path.append(.recipes)
    }

    func showRecipeDetails(_ recipe: Recipe) {
        path.append(.recipeDetails(recipe.name))
    }

    func showOnlineRecipes() {
        path.append(.onlineRecipes)
    }

    func showAddIngredient() {
        activeSheet = .addIngredient
    }

    func dismissSheet() {
        activeSheet = nil
    }

    func goBack() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }

    func goToRoot() {
        path.removeAll()
    }
}