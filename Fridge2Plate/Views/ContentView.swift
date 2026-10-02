import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel: FridgeViewModel

    init(viewModel: FridgeViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        NavigationStack {
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

                Section("Recipes You Can Cook") {
                    if viewModel.availableRecipes.isEmpty {
                        Text("No recipes available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(
                            viewModel.availableRecipes,
                            id: \.name
                        ) { recipe in
                            VStack(alignment: .leading) {
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
            .navigationTitle("Fridge2Plate")
        }
    }
}