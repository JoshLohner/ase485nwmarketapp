// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nwmarketapp/api_service.dart';
import 'graph_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
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
                      return const Text("Loading latest price...");
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Text("Latest price: ${snapshot.data.toString()}");
                    }
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures the row takes minimum space required by children
                  children: [
                    IconButton(
                      icon: const Icon(Icons.show_chart),
                      onPressed: () async {
                        try {
                          List<double> prices =
                              await fetchGraphData(itemId); // Fetch data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GraphPage(prices: prices)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to load data: $e')));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        box.delete(key); // This already exists in your code
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
