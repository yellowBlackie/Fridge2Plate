
import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel: FridgeViewModel
    @StateObject private var router = AppRouter()

    init(viewModel: FridgeViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                Section("My Fridge") {
                    ForEach(
                        viewModel.availableIngredients,
                        id: \.self
                    ) { ingredient in
                        Label(
                            ingredient,
                            systemImage: "refrigerator"
                        )
                    }
                }

                Section("Navigation") {
                    Button {
                        router.showRecipes()
                    } label: {
                        Label(
                            "Show Recipes",
                            systemImage: "book"
                        )
                    }

                    Button {
                        router.showAddIngredient()
                    } label: {
                        Label(
                            "Add Ingredient",
                            systemImage: "plus.circle"
                        )
                    }
                }
            }
            .navigationTitle("Fridge2Plate")
            .navigationDestination(for: AppRoute.self) { route in
                switch route {

                case .recipes:
                    recipeList

                case .recipeDetails(let recipeName):
                    recipeDetails(name: recipeName)
                }
            }
            .sheet(item: $router.activeSheet) { sheet in
                switch sheet {
                case .addIngredient:
                    addIngredientPlaceholder
                }
            }
        }
    }

    private var recipeList: some View {
        List {
            if viewModel.availableRecipes.isEmpty {
                Text("No recipes available")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(
                    viewModel.availableRecipes,
                    id: \.name
                ) { recipe in
                    Button {
                        router.showRecipeDetails(recipe)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recipe.name)
                                .font(.headline)

                            Text(
                                "\(recipe.ingredients.count) ingredients"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Recipes")
    }

    private func recipeDetails(name: String) -> some View {
        Group {
            if let recipe = viewModel.availableRecipes.first(
                where: { $0.name == name }
            ) {
                List {
                    Section("Ingredients") {
                        ForEach(
                            recipe.ingredients,
                            id: \.name
                        ) { ingredient in
                            Text(ingredient.name)
                        }
                    }

                    Section("Servings") {
                        Text("\(recipe.baseServings)")
                    }
                }
                .navigationTitle(recipe.name)
            } else {
                Text("Recipe not found")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var addIngredientPlaceholder: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)

                Text("Add Ingredient")
                    .font(.title2)

                Text("Ingredient form will be added next.")
                    .foregroundStyle(.secondary)

                Button("Close") {
                    router.dismissSheet()
                }
            }
            .padding()
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
