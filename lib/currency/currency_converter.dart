import 'dart:async';
import 'dart:convert';

import '../api/client/universal_client.dart';

/// Currency converter service that uses the Exchange Rate API
/// https://open.er-api.com/
class CurrencyConverter {
  // Singleton instance
  static final CurrencyConverter _instance = CurrencyConverter._internal();
  factory CurrencyConverter() => _instance;
  CurrencyConverter._internal();

  // Cache for the latest exchange rates to avoid unnecessary API calls
  Map<String, dynamic>? _cachedRates;
  String? _cachedBaseCode;
  DateTime? _lastUpdated;
  DateTime? _nextUpdate;

  // Cache validity in minutes (15 minutes default)
  final int _cacheValidityMinutes = 15;

  /// Get latest exchange rates for a specific base currency
  /// [baseCode] is the three-letter currency code (e.g., 'USD', 'INR', 'EUR')
  Future<Map<String, dynamic>> getLatestRates(String baseCode) async {
    // Check if we have valid cached rates for this base currency
    if (_cachedRates != null &&
        _cachedBaseCode == baseCode &&
        _lastUpdated != null &&
        DateTime.now().difference(_lastUpdated!).inMinutes <
            _cacheValidityMinutes) {
      return _cachedRates!;
    }

    // If no valid cache, fetch new data
    try {
      final url = 'https://open.er-api.com/v6/latest/$baseCode';
      final response = await _fetchData(url);

      // Parse response
      final data = jsonDecode(response);

      if (data['result'] == 'success') {
        // Cache the new data
        _cachedRates = data;
        _cachedBaseCode = baseCode;
        _lastUpdated = DateTime.now();

        // Parse next update time
        if (data['time_next_update_utc'] != null) {
          try {
            _nextUpdate = DateTime.parse(data['time_next_update_utc']);
          } catch (e) {
            // If parsing fails, set next update to 24 hours from now
            _nextUpdate = DateTime.now().add(const Duration(hours: 24));
          }
        }

        return data;
      } else {
        throw Exception(
          'Failed to load exchange rates: ${data['error-type'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  /// Convert an amount from one currency to another
  /// [fromCurrency] - Source currency code (e.g., 'USD')
  /// [toCurrency] - Target currency code (e.g., 'EUR')
  /// [amount] - Amount to convert
  Future<double> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    // Get latest rates with the fromCurrency as base
    final ratesData = await getLatestRates(fromCurrency);

    // Get the exchange rate for the target currency
    final rates = ratesData['rates'];
    if (rates == null || !rates.containsKey(toCurrency)) {
      throw Exception('Exchange rate not available for $toCurrency');
    }

    // Calculate converted amount
    final rate = rates[toCurrency];
    return amount * rate;
  }

  /// Get a list of all available currencies
  Future<List<CurrencyInfo>> getAvailableCurrencies() async {
    // We'll use USD as base to get all available currencies
    final ratesData = await getLatestRates('USD');
    final rates = ratesData['rates'];

    if (rates == null) {
      throw Exception('Failed to retrieve available currencies');
    }

    final List<CurrencyInfo> currencies = [];
    rates.forEach((String code, dynamic rate) {
      if (rate is num) {
        currencies.add(CurrencyInfo(code: code, rate: rate.toDouble()));
      }
    });

    return currencies;
  }

  /// Fetch data from URL using built-in Dart functionality
  final client = FittorClient.instance;

  /// Fetch data from URL using built-in Dart functionality
  Future<String> _fetchData(String url) async {
    /// Get Data Using Fittor Client
    final response = await client.get(url);
    if (response.isSuccessful) {
      return response.body;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  /// Get information about the cache status
  Map<String, dynamic> getCacheInfo() {
    return {
      'hasCachedData': _cachedRates != null,
      'baseCurrency': _cachedBaseCode,
      'lastUpdated': _lastUpdated?.toIso8601String(),
      'nextUpdate': _nextUpdate?.toIso8601String(),
      'cacheValidityMinutes': _cacheValidityMinutes,
    };
  }
}

/// Model class for currency information
class CurrencyInfo {
  final String code;
  final double rate;

  CurrencyInfo({required this.code, required this.rate});

  @override
  String toString() => '$code (Rate: $rate)';
}
