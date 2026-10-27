import SwiftUI

struct RecipeListView: View {

    @ObservedObject var viewModel: FridgeViewModel

    let onSelectRecipe: (Recipe) -> Void

    var body: some View {
        List {
            Section {
                Text("Recipes you can cook with your ingredients")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Available Recipes") {
                if viewModel.availableRecipes.isEmpty {
                    ContentUnavailableView(
                        "No Recipes",
                        systemImage: "fork.knife",
                        description: Text(
                            "Try adding more ingredients to your fridge."
                        )
                    )
                } else {
                    ForEach(
                        viewModel.availableRecipes,
                        id: \.name
                    ) { recipe in
                        Button {
                            onSelectRecipe(recipe)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.tint)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recipe.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text(
                                        "\(recipe.ingredients.count) ingredients"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
        .navigationTitle("Recipes")
    }
}
