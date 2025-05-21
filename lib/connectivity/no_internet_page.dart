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
      body: Padding(
        padding: EdgeInsets.all(context.p20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: const AssetImage('assets/no_internet.jpg',
                    package: 'fittor'),
                width: context.wp(80),
              ),
            ),
            30.h,
            Text(
              title,
              style: TextStyle(
                fontSize: context.fs24,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
            8.h,
            Text(
              message,
              style: TextStyle(
                fontSize: context.fs14,
                color: textColor ?? Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            30.h,
            if (onRetry != null)
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  width: context.wp(100),
                  height: context.hp(6),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(context.p12),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    retryButtonText,
                    style: TextStyle(
                      fontSize: context.fs16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            16.h,
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
