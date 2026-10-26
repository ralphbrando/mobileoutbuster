// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outbuster/components/launch/outbuster_launch_screen.dart';

import 'package:outbuster/main.dart';

void main() {
  testWidgets('App can close during splash without leaving a timer',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(OutbusterLaunchScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });
}
