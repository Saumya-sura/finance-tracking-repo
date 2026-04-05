// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/main.dart';

void main() {
  testWidgets('App loads and shows navigation', (WidgetTester tester) async {
    await tester.pumpWidget(FinanceApp());

    // Check for navigation bar items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);

    // Check for initial Home screen content
    expect(find.text('Home Dashboard'), findsOneWidget);
  });
}
