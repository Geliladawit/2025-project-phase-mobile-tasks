# Remote Data Source Implementation

This task implements the **Remote Data Source** layer, enabling the application to communicate with a real REST API via HTTP requests. This replaces the temporary dummy data with live data from the backend.

## 🚀 Features Implemented

*   **API Integration:**
    *   Implemented `ProductRemoteDataSourceImpl` class that implements the `ProductRemoteDataSource` interface using the `http` package.
    *   **Complete CRUD Operations:**
        *   `getAllProducts()`: GET request to fetch the list of all products.
        *   `getProduct(String id)`: GET request to fetch a single product by ID.
        *   `createProduct(ProductModel product)`: POST request to add a new product.
        *   `updateProduct(ProductModel product)`: PUT request to modify an existing product.
        *   `deleteProduct(String id)`: DELETE request to remove a product.
*   **Data Parsing:**
    *   Converts JSON API responses into `ProductModel` objects using `ProductModel.fromJson()`.
    *   Converts `ProductModel` objects into JSON for outgoing requests using `ProductModel.toJson()`.
*   **Error Handling:**
    *   Validates HTTP status codes (200 for GET/PUT/DELETE, 200/201 for POST).
    *   Throws `ServerException` if the API call fails, returns an error code, or encounters network errors.
    *   Properly handles network exceptions and converts them to `ServerException`.
*   **Unit Testing:**
    *   Comprehensive test suite with 16 tests covering all CRUD operations.
    *   Tests verify correct HTTP method usage, URL construction, headers, and request bodies.
    *   Tests validate success scenarios (200/201 status codes) and error scenarios (non-success codes).
    *   Uses `mockito` to mock the `http.Client`, ensuring tests run without hitting the real server.

## 🛠 Dependencies

```yaml
dependencies:
  http: ^1.2.0

dev_dependencies:
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

## ⚙️ Configuration

**Base API URL:**
```
https://g5-flutter-learning-path-be.onrender.com/api/v1/products
```

**API Endpoints:**
- `GET /api/v1/products` - Get all products
- `GET /api/v1/products/{id}` - Get product by ID
- `POST /api/v1/products` - Create new product
- `PUT /api/v1/products/{id}` - Update product
- `DELETE /api/v1/products/{id}` - Delete product

## 🧪 Running Tests

**Generate Mocks:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Run Tests:**
```bash
flutter test test/product_remote_data_source_test.dart
```

**Test Coverage:**
- ✅ `getAllProducts()` - 3 tests (request verification, success response, error handling)
- ✅ `getProduct(String id)` - 3 tests (request verification, success response, error handling)
- ✅ `createProduct(ProductModel)` - 4 tests (request verification, 201 success, 200 success, error handling)
- ✅ `updateProduct(ProductModel)` - 3 tests (request verification, success response, error handling)
- ✅ `deleteProduct(String id)` - 3 tests (request verification, success response, error handling)

**Total: 16 tests - All passing ✅**


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
