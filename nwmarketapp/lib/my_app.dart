import 'package:flutter/material.dart';
import 'api_service.dart'; // Importing the fetchlatestPrices and fetchNames functions
import 'search_page.dart'; // Importing the SearchPage
import 'other_page.dart'; // Importing the OtherPage
import 'database_helper.dart'; // Importing the DatabaseHelper

void main() {
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
  String _serverData = '';

  bool _isLoading = false;
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    SearchPage(),
    OtherPage(),
  ];

  DatabaseHelper dbHelper = DatabaseHelper();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Demo'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _serverData,
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
            onPressed: () {
              _loadServers();
            },
            tooltip: 'Load Servers',
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 16), // Adding some spacing between the buttons
          FloatingActionButton(
            onPressed: () {
              _createNameDict();
            },
            tooltip: 'Name Dict',
            child: Icon(Icons.add), // You can change the icon as needed
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _loadServers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final serverData = await fetchServers();

      setState(() {
        _serverData = serverData;
        //print(_serverData);

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
      Map<String, dynamic> names = await fetchNames();

      setState(() {
        print(names);
        print(names['Iron Ore']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
}
