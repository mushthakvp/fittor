import 'package:fittor/fittor.dart';
import 'package:flutter/widgets.dart';

/// User controller extending FitState
class UserController extends FitState {
  String _name = 'Guest';
  int _age = 0;
  String _email = '';
  bool _isLoggedIn = false;
  List<String> _permissions = [];

  // Getters
  String get name => _name;
  int get age => _age;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  List<String> get permissions => List.unmodifiable(_permissions);
  String get displayName => '$_name (${_age}y)';
  String get userInfo => 'Name: $_name, Age: $_age, Email: $_email';

  @override
  void onInit() {
    debugPrint('UserController initialized');
    _loadUserData();
  }

  @override
  void onClose() {
    debugPrint('UserController disposed');
  }

  // Load initial user data
  void _loadUserData() {
    // Simulate loading user data
    _name = 'Guest';
    _age = 0;
    _email = '';
    _isLoggedIn = false;
    _permissions = [];
  }

  // Update user information
  void updateUser(String name, int age, {String? email}) {
    _name = name;
    _age = age;
    if (email != null) _email = email;

    fitAll();

    // Update selectors
    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('age', () => _age);
    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Login user
  void login(String name, String email, {List<String>? userPermissions}) {
    _name = name;
    _email = email;
    _isLoggedIn = true;
    _permissions = userPermissions ?? ['read'];

    fitAll();

    // Update selectors
    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('isLoggedIn', () => _isLoggedIn);
    fitSelectRefresh('permissions', () => permissions);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Logout user
  void logout() {
    _name = 'Guest';
    _email = '';
    _age = 0;
    _isLoggedIn = false;
    _permissions.clear();

    fitAll();

    // Update selectors
    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('age', () => _age);
    fitSelectRefresh('isLoggedIn', () => _isLoggedIn);
    fitSelectRefresh('permissions', () => permissions);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Update email only
  void updateEmail(String newEmail) {
    _email = newEmail;
    fittor('email'); // Only update builders with 'email' tag

    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Update age only
  void updateAge(int newAge) {
    _age = newAge;
    fittor('age'); // Only update builders with 'age' tag

    fitSelectRefresh('age', () => _age);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Add permission
  void addPermission(String permission) {
    if (!_permissions.contains(permission)) {
      _permissions.add(permission);
      fittor('permissions'); // Only update builders with 'permissions' tag

      fitSelectRefresh('permissions', () => permissions);
    }
  }

  // Remove permission
  void removePermission(String permission) {
    if (_permissions.remove(permission)) {
      fittor('permissions'); // Only update builders with 'permissions' tag

      fitSelectRefresh('permissions', () => permissions);
    }
  }

  // Check if user has permission
  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  // Update name only (with normal tag behavior)
  void updateName(String newName) {
    _name = newName;
    fittor(); // Updates builders with no tag

    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Async operation - simulate user data fetch
  Future<void> fetchUserData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock user data
    _name = 'John Doe';
    _age = 25;
    _email = 'john.doe@example.com';
    _isLoggedIn = true;
    _permissions = ['read', 'write', 'admin'];

    fitAll();

    // Update selectors
    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('age', () => _age);
    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('isLoggedIn', () => _isLoggedIn);
    fitSelectRefresh('permissions', () => permissions);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }

  // Reset user to default
  void resetUser() {
    _loadUserData();
    fitAll();

    // Update selectors
    fitSelectRefresh('name', () => _name);
    fitSelectRefresh('age', () => _age);
    fitSelectRefresh('email', () => _email);
    fitSelectRefresh('isLoggedIn', () => _isLoggedIn);
    fitSelectRefresh('permissions', () => permissions);
    fitSelectRefresh('displayName', () => displayName);
    fitSelectRefresh('userInfo', () => userInfo);
  }
}
