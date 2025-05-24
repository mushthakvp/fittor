import 'dart:html';

// This file is for web-specific implementations of data fetching.
Future<String> fetchData(String url) async {
  // Use the HttpRequest object to fetch data from the given URL.
  final request = await HttpRequest.request(url, method: 'GET');
  // Check if the request was successful.
  if (request.status != 200) {
    // Throw an exception if the request failed.
    throw Exception('Failed to load data: ${request.status}');
  }
  // Return the response text.
  return request.responseText ?? '';
}
