// lib/connectivity/no_internet_page.dart
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  final Widget? child;
  final Future<void> Function()? onRetry;
  final String title;
  final String message;
  final String retryButtonText;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonColor;
  final EdgeInsets? padding;

  const NoInternetPage({
    super.key,
    this.child,
    this.onRetry,
    this.title = 'No Internet Connection',
    this.message = 'Please check your internet connection and try again.',
    this.retryButtonText = 'Retry',
    this.backgroundColor,
    this.textColor,
    this.buttonColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        foregroundColor:
            textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      buttonColor ?? Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
