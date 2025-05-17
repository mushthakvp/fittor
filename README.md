<p align="center">
  <img src="https://raw.githubusercontent.com/mushthakvp/fittor/dev/assets/fittor.png" alt="Fittor Logo" width="200">
</p>

[![pub package](https://img.shields.io/pub/v/fittor.svg)](https://pub.dev/packages/fittor)
[![pub points](https://img.shields.io/pub/points/fittor.svg)](https://pub.dev/packages/fittor/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub issues](https://img.shields.io/github/issues/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/issues)
[![GitHub stars](https://img.shields.io/github/stars/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/stargazers)


A comprehensive Flutter package for responsive UI design and network connectivity management.
A lightweight, intuitive state management solution for Flutter applications.

<!-- [![pub package](https://img.shields.io/pub/v/fittor.svg)](https://pub.dev/packages/fittor) -->

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [State Management](#state-management)
  - [Getting Started](#getting-started)
  - [Advanced Usage Controller](#advanced-usage-controller)
  - [Auto-registration with FitBuilder](#auto-registration-with-fitBuilder)
  - [Initialization and Disposal](#initialization-and-disposal)
- [Usage](#usage)
  - [Responsive](#responsive)
  - [Custom Sized Box](#custom-sized-box)
  - [Internet Connectivity](#internet-connectivity)
  - [Currency Converter](#currency-converter)
- [Extension](#Extension)
- [Contributing](#contributing)
- [License](#license)



## Features

- 📱 **Responsive UI**: Easily create responsive layouts that adapt to different screen sizes and orientations
- 📦 **Custom Sized Box**: Convenient extensions for creating SizedBox widgets
- 🌐 **Internet Connectivity**: Built-in connectivity monitoring with customizable no-internet UI
- 💱 **Currency Converter**: Live exchange rates and currency conversion utilities
- 📦 **Package Management**: Manage dependencies with ease

## Installation

```yaml
dependencies:
  fittor: ^latest_version
```

```bash
flutter pub add fittor
```

Then run:

```bash
flutter pub get
```

## Usage

### Responsive

Fittor provides a responsive design system through mixins and extensions. Here's how to use it:

#### Basic Setup

Add the `FittorAppMixin` to your app:

```dart
class MyApp extends StatelessWidget with FittorAppMixin {
  const MyApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
```

#### Using in Widgets

Access responsive values through context extensions:

```dart
Container(
  width: context.wp(50),          // 50% of screen width
  height: context.hp(25),         // 25% of screen height
  padding: EdgeInsets.all(context.p16), // Adaptive padding
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: context.fs18), // Adaptive font size
  ),
)
```

#### Responsive Mixins

Use the `FittorMixin` in your StatefulWidget:

```dart
class _MyWidgetState extends State<MyWidget> with FittorMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wp(50),    // 50% of screen width
      padding: EdgeInsets.all(p16), // Predefined padding
      child: Text(
        'Hello World',
        style: TextStyle(fontSize: fs(18)), // Responsive font size
      ),
    );
  }
}
```

### Custom Sized Box

Create SizedBox widgets with simple extensions:

```dart
// Width SizedBox
20.w  // SizedBox with width 20

// Height SizedBox
16.h  // SizedBox with height 16

// Square SizedBox
24.s  // SizedBox with width and height both 24
```

### Internet Connectivity

Fittor includes built-in internet connectivity monitoring without any external packages.

#### Using ConnectivityWrapper

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

Wrap your widget with `ConnectivityWrapper` to automatically show a no-internet screen when connectivity is lost:

```dart
ConnectivityWrapper(
  child: YourWidget(),
  // Optional customizations:
  offlineWidget: YourCustomOfflineWidget(),
  onConnectivityChanged: (status) {
    print('Connectivity status: $status');
  },
)
```

The `ignoreOfflineState` parameter (default: false) controls whether the wrapper automatically shows the no-internet screen:

```dart
ConnectivityWrapper(
  ignoreOfflineState: true,  // Don't show no-internet screen automatically
  onConnectivityChanged: (status) {
    // Handle connectivity changes yourself
  },
  child: YourWidget(),
)
```

When `ignoreOfflineState` is set to `true`, the ConnectivityWrapper will not automatically show the no-internet screen when connectivity is lost. Instead, it will continue showing your child widget and notify you of connectivity changes through the `onConnectivityChanged` callback. This is useful when you want to handle connectivity UI yourself, such as showing snackbars or banners instead of full-screen notifications.

#### Using ConnectivityMixin

For more fine-grained control, use the `ConnectivityMixin` in your StatefulWidget:

```dart
class _MyScreenState extends State<MyScreen> with ConnectivityMixin {
  @override
  void onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online) {
      // Handle online state
    } else {
      // Handle offline state
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Access connectivity status with:
    if (isOnline) {
      return OnlineContent();
    } else {
      return OfflineContent();
    }
  }
}
```

### Currency Converter

Fittor provides a currency converter utility with live exchange rates.

#### Basic Conversion

```dart
// Convert 100 INR to USD
double usdAmount = await context.convertCurrency(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);

print('100 INR = $usdAmount USD');
```

#### Convert and Format

```dart
// Convert and format with currency symbol
String formattedAmount = await context.convertAndFormat(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);

print('100 INR = $formattedAmount'); // Outputs: 100 INR = $1.17
```

#### Format with Custom Symbols

```dart
// Format a currency amount with proper symbol
String formatted = context.formatCurrency(1234.56, 'USD');
print(formatted); // Outputs: $1,234.56
```

### Live Exchange Rates

```dart
// Get the current exchange rate between two currencies
double rate = await context.getExchangeRate('INR', 'USD');
print('1 INR = $rate USD'); 
```

#### Advanced Usage

### Direct Access to CurrencyConverter

```dart
final converter = CurrencyConverter();

// Manually get latest rates for a base currency
Map<String, dynamic> rates = await converter.getLatestRates('EUR');

// Check cache status
Map<String, dynamic> cacheInfo = converter.getCacheInfo();
print('Last updated: ${cacheInfo['lastUpdated']}');
```

### FittorCurrency Utilities

```dart
final currencyUtils = FittorCurrency();

// Create a currency text widget
Widget priceText = currencyUtils.currencyText(
  '\$1,234.56',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);
```

## State Management

#### Overview
`Fittor` is a pragmatic `state management library` designed to make Flutter development more efficient with minimal boilerplate. It offers a controller-based approach, more focused API.

### Features

- Controller-based state management: Create reactive UIs with minimal code
- Dependency injection: Easily register and find controllers throughout your app
- Reactive value wrappers: Optimized UI updates with fine-grained reactivity
- Bindings system: Organize dependencies by route or feature
- Extension methods: Access controllers directly from BuildContext
- Auto-disposal: Controllers are automatically managed in the widget lifecycle

### Getting Started

#### 1. Initialize Fittor

Initialize Fittor at the root of your application:

```dart
void main() {
  runApp(
    FitInitializer(
      child: MyApp(),
      initialBindings: [AppBindings()],
    ),
  );
}
```

#### 2. Create a Controller

Controllers manage your application state and business logic:

```dart
class CounterController extends FitController {
  int count = 0;
  
  void increment() {
    count++;
    fittor(); // Notify listeners to rebuild
  }
  
  @override
  void onDelete() {
    // Clean up resources when controller is removed
    super.onDelete();
  }
}
```

#### 3. Using Reactive Values

For more granular updates, use the `FitValue` class:

```dart
class UserController extends FitController {
  final username = "".fit; // Creates a FitValue<String>
  final isLoggedIn = false.fit; // Creates a FitValue<bool>
  
  void login(String name) {
    username.val = name; // This will automatically update listeners
    isLoggedIn.val = true;
  }
}
```

#### 4. Register Controllers with Bindings

Create a bindings class to organize your dependencies:

```dart
class AppBindings extends FitBindings {
  @override
  void dependencies() {
    lazyPut(() => CounterController());
    lazyPut(() => UserController());
  }
}
```

#### 5. Using Controllers in Widgets

Access your controllers in the UI using `FitBuilder:`

```dart
FitBuilder<CounterController>(
  controller: Fit.find<CounterController>(),
  builder: (context, controller) {
    return Text('Count: ${controller.count}');
  },
)
```

For reactive values:

```dart
FitValueBuilder<String>(
  fitValue: userController.username,
  builder: (context, username) {
    return Text('Hello, $username');
  },
)
```

#### 6. Access Controllers via BuildContext Extension

```dart
final controller = context.find<CounterController>();
controller.increment();
```

### Core Concepts

#### Controllers

Controllers are the heart of your application logic. Extend `FitController` to create a controller:

```dart
class ThemeController extends FitController {
  bool isDarkMode = false;
  
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    fittor(); // Notify all listeners (will rebuild UI)
  }
  
  // To update specific widgets only
  void updateSpecificWidgets() {
    fittor('theme-tag'); // Only rebuilds widgets with 'theme-tag'
  }
}
```

### Dependency Injection

Fittor provides several methods to register and find controllers:

- `Fit.lazyPut<T>()` : Registers a controller for lazy initialization
- `Fit.put<T>()` : Registers an already initialized controller
- `Fit.find<T>()` : Finds a registered controller
- `Fit.delete<T>()` : Removes a controller and calls its onDelete method

#### Advanced Usage Controller

#### Tagging Controllers

Register multiple instances of the same controller type:

```dart
// Registration
Fit.put<ApiClient>(ProductApiClient(), tag: 'product');
Fit.put<ApiClient>(UserApiClient(), tag: 'user');

// Usage
final productApi = Fit.find<ApiClient>(tag: 'product');
final userApi = Fit.find<ApiClient>(tag: 'user');
```

#### Auto-registration with FitBuilder

Controllers can be automatically registered with `FitBuilder`:

```dart
FitBuilder<DashboardController>(
  controller: DashboardController(),
  autoRegister: true,
  builder: (context, controller) {
    return DashboardView(controller: controller);
  },
)
```

#### Initialization and Disposal

Controllers are automatically disposed when their widgets are removed from the tree. You can also manually dispose controllers:

```dart
FitBuilder<VideoController>(
  controller: Fit.find<VideoController>(),
  init: (controller) => controller.initialize(),
  dispose: (controller) => controller.cleanup(),
  builder: (context, controller) {
    return VideoPlayer(controller);
  },
)
```


## Extension

### Responsive Features

| Extension | Description | Example |
|----------|-------------|---------|
| `num.w` | Creates SizedBox with width | `20.w` creates SizedBox(width: 20) |
| `num.h` | Creates SizedBox with height | `16.h` creates SizedBox(height: 16) |
| `num.s` | Creates square SizedBox | `24.s` creates SizedBox.square(dimension: 24) |
| `context.wp(%)` | Percentage of screen width | `context.wp(80)` gives 80% of screen width |
| `context.hp(%)` | Percentage of screen height | `context.hp(50)` gives 50% of screen height |
| `context.p*` | Adaptive padding | `context.p16` gives adaptive 16 padding |
| `context.fs*` | Adaptive font size | `context.fs16` returns responsive font size 16 |

### Connectivity Features

| Feature | Description | Example |
|---------|-------------|---------|
| `ConnectivityWrapper` | Wraps UI with connectivity monitoring | `ConnectivityWrapper(child: MyApp())` |
| `ConnectivityMixin` | Mixin for StatefulWidgets | `class _MyState extends State<MyWidget> with ConnectivityMixin` |
| `isOnline` property | Check online status with mixin | `if (isOnline) { /* do network request */ }` |
| `checkConnectivity()` | Manual connectivity check | `await checkConnectivity()` |
| `onConnectivityChanged` | Handle status changes | `onConnectivityChanged(status) { /* handle change */ }` |


### Currency Features

| Feature | Description | Example |
|---------|-------------|---------|
| `convertCurrency()` | Convert currency | `double usdAmount = await context.convertCurrency(from: 'INR', to: 'USD', amount: 100.0);` |
| `convertAndFormat()` | Convert and format | `String formatted = await context.convertAndFormat(from: 'INR', to: 'USD', amount: 100.0);` |
| `formatCurrency()` | Format currency | `String formatted = context.formatCurrency(1234.56, 'USD');` |
| `getExchange Rate()` | Get exchange rate | `double rate = await context.getExchangeRate('INR', 'USD');` |


## 🐞 Troubleshooting

- Ensure the package is correctly imported
- Check that you're using the latest version
- Verify flutter and dart SDK compatibility
- Check for any conflicts with other packages

## 📞 Contact & Support

**Author:** Mushthak VP

### 🌐 Connect With Me
- **Email:** mail.musthak@gmail.com
- **WhatsApp:** +919061213930
- **LinkedIn:** [Mushthak VP](https://in.linkedin.com/in/musthak)
- **Instagram:** [@musth4k](https://www.instagram.com/musth4k/)
- **GitHub:** [mushthakvp](https://github.com/mushthakvp)

### 💡 Collaboration
Have a project or need custom Flutter development? Feel free to reach out! I'm always open to interesting projects, collaborations, and opportunities.

## 🤝 Contributing

Contributions are welcome! Whether you're reporting bugs, suggesting improvements, or want to collaborate, don't hesitate to connect.

## License
[MIT](LICENSE) - Copyright © 2025 Mushthak VP

## 🆘 Support

For any questions, issues, or custom development needs, please contact me directly via email or social media channels.
