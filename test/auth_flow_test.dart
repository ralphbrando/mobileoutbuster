import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:outbuster/pages/sign_in/sign_in_widget.dart';
import 'package:outbuster/auth/custom_auth/auth_util.dart';
import 'package:outbuster/auth/custom_auth/custom_auth_user_provider.dart';
import 'package:outbuster/backend/api_requests/api_manager.dart';
import 'package:outbuster/components/movie_card/movie_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await authManager.initialize();
  });

  test('Tokenless sign-in is rejected and expired sessions are cleared',
      () async {
    await expectLater(authManager.signIn(), throwsArgumentError);
    SharedPreferences.setMockInitialValues({
      '_auth_authentication_token_': 'expired-test-token',
      '_auth_uid_': 'qa',
      '_auth_token_expiration_': 1,
    });
    await authManager.initialize();
    expect(ApiManager.getAuthToken(), isNull);
    expect(outbusterAuthUserSubject.value.loggedIn, isFalse);
    expect(
        (await SharedPreferences.getInstance())
            .getString('_auth_authentication_token_'),
        isNull);
  });

  test('Sign-out clears persisted and API sessions before returning', () async {
    await authManager.signIn(authenticationToken: 'test-token', authUid: 'qa');
    expect(ApiManager.getAuthToken(), 'test-token');
    await authManager.initialize();
    expect(outbusterAuthUserSubject.value.loggedIn, isTrue);
    await authManager.signOut();
    expect(ApiManager.getAuthToken(), isNull);
    await authManager.initialize();
    expect(outbusterAuthUserSubject.value.loggedIn, isFalse);
  });

  test('Corrupt persisted session data is cleared safely', () async {
    SharedPreferences.setMockInitialValues({
      '_auth_authentication_token_': 'test-token',
      '_auth_uid_': 'qa',
      '_auth_user_data_': '{broken-json',
    });
    await authManager.initialize();
    expect(ApiManager.getAuthToken(), isNull);
    expect(outbusterAuthUserSubject.value.loggedIn, isFalse);
  });

  testWidgets('Empty login is validated locally at phone and landscape sizes',
      (tester) async {
    for (final size in [
      const Size(320, 568),
      const Size(844, 390),
      const Size(1024, 1366)
    ]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const MaterialApp(home: SignInWidget()));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Connexion'));
      await tester.pumpAndSettle();
      expect(find.text('Saisissez un email valide.'), findsOneWidget);
      expect(find.text('Saisissez votre mot de passe.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets(
      'Enter submits real credentials and rejected login never authenticates',
      (tester) async {
    var calls = 0;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: SignInWidget()));
      await tester.enterText(
          find.byKey(const Key('sign-in-email')), 'qa@example.com');
      await tester.enterText(
          find.byKey(const Key('sign-in-password')), 'incorrect-test-password');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.text('Email ou mot de passe incorrect.'), findsOneWidget);
      expect(outbusterAuthUserSubject.value.loggedIn, isFalse);
      expect(ApiManager.getAuthToken(), isNull);
    },
        () => MockClient((request) async {
              calls++;
              expect(request.url.path, '/api/login');
              expect(request.bodyFields['email'], 'qa@example.com');
              expect(request.bodyFields['password'], 'incorrect-test-password');
              return http.Response(
                  jsonEncode({'message': 'Invalid credentials'}), 401,
                  headers: {'content-type': 'application/json'});
            }));
  });

  testWidgets(
      'Malformed successful responses show an error instead of silently doing nothing',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: SignInWidget()));
      await tester.enterText(
          find.byKey(const Key('sign-in-email')), 'qa@example.com');
      await tester.enterText(
          find.byKey(const Key('sign-in-password')), 'test-password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Connexion'));
      await tester.pumpAndSettle();
      expect(
          find.text('Connexion impossible pour le moment. Veuillez réessayer.'),
          findsOneWidget);
      expect(outbusterAuthUserSubject.value.loggedIn, isFalse);
    },
        () => MockClient(
            (_) async => http.Response('{"success":true,"data":{}}', 200)));
  });

  testWidgets('Long movie titles fit fixed carousel cards', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: Center(
      child: SizedBox(
          width: 140,
          height: 224,
          child: MovieCardWidget(
            title: 'A very long movie title that needs two lines',
            image: '',
          )),
    ))));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
