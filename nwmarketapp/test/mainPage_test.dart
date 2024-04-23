import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:nwmarketapp/main.dart'; // Adjust the import path
import 'package:nwmarketapp/hive_service.dart';
import 'package:nwmarketapp/search_page.dart';

class MockHiveService extends Mock implements HiveService {}

class MockBox extends Mock implements Box {}

void main() {
  late MockHiveService mockHiveService;
  late MockBox mockBox;

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox();

    // Ensuring that the thenAnswer correctly returns a Future<void>
    when(mockHiveService.initFlutter()).thenAnswer((_) => Future.value());
    when(mockHiveService.openBox('itemsBox')).thenAnswer((_) async => mockBox);
  });

  testWidgets('MyApp builds MaterialApp with SearchPage',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('main initializes Hive and runs the app',
      (WidgetTester tester) async {
    runZoned(() {
      main();
    });

    await tester
        .pumpAndSettle(); // This waits for all animations and scheduled frames to complete.

    // Verifying that the initialization was called correctly
    verify(mockHiveService.initFlutter()).called(1);
    verify(mockHiveService.openBox('itemsBox')).called(1);
    expect(find.byType(MyApp), findsOneWidget);
  });
}
