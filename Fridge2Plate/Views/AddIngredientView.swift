import SwiftUI

struct AddIngredientView: View {

    let onSave: (String) -> Bool
    let onDismiss: () -> Void

    @State private var ingredientName = ""
    @State private var errorMessage: String?

    @FocusState private var isNameFocused: Bool

    var body: some View {
        Form {
            Section("Ingredient") {
                TextField(
                    "e.g. Chicken",
                    text: $ingredientName
                )
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($isNameFocused)
                .onSubmit(saveIngredient)
            }

            Section {
                Text("Enter an ingredient to add it to your fridge.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .accessibilityAddTraits(.updatesFrequently)
                }
            }
        }
        .navigationTitle("Add Ingredient")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onDismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveIngredient()
                }
                .disabled(
                    ingredientName.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    isNameFocused = false
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func saveIngredient() {
        let success = onSave(ingredientName)

        if success { isNameFocused = false
            onDismiss()
        } else {
            errorMessage = "Ingredient is empty or already exists."
        }
    }
}
