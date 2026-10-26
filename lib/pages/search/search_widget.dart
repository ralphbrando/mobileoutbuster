import 'dart:async';
import '/backend/api_requests/api_calls.dart';
import '/components/movie_card/movie_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/tv_shows_details/tv_shows_details_widget.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});
  static String routeName = 'Search';
  static String routePath = '/search';
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _query = TextEditingController();
  Timer? _debounce;
  int _request = 0;
  bool _loading = false;
  String? _error;
  List<dynamic> _results = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _search(String value) {
    _debounce?.cancel();
    final query = value.trim();
    final request = ++_request;
    setState(() {
      _results = [];
      _error = null;
      _loading = query.isNotEmpty;
    });
    if (query.isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final response = await GetFilmsCall.call(search: query);
      if (!mounted || request != _request) return;
      setState(() {
        _loading = false;
        if (!response.succeeded ||
            response.jsonBody is! Map ||
            response.jsonBody['data'] is! List) {
          _error =
              'Recherche indisponible. Vérifiez votre connexion et réessayez.';
        } else {
          _results = response.jsonBody['data'] as List;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Theme(
                data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(primary: theme.primary)),
                child: TextField(
                    key: const Key('catalog-search'),
                    controller: _query,
                    onChanged: _search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _search,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: 'Rechercher sur Outbuster',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Effacer la recherche',
                                onPressed: () {
                                  _query.clear();
                                  _search('');
                                },
                                icon: const Icon(Icons.close)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)))))),
        Expanded(
            child: _query.text.trim().isEmpty
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.search, color: theme.primary, size: 64),
                          const SizedBox(height: 16),
                          Text('Rechercher sur Outbuster',
                              style: theme.headlineSmall,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text('Saisissez le titre d’un film ou d’une série.',
                              style: theme.bodyMedium,
                              textAlign: TextAlign.center),
                        ])))
                : _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_error!,
                                          style: theme.bodyMedium,
                                          textAlign: TextAlign.center),
                                      TextButton(
                                          onPressed: () => _search(_query.text),
                                          child: const Text('Réessayer')),
                                    ])))
                        : _results.isEmpty
                            ? Center(
                                child: Text('Aucun film trouvé',
                                    style: theme.bodyMedium))
                            : GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 190,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 0.55),
                                itemCount: _results.length,
                                itemBuilder: (context, index) {
                                  final film = _results[index] as Map;
                                  final title =
                                      film['film_original_title']?.toString() ??
                                          '';
                                  return Semantics(
                                      button: true,
                                      child: InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TvShowsDetailsWidget(
                                                          tvId: film['id']
                                                              ?.toString(),
                                                          serie: film,
                                                          contentType:
                                                              film['content_type']
                                                                      ?.toString() ??
                                                                  'film'))),
                                          child: MovieCardWidget(
                                              title: title,
                                              image: functions.cleanStorageUrl(
                                                  film['film_cover_url']
                                                          ?.toString() ??
                                                      ''))));
                                })),
      ])),
    );
  }
}
