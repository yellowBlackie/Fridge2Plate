import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: FridgeViewModel

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var library: MealLibrary

    @State private var isConfirmingClear = false

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                        .frame(width: 88, height: 88)
                        .background(
                            LinearGradient(
                                colors: [Color.accentColor, Color.purple.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: Circle()
                        )

                    Text("Home Chef")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            Section {
                HStack(spacing: 12) {
                    statTile(
                        value: viewModel.availableIngredients.count,
                        title: "In fridge",
                        systemImage: "refrigerator"
                    )
                    statTile(
                        value: library.previousMeals.count,
                        title: "Cooked",
                        systemImage: "frying.pan"
                    )
                    statTile(
                        value: library.favorites.count,
                        title: "Favorites",
                        systemImage: "heart"
                    )
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section("Cooking") {
                Button {
                    router.showPreviousMeals()
                } label: {
                    Label("Previous meals", systemImage: "clock.arrow.circlepath")
                }
                .disabled(library.previousMeals.isEmpty)

                Button(role: .destructive) {
                    isConfirmingClear = true
                } label: {
                    Label("Clear cooking history", systemImage: "trash")
                }
                .disabled(library.previousMeals.isEmpty)
            }

            Section {
                LabeledContent("Recipes by", value: "TheMealDB")
            } footer: {
                Text("Fridge2Plate helps you cook with what you already have.")
            }
        }
        .navigationTitle("Profile")
        .confirmationDialog(
            "Clear cooking history?",
            isPresented: $isConfirmingClear,
            titleVisibility: .visible
        ) {
            Button("Clear", role: .destructive) {
                library.clearPreviousMeals()
            }
        }
    }

    private func statTile(
        value: Int,
        title: String,
        systemImage: String
    ) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundStyle(Color.accentColor)

            Text("\(value)")
                .font(.title2.bold())
                .contentTransition(.numericText())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
