import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  Network(this.Url, this.keyApi);

  final String Url;
  final String keyApi;

  Future<dynamic> getCurrencyData(
      String firstCurrency, String secondCurrency) async {
    var url = await Uri.parse('$Url/$firstCurrency/$secondCurrency');
    try {
      final response = await http.get(
        url,
        headers: {
          'X-CoinAPI-Key': keyApi,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load exchange rate: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate (1): $e');
    }
  }
}
