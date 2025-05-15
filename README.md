# Fittor

<p align="center">
  <img src="https://raw.githubusercontent.com/mushthakvp/fittor/dev/assets/fittor.png" alt="Fittor Logo" width="200">
</p>

![Package Views](https://komarev.com/ghpvc/?username=fittor-package&label=Package%20Views&color=blue)
[![pub package](https://img.shields.io/pub/v/fittor.svg)](https://pub.dev/packages/fittor)
[![pub points](https://img.shields.io/pub/points/fittor.svg)](https://pub.dev/packages/fittor/score)
[![popularity](https://img.shields.io/pub/popularity/fittor.svg)](https://pub.dev/packages/fittor/score)
[![likes](https://img.shields.io/pub/likes/fittor.svg)](https://pub.dev/packages/fittor)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub issues](https://img.shields.io/github/issues/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/issues)
[![GitHub stars](https://img.shields.io/github/stars/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/network)
[![Last Commit](https://img.shields.io/github/last-commit/mushthakvp/fittor)](https://github.com/mushthakvp/fittor/commits/main)


A comprehensive Flutter package for responsive UI design and network connectivity management.

<!-- [![pub package](https://img.shields.io/pub/v/fittor.svg)](https://pub.dev/packages/fittor) -->

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Responsive](#responsive)
  - [Custom Sized Box](#custom-sized-box)
  - [Internet Connectivity](#internet-connectivity)
- [Extension](#Extension)
- [Contributing](#contributing)
- [License](#license)



## Features

- 📱 **Responsive UI**: Easily create responsive layouts that adapt to different screen sizes and orientations
- 📦 **Custom Sized Box**: Convenient extensions for creating SizedBox widgets
- 🌐 **Internet Connectivity**: Built-in connectivity monitoring with customizable no-internet UI

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

## Extension

### Available Extensions

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
