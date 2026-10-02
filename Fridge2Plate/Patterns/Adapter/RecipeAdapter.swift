//
//  RecipeAdapter.swift
//  Fridge2Plate
//
//  Created by Nadia on 02.10.2026.
//

import Foundation
final class RecipeAdapter {
func adapt(_ legacyRecipe: LegacyRecipe) -> Recipe {
    Recipe(
        name: legacyRecipe.title,
        ingredients: legacyRecipe.items,
        baseServings: legacyRecipe.portions
    )
}
}
