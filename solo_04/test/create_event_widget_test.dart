import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_04/main.dart';

void main() {
  testWidgets('Add Event FAB opens CreateEventScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EventFormApp());
    await tester.pumpAndSettle();

    // Find Add Event FAB by its label and tap it.
    final fab = find.text('Add Event');
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Expect the CreateEventScreen to show the AppBar title 'Create Event'.
    expect(find.text('Create Event'), findsOneWidget);
  });
}
