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

Future<Map<String, dynamic>> fetchNames() async {
  final data =
      await httpGetJson('https://nwmarketprices.com/api/confirmed_names/');
  Map<String, dynamic> namesDict = {};

  data.forEach((key, value) {
    if (value['name_id'] != null) {
      namesDict[value['name']] = value['name_id'];
    }
  });

  return namesDict;
}

Future<double> fetchPriceData(int item_id) async {
  final responseData =
      await httpGetJson('https://nwmarketprices.com/0/15?cn_id=$item_id');
  return responseData['recent_lowest_price'];
}
