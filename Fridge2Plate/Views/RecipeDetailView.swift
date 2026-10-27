import SwiftUI

struct RecipeDetailView: View {

    let recipe: Recipe

    @State private var showIngredients = false

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.tint)

                    Text(recipe.name)
                        .font(.largeTitle.bold())

                    Text("\(recipe.baseServings) servings")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 12)
            }

            Section("Recipe Information") {
                LabeledContent(
                    "Ingredients",
                    value: "\(recipe.ingredients.count)"
                )

                LabeledContent(
                    "Servings",
                    value: "\(recipe.baseServings)"
                )

                if let calories = recipe.totalCalories() {
                    LabeledContent(
                        "Calculated Calories",
                        value: "\(Int(calories)) kcal"
                    )
                } else {
                    LabeledContent(
                        "Calories",
                        value: "Unknown"
                    )
                }
            }

            Section {
                Button {
                    withAnimation(
                        reduceMotion
                        ? nil
                        : .easeInOut(duration: 0.3)
                    ) {
                        showIngredients.toggle()
                    }
                } label: {
                                    HStack {
                                        Label(
                                            showIngredients
                                            ? "Hide Ingredients"
                                            : "Show Ingredients",
                                            systemImage: "list.bullet"
                                        )

                                        Spacer()

                                        Image(
                                            systemName: showIngredients
                                            ? "chevron.up"
                                            : "chevron.down"
                                        )
                                    }
                                }
                                .accessibilityValue(showIngredients ? "Expanded" : "Collapsed")

                                if showIngredients {
                                    ForEach(
                                        recipe.ingredients,
                                        id: \.name
                                    ) { ingredient in
                                        Label(
                                            ingredient.name,
                                            systemImage: "checkmark.circle"
                                        )
                                        .transition(
                                            .opacity.combined(
                                                with: .move(edge: .top)
                                            )
                                        )
                                    }
                                }
                            } header: {
                                Text("Ingredients")
                            } footer: {
                                Text("Tap the button to expand or collapse the ingredients.")
                            }
                        }
                        .navigationTitle("Recipe Details")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
