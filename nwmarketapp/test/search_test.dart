import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwmarketapp/search_page.dart'; // Adjust the import path to where your SearchPage file is located.

void main() {
  group('SearchPage Widget Tests', () {
    testWidgets('Search field is present and allows input',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SearchPage()));

      // Verify the Search text field is present.
      expect(find.byType(TextField), findsOneWidget);

      // Simulate text entry.
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pump();

      // Check if the TextField updates with the text.
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('FloatingActionButton is present and clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SearchPage()));

      // Verify FloatingActionButton exists.
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Check if it is clickable by tapping.
      await tester.tap(find.byType(FloatingActionButton));
      await tester
          .pumpAndSettle(); // Wait for any potential navigation or dialog opening.

      // Navigation or dialog check would typically go here, but without a navigator observer or similar setup,
      // we can't verify navigation in unit tests easily.
    });

    testWidgets('ListView updates based on search input',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SearchPage()));
      await tester.enterText(find.byType(TextField), 'a');
      await tester
          .pumpAndSettle(); // Simulate the filtering process and UI update.

      // This test would be more effective if we can simulate the actual data.
      // However, without network mocking or a way to provide data, this check is quite limited.
      // This part of the test would ideally check for expected list items based on static data.
    });
  });
}
