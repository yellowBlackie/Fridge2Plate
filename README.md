# Fridge2Plate

**Fridge2Plate** is an iOS application that helps users find recipes based on the ingredients they currently have available.

The main idea is simple: the user specifies the ingredients available in the fridge, and Fridge2Plate analyzes the recipe collection and displays recipes that can be prepared using those ingredients.

The project was developed as part of practical work on **Swift, iOS development, software architecture, design patterns, SOLID principles, Git, and GitHub collaboration**.

---

## Team

| Student | Group | Main Responsibilities |
| --- | --- | --- |
| Bohdana Klimenko | IP-44 | Domain models, MVVM architecture, Builder pattern |
| Nadiia Podkur | IP-41 | SwiftUI, Xcode integration, testing, Adapter pattern |
| Yevhenii Naumenko | IP-44 | Business logic, services, dependency injection, Strategy pattern, Git and documentation |

---

# Project Overview

## Domain

The application works with **ingredients** and **recipes**.

An ingredient contains information such as:

- name;
- category;
- optional calorie value.

A recipe contains:

- recipe name;
- required ingredients;
- number of servings;
- calorie-related functionality.

The application compares the ingredients available to the user with the ingredients required by recipes and determines which recipes can be prepared.

---

## Target User

The target user is a person who wants to quickly decide what to cook using products that are already available at home.

Fridge2Plate helps the user:

- view available ingredients;
- find recipes that can be prepared;
- avoid recipes requiring unavailable products;
- view basic recipe information;
- support different recipe-search strategies.

---

## Main Scenario

For the current demo, the fridge contains:

```text
Eggs
Cheese
Tomato
```

The application contains recipes such as:

```text
Omelette
- Eggs
- Cheese
- Tomato

Chicken Omelette
- Eggs
- Cheese
- Chicken
```

With the default exact-match search strategy, the result is:

```text
Omelette
```

`Chicken Omelette` is not displayed because `Chicken` is not currently available.

---

# Practical Work 1 — Swift Basics and Domain Logic

## Goal

The goal of Practical Work 1 was to create the initial iOS project, configure Git/GitHub, implement the domain model using basic Swift concepts, and demonstrate one complete application scenario.

---

## What Was Implemented

Practical Work 1 introduced the foundation of Fridge2Plate:

- Xcode project configuration;
- Git and GitHub repository;
- `.gitignore`;
- domain models;
- recipe-search business logic;
- Swift structures and classes;
- protocol and enum;
- Optional values and safe unwrapping;
- collections and collection processing;
- conditions;
- minimal SwiftUI interface;
- complete demo scenario;
- Xcode build and iOS Simulator testing.

---

## Main Domain Entities

### Ingredient

`Ingredient` represents a food product.

It contains:

- `name` — ingredient name;
- `category` — ingredient category;
- `calories` — optional calorie value.

Current implementation:

```text
Fridge2Plate/Models/Ingredient.swift
```

### Recipe

`Recipe` represents a recipe that can be prepared by the user.

It contains:

- recipe name;
- collection of required ingredients;
- number of servings;
- calorie-related methods.

Current implementation:

```text
Fridge2Plate/Models/Recipe.swift
```

### Category

`Category` is an enum that represents ingredient categories.

```text
Fridge2Plate/Models/Category.swift
```

### Displayable

`Displayable` is a protocol defining a common requirement for objects that expose a displayable name.

```text
Fridge2Plate/Models/Displayable.swift
```

---

## Swift Concepts Used

| Requirement | Implementation |
| --- | --- |
| `struct` | `Ingredient`, `Recipe` |
| `class` | `FridgeManager` |
| `protocol` | `Displayable` |
| `enum` | `Category` |
| `let` and `var` | Models, services and demo data |
| Properties | Domain models and services |
| Methods | Recipe and service methods |
| Initializers | Models, services, ViewModel and patterns |
| Collections | `[Ingredient]`, `[Recipe]`, `[String]` |
| `Optional` | Optional calorie values |
| Safe Optional handling | `guard let` / `if let` |
| Conditions | Application and demo logic |
| Collection processing | `map`, `filter`, `allSatisfy`, `ForEach` |

---

## Optional Handling

The calorie value of an ingredient is optional because calorie information may not always be available.

The application uses safe Optional handling instead of force unwrapping.

---

## Practical Work 1 Demo

The first version implemented the following scenario:

```text
Available ingredients
        ↓
FridgeManager
        ↓
Recipe filtering
        ↓
Available recipes
        ↓
SwiftUI
```

The user sees:

### My Fridge

- Eggs
- Cheese
- Tomato

### Recipes You Can Cook

- Omelette

This demonstrated a complete domain scenario from input data to visible UI output.

---

## Practical Work 1 — Team Contributions

### Bohdana — Domain Models

Implemented and worked on:

- `Ingredient`;
- `Recipe`;
- `Category`;
- `Displayable`;
- Optional calorie values;
- safe Optional handling;
- basic domain model.

### Yevhenii — Business Logic, Git and Documentation

Implemented and worked on:

- `FridgeManager`;
- recipe storage;
- recipe filtering;
- `map`, `filter`, and `allSatisfy`;
- Git/GitHub workflow;
- feature branches and Pull Requests;
- `.gitignore`;
- README documentation;
- `practical-1` tag.

### Nadiia — SwiftUI, Integration and Testing

Implemented and worked on:

- demo scenario;
- SwiftUI interface;
- integration of domain logic with `ContentView`;
- displaying fridge ingredients;
- displaying available recipes;
- Xcode build verification;
- iOS Simulator testing.

---

## Practical Work 1 Result

The first practical work resulted in a functional minimal iOS application with:

- configured Xcode project;
- domain model;
- business logic;
- SwiftUI presentation;
- Git/GitHub workflow;
- working recipe-search scenario.

The completed version is marked with the Git tag:

```text
practical-1
```

---

# Practical Work 2 — Architecture, Design Patterns and SOLID

## Goal

The goal of Practical Work 2 was to improve the initial implementation by introducing a clear architecture, separating responsibilities, applying design patterns, demonstrating SOLID principles, and making dependencies replaceable.

The application was refactored from a simple tightly connected demo into a more modular architecture.

---

# Architecture

## Selected Architecture — MVVM

The project uses **MVVM (Model–View–ViewModel)**.

MVVM was selected because:

- the application uses SwiftUI;
- UI state can be managed through `ObservableObject` and `@Published`;
- presentation logic can be separated from SwiftUI views;
- business and data-related logic can be tested independently from the UI;
- the project is not complex enough to justify a heavier architecture such as VIPER.

### MVVM Responsibilities

**Model**

Represents domain data:

- `Ingredient`;
- `Recipe`;
- `Category`.

**View**

Responsible only for displaying data and user-facing UI:

- `ContentView`.

**ViewModel**

Stores presentation state and communicates with the service abstraction:

- `FridgeViewModel`.

**Services**

Provide recipe-related operations and business functionality:

- `RecipeServiceProtocol`;
- `RecipeService`;
- `MockRecipeService`;
- `FridgeManager`.

---

## Component Interaction Scheme

```text
┌──────────────────────┐
│     ContentView      │
│        View          │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   FridgeViewModel    │
│      ViewModel       │
└──────────┬───────────┘
           │
           │ depends on abstraction
           ▼
┌──────────────────────────┐
│  RecipeServiceProtocol   │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────┐
│    RecipeService     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│    FridgeManager     │
└──────────┬───────────┘
           │
           │ delegates algorithm
           ▼
┌──────────────────────────┐
│ RecipeSearchStrategy     │
└────────────┬─────────────┘
             │
       ┌─────┴─────────┐
       ▼               ▼
 ExactMatch       MissingIngredients
 Strategy             Strategy
```

The application dependencies are assembled in:

```text
Fridge2Plate/Fridge2PlateApp.swift
```

This file acts as the **composition root** of the application.

---

## Architecture Limitations

MVVM works well for the current size of Fridge2Plate, but it also has limitations:

- ViewModels can become too large in bigger applications;
- additional navigation and coordination abstractions may be required as the project grows;
- complex applications may require more layers, repositories, coordinators, or use cases.

For the current project, MVVM provides sufficient separation without unnecessary architectural complexity.

---

# Design Patterns

Practical Work 2 requires patterns from three categories:

| Category | Pattern | Component |
| --- | --- | --- |
| Creational | Builder | `RecipeBuilder` |
| Structural | Adapter | `RecipeAdapter` |
| Behavioral | Strategy | `RecipeSearchStrategy` |

---

## 1. Creational Pattern — Builder

### Problem

Creating a recipe may require setting multiple values and adding several ingredients.

Direct initialization can become difficult to read as the number of configuration parameters grows.

### Solution

`RecipeBuilder` provides a step-by-step interface for constructing a `Recipe`.

Example:

```swift
let omelette = RecipeBuilder()
    .setName("Omelette")
    .addIngredient(eggs)
    .addIngredient(cheese)
    .addIngredient(tomato)
    .setBaseServings(1)
    .build()
```

### Participants

- **Builder:** `RecipeBuilder`
- **Product:** `Recipe`
- **Client:** `Fridge2PlateApp`

### Purpose

Builder separates complex object construction from the final `Recipe` representation and provides a readable fluent interface.

Implemented in:

```text
Fridge2Plate/Patterns/Builder/RecipeBuilder.swift
```

---

## 2. Structural Pattern — Adapter

### Problem

An external or legacy recipe representation may use a structure incompatible with the application's internal `Recipe` model.

For example:

```text
LegacyRecipe          Recipe

title          →      name
items          →      ingredients
portions       →      baseServings
```

The rest of the application should not need to understand or depend on the legacy representation.

### Solution

`RecipeAdapter` converts `LegacyRecipe` into the internal `Recipe` model.

Conceptually:

```text
LegacyRecipe
     │
     ▼
RecipeAdapter
     │
     ▼
Recipe
```

### Participants

- **Adaptee:** `LegacyRecipe`
- **Adapter:** `RecipeAdapter`
- **Target representation:** `Recipe`
- **Client:** application composition in `Fridge2PlateApp`

### Purpose

Adapter allows an incompatible recipe representation to be integrated without changing the existing recipe-processing logic.

Implemented in:

```text
Fridge2Plate/Patterns/Adapter/LegacyRecipe.swift
Fridge2Plate/Patterns/Adapter/RecipeAdapter.swift
```

---

## 3. Behavioral Pattern — Strategy

### Problem

Recipe filtering may require different algorithms.

For example:

1. show only recipes for which every ingredient is available;
2. show recipes that are missing no more than one ingredient.

Putting every algorithm directly inside `FridgeManager` would increase its responsibility and require modifying it whenever a new search algorithm is introduced.

### Solution

The project defines:

```text
RecipeSearchStrategy
```

with multiple implementations:

```text
ExactMatchStrategy
MissingIngredientsStrategy
```

`FridgeManager` delegates recipe filtering to the selected strategy.

### ExactMatchStrategy

Returns recipes only when all required ingredients are available.

```text
Eggs + Cheese + Tomato
        ↓
ExactMatchStrategy
        ↓
Omelette
```

### MissingIngredientsStrategy

Can return recipes even when a configured number of ingredients is missing.

For example:

```text
Eggs + Cheese + Tomato
        ↓
MissingIngredientsStrategy
        ↓
Omelette
Chicken Omelette
```

when one missing ingredient is allowed.

### Participants

- **Strategy:** `RecipeSearchStrategy`
- **Concrete Strategy:** `ExactMatchStrategy`
- **Concrete Strategy:** `MissingIngredientsStrategy`
- **Context:** `FridgeManager`

### Purpose

Strategy allows the recipe-search algorithm to change independently from `FridgeManager`.

Implemented in:

```text
Fridge2Plate/Patterns/Strategy/RecipeSearchStrategy.swift
Fridge2Plate/Patterns/Strategy/ExactMatchStrategy.swift
Fridge2Plate/Patterns/Strategy/MissingIngredientsStrategy.swift
```

---

# Dependency Injection

`FridgeViewModel` does not create its service internally.

Instead, the dependency is passed through its initializer:

```swift
init(recipeService: RecipeServiceProtocol) {
    self.recipeService = recipeService
}
```

This is **initializer-based Dependency Injection**.

The actual dependency is assembled externally in `Fridge2PlateApp`.

```text
Fridge2PlateApp
       │
       ▼
RecipeService
       │
       ▼
FridgeViewModel
```

This makes the ViewModel easier to test and prevents it from being tightly coupled to one concrete service implementation.

---

# Real and Mock Service Substitution

The project defines the abstraction:

```text
RecipeServiceProtocol
```

and two implementations:

```text
RecipeService
MockRecipeService
```

Therefore:

```text
                  RecipeService
                       │
                       ▼
FridgeViewModel → RecipeServiceProtocol
                       ▲
                       │
                MockRecipeService
```

The production application can use:

```swift
let recipeService = RecipeService(
    fridgeManager: fridgeManager
)

let viewModel = FridgeViewModel(
    recipeService: recipeService
)
```

For testing or demonstration, it can instead receive:

```swift
let mockService = MockRecipeService(
    recipes: [omelette]
)

let viewModel = FridgeViewModel(
    recipeService: mockService
)
```

No changes inside `FridgeViewModel` are required.

---

# Dependency Injection vs Dependency Inversion

These concepts are related but are not the same.

### Dependency Injection

Dependency Injection is a **technique** for providing an object's dependencies from outside.

Example:

```swift
init(recipeService: RecipeServiceProtocol)
```

`FridgeViewModel` receives its dependency instead of constructing it internally.

### Dependency Inversion Principle

Dependency Inversion is a **design principle** stating that high-level modules should depend on abstractions rather than concrete low-level implementations.

In Fridge2Plate:

```text
FridgeViewModel
       ↓
RecipeServiceProtocol
       ↑
RecipeService / MockRecipeService
```

The ViewModel depends on the protocol rather than directly on `RecipeService`.

---

# SOLID Principles

## S — Single Responsibility Principle

Each component has a focused responsibility.

| Component | Responsibility |
| --- | --- |
| `ContentView` | Display UI |
| `FridgeViewModel` | Presentation state and communication with service |
| `RecipeService` | Recipe service operations |
| `FridgeManager` | Manage recipes and delegate searching |
| `RecipeBuilder` | Construct recipes |
| `RecipeAdapter` | Convert legacy recipes |
| Search strategies | Implement individual search algorithms |

This avoids placing UI, data creation, filtering, and state management in one class.

---

## O — Open/Closed Principle

Software entities should be open for extension but closed for unnecessary modification.

`RecipeSearchStrategy` demonstrates this principle.

A new algorithm can be added:

```text
CalorieLimitStrategy
FavoriteRecipeStrategy
FastRecipeStrategy
```

without changing the existing `ExactMatchStrategy` or `MissingIngredientsStrategy`.

`FridgeManager` can work with any implementation of `RecipeSearchStrategy`.

---

## L — Liskov Substitution Principle

Implementations of an abstraction should be usable wherever that abstraction is expected.

`FridgeViewModel` accepts:

```text
RecipeServiceProtocol
```

Therefore both:

```text
RecipeService
MockRecipeService
```

can be supplied without changing the ViewModel.

The same concept applies to implementations of `RecipeSearchStrategy`.

---

## I — Interface Segregation Principle

Protocols should remain focused instead of forcing clients to depend on functionality they do not use.

The project uses small protocols:

```text
RecipeServiceProtocol
RecipeSearchStrategy
Displayable
```

Each protocol describes a specific responsibility.

For example, `FridgeViewModel` depends only on the recipe-search functionality it requires.

---

## D — Dependency Inversion Principle

High-level modules depend on abstractions instead of concrete implementations.

Instead of:

```text
FridgeViewModel → RecipeService
```

the project uses:

```text
FridgeViewModel → RecipeServiceProtocol ← RecipeService
                                      ← MockRecipeService
```

This reduces coupling and enables dependency substitution.

---

# Anti-Patterns and Improvements

## Excessive Responsibility / God Object

### Before

In the initial implementation, `ContentView` was responsible for several tasks:

- creating ingredients;
- creating recipes;
- creating `FridgeManager`;
- running recipe filtering;
- storing presentation data;
- displaying the UI.

This mixed several responsibilities in one component.

### After

Practical Work 2 separates these responsibilities between:

```text
View
ViewModel
Services
Models
Patterns
Composition Root
```

---

## Direct UI–Business Logic Coupling

### Before

`ContentView` directly communicated with business logic and created its dependencies.

### After

The interaction is:

```text
ContentView
     ↓
FridgeViewModel
     ↓
RecipeServiceProtocol
     ↓
Business Logic
```

The View no longer needs to know how recipes are searched.

---

## Hidden Global Dependencies

The project avoids global singleton services.

Dependencies are explicitly created and passed through initializers.

This makes dependencies visible and replaceable.

---

## Duplication

Recipe-search algorithms are isolated in Strategy implementations rather than duplicated across UI or service classes.

Object creation and legacy conversion are also centralized in their corresponding Builder and Adapter components.

---

# Pattern and SOLID Mapping

| Type | Pattern / Principle | Component | Purpose |
| --- | --- | --- | --- |
| Architecture | MVVM | `ContentView`, `FridgeViewModel`, Models | Separate UI, presentation state and domain data |
| Creational | Builder | `RecipeBuilder` | Step-by-step creation of recipes |
| Structural | Adapter | `RecipeAdapter` | Convert incompatible recipe representations |
| Behavioral | Strategy | `RecipeSearchStrategy` | Support interchangeable search algorithms |
| SOLID | SRP | Views, ViewModel, Services, Patterns | Separate responsibilities |
| SOLID | OCP | `RecipeSearchStrategy` | Add search algorithms without changing existing ones |
| SOLID | LSP | `RecipeServiceProtocol` implementations | Substitute real and mock services |
| SOLID | ISP | Small focused protocols | Avoid unnecessary dependencies |
| SOLID | DIP | `FridgeViewModel → RecipeServiceProtocol` | Depend on abstraction |
| Technique | Dependency Injection | `FridgeViewModel.init` | Supply service from outside |

---

# Current Project Structure

```text
Fridge2Plate/
├── Models/
│   ├── Category.swift
│   ├── Displayable.swift
│   ├── Ingredient.swift
│   └── Recipe.swift
│
├── Views/
│   └── ContentView.swift
│
├── ViewModels/
│   └── FridgeViewModel.swift
│
├── Services/
│   ├── FridgeManager.swift
│   ├── RecipeServiceProtocol.swift
│   ├── RecipeService.swift
│   └── MockRecipeService.swift
│
├── Patterns/
│   ├── Builder/
│   │   └── RecipeBuilder.swift
│   │
│   ├── Adapter/
│   │   ├── LegacyRecipe.swift
│   │   └── RecipeAdapter.swift
│   │
│   └── Strategy/
│       ├── RecipeSearchStrategy.swift
│       ├── ExactMatchStrategy.swift
│       └── MissingIngredientsStrategy.swift
│
├── Assets.xcassets/
└── Fridge2PlateApp.swift
```

---

# Practical Work 2 — Team Contributions

## Bohdana — MVVM and Builder

Responsible for:

- reorganizing the project into architecture-related folders;
- introducing the MVVM architecture;
- implementing `FridgeViewModel`;
- separating View and ViewModel responsibilities;
- implementing the creational `RecipeBuilder` pattern.

Relevant commits include:

```text
Create MVVM architecture skeleton
Add Recipe Builder pattern
```

---

## Yevhenii — Services, DI, Strategy and SOLID

Responsible for:

- `RecipeServiceProtocol`;
- `RecipeService`;
- `MockRecipeService`;
- Dependency Injection;
- Dependency Inversion;
- service substitution;
- `RecipeSearchStrategy`;
- `ExactMatchStrategy`;
- `MissingIngredientsStrategy`;
- integration of Strategy with `FridgeManager`;
- SOLID and architecture documentation.

Relevant commits include:

```text
Add recipe service abstraction and dependency injection
Add mock recipe service for dependency substitution
Add recipe search Strategy pattern
```

---

## Nadiia — Adapter, Xcode Integration and Testing

Responsible for:

- `LegacyRecipe`;
- `RecipeAdapter`;
- integration of Adapter into the application;
- verifying the complete project in Xcode;
- building the project;
- running the application in iOS Simulator;
- checking that the existing scenario continues to work after architectural changes.

Relevant commit:

```text
Add Recipe Adapter pattern
```

---

# How to Run

## Requirements

- macOS
- Xcode
- iOS Simulator

## Steps

1. Clone the repository.
2. Open:

```text
Fridge2Plate.xcodeproj
```

3. Select an iPhone Simulator.
4. Build using:

```text
Command + B
```

5. Run using:

```text
Command + R
```

---

# How to Verify the Demo Scenario

After launching the application, the **My Fridge** section should contain:

```text
Eggs
Cheese
Tomato
```

The **Recipes You Can Cook** section should contain:

```text
Omelette
3 ingredients
```

`Chicken Omelette` should not appear with `ExactMatchStrategy`, because `Chicken` is not available.

This verifies the complete chain:

```text
SwiftUI View
     ↓
FridgeViewModel
     ↓
RecipeServiceProtocol
     ↓
RecipeService
     ↓
FridgeManager
     ↓
ExactMatchStrategy
     ↓
Recipe result
```

The application was successfully built and tested using an iOS Simulator.

---

# Testing Business Logic Separately from UI

The architecture allows business logic to be tested without SwiftUI.

For example, `FridgeViewModel` can receive `MockRecipeService`:

```swift
let mockService = MockRecipeService(
    recipes: [omelette]
)

let viewModel = FridgeViewModel(
    recipeService: mockService
)
```

The ViewModel can then be tested without:

- `ContentView`;
- iOS Simulator;
- real recipe service implementation.

Search algorithms can also be tested independently by creating a concrete `RecipeSearchStrategy` and passing recipe/ingredient collections directly to it.

---

# Git Workflow

Development uses:

- feature branches;
- separate commits for logical stages;
- Pull Requests;
- `main` as the integrated project branch;
- `.gitignore`;
- tags for completed practical works.

Main Practical Work 2 branches:

```text
feature/mvvm-architecture
feature/service-strategy
feature/adapter-integration
```

Important architecture stages were intentionally stored as separate commits.

---

# Practical Work Versions

## Practical Work 1

Focus:

```text
Swift basics
Domain models
Collections
Optional
Business logic
SwiftUI demo
Git/GitHub
```

Final tag:

```text
practical-1
```

## Practical Work 2

Focus:

```text
MVVM
Architecture separation
Builder
Adapter
Strategy
SOLID
Dependency Injection
Dependency Inversion
Mock dependency substitution
Anti-pattern prevention
```

Final tag:

```text
practical-2
```

---

# Defense Topics

The project demonstrates the material required for defense:

- why MVVM was selected;
- advantages and limitations of MVVM;
- difference between architecture and a design pattern;
- problem solved by Builder;
- problem solved by Adapter;
- problem solved by Strategy;
- Single Responsibility Principle;
- Open/Closed Principle;
- Liskov Substitution Principle;
- Interface Segregation Principle;
- Dependency Inversion Principle;
- difference between Dependency Injection and Dependency Inversion;
- dependency substitution using `MockRecipeService`;
- testing business logic independently from SwiftUI and real services.

---

# Summary

Fridge2Plate evolved through two practical works.

**Practical Work 1** established the application foundation:

```text
Swift + Domain Model + Business Logic + SwiftUI + Git
```

**Practical Work 2** reorganized that implementation into a modular architecture:

```text
MVVM
  +
Builder
  +
Adapter
  +
Strategy
  +
SOLID
  +
Dependency Injection
```

The result is a small but structured iOS application in which presentation, business logic, object creation, data adaptation, and search algorithms have clearly separated responsibilities.
