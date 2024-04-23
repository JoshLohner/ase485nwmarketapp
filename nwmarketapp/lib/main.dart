import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'search_page.dart';
import 'hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveService hiveService = HiveService();
  await hiveService.initFlutter();
  await hiveService.openBox('itemsBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
