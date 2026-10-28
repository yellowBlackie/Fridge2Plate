import SwiftUI

struct FridgeHomeView: View {

    @ObservedObject var viewModel: FridgeViewModel

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var library: MealLibrary

    @AppStorage("home.introDismissed") private var introDismissed = false
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                if !introDismissed {
                    introCard
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }

                searchSection

                fridgeSection

                previousMealsSection
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Fridge2Plate")
    }

    // MARK: - Sections

    private var introCard: some View {
        ZStack(alignment: .topTrailing) {

            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("What's in your fridge?")
                        .font(.title3.bold())

                    Text("Find recipes using the ingredients you already have.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Image(systemName: "refrigerator.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.accentColor.opacity(0.5))
                    .padding(.trailing, 12)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.14),
                        Color.accentColor.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

            Button {
                withAnimation(.snappy) {
                    introDismissed = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(10)
            .accessibilityLabel("Hide tip")
        }
    }

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Find new recipe online")
                .font(.title3.bold())

            SearchField(
                placeholder: "Search meals, e.g. pasta",
                text: $searchText,
                onSubmit: search
            )
        }
    }

    private var fridgeSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            SectionHeader(title: "My Fridge") {
                router.select(.fridge)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {

                    ForEach(viewModel.availableIngredients, id: \.self) { ingredient in
                        Button {
                            router.select(.fridge)
                        } label: {
                            VStack(spacing: 8) {
                                IngredientAvatar(name: ingredient)

                                Text(ingredient)
                                    .font(.footnote)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                            }
                            .frame(width: 76)
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        router.showAddIngredient()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.title2.weight(.medium))
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 68, height: 68)
                                .overlay(
                                    Circle()
                                        .strokeBorder(
                                            Color.accentColor.opacity(0.5),
                                            style: StrokeStyle(lineWidth: 1.5, dash: [5])
                                        )
                                )

                            Text("Add")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 76)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal, -16)
        }
    }

    private var previousMealsSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            SectionHeader(
                title: "Previous meals",
                action: library.previousMeals.isEmpty ? nil : {
                    router.showPreviousMeals()
                }
            )

            if library.previousMeals.isEmpty {
                EmptyStateCard(
                    systemImage: "frying.pan",
                    title: "Nothing cooked yet",
                    message: "Open a recipe and tap Cook — it will show up here."
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        ForEach(library.previousMeals) { meal in
                            Button {
                                router.showOnlineRecipeDetails(meal)
                            } label: {
                                MealCard(meal: meal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, -16)
            }
        }
    }

    // MARK: - Actions

    private func search() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return
        }

        router.showOnlineRecipes(query: query)
    }
}
