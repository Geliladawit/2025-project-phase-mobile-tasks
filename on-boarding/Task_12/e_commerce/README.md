# eCommerce Mobile App

A Flutter application built using **Clean Architecture** and **TDD** (Test Driven Development) principles. This project demonstrates a scalable structure for managing product data, with a strong focus on defining strict contracts for data retrieval.

## 🏗 Architecture Overview

The project follows the "Feature-First" Clean Architecture pattern, dividing the code into three main layers:

### 1. Domain Layer (Inner Layer)
The core business logic, independent of external libraries.
*   **Entities:** Pure Dart classes describing business objects (e.g., `Product`).
*   **Use Cases:** Encapsulate specific business rules (e.g., `GetProduct`).
*   **Repositories (Interfaces):** Abstract contracts defining *what* data operations are possible.

### 2. Data Layer (Middle Layer)
Handles data retrieval, caching, and transformation.
*   **Models:** Subclasses of Entities handling JSON serialization (`ProductModel`).
*   **Data Sources (Contracts):** Interfaces defining the boundary between the app and external data.
    *   `RemoteDataSource`: Contract for API interaction.
    *   `LocalDataSource`: Contract for local caching (DB/SharedPrefs).
*   **Repositories (Implementations):** The "Brain" of the data layer. It coordinates between Remote and Local sources based on network connectivity.

### 3. Presentation Layer (Outer Layer)
Handles UI and User Input.
*   **Pages/Screens:** The widgets user sees (e.g., `HomeScreen`).
*   **Widgets:** Reusable UI components.

## 📜 Task 11: Data Contracts

This version of the app introduces strict **Interfaces** for data handling to ensure testability and separation of concerns:

1.  **ProductRemoteDataSource:** Defines methods to interact with the backend API (returns `ProductModel`, throws `ServerException`).
2.  **ProductLocalDataSource:** Defines methods to cache data locally for offline support (throws `CacheException`).
3.  **NetworkInfo:** A core contract to determine device connectivity status.

## 🔄 Data Flow

When a user requests data (e.g., "View All Products"):

1.  **UI:** Calls the `ViewAllProductsUsecase`.
2.  **Domain:** UseCase calls the `ProductRepository` interface.
3.  **Data (Repository Impl):**
    *   Checks `NetworkInfo` to see if the device is online.
    *   **If Online:** Calls `RemoteDataSource` to fetch fresh data -> Caches it in `LocalDataSource` -> Returns data.
    *   **If Offline:** Calls `LocalDataSource` to retrieve the last cached data.
4.  **Data:** `ProductModel` is converted to a `Product` entity.
5.  **UI:** The screen updates with the returned Entity.

## 📂 Folder Structure

```text
lib/
├── core/
│   ├── error/                   # Custom Exceptions & Failures
│   ├── network/                 # NetworkInfo Contract
│   └── usecases/                # Base UseCase definition
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/     # [NEW] Remote & Local Data Source Contracts
│       │   ├── models/          # Data Models (JSON parsing)
│       │   └── repositories/    # Repository Implementation (Logic)
│       ├── domain/
│       │   ├── entities/        # Core Entities
│       │   ├── repositories/    # Repository Interfaces
│       │   └── usecases/        # Business Logic classes
│       └── presentation/        # UI Screens & Widgets
└── main.dart                    # Entry point