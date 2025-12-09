# Domain Layer Implementation (Entities, Use Cases, Repositories)

This module implements the **Domain Layer** for the eCommerce Mobile App, adhering to **Clean Architecture** principles. It establishes the core business logic, decoupled from the User Interface and Data sources, facilitating Test-Driven Development (TDD).

## 📋 Task Overview

The objective of this task is to set up the foundational structures for product management, including:
1.  **Entities:** The core business objects.
2.  **Repositories:** Abstract definitions of data operations.
3.  **Use Cases:** Encapsulated business rules for CRUD operations.

## 🏗 Architecture

This project follows **Clean Architecture**. The code implemented here belongs to the innermost circle (Domain), which is purely Dart code and has **zero dependencies** on Flutter UI, APIs, or Databases.

### Dependencies
To handle value equality and functional error handling, the following packages are used:
*   `equatable`: For easy value comparison in Entities and Params.
*   `dartz`: For functional programming (specifically `Either<Failure, Success>` return types).

## 📂 Project Structure

The folder structure is organized by layer (`domain`).

```text
lib/
├── core/
│   └──  injection.dart              # Dependency Injection Container
├──  data/
│       └── repositories/
│               └── product_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product.dart
│       │   ├── repositories/
│       │   │   └── product_repo.dart
│       │   └── usecases/
│       │       ├── create_product.dart
│       │       ├── delete_product.dart
│       │       ├── get_products.dart
│       │       └── update_product.dart
│       └── presentation/
│           │   ├── add_edit_product_screen.dart
│           │   ├── home_screen.dart
│           │   ├── product_detail_screen.dart
│           │   └── product_card.dart
└── main.dart