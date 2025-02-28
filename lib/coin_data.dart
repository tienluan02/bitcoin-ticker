import 'dart:convert';
import 'package:http/http.dart' as http;

final String keyApi = 'bbcb56d1-4994-4c2a-b24e-1e9d99d0036f';
final String Url = 'https://api-realtime.exrates.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future<double> getCurrencyData(
      String firstCurrency, String secondCurrency) async {
    var url = await Uri.parse(
        '$Url/$firstCurrency/$secondCurrency');
    try {
      final response = await http.get(
        url,
        headers: {
          'X-CoinAPI-Key': keyApi,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return await data['rate'] as double;
      } else {
        throw Exception('Failed to load exchange rate: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }
}
