import SwiftUI
import Combine

enum AppTab: Hashable {
    case home
    case favorites
    case fridge
    case profile
}

enum AppRoute: Hashable {
    case recipes
    case recipeDetails(String)
    case onlineRecipes(query: String)
    case onlineRecipeDetails(RemoteMeal)
    case ingredientRecipes([String])
    case previousMeals
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
    @Published var selectedTab: AppTab = .home

    func showRecipes() {
        path.append(.recipes)
    }

    func showRecipeDetails(_ recipe: Recipe) {
        path.append(.recipeDetails(recipe.name))
    }

    func showOnlineRecipes(query: String = "chicken") {
        path.append(.onlineRecipes(query: query))
    }

    func showOnlineRecipeDetails(_ meal: RemoteMeal) {
        path.append(.onlineRecipeDetails(meal))
    }

    func showIngredientRecipes(_ ingredients: [String]) {
        path.append(.ingredientRecipes(ingredients))
    }

    func showPreviousMeals() {
        path.append(.previousMeals)
    }

    func select(_ tab: AppTab) {
        path.removeAll()
        selectedTab = tab
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
