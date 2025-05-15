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
- [Examples](#examples)
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

## Examples

### Responsive App Example

```dart
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Demo')),
      body: Center(
        child: Container(
          width: context.wp(80),
          padding: EdgeInsets.all(context.p16),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(context.r8),
          ),
          child: Text(
            'This text and container adapt to screen size',
            style: TextStyle(fontSize: context.fs18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
```

### Internet Connectivity Example

```dart
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with FittorAppMixin {
  const MyApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConnectivityWrapper(
        // Set to true if you want to handle connectivity display yourself
        ignoreOfflineState: true,
        onConnectivityChanged: (status) {
          debugPrint('Connectivity status: $status');
        },
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ConnectivityMixin {
  @override
  void onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are back online!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are offline!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Demo'),
        actions: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Connectivity Status:',
              style: TextStyle(fontSize: context.fs18),
            ),
            const SizedBox(height: 8),
            Text(
              isOnline ? 'ONLINE' : 'OFFLINE',
              style: TextStyle(
                fontSize: context.fs24,
                fontWeight: FontWeight.bold,
                color: isOnline ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Force a connectivity check
                final status = await checkConnectivity();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Connectivity check result: ${status == ConnectivityStatus.online ? 'ONLINE' : 'OFFLINE'}',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Check Connectivity Now'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

<script>
document.addEventListener('DOMContentLoaded', function() {
  // Add click handlers to table of contents links
  const tocLinks = document.querySelectorAll('a[href^="#"]');
  tocLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const targetId = this.getAttribute('href').substring(1);
      const targetElement = document.getElementById(targetId);
      if (targetElement) {
        targetElement.scrollIntoView({
          behavior: 'smooth'
        });
      }
    });
  });
});
</script>
