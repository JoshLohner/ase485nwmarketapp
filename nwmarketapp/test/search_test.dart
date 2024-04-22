import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nwmarketapp/main.dart'; // Ensure this path is correct to your main file

void main() {
  testWidgets('SearchPage has a TextField and ListView',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    // Check for TextField and its properties
    expect(find.byType(TextField), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.decoration?.labelText, 'Search');

    // Check for ListView
    expect(find.byType(ListView), findsOneWidget);
  });
}
