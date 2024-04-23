// hive_service.dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> initFlutter() async {
    await Hive.initFlutter();
  }

  Future<Box> openBox(String boxName) {
    return Hive.openBox(boxName);
  }
}
