## 1.0.18

- **Package Name Change**: The package name Changer added
- **App Name Change**: The app name Changer added

Usage:

```dart
// Activate the fittor CLI globally

dart pub global activate fittor

# Change package name
fittor change package com.example.fittor

# Change app name  
fittor change name "My Awesome App"
```

## 1.0.17

- **Fittor Blur Ash**: You can now use the `FittorBlurAsh` widget to add a blur effect to a widget.

```dart
FittorBlurAsh(
  hash: 'UbCP*BWYWWof~qWraykC_3WYjZof?bflaxoL',
  width: 300,
  height: 200,
);

FittorBlurAsh FittorBlurAsh({
  Key? key,
  required String hash,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  Color? color,
  Widget? child,
  Widget? loadingWidget,
  Widget? errorWidget,
  int resolution = 32,
})
```

## 1.0.16

1. `enableSwipeBack` flag in `FitRouterConfig`
2. `allowSwipeBack` property in `FitPage` for per-route control
3. Use of `CupertinoPageRoute` on iOS devices
4. Custom `_SwipeBackPageRoute` for custom transitions with swipe back support

## 1.0.15

**Fittor is compatible with:**
- Dart SDK: >=3.4.0 <4.0.0
- Flutter: >=3.19.0

## 1.0.14

- Fittor Route Management: Easily navigate between screens and manage routes in your application.
- Fittor State Management: Manage the state of your application using the StateManager class.
- Fittor Dependency Injection: Inject dependencies into your controllers and widgets.
- Fittor Logger: Log messages to the console for debugging and monitoring.
- Fittor Cache: Cache data for faster access and offline support.
- Fittor Analytics: Track user

## 1.0.13

- State Management: Manage the state of your application using the StateManager class.
- (OnInit ) : This method is called when the widget is initialized.

```dart
  @override
  void onInit() {
    super.onInit();
    debugPrint('SampleController initialized'); // For debugging
    isInitialized = true;

    // You can do initial setup here, like:
    // - Loading data from local storage
    // - Setting up initial state
    // - Initializing dependencies
  }
```

- (OnDelete) : This method is called when the widget is removed from the widget tree.

```dart
  @override
  void onDelete() {
    debugPrint('SampleController being deleted'); // For debugging

    // Clean up resources when controller is removed
    // This is important to prevent memory leaks
    // Examples:
    // - Cancel subscriptions
    // - Close streams
    // - Dispose of animation controllers
    // - Close database connections

    super.onDelete();
  }
  ```

## 1.0.12

- (CLI) Command Example for Fittor
- Use Below Command to Create a New Fittor App

```dart
dart pub global activate fittor

// Activate the fittor CLI globally
```
```dart
fittor create app

// Create a new Fittor App
```
```dart
fittor -h

// Usage: fittor [command] [options]
```

## 1.0.11

- (CLI) Tool Testing for Fittor Store Bug Updated

- # Create a new Fittor app
- **fittor create app**

- # Create a new page
- **fittor create page --name=user_profile**

- # Create a widget
- **fittor create widget --name=custom_card**

```dart
// Activate the fittor CLI globally
dart pub global activate fittor

// Create a new Fittor Folder Structure
fittor create app

```


## 1.0.10

- (CLI) Tool Testing for Fittor Store Bug Updated

## 1.0.9

- Add Command Line Interface (CLI) for Fittor Store Bug Updated
- Command Line Interface (CLI) for Fittor Store Bug Updated

## 1.0.8+2

- Add Command Line Interface (CLI) for Fittor Store Bug Updated

## 1.0.8+1

- Add Command Line Interface (CLI) for Fittor Store

## 1.0.8

- Fittor Store
- A secure, persistent key-value storage solution for Flutter applications with built-in encryption for sensitive data.
- **Secure Storage**: Automatically encrypts sensitive data (tokens, passwords, etc.)
- **Persistent Storage**: Data survives app restarts
- **Type-Safe Operations**: Dedicated methods for different data types
- **Automatic Serialization**: Handles complex types like DateTime and JSON
- **Security Features**:
  - PIN protection (via `FittorSecure`)
  - Session timeout
  - Failed attempt lockout
  - Encryption key rotation
- **Convenience Mixin**: Easy access to storage in StatefulWidgets
- **Backup & Restore**: Create and restore from backups
- **Auto-Save**: Configurable auto-save functionality

## 1.0.7

- A lightweight, intuitive state management solution for Flutter applications.
- Controller-based state management: Create reactive UIs with minimal code
- Dependency injection: Easily register and find controllers throughout your app
- Reactive value wrappers: Optimized UI updates with fine-grained reactivity
- Bindings system: Organize dependencies by route or feature
- Extension methods: Access controllers directly from BuildContext
- Auto-disposal: Controllers are automatically managed in the widget lifecycle

## 1.0.6

- Currency Converter Free API
- Live Currency Converter
- Currency Converter Widget
- Currency Converter Example

```dart
final converter = CurrencyConverter();

// Manually get latest rates for a base currency
Map<String, dynamic> rates = await converter.getLatestRates('EUR');

// Create Widget

final currencyUtils = FittorCurrency();

// Create a currency text widget
Widget priceText = currencyUtils.currencyText(
  '\$1,234.56',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);
```

## 1.0.5

- Add Logo to README.md
- Add Clear Cache to README.md

## 1.0.4

- Added Internet Connectivity Monitoring
- Added ConnectivityMixin for StatefulWidgets
- Added ConnectivityWrapper for wrapping UI with connectivity monitoring

```dart
class MyApp extends StatelessWidget with FittorAppMixin {
  const MyApp({super.key});
  @override
  Widget responsive(BuildContext context) {
    return MaterialApp(
      home: ConnectivityWrapper(
        ignoreOfflineState: true,
        onConnectivityChanged: (status) {
          debugPrint('Connectivity status: $status');
        },
        child: const HomeScreen(),
      ),
    );
  }
}
```

## 1.0.3

- Added a new method to the ResponsiveHelper class to retrieve the current device type from a BuildContext.


## 1.0.2+1

- License updated to MIT
- README.md updated with new features and examples
- ScaleFactor Deprecated and replaced with ScaleFactor.of


## 1.0.2

- New SizedBox widget to wrap content and apply responsive sizing.
- Use Height Like this
```dart
  Widget _buildCustomSizedBoxExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height 10',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        10.h,
        Text(
          'Height 20',
          style: TextStyle(
            fontSize: context.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        20.h,
      ],
    );
  }
```

## 1.0.1

- Fixed a bug in the `ResponsiveHelper.of` method that caused a crash when used in a widget tree.
- Added a new method `ResponsiveHelper.ofContext` to retrieve the responsive helper instance from a BuildContext.
- Added a new method `ResponsiveHelper.ofDeviceType` to retrieve the device type from a BuildContext.
- Added a new method `ResponsiveHelper.ofOrientation` to retrieve the orientation from a BuildContext.

## 1.0.0

- First stable release of Responsive Helper package
- Core features implemented:
  * Device type detection (Mobile, Tablet, Desktop)
  * Orientation detection
  * Percentage-based width and height calculations
  * Safe area aware sizing
  * Adaptive font sizes
  * Context extensions for responsive design
  * Device-specific value selection


## 0.0.1

* Initial development release
* Preparing package for pub.dev publication