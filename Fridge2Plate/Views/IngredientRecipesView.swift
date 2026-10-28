import SwiftUI

/// Recipes that use all ingredients selected in My Fridge.
struct IngredientRecipesView: View {

    @StateObject private var viewModel: IngredientRecipesViewModel
    @ObservedObject private var fridgeViewModel: FridgeViewModel

    @EnvironmentObject private var router: AppRouter

    init(
        ingredients: [String],
        service: any OnlineRecipeServiceProtocol,
        fridgeViewModel: FridgeViewModel
    ) {
        _viewModel = StateObject(
            wrappedValue: IngredientRecipesViewModel(
                ingredients: ingredients,
                service: service
            )
        )
        self.fridgeViewModel = fridgeViewModel
    }

    private var localRecipes: [Recipe] {
        fridgeViewModel.localRecipes(using: viewModel.ingredients)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                selectedIngredients

                if !localRecipes.isEmpty {
                    localSection
                }

                onlineSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Recipes for you")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = viewModel.state {
                await viewModel.load()
            }
        }
    }

    private var selectedIngredients: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.ingredients, id: \.self) { ingredient in
                    HStack(spacing: 6) {
                        IngredientAvatar(name: ingredient, size: 26)

                        Text(ingredient)
                            .font(.subheadline.weight(.medium))
                    }
                    .padding(.leading, 4)
                    .padding(.trailing, 12)
                    .padding(.vertical, 4)
                    .background(Color(.systemBackground), in: Capsule())
                }
            }
        }
    }

    private var localSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("From your cookbook")
                .font(.title3.bold())

            ForEach(localRecipes, id: \.name) { recipe in
                Button {
                    router.showRecipeDetails(recipe)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "book.closed.fill")
                            .font(.title2)
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 56, height: 56)
                            .background(Color.accentColor.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipe.name)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text("\(recipe.ingredients.count) ingredients")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(10)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var onlineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Online recipes")
                .font(.title3.bold())

            switch viewModel.state {

            case .idle, .loading:
                HStack {
                    Spacer()
                    ProgressView("Finding recipes...")
                    Spacer()
                }
                .padding(.vertical, 40)

            case .success(let meals):
                ForEach(meals) { meal in
                    Button {
                        router.showOnlineRecipeDetails(meal)
                    } label: {
                        MealRow(meal: meal)
                    }
                    .buttonStyle(.plain)
                }

            case .empty:
                EmptyStateCard(
                    systemImage: "magnifyingglass",
                    title: "No recipe uses all of these",
                    message: "Try selecting fewer ingredients."
                )

            case .failure(let message):
                VStack(spacing: 12) {
                    EmptyStateCard(
                        systemImage: "wifi.exclamationmark",
                        title: "Couldn't load recipes",
                        message: message
                    )

                    Button {
                        Task {
                            await viewModel.load()
                        }
                    } label: {
                        Label("Retry", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
