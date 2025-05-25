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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: screenWidth * 0.2,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              message,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: textColor ?? Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.04),
            if (onRetry != null)
              SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        buttonColor ?? Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    retryButtonText,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (child != null) ...[
              SizedBox(height: screenHeight * 0.02),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}
