import 'package:flutter/material.dart';

import '../currency/currency_converter.dart';

/// UI utilities for currency conversion
class FittorCurrency {
  // Singleton instance
  static final FittorCurrency _instance = FittorCurrency._internal();
  factory FittorCurrency() => _instance;
  FittorCurrency._internal();

  // Reference to currency converter instance
  final CurrencyConverter _converter = CurrencyConverter();

  /// Format currency amount with specified currency code
  /// Example: formatCurrency(1234.56, 'USD') returns "$1,234.56"
  String formatCurrency(
    double amount,
    String currencyCode, {
    int decimalPlaces = 2,
  }) {
    final symbol = _getCurrencySymbol(currencyCode);
    final formattedNumber = amount
        .toStringAsFixed(decimalPlaces)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    return '$symbol$formattedNumber';
  }

  /// Get currency symbol for a currency code
  String _getCurrencySymbol(String code) {
    final Map<String, String> symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'INR': '₹',
      'AED': 'AED ',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF ',
      'CNY': '¥',
      'CZK': 'Kč',
      'DKK': 'kr',
      'HKD': 'HK\$',
    };

    return symbols[code] ?? '$code ';
  }

  /// Convert currency and format the result
  Future<String> convertAndFormat({
    required String from,
    required String to,
    required double amount,
    int decimalPlaces = 2,
  }) async {
    final convertedAmount = await _converter.convert(
      fromCurrency: from,
      toCurrency: to,
      amount: amount,
    );

    return formatCurrency(convertedAmount, to, decimalPlaces: decimalPlaces);
  }

  /// Direct access to the converter instance
  CurrencyConverter get converter => _converter;

  /// Get a text widget with formatted currency
  Widget currencyText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
