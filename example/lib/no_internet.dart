import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> with ConnectivityMixin {
  @override
  void onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Internet connection restored.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No internet connection.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Internet Checking Demo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            20.h,
            const Icon(Icons.wifi_off, size: 74, color: Colors.red),
            20.h,
            Text(
              'Internet Connection Demo',
              style: TextStyle(
                fontSize: context.fs20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a demo of how to handle no internet connection.',
              textAlign: TextAlign.center,
            ),
            30.h,
            Text(
              'Using ConnectivityWrapper in Main.dart',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              connectivityWrapper,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            30.h,
            Text(
              'Using ConnectivityWrapper in Main.dart',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              connectivityMixin,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

String connectivityWrapper = '''
class MyApp extends StatelessWidget with FittorAppMixin {
  const MyApp({super.key});
  @override
  Widget responsive(BuildContext context) {
    return MaterialApp(
      home: ConnectivityWrapper(
        ignoreOfflineState: true,
        onConnectivityChanged: (status) {
          debugPrint("Connectivity status: status");
        },
        child: const HomeScreen(),
      ),
    );
  }
}
''';

String connectivityMixin =
    '''class _MyScreenState extends State<MyScreen> with ConnectivityMixin {
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
}''';
