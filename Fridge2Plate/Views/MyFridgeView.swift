import SwiftUI

struct MyFridgeView: View {

    @ObservedObject var viewModel: FridgeViewModel

    @EnvironmentObject private var router: AppRouter

    var body: some View {
        Group {
            if viewModel.availableIngredients.isEmpty {
                ContentUnavailableView {
                    Label("Your fridge is empty", systemImage: "refrigerator")
                } description: {
                    Text("Add what you have at home to find matching recipes.")
                } actions: {
                    Button("Add Ingredient") {
                        router.showAddIngredient()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ingredientList
            }
        }
        .navigationTitle("My Fridge")
        .toolbar {
            if !viewModel.availableIngredients.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    Button(allSelected ? "Clear" : "Select All") {
                        withAnimation(.snappy) {
                            if allSelected {
                                viewModel.clearSelection()
                            } else {
                                viewModel.selectAll()
                            }
                        }
                    }
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.showAddIngredient()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Ingredient")
            }
        }
    }

    private var allSelected: Bool {
        !viewModel.availableIngredients.isEmpty
            && viewModel.selectedIngredients.count == viewModel.availableIngredients.count
    }

    private var ingredientList: some View {
        List {
            Section {
                ForEach(viewModel.availableIngredients, id: \.self) { ingredient in
                    row(for: ingredient)
                }
                .onDelete(perform: deleteIngredients)
            } footer: {
                Text("Select ingredients to find recipes that use all of them. Swipe left to remove one.")
            }
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .bottom) {
            showRecipesButton
        }
    }

    private func row(for ingredient: String) -> some View {
        let isSelected = viewModel.isSelected(ingredient)

        return Button {
            withAnimation(.snappy(duration: 0.2)) {
                viewModel.toggleSelection(ingredient)
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary.opacity(0.5))
                    .contentTransition(.symbolEffect(.replace))

                IngredientAvatar(name: ingredient, size: 44)

                Text(ingredient)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.vertical, 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var showRecipesButton: some View {
        let count = viewModel.selectedIngredients.count

        return Button {
            router.showIngredientRecipes(viewModel.orderedSelection)
        } label: {
            HStack {
                Image(systemName: "sparkles")

                Text(count == 0 ? "Select ingredients" : "Show recipes (\(count))")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background(
                count == 0 ? Color.secondary.opacity(0.4) : Color.accentColor,
                in: Capsule()
            )
        }
        .disabled(count == 0)
        .padding(.horizontal)
        .padding(.bottom, 8)
        .animation(.snappy, value: count)
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
