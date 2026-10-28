import Foundation
import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel: FridgeViewModel
    @StateObject private var router = AppRouter()
    @StateObject private var library: MealLibrary

    private let onlineService: any OnlineRecipeServiceProtocol

    init(
        viewModel: FridgeViewModel,
        onlineService: any OnlineRecipeServiceProtocol,
        library: MealLibrary
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )

        _library = StateObject(
            wrappedValue: library
        )

        self.onlineService = onlineService
    }

    var body: some View {
        NavigationStack(path: $router.path) {

            MainTabView(viewModel: viewModel)
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

                case .onlineRecipes(let query):
                    OnlineRecipesView(
                        liveService: onlineService,
                        initialQuery: query
                    )

                case .onlineRecipeDetails(let meal):
                    OnlineRecipeDetailView(meal: meal)

                case .ingredientRecipes(let ingredients):
                    IngredientRecipesView(
                        ingredients: ingredients,
                        service: onlineService,
                        fridgeViewModel: viewModel
                    )

                case .previousMeals:
                    PreviousMealsView()
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
        .environmentObject(router)
        .environmentObject(library)
    }
}
