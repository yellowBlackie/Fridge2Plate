import Foundation

struct RemoteIngredient: Hashable, Codable {
    let name: String
    let measure: String

    var imageURL: URL? {
        guard let encoded = name.addingPercentEncoding(
            withAllowedCharacters: .urlPathAllowed
        ) else {
            return nil
        }

        return URL(
            string: "https://www.themealdb.com/images/ingredients/\(encoded)-small.png"
        )
    }
}

struct RemoteMeal: Codable, Identifiable, Hashable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let ingredients: [RemoteIngredient]

    var id: String {
        idMeal
    }

    init(
        idMeal: String,
        strMeal: String,
        strMealThumb: String?,
        strCategory: String? = nil,
        strArea: String? = nil,
        strInstructions: String? = nil,
        ingredients: [RemoteIngredient] = []
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.ingredients = ingredients
    }

    // TheMealDB returns ingredients as flat fields:
    // strIngredient1...strIngredient20 and strMeasure1...strMeasure20.
    private struct DynamicKey: CodingKey {
        let stringValue: String
        let intValue: Int? = nil

        init(_ stringValue: String) {
            self.stringValue = stringValue
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)

        idMeal = try container.decode(String.self, forKey: DynamicKey("idMeal"))
        strMeal = try container.decode(String.self, forKey: DynamicKey("strMeal"))
        strMealThumb = try container.decodeIfPresent(String.self, forKey: DynamicKey("strMealThumb"))
        strCategory = try container.decodeIfPresent(String.self, forKey: DynamicKey("strCategory"))
        strArea = try container.decodeIfPresent(String.self, forKey: DynamicKey("strArea"))
        strInstructions = try container.decodeIfPresent(String.self, forKey: DynamicKey("strInstructions"))

        var ingredients: [RemoteIngredient] = []

        for index in 1...20 {
            let name = try container.decodeIfPresent(
                String.self,
                forKey: DynamicKey("strIngredient\(index)")
            )?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard !name.isEmpty else {
                continue
            }

            let measure = try container.decodeIfPresent(
                String.self,
                forKey: DynamicKey("strMeasure\(index)")
            )?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            ingredients.append(
                RemoteIngredient(name: name, measure: measure)
            )
        }

        self.ingredients = ingredients
    }

    // Encodes back into the same flat TheMealDB format,
    // so saved meals can be decoded with init(from:).
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)

        try container.encode(idMeal, forKey: DynamicKey("idMeal"))
        try container.encode(strMeal, forKey: DynamicKey("strMeal"))
        try container.encodeIfPresent(strMealThumb, forKey: DynamicKey("strMealThumb"))
        try container.encodeIfPresent(strCategory, forKey: DynamicKey("strCategory"))
        try container.encodeIfPresent(strArea, forKey: DynamicKey("strArea"))
        try container.encodeIfPresent(strInstructions, forKey: DynamicKey("strInstructions"))

        for (offset, ingredient) in ingredients.prefix(20).enumerated() {
            try container.encode(ingredient.name, forKey: DynamicKey("strIngredient\(offset + 1)"))
            try container.encode(ingredient.measure, forKey: DynamicKey("strMeasure\(offset + 1)"))
        }
    }
}

extension RemoteIngredient {

    /// TheMealDB ingredient photo for any ingredient name.
    static func imageURL(for name: String) -> URL? {
        RemoteIngredient(name: name, measure: "").imageURL
    }
}

struct MealSearchResponse: Decodable {
    let meals: [RemoteMeal]?
}
