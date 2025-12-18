# Network Info Implementation

This task enhances the app's robustness by integrating real-time network connectivity checks. The repository now intelligently switches between fetching data from the API and the local cache based on the device's internet status.

## 🚀 Key Features

*   **Network Connectivity Check:**
    *   Added `internet_connection_checker` dependency.
    *   Implemented `NetworkInfo` class to abstract connectivity logic.
*   **Smart Repository:**
    *   The Repository now checks `networkInfo.isConnected`.
    *   **Online:** Fetches from Remote Data Source.
    *   **Offline:** Fetches from Local Data Source.
*   **Web Support:** Added safeguards to fallback gracefully on Web platforms where raw socket checks are not supported.

## 📂 File Changes

*   `lib/core/network/network_info.dart`: Interface and Implementation of the network checker.
*   `lib/core/injection.dart`: Updated Dependency Injection to provide the real `InternetConnectionChecker`.
*   `pubspec.yaml`: Added `internet_connection_checker` package.

## 🛠 Dependencies

```yaml
dependencies:
  internet_connection_checker: ^1.0.0+1