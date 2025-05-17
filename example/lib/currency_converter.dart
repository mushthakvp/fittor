// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';

class CurrencyConverterExample extends StatefulWidget {
  const CurrencyConverterExample({super.key});

  @override
  State<CurrencyConverterExample> createState() =>
      _CurrencyConverterExampleState();
}

class _CurrencyConverterExampleState extends State<CurrencyConverterExample>
    with FittorMixin {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'INR';
  String _toCurrency = 'USD';
  String _result = '';
  bool _isLoading = false;
  List<CurrencyInfo> _availableCurrencies = [];

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _availableCurrencies = await context.getAvailableCurrencies();
    } catch (e) {
      log("Error loading currencies: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading currencies: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final formattedResult = await context.convertAndFormat(
        from: _fromCurrency,
        to: _toCurrency,
        amount: amount,
      );

      setState(() {
        _result = formattedResult;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error converting currency: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount input
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: p16),

            // Currency selectors
            Row(
              children: [
                Expanded(
                  child: _buildCurrencyDropdown(
                    value: _fromCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _fromCurrency = value;
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: p8),
                  child: const Icon(Icons.arrow_forward),
                ),

                Expanded(
                  child: _buildCurrencyDropdown(
                    value: _toCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _toCurrency = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: p16),

            // Convert button
            ElevatedButton(
              onPressed: _isLoading ? null : _convertCurrency,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Convert'),
            ),

            SizedBox(height: p24),

            // Result
            if (_result.isNotEmpty)
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(p16),
                  child: Column(
                    children: [
                      Text(
                        'Result',
                        style: TextStyle(
                          fontSize: context.fs16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: p8),
                      Text(
                        _result,
                        style: TextStyle(
                          fontSize: context.fs24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Text(
              'This is a demo of how to use the currency converter package.',
              textAlign: TextAlign.center,
            ),
            30.h,
            Text(
              'To convert a currency:',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              connectivityWrapper,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            20.h,
            HighlightView(
              fittorCurrencyUtilities,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            30.h,
            Text(
              'Basic Currency Conversion',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              basicCurrencyConversion,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            30.h,
            Text(
              'Convert and Format',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              convertAndFormat,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            20.h,
            Text(
              'Get Exchange Rate',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              getExchangeRate,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
            20.h,
            Text(
              'Get Available Currencies',
              style: TextStyle(
                fontSize: context.fs16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            20.h,
            HighlightView(
              getAvailableCurrencies,
              language: 'dart',
              theme: themeMap['solarized-dark']!,
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: p8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(r4),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items:
            _isLoading
                ? [DropdownMenuItem(value: value, child: Text(value))]
                : _availableCurrencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency.code,
                    child: Text(currency.code),
                  );
                }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

String connectivityWrapper = '''
// Example: Convert 100 INR to USD
final convertedAmount = await context.convertCurrency(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);

// Or with formatting
final formattedResult = await context.convertAndFormat(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);
''';

String fittorCurrencyUtilities = '''
final currencyUtils = FittorCurrency();

// Create a currency text widget
Widget priceText = currencyUtils.currencyText(
  '\$1,234.56',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);
''';

String basicCurrencyConversion = '''// Convert 100 INR to USD
double usdAmount = await context.convertCurrency(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);

print('100 INR = usdAmount USD');''';

String convertAndFormat = '''
// Convert and format with currency symbol
String formattedAmount = await context.convertAndFormat(
  from: 'INR',
  to: 'USD',
  amount: 100.0,
);

print('100 INR = formattedAmount'); // Outputs: 100 INR = 1.17
''';

String getExchangeRate =
    '''// Get the current exchange rate between two currencies
double rate = await context.getExchangeRate('INR', 'USD');
print('1 INR = rate USD');''';

String getAvailableCurrencies = '''
// Get list of all available currencies
List<CurrencyInfo> currencies = await context.getAvailableCurrencies();
for (var currency in currencies) {
  print('{currency.code}: {currency.rate}');
}
''';
