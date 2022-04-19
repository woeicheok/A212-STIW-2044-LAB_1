import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAB_1',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyExchangeratesPage(),
    );
  }
}

class MyExchangeratesPage extends StatefulWidget {
  const MyExchangeratesPage({Key? key}) : super(key: key);

  @override
  State<MyExchangeratesPage> createState() => _MyExchangeratesPageState();
}

class _MyExchangeratesPageState extends State<MyExchangeratesPage> {
  String selectCoin = "Bitcoin",
      description = "Select A Coins to see the rates",
      exchangerate = "";

  var name, unit, value, type;
  List<String> coinList = [
    "Bitcoin",
    "Ether",
    "Litecoin",
    "Bitcoin Cash",
    "Binance Coin",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cryptocurrency Value Exchange")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Cryptocurrency Value Exchange",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              itemHeight: 60,
              value: selectCoin,
              onChanged: (newValue) {
                setState(() {
                  selectCoin = newValue.toString();
                });
              },
              items: coinList.map((selectCoin) {
                return DropdownMenuItem(
                  child: Text(
                    selectCoin,
                  ),
                  value: selectCoin,
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: _exchangerates, child: const Text("Exchange Rates")),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ],
        )));
  }

  Future<void> _exchangerates() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress..."), title: const Text("Searching..."));
    progressDialog.show();

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      name = parsedData['rates']['name'];
      value = parsedData['rates']['value'];
      type = parsedData['rates']['type'];
      unit = parsedData['rates']['unit'];
      setState(() {
        description = "$selectCoin value = $value type= $type unit is $unit";
      });
      progressDialog.dismiss();
    }
  }
}
