import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchServers() async {
  //15 is valhalla
  final response =
      await http.get(Uri.parse('https://nwmarketprices.com/api/servers/'));
  return response.body;
}

Future<String> fetchlatestPrices() async {
  final response = await http
      .get(Uri.parse('https://nwmarketprices.com/api/latest-prices/15/'));
  return response.body;
}

Future<Map<String, dynamic>> fetchNames() async {
  final response = await http
      .get(Uri.parse('https://nwmarketprices.com/api/confirmed_names/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    Map<String, dynamic> namesDict = {};

    // Iterate through each entry and extract name and name_id
    data.forEach((key, value) {
      String name = value['name'];
      dynamic nameId = value['name_id'];

      // Check if name_id is not null before adding to dictionary
      if (nameId != null) {
        namesDict[name] = nameId; // Add entry to dictionary
      }
    });

    return namesDict;
  } else {
    throw Exception('Failed to load names');
  }
}

Future<double> fetchSingleItemPrice(int item_id) async {
  final response = await http
      .get(Uri.parse('https://nwmarketprices.com/0/15?cn_id=$item_id'));
  Map<String, dynamic> responseData = jsonDecode(response.body);
  double recentLowestPrice = responseData['recent_lowest_price'];

  return recentLowestPrice;
}

Future<double> fetchPriceData(int item_id) async {
  final response = await http
      .get(Uri.parse('https://nwmarketprices.com/0/15?cn_id=$item_id'));
  Map<String, dynamic> responseData = jsonDecode(response.body);
  print(responseData);
  double recentLowestPrice = responseData['recent_lowest_price'];

  return recentLowestPrice;
}
