import 'package:flutter/material.dart';

import '../currency/currency_converter.dart';
import '../currency/fittor_currency.dart';

/// Extensions for easy access to currency conversion features
extension FittorCurrencyExtension on BuildContext {
  /// Get access to the currency formatter
  FittorCurrency get currency => FittorCurrency();

  /// Convert currency (from, to, amount)
  Future<double> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    return await CurrencyConverter().convert(
      fromCurrency: from,
      toCurrency: to,
      amount: amount,
    );
  }

  /// Format currency with symbol
  String formatCurrency(
    double amount,
    String currencyCode, {
    int decimalPlaces = 2,
  }) {
    return currency.formatCurrency(
      amount,
      currencyCode,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Convert and format currency
  Future<String> convertAndFormat({
    required String from,
    required String to,
    required double amount,
    int decimalPlaces = 2,
  }) async {
    return await currency.convertAndFormat(
      from: from,
      to: to,
      amount: amount,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Get exchange rate between two currencies
  Future<double> getExchangeRate(String from, String to) async {
    final rates = await CurrencyConverter().getLatestRates(from);
    return rates['rates'][to];
  }

  /// Get list of available currencies
  Future<List<CurrencyInfo>> getAvailableCurrencies() async {
    return await CurrencyConverter().getAvailableCurrencies();
  }
}
