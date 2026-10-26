import '/components/api_error_panel.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/movie_card/movie_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/tv_shows_details/tv_shows_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_films_model.dart';
export 'category_films_model.dart';

class CategoryFilmsWidget extends StatefulWidget {
  const CategoryFilmsWidget({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final int categoryId;
  final String categoryName;

  static String routeName = 'CategoryFilms';
  static String routePath = '/categoryFilms';

  @override
  State<CategoryFilmsWidget> createState() => _CategoryFilmsWidgetState();
}

class _CategoryFilmsWidgetState extends State<CategoryFilmsWidget> {
  late CategoryFilmsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<ApiCallResponse> _films;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryFilmsModel());
    _films = GetFilmsByCategoryCall.call(categoryId: widget.categoryId);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          title: Text(
            widget.categoryName,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<ApiCallResponse>(
            future: _films,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }

              final filmsResponse = snapshot.data!;
              if (!filmsResponse.succeeded)
                return Center(
                    child: ApiErrorPanel(
                        response: filmsResponse,
                        onRetry: () => setState(() {
                              _films = GetFilmsByCategoryCall.call(
                                  categoryId: widget.categoryId);
                            })));
              final filmsData = getJsonField(
                filmsResponse.jsonBody,
                r'''$.data''',
              );

              if (filmsData == null || filmsData is! List) {
                return Center(
                  child: Text(
                    'Aucun film trouvé',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                );
              }

              final films = filmsData as List;

              if (films.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun film dans cette catégorie',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 190,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: films.length,
                  itemBuilder: (context, index) {
                    final film = films[index];
                    final imageUrl = getJsonField(film, r'''$.film_cover_url''')
                            ?.toString() ??
                        '';
                    final title =
                        getJsonField(film, r'''$.film_original_title''')
                                ?.toString() ??
                            '';
                    final contentType =
                        getJsonField(film, r'''$.content_type''')?.toString() ??
                            'film';

                    return InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TvShowsDetailsWidget(
                              tvId: getJsonField(film, r'''$.id''').toString(),
                              serie: film,
                              contentType: contentType,
                            ),
                          ),
                        );
                      },
                      child: MovieCardWidget(
                        key: Key('KeyCatFilm_$index'),
                        imagePath: functions.cleanStorageUrl(imageUrl),
                        title: title,
                        rating: '',
                        image: functions.cleanStorageUrl(imageUrl),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
