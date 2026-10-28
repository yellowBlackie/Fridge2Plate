import Foundation
import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel: FridgeViewModel
    @StateObject private var router = AppRouter()

    private let onlineService: any OnlineRecipeServiceProtocol

    init(
        viewModel: FridgeViewModel,
        onlineService: any OnlineRecipeServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )

        self.onlineService = onlineService
    }

    var body: some View {
        NavigationStack(path: $router.path) {

            FridgeHomeView(
                viewModel: viewModel,
                onShowRecipes: {
                    router.showRecipes()
                },
                onAddIngredient: {
                    router.showAddIngredient()
                },
                onOnlineRecipes: {
                    router.showOnlineRecipes()
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {

                case .recipes:
                    RecipeListView(
                        viewModel: viewModel,
                        onSelectRecipe: { recipe in
                            router.showRecipeDetails(recipe)
                        }
                    )

                case .recipeDetails(let recipeName):
                    if let recipe = viewModel.availableRecipes.first(
                        where: { $0.name == recipeName }
                    ) {
                        RecipeDetailView(recipe: recipe)
                    } else {
                        ContentUnavailableView(
                            "Recipe Not Found",
                            systemImage: "exclamationmark.triangle"
                        )
                    }

                case .onlineRecipes:
                    OnlineRecipesView(
                        liveService: onlineService
                    )

                case .onlineRecipeDetails(let meal):
                    OnlineRecipeDetailView(meal: meal)
                }
            }
            .sheet(item: $router.activeSheet) { _ in
                NavigationStack {
                    AddIngredientView(
                        onSave: { name in
                            viewModel.addIngredient(name)
                        },
                        onDismiss: {
                            router.dismissSheet()
                        }
                    )
                }
            }
        }
    }
}
