
import Foundation
import Combine

final class FridgeViewModel: ObservableObject {

    @Published var availableIngredients: [String]
    @Published var availableRecipes: [Recipe] = []
    @Published private(set) var selectedIngredients: Set<String> = []

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService

        self.availableIngredients = [
            "Eggs",
            "Cheese",
            "Tomato"
        ]

        findAvailableRecipes()
    }

    func findAvailableRecipes() {
        availableRecipes = recipeService.findRecipes(
            with: availableIngredients
        )
    }

    @discardableResult
    func addIngredient(_ name: String) -> Bool {

        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            return false
        }

        let alreadyExists = availableIngredients.contains {
            $0.lowercased() == trimmedName.lowercased()
        }

        guard !alreadyExists else {
            return false
        }

        availableIngredients.append(trimmedName)

        findAvailableRecipes()

        return true
    }

    
    @discardableResult
    func removeIngredient(_ name: String) -> Bool {

        guard let index = availableIngredients.firstIndex(
            where: {
                $0.caseInsensitiveCompare(name) == .orderedSame
            }
        ) else {
            return false
        }

        let removed = availableIngredients.remove(at: index)
        selectedIngredients.remove(removed)

        findAvailableRecipes()

        return true
    }

    func isSelected(_ ingredient: String) -> Bool {
        selectedIngredients.contains(ingredient)
    }

    func toggleSelection(_ ingredient: String) {
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
    }

    func selectAll() {
        selectedIngredients = Set(availableIngredients)
    }

    func clearSelection() {
        selectedIngredients = []
    }

    /// Selected ingredients in the same order as in the fridge.
    var orderedSelection: [String] {
        availableIngredients.filter { selectedIngredients.contains($0) }
    }

    /// Local recipes that only use the given ingredients.
    func localRecipes(using ingredients: [String]) -> [Recipe] {
        recipeService.findRecipes(with: ingredients)
    }
}
