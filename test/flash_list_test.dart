import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flash_list/flash_list.dart';

void main() {
  testWidgets('FlashList shows items correctly', (WidgetTester tester) async {
    final List<String> items = List.generate(20, (index) => 'Item $index');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlashList<String>(
            data: items,
            itemBuilder: (context, item, index) => ListTile(
              title: Text(item),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });

  // Add more tests if needed
}
