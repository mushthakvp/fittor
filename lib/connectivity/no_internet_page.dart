import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onRetry;
  final String title;
  final String message;
  final String retryButtonText;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonColor;

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: buttonColor ?? Colors.black,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(context.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: context.hp(10),
                color: Colors.grey[400],
              ),
            ),
            20.h,
            Text(
              title,
              style: TextStyle(
                fontSize: context.fs28,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
            5.h,
            Text(
              message,
              style: TextStyle(
                fontSize: context.fs14,
                color: textColor ?? Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            70.h,
          ],
        ),
      ),
    );
  }
}
