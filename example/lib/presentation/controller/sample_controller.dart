import 'package:fittor/fittor.dart';
import 'package:flutter/rendering.dart';

class CounterController extends FitState {
  int _count = 0;
  String _status = 'Ready';
  bool _isLoading = false;

  // Getters
  int get count => _count;
  String get status => _status;
  bool get isLoading => _isLoading;

  @override
  void onInit() {
    debugPrint('CounterController initialized');
  }

  @override
  void onClose() {
    debugPrint('CounterController disposed');
  }

  // This will ONLY update builders with NO tag
  void incrementNormal() {
    _count++;
    _status = 'Normal increment';
    fittor(); // Only updates builders without tags

    // Update selectors
    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }

  // This will ONLY update builders with the 'special' tag
  void incrementSpecial() {
    _count++;
    _status = 'Special increment';
    fittor('special'); // Only updates builders with 'special' tag

    // Update selectors
    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }

  // This will update ALL builders regardless of tags
  void incrementAll() {
    _count++;
    _status = 'All increment';
    fitAll(); // Updates all builders regardless of tags

    // Update selectors
    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }

  // Decrement methods
  void decrementNormal() {
    if (_count > 0) {
      _count--;
      _status = 'Normal decrement';
      fittor();

      fitSelectRefresh('count', () => _count);
      fitSelectRefresh('status', () => _status);
    }
  }

  void decrementSpecial() {
    if (_count > 0) {
      _count--;
      _status = 'Special decrement';
      fittor('special');

      fitSelectRefresh('count', () => _count);
      fitSelectRefresh('status', () => _status);
    }
  }

  void decrementAll() {
    if (_count > 0) {
      _count--;
      _status = 'All decrement';
      fitAll();

      fitSelectRefresh('count', () => _count);
      fitSelectRefresh('status', () => _status);
    }
  }

  // Reset counter
  void reset() {
    _count = 0;
    _status = 'Reset';
    fitAll();

    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }

  // Async operation example
  Future<void> incrementAsync() async {
    _isLoading = true;
    _status = 'Loading...';
    fitAll();
    fitSelectRefresh('isLoading', () => _isLoading);
    fitSelectRefresh('status', () => _status);

    // Simulate async operation
    await Future.delayed(const Duration(seconds: 2));

    _count++;
    _isLoading = false;
    _status = 'Async increment completed';
    fitAll();

    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('isLoading', () => _isLoading);
    fitSelectRefresh('status', () => _status);
  }

  // Set counter to specific value
  void setCount(int value) {
    _count = value;
    _status = 'Count set to $value';
    fitAll();

    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }

  // Double the counter
  void double() {
    _count *= 2;
    _status = 'Count doubled';
    fitAll();

    fitSelectRefresh('count', () => _count);
    fitSelectRefresh('status', () => _status);
  }
}
