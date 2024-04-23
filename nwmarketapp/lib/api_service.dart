import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> httpGetJson(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to fetch data with status code: ${response.statusCode}');
    }
  } on Exception catch (e) {
    throw Exception('Failed to load data: $e');
  }
}

Future<String> fetchServers() async {
  //15 is valhalla
  final response =
      await http.get(Uri.parse('https://nwmarketprices.com/api/servers/'));
  return response.body;
}

Future<String> fetchLatestPrices() async {
  try {
    final responseData =
        await httpGetJson('https://nwmarketprices.com/api/latest-prices/15/');
    return json.encode(
        responseData); // Assuming you want to convert the response to a JSON string
  } catch (e) {
    throw Exception('Failed to fetch latest prices: $e');
  }
}

Future<double> fetchPriceData(int itemId) async {
  try {
    final response = await http
        .get(Uri.parse('https://nwmarketprices.com/0/15?cn_id=$itemId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['recent_lowest_price']?.toDouble() ??
          0; // Ensure it's a double
    } else {
      throw Exception(
          'Failed to fetch price: Server responded with ${response.statusCode}');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Failed to fetch price data: $e'); // Log the error
    throw Exception('Error fetching price: $e');
  }
}

Future<List<double>> fetchGraphData(int itemId) async {
  try {
    final response = await http
        .get(Uri.parse('https://nwmarketprices.com/0/15?cn_id=$itemId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // Assume the recent values are the latest ones in the `price_graph_data` list
      var latestGraphData = data['price_graph_data'].first;

      List<double> prices = [
        data['recent_lowest_price']?.toDouble() ??
            0.0, // recent_lowest_price from main object
        latestGraphData['lowest_price']?.toDouble() ??
            0.0, // lowest_price from the latest price graph data
        latestGraphData['highest_buy_order']?.toDouble() ??
            0.0, // highest_buy_order from the latest price graph data
        latestGraphData['avg_price']?.toDouble() ??
            0.0, // avg_price from the latest price graph data
      ];

      return prices;
    } else {
      throw Exception(
          'Failed to fetch graph data: Server responded with ${response.statusCode}');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Failed to fetch graph data: $e'); // Log the error
    throw Exception('Error fetching graph data: $e');
  }
}

Future<Map<String, dynamic>> fetchNames() async {
  final response = await http
      .get(Uri.parse('https://nwmarketprices.com/api/confirmed_names/'));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    Map<String, dynamic> namesDict = {};
    data.forEach((key, value) {
      if (value['name_id'] != null) {
        namesDict[value['name']] = value['name_id'];
      }
    });
    return namesDict;
  } else {
    throw Exception('Failed to load names');
  }
}
