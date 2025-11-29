# Flutter E-Commerce App (Task 7)

A simple Flutter application demonstrating Navigation, Routing, and CRUD operations for an e-commerce product list.

## Features

1.  **Screen Navigation:**
    *   **Home Screen:** Lists all available products.
    *   **Details Screen:** View product details, delete, or edit.
    *   **Add/Edit Screen:** A form to create new products or modify existing ones.

2.  **Navigation & Routing:**
    *   Uses **Named Routes** (`/`, `/details`, `/add_edit`) for clean navigation logic.
    *   Implements **Custom Animations** (Right-to-Left Slide) using `PageRouteBuilder` in `onGenerateRoute`.

3.  **Data Flow:**
    *   Passes product objects as arguments between screens.
    *   Returns data (Updated Product or Delete signals) via `Navigator.pop()` to update the UI dynamically.

## How to Run

1.  **Prerequisites:** Ensure you have Flutter installed (`flutter doctor`).
2.  **Clone/Download:** Clone this repository to your local machine.
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the App:**
    ```bash
    flutter run
    ```

## Implementation Details

*   **State Management:** Uses `setState` in the top-level `EcommerceApp` widget to manage the product list, demonstrating how data travels up and down the widget tree through navigation callbacks.
*   **UI:** Matches the modern e-commerce design style with clean cards, input fields, and a cohesive color scheme.