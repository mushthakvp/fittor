// File: lib/bin/custom_fittor_impl.dart
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  final runner = CommandRunner('fittor', 'Fittor project structure generator')
    ..addCommand(CreateCommand());

  try {
    runner.run(arguments);
  } catch (e) {
    debugPrint('Error: $e');
    runner.printUsage();
  }
}

class CreateCommand extends Command {
  @override
  final name = 'create';

  @override
  final description = 'Creates the standard Fittor project structure';

  @override
  void run() {
    createFittorStructure(Directory.current);
  }
}

void createFittorStructure(Directory baseDir) {
  debugPrint('🚀 Creating Fittor project structure...');

  // Always create or overwrite main.dart with the template
  final mainFile = File(path.join(baseDir.path, 'lib', 'main.dart'));

  // Create directory if needed
  if (!mainFile.parent.existsSync()) {
    mainFile.parent.createSync(recursive: true);
  }

  // Always write the template, regardless of whether the file exists
  mainFile.writeAsStringSync(_mainDartTemplate());

  if (mainFile.existsSync()) {
    debugPrint('✅ Created/Replaced lib/main.dart with Fittor template');
  } else {
    debugPrint('❌ Failed to create lib/main.dart');
  }

  // Create fittor directory structure
  final fittorDir = Directory(path.join(baseDir.path, 'lib', 'fittor'));

  // Create core folder structure
  _createDirectory(fittorDir, 'core/network');
  _createFile(fittorDir, 'core/network/api_client.dart', _apiClientTemplate());

  _createDirectory(fittorDir, 'core/util');
  _createFile(fittorDir, 'core/util/constants.dart', _constantsTemplate());

  _createDirectory(fittorDir, 'core/routes');
  _createFile(fittorDir, 'core/routes/app_routes.dart', _appRoutesTemplate());

  debugPrint('✅ Created core folder structure');

  // Create data folder structure
  _createDirectory(fittorDir, 'data/model');
  _createFile(
    fittorDir,
    'data/model/sample_model.dart',
    _sampleModelTemplate(),
  );

  _createDirectory(fittorDir, 'data/repo');
  _createFile(
    fittorDir,
    'data/repo/sample_repository.dart',
    _sampleRepositoryTemplate(),
  );

  _createDirectory(fittorDir, 'data/source');
  _createFile(
    fittorDir,
    'data/source/sample_data_source.dart',
    _sampleDataSourceTemplate(),
  );

  debugPrint('✅ Created data folder structure');

  // Create presentation folder structure
  _createDirectory(fittorDir, 'presentation/screen');
  _createFile(
    fittorDir,
    'presentation/screen/sample_screen.dart',
    _sampleScreenTemplate(),
  );

  _createDirectory(fittorDir, 'presentation/controller');
  _createFile(
    fittorDir,
    'presentation/controller/sample_controller.dart',
    _sampleControllerTemplate(),
  );

  debugPrint('✅ Created presentation folder structure');

  // Create index files for each main folder
  _createIndexFile(fittorDir, 'core', ['network', 'util', 'routes']);
  _createIndexFile(fittorDir, 'data', ['model', 'repo', 'source']);
  _createIndexFile(fittorDir, 'presentation', ['screen', 'controller']);
  debugPrint('✅ Created index.dart files');

  // Create main index file for fittor directory
  final mainIndexFile = File(path.join(fittorDir.path, 'index.dart'));
  if (!mainIndexFile.existsSync()) {
    mainIndexFile.createSync(recursive: true);
    mainIndexFile.writeAsStringSync('''library fittor;

export 'core/index.dart';
export 'data/index.dart';
export 'presentation/index.dart';
''');
  }

  debugPrint('\n🎉 Fittor project structure created successfully!');
  debugPrint('\nRecommended next steps:');
  debugPrint('  1. Update your pubspec.yaml to include required dependencies');
  debugPrint(
    '  2. Create your app routes in lib/fittor/core/routes/app_routes.dart',
  );
  debugPrint('  3. Define your data models in lib/fittor/data/model');
  debugPrint('  4. Run "flutter pub get" to fetch dependencies');
  debugPrint('''
      Email: mail.musthak@gmail.com
      WhatsApp: +919061213930
      LinkedIn: Mushthak VP
      Instagram: @musth4k
''');
}

void _createDirectory(Directory baseDir, String relativePath) {
  final directory = Directory(path.join(baseDir.path, relativePath));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    debugPrint('  Created directory: $relativePath');
  }
}

void _createFile(Directory baseDir, String relativePath, String content) {
  final file = File(path.join(baseDir.path, relativePath));
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
    debugPrint('  Created file: $relativePath');
  } else {
    debugPrint('  File already exists, skipping: $relativePath');
  }
}

void _createIndexFile(
  Directory baseDir,
  String folderName,
  List<String> subfolders,
) {
  final indexFile = File(path.join(baseDir.path, folderName, 'index.dart'));
  if (!indexFile.existsSync()) {
    indexFile.createSync(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('library fittor.$folderName;');
    buffer.writeln();

    // Add exports for each subfolder's index file
    for (final subfolder in subfolders) {
      // Export the individual files in each subfolder
      final subDir = Directory(path.join(baseDir.path, folderName, subfolder));
      if (subDir.existsSync()) {
        for (final entity in subDir.listSync()) {
          if (entity is File &&
              entity.path.endsWith('.dart') &&
              !entity.path.endsWith('index.dart')) {
            final relativePath = path.basename(entity.path);
            buffer.writeln('export \'$subfolder/$relativePath\';');
          }
        }
      }
    }

    indexFile.writeAsStringSync(buffer.toString());
  }
}

String _mainDartTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'fittor/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fittor App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fittor App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Welcome to Fittor!'),
      ),
    );
  }
}
''';
}

String _apiClientTemplate() {
  return '''
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Base API client for handling network requests
class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Performs a GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _httpClient.get(
      Uri.parse('\$baseUrl\$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    
    return _handleResponse(response);
  }

  /// Performs a POST request
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await _httpClient.post(
      Uri.parse('\$baseUrl\$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    
    return _handleResponse(response);
  }

  /// Handle API response and error cases
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: \${response.statusCode} \${response.body}');
    }
  }
  
  /// Close the client when done
  void dispose() {
    _httpClient.close();
  }
}
''';
}

String _constantsTemplate() {
  return '''
/// Application constants
class AppConstants {
  // API URLs
  static const String apiBaseUrl = 'https://api.example.com';
  
  // Asset paths
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  
  // Don't allow instantiation
  AppConstants._();
}
''';
}

String _appRoutesTemplate() {
  return '''
import 'package:flutter/material.dart';
import '../../../fittor/presentation/screen/sample_screen.dart';

/// Handles all the routes for the application
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String profile = '/profile';
  
  /// Route generator function for MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const SampleScreen(title: 'Home'),
        );
      case detail:
        return MaterialPageRoute(
          builder: (_) => const SampleScreen(title: 'Detail'),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const SampleScreen(title: 'Profile'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
  
  // Don't allow instantiation
  AppRoutes._();
}
''';
}

String _sampleModelTemplate() {
  return '''
/// Sample data model class
class SampleModel {
  final int id;
  final String title;
  final String description;
  
  SampleModel({
    required this.id,
    required this.title,
    required this.description,
  });
  
  /// Create from JSON map
  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
  
  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
  
  /// Create a copy with updated fields
  SampleModel copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return SampleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
''';
}

String _sampleRepositoryTemplate() {
  return '''
import '../model/sample_model.dart';
import '../source/sample_data_source.dart';

/// Sample repository implementation
class SampleRepository {
  final SampleDataSource _dataSource;
  
  SampleRepository({SampleDataSource? dataSource})
    : _dataSource = dataSource ?? SampleDataSource();
  
  /// Get all items
  Future<List<SampleModel>> getAllItems() async {
    try {
      final data = await _dataSource.fetchItems();
      return data.map((json) => SampleModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get items: \$e');
    }
  }
  
  /// Get item by ID
  Future<SampleModel> getItemById(int id) async {
    try {
      final json = await _dataSource.fetchItemById(id);
      return SampleModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to get item \$id: \$e');
    }
  }
  
  /// Create new item
  Future<SampleModel> createItem(SampleModel item) async {
    try {
      final json = await _dataSource.createItem(item.toJson());
      return SampleModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to create item: \$e');
    }
  }
}
''';
}

String _sampleDataSourceTemplate() {
  return '''
import '../../core/network/api_client.dart';
import '../../core/util/constants.dart';

/// Data source for Sample items
class SampleDataSource {
  final ApiClient _apiClient;
  
  SampleDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(baseUrl: AppConstants.apiBaseUrl);
  
  /// Fetch all items from API
  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await _apiClient.get('/items');
    return List<Map<String, dynamic>>.from(response['data']);
  }
  
  /// Fetch specific item by ID
  Future<Map<String, dynamic>> fetchItemById(int id) async {
    final response = await _apiClient.get('/items/\$id');
    return response['data'];
  }
  
  /// Create a new item
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/items', body: data);
    return response['data'];
  }
  
  /// Dispose resources
  void dispose() {
    _apiClient.dispose();
  }
}
''';
}

String _sampleScreenTemplate() {
  return '''
import 'package:flutter/material.dart';
import '../controller/sample_controller.dart';

/// A sample screen demonstrating Fittor architecture
class SampleScreen extends StatefulWidget {
  final String title;
  
  const SampleScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  final _controller = SampleController();
  
  @override
  void initState() {
    super.initState();
    _controller.loadItems();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ValueListenableBuilder(
        valueListenable: _controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ValueListenableBuilder(
            valueListenable: _controller.items,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return const Center(child: Text('No items available'));
              }
              
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    onTap: () => _controller.selectItem(item),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';
}

String _sampleControllerTemplate() {
  return '''
import 'package:flutter/foundation.dart';
import '../../data/model/sample_model.dart';
import '../../data/repo/sample_repository.dart';

/// Controller for managing Sample data and business logic
class SampleController {
  final SampleRepository _repository;
  
  /// Observable state
  final items = ValueNotifier<List<SampleModel>>([]);
  final isLoading = ValueNotifier<bool>(false);
  final selectedItem = ValueNotifier<SampleModel?>(null);
  
  SampleController({SampleRepository? repository})
    : _repository = repository ?? SampleRepository();
  
  /// Load all items
  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      final result = await _repository.getAllItems();
      items.value = result;
    } catch (e) {
      debugPrint('Error loading items: \$e');
      // Handle error appropriately
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Select an item for detailed view
  void selectItem(SampleModel item) {
    selectedItem.value = item;
    // Additional navigation logic could be added here
  }
  
  /// Add a new sample item
  Future<void> addItem() async {
    final newItem = SampleModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'New Item',
      description: 'Sample description',
    );
    
    isLoading.value = true;
    try {
      final createdItem = await _repository.createItem(newItem);
      items.value = [...items.value, createdItem];
    } catch (e) {
      debugPrint('Error creating item: \$e');
      // Handle error appropriately
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Clean up resources
  void dispose() {
    items.dispose();
    isLoading.dispose();
    selectedItem.dispose();
  }
}
''';
}
