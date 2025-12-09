# eCommerce Mobile App

A Flutter application built using **Clean Architecture** and **TDD** (Test Driven Development) principles. This project demonstrates a scalable structure for managing product data.

## 🏗 Architecture Overview

The project follows the "Feature-First" Clean Architecture pattern, dividing the code into three main layers:

### 1. Domain Layer (Inner Layer)
This is the core of the application. It is independent of any external libraries or UI.
*   **Entities:** Pure Dart classes describing the core business objects (e.g., `Product`).
*   **Use Cases:** Encapsulate specific business rules (e.g., `GetProduct`, `CreateProduct`).
*   **Repositories (Interfaces):** Abstract definitions (contracts) of how data should be retrieved.

### 2. Data Layer (Middle Layer)
This layer handles data retrieval and transformation.
*   **Models:** Subclasses of Entities that handle JSON serialization/deserialization (`ProductModel`).
*   **Repositories (Implementations):** The actual code that fetches data (from API, Database, or Mock Data) and returns it as Domain Entities.

### 3. Presentation Layer (Outer Layer)
This layer handles the UI and User Input.
*   **Pages/Screens:** The widgets user sees (e.g., `HomeScreen`, `ProductDetailScreen`).
*   **Widgets:** Reusable UI components (e.g., `ProductCard`).

## 🔄 Data Flow

When a user interacts with the app (e.g., opens the Home Screen), the data flows as follows:

1.  **UI:** `HomeScreen` calls the `ViewAllProductsUsecase`.
2.  **Domain:** The UseCase requests data from the `ProductRepository` interface.
3.  **Data:** The `ProductRepositoryImpl` fetches raw JSON data (simulated or from API).
4.  **Data:** The `ProductModel.fromJson()` converts raw JSON into a Dart Object.
5.  **Domain:** The Repository returns the data as a `Product` Entity to the UseCase.
6.  **UI:** The UseCase returns the Entity to the `HomeScreen`, which updates the state.

## 📂 Folder Structure

```text
lib/
├── core/                # Shared utilities (Errors, Base UseCase)
├── features/
│   └── product/         # Product Feature Module
│       ├── data/        # Models & Repository Implementation
│       ├── domain/      # Entities, Use Cases & Repository Interfaces
│       └── presentation/# UI Screens & Widgets
└── main.dart            # Entry point