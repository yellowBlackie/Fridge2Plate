import SwiftUI

struct FridgeHomeView: View {

    @ObservedObject var viewModel: FridgeViewModel

    let onShowRecipes: () -> Void
    let onAddIngredient: () -> Void

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's in your fridge?")
                        .font(.title2.bold())

                    Text("Find recipes using the ingredients you already have.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("My Fridge") {
                if viewModel.availableIngredients.isEmpty {
                    Text("Your fridge is empty")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(
                        viewModel.availableIngredients,
                        id: \.self
                    ) { ingredient in
                        Label(
                            ingredient,
                            systemImage: "refrigerator"
                        )
                    }
                    .onDelete(perform: deleteIngredients)
                }
            }

            Section("Actions") {
                Button(action: onAddIngredient) {
                    Label(
                        "Add Ingredient",
                        systemImage: "plus.circle.fill"
                    )
                }

                Button(action: onShowRecipes) {
                    Label(
                        "Show Recipes",
                        systemImage: "book.closed.fill"
                    )
                }
            }

            Section {
                Text("Swipe left on an ingredient to remove it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Fridge2Plate")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onAddIngredient) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Ingredient")
            }
        }
    }

    private func deleteIngredients(at offsets: IndexSet) {
        let names = offsets.map {
            viewModel.availableIngredients[$0]
        }

        for name in names {
            viewModel.removeIngredient(name)
        }
    }
}
