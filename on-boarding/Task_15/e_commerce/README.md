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

# Remote Data Source Implementation

In this task, I implemented the **Remote Data Source** layer, enabling the application to communicate with a real REST API via HTTP requests. This replaces the temporary dummy data with live data from the backend.

## 🚀 Features Implemented

*   **API Integration:**
    *   Implemented `ProductRemoteDataSourceImpl` using the `http` package.
    *   **CRUD Operations:**
        *   `getAllProducts()`: GET request to fetch the list of products.
        *   `getProduct(id)`: GET request to fetch a single product details.
        *   `createProduct()`: POST request to add a new product.
        *   `updateProduct()`: PUT request to modify an existing product.
        *   `deleteProduct()`: DELETE request to remove a product.
*   **Data Parsing:**
    *   Converts JSON API responses into `ProductModel` objects.
    *   Converts `ProductModel` objects into JSON for outgoing requests.
*   **Error Handling:**
    *   Checks HTTP status codes (200, 201).
    *   Throws `ServerException` if the API call fails or returns an error code.
*   **Unit Testing:**
    *   Added tests using `mockito` to mock the `http.Client`, ensuring correct URL calling and header management without hitting the real server during tests.

## 🛠 Dependencies

```yaml
dependencies:
  http: ^1.2.0
```
## ⚙️ Configuration
Base API URL:
```
https://g5-flutter-learning-path-be.onrender.com/api/v1/products
```

## 🧪 Running Tests
Generate Mocks:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
Run Test:
```
flutter test test/product_remote_data_source_test.dart
```