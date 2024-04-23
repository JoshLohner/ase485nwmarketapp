import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwmarketapp/dashboard_page.dart';

void main() {
  group('Dashboard Page Tests', () {
    testWidgets('Dashboard page should display its title',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: DashboardPage()));

      // Verify that the dashboard contains its title.
      expect(find.text('Dashboard'), findsOneWidget);
    });

    // Add more tests to verify other functionalities and widgets on the dashboard
  });
}
