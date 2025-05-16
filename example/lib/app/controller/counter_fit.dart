import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class CounterController extends FitController {
  // Use .fit extension to convert a regular value to a FitValue
  final counter = 0.fit;

  // Method to increment counter
  void increment() {
    counter.val++; // Use .val to access or modify the value
    fittor(); // Notify listeners to rebuild (instead of update())
  }

  // Method to increment counter and only update widgets with 'display' tag
  void incrementDisplayOnly() {
    counter.val++;
    fittor('display'); // Only update widgets with 'display' tag
  }

  // Optional: Called when controller is removed
  @override
  void onDelete() {
    debugPrint('CounterController is being deleted');
    super.onDelete();
  }
}
