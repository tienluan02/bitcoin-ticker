import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'network.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    fetchAllExchangeRates(); // Fetch initial exchange rate on app start
  }

  String selectedCurrency = 'AUD';
  String crypto = 'BTC';
  Map<String, double> exchangeRate = {}; // Use nullable double to handle null cases
  final String keyApi =
      'bbcb56d1-4994-4c2a-b24e-1e9d99d0036f'; // Replace with your actual API key
  final String url = 'https://api-realtime.exrates.coinapi.io/v1/exchangerate';

  // Fetch the exchange rate and update state
  Future<void> fetchAllExchangeRates() async {
    try {
      for (String crypto in cryptoList) {
        final rate = await Network(url, keyApi).getCurrencyData(crypto, selectedCurrency);
        setState(() {
          exchangeRate[crypto] = rate['rate']; // Store the rate for each crypto
        });
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      setState(() {
        for (String crypto in cryptoList) {
          exchangeRate[crypto] = 0.0; // Default to 0 if there's an error
        }
      });
    }
  }

  Future<void> fetchExchangeRate(String crypto) async {
    try {
      final rate = await Network(url, keyApi).getCurrencyData(crypto, selectedCurrency);
      setState(() {
        exchangeRate[crypto] = rate['rate'];
      });
    } catch (e) {
      print('Error fetching exchange rate for $crypto: $e');
      setState(() {
        exchangeRate[crypto] = 0.0; // Default to 0 if there's an error
      });
    }
  }

  Widget getAndroidButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newCurrency = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newCurrency);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
        fetchAllExchangeRates(); // Fetch new rate when currency changes
      },
    );
  }

  Widget getIosButton() {
    List<Widget> scrollItems = [];
    for (String currency in currenciesList) {
      scrollItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        fetchAllExchangeRates(); // Fetch new rate after updating selectedCurrency
      },
      children: scrollItems,
    );
  }

  Widget androidOrIos() {
    if (Platform.isIOS) {
      return getIosButton();
    } else {
      return getAndroidButton();
    }
  }

  Column displayContainer() {
    List<Widget> cards = [];
    for (String crypto in cryptoList) {
      cards.add(Padding(
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
              '1 $crypto = ${exchangeRate[crypto]?.toStringAsFixed(2) ?? 'Loading...'} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
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
          Column(
            children: [
              displayContainer(),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: androidOrIos(),
          ),
        ],
      ),
    );
  }
}
