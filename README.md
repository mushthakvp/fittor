# Fittor

A comprehensive Flutter package for responsive UI design and network connectivity management.

[![pub package](https://img.shields.io/pub/v/fittor.svg)](https://pub.dev/packages/fittor)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Responsive](#responsive)
  - [Custom Sized Box](#custom-sized-box)
  - [Internet Connectivity](#internet-connectivity)
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

## 🎯 Best Practices

- Use `context.wp()` and `context.hp()` for responsive layouts
- Utilize `context.fs()` for adaptive typography
- Leverage `context.deviceValue()` for device-specific customizations
- Always consider both portrait and landscape orientations

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
