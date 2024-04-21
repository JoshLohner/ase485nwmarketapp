import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('itemsBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _namesDict = {}; // This will hold the fetched names
  Map<String, dynamic> _filteredNames = {};

  @override
  void initState() {
    super.initState();
    fetchNames().then((data) {
      setState(() {
        _namesDict = data;
        _filteredNames = _namesDict;
      });
    });
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

  void _filterNames(String enteredKeyword) {
    Map<String, dynamic> results = {};
    if (enteredKeyword.isEmpty) {
      results = _namesDict;
    } else {
      results = Map.fromEntries(_namesDict.entries.where((entry) => entry.key
          .toString()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())));
    }
    setState(() {
      _filteredNames = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Items"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                _filterNames(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNames.length,
              itemBuilder: (context, index) {
                String key = _filteredNames.keys.elementAt(index);
                return ListTile(
                  title: Text(key),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Hive.box('itemsBox').put(
                          key,
                          _namesDict[
                              key]); // Store the item ID associated with the name
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        },
        child: Icon(Icons.dashboard),
        tooltip: 'Go to Dashboard',
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<double> fetchPriceData(int item_id) async {
    try {
      final response = await http
          .get(Uri.parse('https://nwmarketprices.com/0/15?cn_id=$item_id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data['recent_lowest_price']?.toDouble() ??
            0; // Ensure it's a double
      } else {
        throw Exception(
            'Failed to fetch price: Server responded with ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch price data: $e'); // Log the error
      throw Exception('Error fetching price: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('itemsBox').listenable(),
        builder: (context, Box box, widget) {
          return ListView.builder(
            itemCount: box.keys.length,
            itemBuilder: (context, index) {
              String key = box.keyAt(index);
              int itemId =
                  box.get(key); // Assuming the value stored is the item ID

              return ListTile(
                title: Text(key),
                subtitle: FutureBuilder<double>(
                  future: fetchPriceData(itemId),
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading latest price...");
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Text("Latest price: ${snapshot.data.toString()}");
                    }
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    box.delete(key);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
