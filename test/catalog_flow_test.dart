import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:outbuster/pages/search/search_widget.dart';
import 'package:outbuster/pages/tv_shows_details/tv_shows_details_widget.dart';
import 'package:outbuster/pages/player/player_widget.dart';
import 'package:outbuster/pages/home/home_widget.dart';
import 'package:outbuster/pages/profile/profile_widget.dart';

http.Response reply(dynamic data, [int status = 200]) =>
    http.Response(jsonEncode(data), status,
        headers: {'content-type': 'application/json'});
Map<String, dynamic> film(String title) => {
      'id': 1,
      'film_original_title': title,
      'film_cover_url': '',
      'film_tagline': '',
      'film_running_time': 90,
      'film_version': 'VOSTFR',
      'country_name': 'France',
      'film_synopsis': 'Synopsis de test',
      'is_favorited': 1,
      'categories': [],
      'genres': [],
      'critics': [],
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Search ignores late responses and clears results immediately',
      (tester) async {
    final slow = Completer<http.Response>();
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: SearchWidget()));
      final input = find.byKey(const Key('catalog-search'));
      await tester.enterText(input, 'old');
      await tester.pump(const Duration(milliseconds: 410));
      await tester.enterText(input, 'new');
      await tester.pump(const Duration(milliseconds: 410));
      await tester.pumpAndSettle();
      expect(find.text('New result'), findsOneWidget);
      slow.complete(reply({
        'data': [film('Old result')]
      }));
      await tester.pumpAndSettle();
      expect(find.text('Old result'), findsNothing);
      await tester.tap(find.byTooltip('Effacer la recherche'));
      await tester.pumpAndSettle();
      expect(find.text('New result'), findsNothing);
      expect(find.text('Saisissez le titre d’un film ou d’une série.'),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    },
        () => MockClient((request) => request.bodyFields['search'] == 'old'
            ? slow.future
            : Future.value(reply({
                'data': [film('New result')]
              }))));
  });

  testWidgets('Search distinguishes network errors from zero results',
      (tester) async {
    var status = 503;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: SearchWidget()));
      await tester.enterText(
          find.byKey(const Key('catalog-search')), 'missing');
      await tester.pump(const Duration(milliseconds: 410));
      await tester.pumpAndSettle();
      expect(find.textContaining('Recherche indisponible'), findsOneWidget);
      expect(find.text('Aucun film trouvé'), findsNothing);
      status = 200;
      await tester.tap(find.text('Réessayer'));
      await tester.pump(const Duration(milliseconds: 410));
      await tester.pumpAndSettle();
      expect(find.text('Aucun film trouvé'), findsOneWidget);
    }, () => MockClient((_) async => reply({'data': []}, status)));
  });

  testWidgets(
      'Favorite removal updates immediately without re-fetching stale film data',
      (tester) async {
    var detailCalls = 0;
    var toggles = 0;
    await http.runWithClient(() async {
      await tester
          .pumpWidget(const MaterialApp(home: TvShowsDetailsWidget(tvId: '1')));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(detailCalls, 1);
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(toggles, 2);
      expect(detailCalls, 1);
      expect(tester.takeException(), isNull);
    },
        () => MockClient((request) async {
              if (request.url.path.endsWith('/toggle')) {
                toggles++;
                return reply({
                  'data': {'is_favorited': toggles == 2}
                });
              }
              detailCalls++;
              return reply({'data': film('Test film')});
            }));
  });

  testWidgets('Missing video URL keeps the user on the film page',
      (tester) async {
    await http.runWithClient(() async {
      await tester
          .pumpWidget(const MaterialApp(home: TvShowsDetailsWidget(tvId: '1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Regarder'));
      await tester.pumpAndSettle();
      expect(find.text('Lien vidéo indisponible.'), findsOneWidget);
      expect(find.byType(PlayerWidget), findsNothing);
      expect(tester.takeException(), isNull);
    },
        () => MockClient((request) async => request.url.path.contains('/video/')
            ? reply({'success': true, 'data': null})
            : reply({'data': film('Test film')})));
  });

  testWidgets(
      'Home shows retry and expired-session errors instead of a blank catalogue',
      (tester) async {
    var status = 503;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: HomeWidget()));
      await tester.pumpAndSettle();
      expect(find.text('Réessayer'), findsNWidgets(2));
      await tester.pumpWidget(const SizedBox());
      status = 401;
      await tester.pumpWidget(const MaterialApp(home: HomeWidget()));
      await tester.pumpAndSettle();
      expect(find.text('Se reconnecter'), findsNWidgets(2));
    },
        () =>
            MockClient((_) async => reply({'message': 'Unavailable'}, status)));
  });

  testWidgets(
      'Invalid player links retain a visible return action on landscape',
      (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    await tester
        .pumpWidget(const MaterialApp(home: PlayerWidget(videoUrl: 'null')));
    await tester.pumpAndSettle();
    expect(find.text('Lien vidéo indisponible.'), findsOneWidget);
    expect(find.byTooltip('Retour'), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets(
      'Series episodes use the series endpoint and show subscription errors',
      (tester) async {
    var requestedEpisode = false;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(
          home: TvShowsDetailsWidget(tvId: '2', contentType: 'serie')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Pilot'), findsOneWidget);
      await tester.ensureVisible(find.textContaining('Pilot'));
      await tester.tap(find.textContaining('Pilot'));
      await tester.pumpAndSettle();
      expect(requestedEpisode, isTrue);
      expect(find.text('Lecture indisponible'), findsOneWidget);
      expect(find.text('Abonnement requis'), findsOneWidget);
    },
        () => MockClient((request) async {
              if (request.url.path == '/api/serie-video/7') {
                requestedEpisode = true;
                return reply(
                    {'error': true, 'message': 'Abonnement requis'}, 403);
              }
              final data = film('Test series')
                ..addAll({
                  'content_type': 'serie',
                  'episodes': [
                    {
                      'id': 7,
                      'season': 1,
                      'episode': 1,
                      'title': 'Pilot',
                      'running_time': 24
                    }
                  ]
                });
              return reply({'data': data});
            }));
  });

  testWidgets('Empty profile remains readable on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: ProfileWidget()));
      await tester.pumpAndSettle();
      expect(find.text('Aucun abonnement actif'), findsOneWidget);
      expect(find.text('Aucun film dans vos favoris'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
        () => MockClient((request) async => reply({
              'data': request.url.path.endsWith('/user')
                  ? {'current_plan': null}
                  : []
            })));
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets(
      'Returning from a favorite waits for its save and refreshes the library',
      (tester) async {
    final save = Completer<void>();
    var favorited = true;
    var favoriteReads = 0;
    await http.runWithClient(() async {
      await tester.pumpWidget(const MaterialApp(home: ProfileWidget()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test film'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();
      expect(tester.widget<PopScope>(find.byType(PopScope)).canPop, isFalse);
      await Navigator.of(tester.element(find.byType(TvShowsDetailsWidget)))
          .maybePop();
      await tester.pump();
      expect(find.byType(TvShowsDetailsWidget), findsOneWidget);
      save.complete();
      await tester.pumpAndSettle();
      expect(tester.widget<PopScope>(find.byType(PopScope)).canPop, isTrue);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Aucun film dans vos favoris'), findsOneWidget);
      expect(find.text('Test film'), findsNothing);
      expect(favoriteReads, 2);
    },
        () => MockClient((request) async {
              if (request.url.path.endsWith('/toggle')) {
                await save.future;
                favorited = false;
                return reply({
                  'data': {'is_favorited': false}
                });
              }
              if (request.url.path.endsWith('/favorites')) {
                favoriteReads++;
                return reply({
                  'data': favorited ? [film('Test film')] : []
                });
              }
              if (request.url.path.endsWith('/user'))
                return reply({
                  'data': {'current_plan': null}
                });
              if (request.url.path.endsWith('/pages'))
                return reply({'data': []});
              return reply({'data': film('Test film')});
            }));
  });
}
