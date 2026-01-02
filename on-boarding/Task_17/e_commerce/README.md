## Task 17: BLoC State Management

This task introduces the **BLoC (Business Logic Component)** pattern to manage the application's state, acting as the bridge between the UI and Domain layers.

## 🚀 Features Implemented

*   **BLoC Structure:**
    *   **Events:** Defined user actions (`LoadAllProductEvent`, `CreateProductEvent`, etc.).
    *   **States:** Defined UI states (`LoadingState`, `LoadedAllProductState`, `ErrorState`).
    *   **ProductBloc:** Implemented the logic to map Events to States using Use Cases.
*   **Use Case Updates:** Refactored Use Cases to return `Either<Failure, Type>`, ensuring consistent error handling within the BLoC.
*   **Dependency Injection:** Registered `ProductBloc` with `GetIt` for easy access throughout the app.
*   **Testing (TDD):** Added comprehensive unit tests for the BLoC using `bloc_test` and `mockito`.

## 🛠 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

dev_dependencies:
  bloc_test: ^9.1.5

```
### 🧪 Running Tests

To verify the BLoC logic:

Generate Mocks:

```
flutter pub run build_runner build --delete-conflicting-outputs
```

Run Test:

```
flutter test test/product_bloc_test.dart
```