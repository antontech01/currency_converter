import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<String> currencies = [
    "USD",
    "EUR",
    "GBP",
    "JPY",
    "CAD",
    "AUD",
    "INR",
    "CNY",
    "MXN",
    "KRW",
    "CHF"
  ];

  // The selected currencies.
  String currencyFrom = "USD";
  String currencyTo = "EUR";

  // The amount to be converted.
  double amount = 100;

  // The converted amount.
  double result = 0;

  // void convert() {
  //   setState(() {
  //     result = double.parse(textEditingController.text) * 81;
  //   });
  // }

  // Fetches the latest exchange rates from the API.
  Future<void> convert() async {
    final response = await http.get(Uri.parse(
        "https://openexchangerates.org/api/latest.json?app_id=Your-api-key"));

    if (response.statusCode == 200) {
      final exchangeRates = jsonDecode(response.body)["rates"];

      // Calculate the converted amount.
      setState(() {
        result = amount * exchangeRates[currencyTo];
      });
    } else {
      'Coversion failed, check youe connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Currency converter'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currencyTo ${result.toStringAsFixed(2)}',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
            DropdownButton<String>(
              dropdownColor: Colors.amber,
              focusColor: Colors.amber,
              value: currencyFrom,
              items: currencies
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                          currency,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  currencyFrom = value!;
                });
              },
            ),
            DropdownButton<String>(
              dropdownColor: Colors.amber,
              focusColor: Colors.amber,
              value: currencyTo,
              items: currencies
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                          currency,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  currencyTo = value!;
                });
              },
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter amount to convert',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.monetization_on_outlined),
                prefixIconColor: Colors.black,
                filled: true,
                fillColor: Colors.white,
                focusedBorder: border,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                convert();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, 50),
                ),
              ),
              child: const Text('Convert'),
            ),
          ],
        ),
      ),
    );
  }
}
