import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nwmarketapp/main.dart';

void main() {
  group('GraphPage Tests', () {
    testWidgets('Should display the graph with correct labels',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: GraphPage(prices: [1.0, 2.0, 3.0])));
      await tester.pump(); // Ensure the page is built
      // Check for specific text in the graph labels
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Lowest'), findsOneWidget);
      expect(find.text('Average'), findsOneWidget);
    });
  });
}
