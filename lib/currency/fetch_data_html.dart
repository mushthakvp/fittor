import 'dart:html';

Future<String> fetchData(String url) async {
  final request = await HttpRequest.request(url, method: 'GET');
  if (request.status != 200) {
    throw Exception('Failed to load data: ${request.status}');
  }
  return request.responseText ?? '';
}
