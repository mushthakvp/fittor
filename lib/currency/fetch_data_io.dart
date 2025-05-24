import 'dart:convert';
import 'dart:io';

Future<String> fetchData(String url) async {
  final uri = Uri.parse(url);
  final request = await HttpClient().getUrl(uri);
  final response = await request.close();

  if (response.statusCode != 200) {
    throw Exception('Failed to load data: ${response.statusCode}');
  }

  final contents = StringBuffer();
  await for (var data in response.transform(utf8.decoder)) {
    contents.write(data);
  }
  return contents.toString();
}
