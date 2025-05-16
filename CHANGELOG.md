## 0.0.1

* Initial development release
* Preparing package for pub.dev publication

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

## 1.0.1

- Fixed a bug in the `ResponsiveHelper.of` method that caused a crash when used in a widget tree.
- Added a new method `ResponsiveHelper.ofContext` to retrieve the responsive helper instance from a BuildContext.
- Added a new method `ResponsiveHelper.ofDeviceType` to retrieve the device type from a BuildContext.
- Added a new method `ResponsiveHelper.ofOrientation` to retrieve the orientation from a BuildContext.

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

## 1.0.2+1

- License updated to MIT
- README.md updated with new features and examples
- ScaleFactor Deprecated and replaced with ScaleFactor.of

## 1.0.3

- Added a new method to the ResponsiveHelper class to retrieve the current device type from a BuildContext.

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

## 1.0.5

- Add Logo to README.md
- Add Clear Cache to README.md

## 1.0.6

- Currency Converter Free API
- Live Currency Converter
- Currency Converter Widget
- Currency Converter Example