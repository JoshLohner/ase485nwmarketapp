import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'api_service.dart'; // Importing the fetchlatestPrices and fetchNames functions
import 'search_page.dart'; // Importing the SearchPage
import 'other_page.dart';

void main() async {
  Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box _favBox;
  Map<String, dynamic>? namesDict;
  String _serverData = '';
  bool _isLoading = false;
  int _selectedIndex = 0;

  List<String> _names = [];
  List<double> _prices = [];

  @override
  void initState() {
    super.initState();
    _createNameDict();
    _initializeHiveBox();
  }

  Future<void> _initializeHiveBox() async {
    _favBox = await Hive.openBox('favBox');
    await _createNameDict(); // Wait for fetchNames() to complete
    extractValues(_favBox);
    setPrices(_favBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Demo'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _names.length,
              itemBuilder: (BuildContext context, int index) {
                // Check if the index is valid before accessing elements
                if (index >= 0 && index < _names.length) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _names[index],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  _prices.isNotEmpty
                                      ? '\$${_prices[index]}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  _removeFromFavorites(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.insert_chart),
                                onPressed: () {
                                  // Add your logic here for the graph button
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Return an empty container or placeholder widget if index is out of range
                  return Container();
                }
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Other',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              displayAllItems(_favBox);
              print("before");
              setPrices(_favBox);
              print("after");
            },
            tooltip: 'Load Servers',
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 16), // Adding some spacing between the buttons
        ],
      ),
    );
  }

  void setPrices(Box box) async {
    List<double> prices = [];
    for (var key in box.keys) {
      var value = box.get(key);
      double result = await fetchSingleItemPrice(namesDict?[value]);

      prices.add(result);
      // Assuming result is a string representation of a double
    }

    setState(() {
      _prices = prices;
      print(_prices);
    });
  }

  void extractValues(Box box) {
    setState(() {
      _names.clear(); // Clear the existing list before populating it again
      for (var value in box.values) {
        _names.add(value
            .toString()); // Convert the value to a string and add it to the list
      }
    });
  }

  void displayAllItems(Box box) {
    for (var key in box.keys) {
      var value = box.get(key);
      print('Key: $key, Value: $value');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadServers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final serverData = await fetchServers();

      setState(() {
        _serverData = serverData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _createNameDict() async {
    setState(() {
      _isLoading = true;
    });
    try {
      namesDict = await fetchNames(); // Assign fetchNames result to namesDict

      setState(() {
        // Update state or perform other operations as needed
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _removeFromFavorites(int index) {
    if (index >= 0 && index < _names.length) {
      String nameToRemove = _names[index];
      _favBox.delete(nameToRemove); // Remove item from favBox
      setState(() {
        _names.removeAt(index); // Remove item from _names list
        _prices.removeAt(index); // Remove corresponding price
      });
    }
  }
}
