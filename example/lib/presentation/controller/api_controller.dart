import 'dart:convert';

import 'package:fittor/fittor.dart';
import 'package:flutter/cupertino.dart';

class ApiController extends FitController {
  final client = FittorClient.instance;

  Future<void> getPosts() async {
    FittorResponse response = await client.get(
      'https://jsonplaceholder.typicode.com/posts/1',
    );
    if (response.isSuccessful) {
      final data = jsonDecode(response.body);
      debugPrint('Post: $data');
    }
  }
}
