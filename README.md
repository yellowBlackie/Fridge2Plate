# Fridge2Plate

Fridge2Plate is an iOS application that helps users find recipes based on the ingredients they currently have available.

The main idea of the application is simple: the user specifies the ingredients available in their fridge, and Fridge2Plate checks the recipe collection and displays the recipes that can be prepared using those ingredients.

Created By IP-44 Klimenko Bogdana, IP-41 Podkur Nadiia, IP-44 Naumenko Evgeniy

## Practical Work 1 — Team Contributions

Practical Work 1 was completed collaboratively by three team members. Responsibilities were divided between domain modeling, business logic, version control, UI implementation, and testing.

### Bohdana — Domain Models

Bohdana was responsible for the domain model and the main entities of the application.

Implemented and worked on:

- `Ingredient` model;
- `Recipe` model;
- `Category` enum;
- `Displayable` protocol;
- Optional calorie values and their safe handling;
- basic structure of the Fridge2Plate domain model.

Main files:

- `Fridge2Plate/Ingredient.swift`
- `Fridge2Plate/Recipe.swift`
- `Fridge2Plate/Category.swift`
- `Fridge2Plate/Displayable.swift`

### Yevhenii — Business Logic, Git and Documentation

Yevhenii was responsible for the main recipe-search logic, repository organization, and project documentation.

Implemented and worked on:

- `FridgeManager`;
- adding and storing recipes;
- recipe filtering based on available ingredients;
- collection processing using `map`, `filter`, and `allSatisfy`;
- Git and GitHub repository configuration;
- feature branches and Pull Requests;
- `.gitignore`;
- project documentation in `README.md`;
- final `practical-1` tag.

Main file:

- `Fridge2Plate/FridgeManager.swift`

### Nadia — SwiftUI, Integration and Testing

Nadia was responsible for the demonstration scenario, SwiftUI integration, and testing the application in Xcode.

Implemented and worked on:

- demo scenario for Fridge2Plate;
- integration of the domain logic with `ContentView`;
- minimal SwiftUI interface;
- displaying available fridge ingredients;
- displaying recipes that can be prepared;
- Xcode project build and run verification;
- testing the application using iOS Simulator.

Main files:

- `Fridge2Plate/ContentView.swift`
- `Fridge2Plate/Fridge2PlateApp.swift`

### Team Result

As a result of the shared work, Practical Work 1 includes:

- configured Xcode project;
- Git and GitHub workflow;
- domain models;
- recipe-search business logic;
- Swift language concepts required by the assignment;
- completed Fridge2Plate demo scenario;
- minimal SwiftUI interface;
- project documentation;
- final version marked with the `practical-1` Git tag.

## Domain

The application works with ingredients and recipes.

Each ingredient contains information such as its name, category, and optional calorie value. A recipe contains a collection of ingredients required for its preparation.

The application compares the ingredients available to the user with the ingredients required by each recipe and returns only recipes that can be prepared.

## Target User

The target user is a person who wants to quickly decide what to cook using products that are already available at home.

Fridge2Plate can help the user:

- see which ingredients are currently available;
- find recipes that can be prepared from those ingredients;
- avoid selecting recipes that require unavailable products;
- view basic information about available recipes.

## Main Scenarios

### 1. View available ingredients

The user can see the ingredients currently available in the fridge.

Example:

- Eggs
- Cheese
- Tomato

### 2. Find available recipes

The application compares the available ingredients with the ingredients required by recipes.

For example, if the fridge contains:

- Eggs
- Cheese
- Tomato

and the application contains the recipes:

- Omelette — Eggs, Cheese, Tomato
- Chicken Omelette — Eggs, Cheese, Chicken

the result will contain only:

- Omelette

Chicken Omelette is not displayed because Chicken is not available.

## Main Entities

### Ingredient

`Ingredient` represents a food product.

It contains:

- `name` — ingredient name;
- `category` — ingredient category;
- `calories` — optional calorie value.

Implemented in:

`Fridge2Plate/Ingredient.swift`

### Recipe

`Recipe` represents a recipe that can be prepared by the user.

It contains:

- recipe name;
- collection of required ingredients;
- number of servings;
- methods related to calorie calculation.

Implemented in:

`Fridge2Plate/Recipe.swift`

## FridgeManager

`FridgeManager` contains the main recipe-search logic.

It stores a collection of recipes and provides methods for:

- adding recipes;
- searching for recipes;
- filtering recipes based on available ingredients.

The `findRecipes(with:)` method uses collection operations to determine whether all required ingredients of a recipe are available.

Implemented in:

`Fridge2Plate/FridgeManager.swift`

## Swift Concepts Used

The project demonstrates the main Swift concepts required for Practical Work 1.

| Requirement | Implementation |
| --- | --- |
| `struct` | `Ingredient`, `Recipe` |
| `class` | `FridgeManager` |
| `protocol` | `Displayable` |
| `enum` | `Category` |
| `let` and `var` | Used in models, manager and demo scenario |
| Properties | Used in `Ingredient`, `Recipe`, `FridgeManager` |
| Methods | Recipe methods and `FridgeManager` methods |
| Initializers | Implemented for the domain models and manager |
| Collections | `[Ingredient]`, `[Recipe]`, `[String]` |
| `Optional` | Optional calorie value |
| Safe Optional handling | `guard let` / `if let` |
| Conditions | `if` / `else` in the demo scenario |
| Collection processing | `map`, `filter`, `allSatisfy`, `ForEach` |

## Protocol

The `Displayable` protocol defines a common requirement for objects that can expose a displayable name.

Implemented in:

`Fridge2Plate/Displayable.swift`

## Enum

`Category` represents the available ingredient categories.

Implemented in:

`Fridge2Plate/Category.swift`

## Optional

The calorie value of an ingredient is optional.

This demonstrates that some ingredients may not have calorie information available.

The project uses safe Optional handling instead of force unwrapping.

## Demo Scenario

A complete domain scenario is implemented in:

`Fridge2Plate/ContentView.swift`

The demo creates several ingredients and recipes.

Available ingredients:

- Eggs
- Cheese
- Tomato

Example recipes:

- Omelette
- Chicken Omelette

The application uses `FridgeManager` to filter the recipes.

Because Chicken is not available, only Omelette is displayed.

The result is shown in the SwiftUI interface and is also printed to the Xcode console.

## User Interface

The application contains a minimal SwiftUI interface.

The main screen contains two sections:

### My Fridge

Displays the ingredients available to the user.

### Recipes You Can Cook

Displays recipes that can be prepared using the currently available ingredients.

A complete production UI is outside the scope of Practical Work 1. The current interface is used to demonstrate the implemented domain scenario.

## How to Run

Requirements:

- macOS
- Xcode
- iOS Simulator

Steps:

1. Clone the repository.
2. Open `Fridge2Plate.xcodeproj` in Xcode.
3. Select an iPhone Simulator.
4. Build the project using `Command + B`.
5. Run the application using `Command + R`.

The application should display the Fridge2Plate screen with available ingredients and recipes.

## How to Test the Demo Scenario

After launching the application, verify that the **My Fridge** section contains:

- Eggs
- Cheese
- Tomato

The **Recipes You Can Cook** section should contain:

- Omelette

Chicken Omelette should not appear because Chicken is not included in the available ingredients.

The Xcode console also displays information about the demo scenario and recipe filtering.

## Project Structure

```text
Fridge2Plate
├── Category.swift
├── ContentView.swift
├── Displayable.swift
├── Fridge2PlateApp.swift
├── FridgeManager.swift
├── Ingredient.swift
└── Recipe.swift
```

## Git Workflow

Development is performed using Git and GitHub.

The project uses:

- separate feature branches;
- commits for individual changes;
- Pull Requests for merging changes into `main`;
- `.gitignore` for excluding files that should not be tracked.

Examples of development branches:

- `feature/models`
- `feature/fridge-manager`
- `feature/demo-scenario`

## Practical Work 1

This repository contains the implementation for Practical Work 1.

The project demonstrates:

- creation and configuration of an iOS project;
- Git and GitHub workflow;
- Swift structures and classes;
- protocols and enums;
- Optional values and safe unwrapping;
- collections and collection processing;
- conditions;
- a completed domain scenario;
- a minimal SwiftUI interface.
