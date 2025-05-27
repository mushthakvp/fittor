import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final _amountController = TextEditingController();
  String _fromCurrency = 'INR';
  String _toCurrency = 'USD';
  String _result = '';
  bool _isLoading = false;
  final CurrencyConverter _converter = CurrencyConverter();

  Future<void> _convert() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final converted = await _converter.convert(
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
        amount: amount,
      );
      setState(() => _result = '${converted.toStringAsFixed(2)} $_toCurrency');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromCurrency,
                    items:
                        ['INR', 'USD', 'EUR', 'GBP', 'JPY']
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _fromCurrency = value!),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toCurrency,
                    items:
                        ['USD', 'INR', 'EUR', 'GBP', 'JPY']
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => _toCurrency = value!),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _convert,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Convert'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Text(_result, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
