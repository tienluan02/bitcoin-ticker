import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  @override
  void initState() {
    super.initState();
    getCurrencyData('BTC', selectedCurrency);
  }

  String selectedCurrency = 'USD';
  final String keyApi = 'bbcb56d1-4994-4c2a-b24e-1e9d99d0036f';

  Widget getAndroidButton() {
    List<DropdownMenuItem<String>> DropDownItem = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> newCurrency = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      DropDownItem.add(newCurrency);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: DropDownItem,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
      },
    );
  }

  Widget getIosButton() {
    List<Widget> ScrollItem = [];
    for (String currency in currenciesList) {
      ScrollItem.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: ScrollItem,
    );
  }

  Widget AndroidOrIos() {
    if (Platform.isIOS) {
      return getIosButton();
    } else {
      return getAndroidButton();
    }
  }

  Future<double> getCurrencyData(
      String firstCurrency, String secondCurrency) async {
    var url = await Uri.parse(
        'https://api-realtime.exrates.coinapi.io/v1/exchangerate/$firstCurrency/$secondCurrency');
    try {
      final response = await http.get(
        url,
        headers: {
          'X-CoinAPI-Key': keyApi,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rate'] as double;
      } else {
        throw Exception('Failed to load exchange rate: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ? $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: AndroidOrIos(),
          ),
        ],
      ),
    );
  }
}
