import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outbuster/components/launch/outbuster_launch_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'));
    await fonts.load();
  });
  Future<void> launch(WidgetTester tester, Size size, {VoidCallback? onStart}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: OutbusterLaunchScreen(onStart: onStart)));
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        await precacheImage((element.widget as Image).image, element);
      }
    });
    await tester.pumpAndSettle();
  }

  testWidgets('Welcome stays usable on small phones, landscape and tablets', (tester) async {
    for (final size in [const Size(320, 568), const Size(844, 390), const Size(1024, 1366)]) {
      var tapped = false;
      await launch(tester, size, onStart: () => tapped = true);
      expect(tester.takeException(), isNull);
      expect(find.text('Démarrer'), findsOneWidget);
      await tester.tap(find.text('Démarrer'));
      expect(tapped, isTrue);
    }
  });

  testWidgets('Loading frame has branding and no start action', (tester) async {
    await launch(tester, const Size(390, 844));
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Démarrer'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Opt-in visual exports use the actual widget, bundled artwork and layout.
  if (Platform.environment['OUTBUSTER_EXPORT_PREVIEWS'] == 'true') {
    testWidgets('Export welcome screenshot', (tester) async {
      await launch(tester, const Size(390, 844), onStart: () {});
      await expectLater(find.byType(OutbusterLaunchScreen), matchesGoldenFile('previews/welcome.png'));
    });
    testWidgets('Export splash screenshot', (tester) async {
      await launch(tester, const Size(390, 844));
      await expectLater(find.byType(OutbusterLaunchScreen), matchesGoldenFile('previews/splash.png'));
    });
  }
}
