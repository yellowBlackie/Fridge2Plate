import Foundation
import Combine

/// Keeps favourite and cooked meals and saves them on the device.
@MainActor
final class MealLibrary: ObservableObject {

    @Published private(set) var favorites: [RemoteMeal] = []
    @Published private(set) var previousMeals: [RemoteMeal] = []

    private let defaults: UserDefaults

    private let favoritesKey = "mealLibrary.favorites"
    private let previousMealsKey = "mealLibrary.previousMeals"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        favorites = load(forKey: favoritesKey)
        previousMeals = load(forKey: previousMealsKey)
    }

    func isFavorite(_ meal: RemoteMeal) -> Bool {
        favorites.contains { $0.id == meal.id }
    }

    func toggleFavorite(_ meal: RemoteMeal) {
        if isFavorite(meal) {
            favorites.removeAll { $0.id == meal.id }
        } else {
            favorites.insert(meal, at: 0)
        }

        save(favorites, forKey: favoritesKey)
    }

    /// Moves the meal to the top of Previous meals.
    func markCooked(_ meal: RemoteMeal) {
        previousMeals.removeAll { $0.id == meal.id }
        previousMeals.insert(meal, at: 0)

        save(previousMeals, forKey: previousMealsKey)
    }

    func isCooked(_ meal: RemoteMeal) -> Bool {
        previousMeals.contains { $0.id == meal.id }
    }

    func clearPreviousMeals() {
        previousMeals = []
        save(previousMeals, forKey: previousMealsKey)
    }

    private func load(forKey key: String) -> [RemoteMeal] {
        guard let data = defaults.data(forKey: key) else {
            return []
        }

        return (try? JSONDecoder().decode([RemoteMeal].self, from: data)) ?? []
    }

    private func save(_ meals: [RemoteMeal], forKey key: String) {
        if let data = try? JSONEncoder().encode(meals) {
            defaults.set(data, forKey: key)
        }
    }
}
