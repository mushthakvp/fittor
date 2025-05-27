class FittorHeaders {
  final Map<String, List<String>> _headers;

  FittorHeaders([Map<String, dynamic>? headers])
      : _headers = <String, List<String>>{} {
    if (headers != null) {
      headers.forEach((key, value) {
        set(key, value);
      });
    }
  }

  void set(String name, dynamic value) {
    final key = name.toLowerCase();
    if (value is String) {
      _headers[key] = [value];
    } else if (value is List<String>) {
      _headers[key] = List.from(value);
    } else if (value is List) {
      _headers[key] = value.map((v) => v.toString()).toList();
    } else {
      _headers[key] = [value.toString()];
    }
  }

  void add(String name, String value) {
    final key = name.toLowerCase();
    _headers.putIfAbsent(key, () => []).add(value);
  }

  String? get(String name) {
    final values = getAll(name);
    return values.isEmpty ? null : values.first;
  }

  List<String> getAll(String name) {
    return _headers[name.toLowerCase()] ?? [];
  }

  void remove(String name) {
    _headers.remove(name.toLowerCase());
  }

  bool contains(String name) {
    return _headers.containsKey(name.toLowerCase());
  }

  void clear() {
    _headers.clear();
  }

  Map<String, String> toMap() {
    final result = <String, String>{};
    _headers.forEach((key, values) {
      if (values.isNotEmpty) {
        result[key] = values.join(', ');
      }
    });
    return result;
  }

  Map<String, List<String>> toMultiMap() {
    return Map.from(_headers);
  }

  // Common headers
  String? get contentType => get('content-type');
  set contentType(String? value) =>
      value != null ? set('content-type', value) : remove('content-type');

  String? get userAgent => get('user-agent');
  set userAgent(String? value) =>
      value != null ? set('user-agent', value) : remove('user-agent');

  String? get authorization => get('authorization');
  set authorization(String? value) =>
      value != null ? set('authorization', value) : remove('authorization');

  String? get accept => get('accept');
  set accept(String? value) =>
      value != null ? set('accept', value) : remove('accept');

  @override
  String toString() {
    return 'FittorHeaders($_headers)';
  }
}
