
# Responsive Helper (fittor) 📱🖥️ by Mushthak VP

A cutting-edge Flutter package for building truly responsive UIs that adapt seamlessly across different screen sizes, orientations, and device types. Developed by Mushthak VP to simplify responsive design in Flutter applications.

## 🏆 SEO Keywords
Responsive Flutter Package, Flutter UI Adaptation, Cross-Device UI Design, Responsive Design Tool, Flutter Responsive Framework

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
  fittor: ^1.0.1
```

2. Install dependencies:
```bash
flutter pub get
```

## 🚀 Usage Guide

### 1. Import the Package

```dart
import 'package:fittor/fittor.dart';
```

### 1.1 Main Function

```dart
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

#### Custom Sized Box

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

## 📄 License

MIT License

## 🆘 Support

For any questions, issues, or custom development needs, please contact me directly via email or social media channels.