import SwiftUI

// MARK: - Images

/// Meal photo with a soft placeholder while it loads.
struct MealThumbnail: View {

    let urlString: String?

    var body: some View {
        AsyncImage(
            url: urlString.flatMap(URL.init(string:))
        ) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ZStack {
                Color(.secondarySystemBackground)

                Image(systemName: "fork.knife")
                    .font(.title2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

/// Round ingredient photo from TheMealDB, or its first letter as a fallback.
struct IngredientAvatar: View {

    let name: String
    var size: CGFloat = 68

    var body: some View {
        AsyncImage(
            url: RemoteIngredient.imageURL(for: name)
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.14)

            default:
                Text(name.prefix(1).uppercased())
                    .font(.system(size: size * 0.38, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .frame(width: size, height: size)
        .background(Color.accentColor.opacity(0.08))
        .clipShape(Circle())
        .overlay(
            Circle()
                .strokeBorder(Color.primary.opacity(0.06))
        )
    }
}

// MARK: - Meal cards

extension RemoteMeal {

    /// "Chicken · India" — only the parts that exist.
    var subtitle: String {
        [strCategory, strArea]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }
}

/// Square card for horizontal carousels.
struct MealCard: View {

    let meal: RemoteMeal

    /// Fixed width for carousels; nil fills the available width (grids).
    var width: CGFloat? = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay(MealThumbnail(urlString: meal.strMealThumb))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(meal.strMeal)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if !meal.subtitle.isEmpty {
                    Text(meal.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .frame(width: width, alignment: .leading)
        .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
    }
}

/// Full-width card for vertical lists.
struct MealRow: View {

    let meal: RemoteMeal

    var body: some View {
        HStack(spacing: 14) {

            MealThumbnail(urlString: meal.strMealThumb)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.strMeal)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                if !meal.subtitle.isEmpty {
                    Text(meal.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

// MARK: - Layout helpers

/// "Title  >" header used above home sections.
struct SectionHeader: View {

    let title: String
    var action: (() -> Void)?

    var body: some View {
        if let action {
            Button(action: action) {
                label
            }
            .buttonStyle(.plain)
        } else {
            label
        }
    }

    private var label: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.primary)

            if action != nil {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(5)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }

            Spacer()
        }
        .contentShape(Rectangle())
    }
}

/// Friendly placeholder for empty sections.
struct EmptyStateCard: View {

    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 48, height: 48)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.secondarySystemBackground).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

/// Rounded search field with a clear button.
struct SearchField: View {

    let placeholder: String
    @Binding var text: String
    var onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit(onSubmit)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.tertiary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

// MARK: - Bottom bar

struct AppBottomBar: View {

    @Binding var selectedTab: AppTab
    var onAdd: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home, title: "Home", systemImage: "house")
            tabButton(.favorites, title: "Favorites", systemImage: "heart")

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .shadow(color: Color.accentColor.opacity(0.35), radius: 10, y: 4)
            }
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Add Ingredient")

            tabButton(.fridge, title: "Fridge", systemImage: "refrigerator")
            tabButton(.profile, title: "Profile", systemImage: "person")
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .background(
            Rectangle()
                .fill(.bar)
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: .black.opacity(0.06), radius: 8, y: -2)
        )
    }

    private func tabButton(
        _ tab: AppTab,
        title: String,
        systemImage: String
    ) -> some View {
        let isSelected = selectedTab == tab

        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "\(systemImage).fill" : systemImage)
                    .font(.title3)
                    .frame(height: 26)

                Text(title)
                    .font(.caption2.weight(.medium))
            }
            .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
