import SwiftUI

struct PreviousMealsView: View {

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var library: MealLibrary

    var body: some View {
        Group {
            if library.previousMeals.isEmpty {
                ContentUnavailableView(
                    "Nothing cooked yet",
                    systemImage: "frying.pan",
                    description: Text("Open a recipe and tap Cook to add it here.")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(library.previousMeals) { meal in
                            Button {
                                router.showOnlineRecipeDetails(meal)
                            } label: {
                                MealRow(meal: meal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Previous meals")
        .navigationBarTitleDisplayMode(.inline)
    }
}
