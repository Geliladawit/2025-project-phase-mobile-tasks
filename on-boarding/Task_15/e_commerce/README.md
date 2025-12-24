# Local Data Source Implementation

This task implements the **Local Data Source** layer using `SharedPreferences`, enabling the app to persist product data on the device for offline access.

## 🚀 Features Implemented

*   **Caching Mechanism:**
    *   Implemented `ProductLocalDataSourceImpl` to handle data persistence.
    *   `cacheProducts()`: Converts the list of `ProductModel` to JSON and saves it to local storage.
    *   `getLastProducts()`: Retrieves and parses the cached JSON data when the device is offline.
*   **Dependency Injection:** Updated DI to initialize `SharedPreferences` asynchronously before the app starts.
*   **Unit Testing:** Added tests using `mockito` to verify that data is correctly saved to and retrieved from `SharedPreferences`.

## 🛠 Dependencies

```yaml
dependencies:
  shared_preferences: ^2.2.0
```
## 🧪 Running Tests
Generate Mocks:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
Run Test:
```
flutter test test/product_local_data_source_test.dart
```