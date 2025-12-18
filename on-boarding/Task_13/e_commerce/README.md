## 🚀 Features Implemented

*   **Smart Data Retrieval:**
    *   **Online:** Checks internet connection -> Fetches fresh data from `RemoteDataSource` -> Caches data in `LocalDataSource` -> Returns data.
    *   **Offline:** Checks internet connection -> Retrieves last saved data from `LocalDataSource`.
*   **Error Handling:**
    *   Catches `ServerException` when API calls fail.
    *   Catches `CacheException` when no local data is available.
    *   Propagates exceptions to the Domain layer for UI handling.
*   **Test-Driven Development (TDD):**
    *   Full unit test coverage using `mockito` to simulate network states and data source responses.

## 📂 File Structure

```text
lib/features/product/data/repositories/
└── product_repository_impl.dart   # The core logic implementation

test/features/product/data/repositories/
└── product_repository_impl_test.dart  # Unit tests verifying the logic

```
## 🧪 Running Tests
Generate Mocks:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
Run Tests:
```
flutter test test/features/product/data/repositories/product_repository_impl_test.dart
```
