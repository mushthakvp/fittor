# Responsive Helper 📱🖥️

A comprehensive Flutter package for building truly responsive UIs that adapt seamlessly across different screen sizes, orientations, and device types.

## ✨ Features

- 🔍 Device Type Detection
  - Identify device type (Mobile, Tablet, Desktop)
  - Orientation detection (Portrait & Landscape)

- 📐 Adaptive Sizing
  - Percentage-based width and height calculations
  - Safe area aware sizing
  - Adaptive font sizes
  - Device-specific value selection

- 🛠️ Convenient Extensions
  - Easy-to-use context extensions
  - Predefined spacing widgets
  - Lightweight and intuitive API

## 📦 Installation

1. Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  responsive_helper: ^1.0.0
```

2. Install dependencies:
```bash
flutter pub get
```

## 🚀 Usage Guide

### 1. Import the Package

```dart
import 'package:responsive_helper/responsive.dart';
```

### 2. Context Extensions

The package provides powerful extensions on `BuildContext`:

```dart
// Screen Dimensions
double screenWidth = context.width;
double screenHeight = context.height;

// Adaptive Font Sizing
TextStyle title = TextStyle(fontSize: context.fs(20));

// Percentage-based Sizing
Widget responsiveContainer = Container(
  width: context.wp(80),   // 80% of screen width
  height: context.hp(50),  // 50% of screen height
);

// Device-specific Values
Widget adaptiveWidget = context.deviceValue(
  mobile: mobileWidget,
  tablet: tabletWidget,
  desktop: desktopWidget,
);
```

### 3. Detailed Examples

#### Device Information

```dart
class DeviceInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Screen Width: ${context.width}'),
        Text('Screen Height: ${context.height}'),
        Text('Orientation: ${ResponsiveHelper.isPortrait ? 'Portrait' : 'Landscape'}'),
        Text('Device Type: ${ResponsiveHelper.deviceType}'),
      ],
    );
  }
}
```

#### Adaptive Sizing

```dart
class AdaptiveSizingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Percentage-based container
        Container(
          width: context.wp(90),   // 90% of screen width
          height: context.hp(20),  // 20% of screen height
          color: Colors.blue,
        ),

        // Adaptive padding
        Padding(
          padding: EdgeInsets.all(context.deviceValue(
            mobile: context.p8,
            tablet: context.p16,
            desktop: context.p24,
          )),
          child: Text('Adaptive Padding'),
        ),
      ],
    );
  }
}
```

#### Font Sizing

```dart
class ResponsiveFontExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Adaptive font sizes
        Text('Title', style: TextStyle(fontSize: context.fs(24))),
        Text('Subtitle', style: TextStyle(fontSize: context.fs(18))),
        
        // Predefined font sizes
        Text('Small Text', style: TextStyle(fontSize: context.fs12)),
        Text('Large Text', style: TextStyle(fontSize: context.fs32)),
      ],
    );
  }
}
```

### 4. Available Extensions

| Extension | Description | Example |
|----------|-------------|---------|
| `context.width` | Total screen width | `double width = context.width;` |
| `context.height` | Total screen height | `double height = context.height;` |
| `context.wp(%)` | Percentage of screen width | `context.wp(80)` gives 80% of screen width |
| `context.hp(%)` | Percentage of screen height | `context.hp(50)` gives 50% of screen height |
| `context.fs()` | Adaptive font size | `context.fs(16)` returns responsive font size |
| `context.p*` | Adaptive padding | `context.p16` gives adaptive 16 padding |
| `context.s*` | Vertical spacers | `context.s16` adds a 16-unit vertical space |
| `context.deviceValue()` | Device-specific values | Select value based on device type |

## 🎯 Best Practices

- Use `context.wp()` and `context.hp()` for responsive layouts
- Utilize `context.fs()` for adaptive typography
- Leverage `context.deviceValue()` for device-specific customizations
- Always consider both portrait and landscape orientations

## 🐞 Troubleshooting

- Ensure the package is correctly imported
- Check that you're using the latest version
- Verify flutter and dart SDK compatibility

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License

## 🆘 Support

If you encounter any issues or have questions, please file an issue on our GitHub repository.