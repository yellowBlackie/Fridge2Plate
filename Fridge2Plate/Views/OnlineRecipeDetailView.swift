import SwiftUI

struct OnlineRecipeDetailView: View {

    let meal: RemoteMeal

    private var steps: [String] {
        (meal.strInstructions ?? "")
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { line in
                // Skip empty lines and "STEP 1"-style headings.
                !line.isEmpty
                    && line.range(
                        of: #"^step\s*\d+$"#,
                        options: [.regularExpression, .caseInsensitive]
                    ) == nil
            }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                header

                ingredientsSection

                instructionsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {

            AsyncImage(
                url: meal.strMealThumb.flatMap(URL.init(string:))
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "fork.knife")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.secondarySystemBackground))
            }
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Text(meal.strMeal)
                .font(.largeTitle.bold())

            HStack(spacing: 8) {
                if let category = meal.strCategory, !category.isEmpty {
                    tag(category, systemImage: "tag")
                }

                if let area = meal.strArea, !area.isEmpty {
                    tag(area, systemImage: "globe")
                }
            }
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            sectionTitle(
                "Ingredients",
                count: meal.ingredients.count
            )

            if meal.ingredients.isEmpty {
                emptyText("No ingredients available.")
            } else {
                VStack(spacing: 0) {
                    ForEach(
                        Array(meal.ingredients.enumerated()),
                        id: \.offset
                    ) { index, ingredient in
                        HStack(spacing: 12) {

                            AsyncImage(url: ingredient.imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color(.secondarySystemBackground)
                            }
                            .frame(width: 40, height: 40)
                            .padding(4)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Circle())

                            Text(ingredient.name)

                            Spacer()

                            Text(ingredient.measure)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)

                        if index < meal.ingredients.count - 1 {
                            Divider()
                                .padding(.leading, 68)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            sectionTitle("Instructions", count: nil)

            if steps.isEmpty {
                emptyText("No instructions available.")
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(
                        Array(steps.enumerated()),
                        id: \.offset
                    ) { index, step in
                        HStack(alignment: .top, spacing: 12) {

                            Text("\(index + 1)")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.accentColor)
                                .clipShape(Circle())

                            Text(step)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    private func tag(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.accentColor.opacity(0.12))
            .foregroundStyle(Color.accentColor)
            .clipShape(Capsule())
    }

    private func sectionTitle(_ title: String, count: Int?) -> some View {
        HStack {
            Text(title)
                .font(.title2.bold())

            if let count {
                Text("\(count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func emptyText(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
