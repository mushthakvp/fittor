import 'dart:convert';
import 'dart:io';

/// Fetches data from the given URL using [HttpClient].
/// This implementation is for non-web platforms (e.g., mobile, desktop).
/// It uses the [dart:io] library to make HTTP requests.
/// [url] - The URL to fetch data from.
/// Returns the response body as a string.
/// Throws an exception if the request fails.
/// [url] - The URL to fetch data from.
Future<String> fetchData(String url) async {
  /// Parse the URL to create a [Uri] object.
  final uri = Uri.parse(url);

  /// Create a new [HttpClient] instance.
  final request = await HttpClient().getUrl(uri);

  /// Set the request headers.
  final response = await request.close();

  /// Check if the response status code is 200 (OK).
  if (response.statusCode != 200) {
    /// If not, throw an exception with the status code.
    throw Exception('Failed to load data: ${response.statusCode}');
  }

  /// Read the response body as a string.
  /// This is done using a [StringBuffer] to accumulate the data.
  /// The response is transformed using [utf8.decoder] to decode the bytes.
  /// The [await for] loop reads the data asynchronously.
  /// The final result is returned as a string.
  /// The [StringBuffer] is used to efficiently concatenate the data.
  final contents = StringBuffer();

  /// Read the response body as a string.
  /// This is done using a [StringBuffer] to accumulate the data.
  /// The response is transformed using [utf8.decoder] to decode the bytes.
  /// The [await for] loop reads the data asynchronously.
  await for (var data in response.transform(utf8.decoder)) {
    contents.write(data);
  }
  return contents.toString();
}
