import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var library: MealLibrary

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        Group {
            if library.favorites.isEmpty {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text("Tap the heart on any recipe to save it here.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(library.favorites) { meal in
                            Button {
                                router.showOnlineRecipeDetails(meal)
                            } label: {
                                MealCard(meal: meal, width: nil)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
