# BLoC Implementation

This task implements the **BLoC (Business Logic Component)** pattern for state management in the e-commerce app, providing a clean separation between business logic and UI.

## 🚀 Features Implemented

### Task 17.1: Event Classes
Created all necessary event classes that represent user actions:
- **`LoadAllProductEvent`**: Dispatched when loading all products from the repository
- **`GetSingleProductEvent`**: Dispatched when retrieving a single product by ID (requires `id` parameter)
- **`UpdateProductEvent`**: Dispatched when updating a product's details (requires `Product` parameter)
- **`DeleteProductEvent`**: Dispatched when deleting a product (requires `id` parameter)
- **`CreateProductEvent`**: Dispatched when creating a new product (requires `Product` parameter)

All events extend `ProductEvent` (which extends `Equatable`) with proper property comparison.

### Task 17.2: State Classes
Designed state classes that represent various UI states:
- **`EmptyState`**: Represents the initial state before any data is loaded
- **`LoadingState`**: Indicates that the app is currently fetching data
- **`LoadedAllProductState`**: Represents the state where all products are successfully loaded (contains `List<Product>`)
- **`LoadedSingleProductState`**: Represents the state where a single product is successfully retrieved (contains `Product`)
- **`ErrorState`**: Indicates that an error has occurred during data retrieval or processing (contains error message)

All states extend `ProductState` (which extends `Equatable`) with proper property comparison.

### Task 17.3: ProductBloc
Developed the `ProductBloc` class that handles business logic, event processing, and state management:

- **Initial State Setup**: Initialized with `EmptyState` as the default state
- **Event Handling Logic**: Implemented event handlers using `on<Event>` pattern:
  - `_onLoadAllProductEvent`: Handles loading all products
  - `_onGetSingleProductEvent`: Handles retrieving a single product
  - `_onCreateProductEvent`: Handles creating a new product
  - `_onUpdateProductEvent`: Handles updating a product
  - `_onDeleteProductEvent`: Handles deleting a product
- **Use Case Interaction**: Integrates with all use cases:
  - `ViewAllProductsUsecase` (getAllProduct)
  - `GetSingleProductUsecase` (getSingleProduct)
  - `CreateProductUsecase` (createProduct)
  - `UpdateProductUsecase` (updateProduct)
  - `DeleteProductUsecase` (deleteProduct)
- **Streams and State Emission**: Uses `emit()` to emit appropriate states based on event processing
- **Error Handling**: Comprehensive error handling with try-catch blocks that emit `ErrorState` when operations fail

### Additional Implementation:
- **GetSingleProductUsecase**: Created use case for getting a single product by ID
- **Dependency Injection**: Updated `Injection` class to include `GetSingleProductUsecase` and `ProductBloc`

## 📁 File Structure

```
lib/features/product/
├── domain/
│   └── usecases/
│       ├── get_single_product.dart (new)
│       ├── get_product.dart
│       ├── create_product.dart
│       ├── update_product.dart
│       └── delete_product.dart
└── presentation/
    └── bloc/
        ├── product_bloc.dart (new)
        ├── product_event.dart (new)
        └── product_state.dart (new)
```

## 🛠 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
```

## ⚙️ Usage

### Accessing the BLoC

The `ProductBloc` is available through dependency injection:

```dart
// After calling Injection.init()
final bloc = Injection.productBloc;
```

### Dispatching Events

```dart
// Load all products
bloc.add(LoadAllProductEvent());

// Get single product
bloc.add(GetSingleProductEvent('product-id'));

// Create product
bloc.add(CreateProductEvent(product));

// Update product
bloc.add(UpdateProductEvent(product));

// Delete product
bloc.add(DeleteProductEvent('product-id'));
```

### Listening to States

```dart
BlocBuilder<ProductBloc, ProductState>(
  bloc: Injection.productBloc,
  builder: (context, state) {
    if (state is LoadingState) {
      return CircularProgressIndicator();
    } else if (state is LoadedAllProductState) {
      return ProductList(products: state.products);
    } else if (state is ErrorState) {
      return ErrorWidget(state.message);
    }
    return EmptyWidget();
  },
)
```

## 🎯 BLoC Pattern Benefits

- **Separation of Concerns**: Business logic is separated from UI
- **Testability**: Easy to unit test business logic independently
- **Predictable State Management**: Clear state transitions
- **Reusability**: Business logic can be reused across different UI components
- **Maintainability**: Clean, organized code structure following BLoC pattern principles