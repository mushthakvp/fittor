import 'package:fittor/fittor.dart';
import 'package:flutter/cupertino.dart';

class SampleController extends FitController {
  int count = 0;
  bool isInitialized = false;

  // Called when controller is first accessed
  @override
  void onInit() {
    super.onInit();
    debugPrint('SampleController initialized'); // For debugging
    isInitialized = true;

    // You can do initial setup here, like:
    // - Loading data from local storage
    // - Setting up initial state
    // - Initializing dependencies
  }

  // This will ONLY update builders with NO tag
  void incrementNormal() {
    count++;
    fittor(); // Only updates builders without tags
  }

  // This will ONLY update builders with the 'tag2' tag
  void incrementTag2() {
    count++;
    fittor('tag2'); // Only updates builders with 'tag2' tag
  }

  // This will update ALL builders regardless of tags
  void incrementAll() {
    count++;
    fitAll(); // Updates all builders regardless of tags
  }

  @override
  void onDelete() {
    debugPrint('SampleController being deleted'); // For debugging

    // Clean up resources when controller is removed
    // This is important to prevent memory leaks
    // Examples:
    // - Cancel subscriptions
    // - Close streams
    // - Dispose of animation controllers
    // - Close database connections

    super.onDelete();
  }
}
