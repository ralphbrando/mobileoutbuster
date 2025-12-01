import '/backend/api_requests/api_calls.dart';
import '/components/movie_card/movie_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/player/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tv_shows_details_model.dart';
export 'tv_shows_details_model.dart';

class TvShowsDetailsWidget extends StatefulWidget {
  const TvShowsDetailsWidget({
    super.key,
    required this.tvId,
    this.serie,
  });

  final String? tvId;
  final dynamic serie;

  static String routeName = 'TvShowsDetails';
  static String routePath = '/tvShowsDetails';

  @override
  State<TvShowsDetailsWidget> createState() => _TvShowsDetailsWidgetState();
}

class _TvShowsDetailsWidgetState extends State<TvShowsDetailsWidget> {
  late TvShowsDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TvShowsDetailsModel());
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
        body: SafeArea(
          top: true,
          child: FutureBuilder<ApiCallResponse>(
            future: GetFilmDetailsCall.call(
              filmId: int.tryParse(widget.tvId ?? '0') ?? 0,
            ),
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
              
              final filmDetailsResponse = snapshot.data!;
              final filmData = getJsonField(
                filmDetailsResponse.jsonBody,
                r'''$.data''',
              );

              if (filmData == null) {
                return Center(
                  child: Text(
                    'Film non trouvé',
                    style: FlutterFlowTheme.of(context).headlineMedium,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            functions.cleanStorageUrl(
                              getJsonField(
                                filmData,
                                r'''$.film_cover_url''',
                              ).toString(),
                            ),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                child: Icon(
                                  Icons.movie,
                                  size: 100.0,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 400.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  FlutterFlowTheme.of(context).primaryBackground
                                ],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                            ),
                          ),
                          // Back Button
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xB3272B30),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios_outlined,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                                // Favorite Button
                                Visibility(
                                  visible: false,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  maintainSize: true,
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xB3272B30),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Title and Info
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getJsonField(filmData, r'''$.film_original_title''').toString(),
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  if (getJsonField(filmData, r'''$.film_tagline''').toString().isNotEmpty)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        getJsonField(filmData, r'''$.film_tagline''').toString(),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.poppins(
                                                fontStyle: FontStyle.italic,
                                              ),
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        if (getJsonField(filmData, r'''$.film_running_time''').toString().isNotEmpty)
                                          Text(
                                            '${getJsonField(filmData, r'''$.film_running_time''').toString()} min',
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        if (getJsonField(filmData, r'''$.film_running_time''').toString().isNotEmpty &&
                                            getJsonField(filmData, r'''$.film_version''').toString().isNotEmpty)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Text(
                                              '•',
                                              style: FlutterFlowTheme.of(context).bodySmall,
                                            ),
                                          ),
                                        if (getJsonField(filmData, r'''$.film_version''').toString().isNotEmpty)
                                          Text(
                                            getJsonField(filmData, r'''$.film_version''').toString(),
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        if (getJsonField(filmData, r'''$.country_name''').toString().isNotEmpty)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Text(
                                              '•',
                                              style: FlutterFlowTheme.of(context).bodySmall,
                                            ),
                                          ),
                                        if (getJsonField(filmData, r'''$.country_name''').toString().isNotEmpty)
                                          Text(
                                            getJsonField(filmData, r'''$.country_name''').toString(),
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Play Button
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        final filmId = int.tryParse(widget.tvId ?? '0') ?? 0;
                                        if (filmId == 0) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Film introuvable.'),
                                            ),
                                          );
                                          return;
                                        }

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );

                                        final videoResponse = await GetVideoLinkCall.call(
                                          videoId: filmId,
                                        );

                                        Navigator.pop(context);

                                        final responseBody =
                                            videoResponse.jsonBody ?? {};
                                        final hasError = getJsonField(
                                              responseBody,
                                              r'''$.error''',
                                            ) ==
                                            true;
                                        final message = getJsonField(
                                          responseBody,
                                          r'''$.message''',
                                        ).toString();

                                        if (!videoResponse.succeeded || hasError) {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Lecture indisponible'),
                                                content: Text(
                                                  message.isNotEmpty
                                                      ? message
                                                      : 'La lecture du film est réservée aux abonnés.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }

                                        final videoUrl = getJsonField(
                                          responseBody,
                                          r'''$.data''',
                                        ).toString();

                                        if (videoUrl.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Lien vidéo indisponible.'),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlayerWidget(
                                              videoUrl: videoUrl,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.play,
                                              color: FlutterFlowTheme.of(context).primaryBtnText,
                                              size: 20.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                'Regarder',
                                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                                      color: FlutterFlowTheme.of(context).primaryBtnText,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Synopsis
                    if (getJsonField(filmData, r'''$.film_synopsis''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synopsis',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.film_synopsis''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Categories
                    if (getJsonField(filmData, r'''$.category_list''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Catégories',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.category_list''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Genres
                    if (getJsonField(filmData, r'''$.genre_list''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Genres',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.genre_list''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Tags
                    if (getJsonField(filmData, r'''$.film_tag_list''') != null)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tags',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: (getJsonField(filmData, r'''$.film_tag_list''') as List?)
                                        ?.map<Widget>((tag) => Container(
                                              padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                borderRadius: BorderRadius.circular(16.0),
                                              ),
                                              child: Text(
                                                tag.toString(),
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ))
                                        .toList() ??
                                    [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Cast
                    if (getJsonField(filmData, r'''$.film_cast_name_list''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Casting',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.film_cast_name_list''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Crew
                    if (getJsonField(filmData, r'''$.film_crew_name_list''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Équipe',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.film_crew_name_list''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Pros
                    if (getJsonField(filmData, r'''$.film_pros''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pourquoi vous aimerez',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.film_pros''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Cons
                    if (getJsonField(filmData, r'''$.film_cons''').toString().isNotEmpty)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pourquoi vous n\'aimerez peut-être pas',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                getJsonField(filmData, r'''$.film_cons''').toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Critics
                    if (getJsonField(filmData, r'''$.critic_list''') != null)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Critiques',
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: (getJsonField(filmData, r'''$.critic_list''') as List?)
                                        ?.map<Widget>((critic) => Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                              child: Container(
                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (getJsonField(critic, r'''$.film_critic_title''').toString().isNotEmpty)
                                                      Text(
                                                        getJsonField(critic, r'''$.film_critic_title''').toString(),
                                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                    if (getJsonField(critic, r'''$.film_criticism''').toString().isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                        child: Text(
                                                          getJsonField(critic, r'''$.film_criticism''').toString(),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                letterSpacing: 0.0,
                                                              ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList() ??
                                    [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    // More Videos
                    if (getJsonField(filmData, r'''$.more_videos_list''') != null)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 16.0),
                        child: Text(
                          'Plus de vidéos',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    if (getJsonField(filmData, r'''$.more_videos_list''') != null)
                      SizedBox(
                        height: 224.0,
                        child: Builder(
                          builder: (context) {
                            final moreVideos = (getJsonField(filmData, r'''$.more_videos_list''') as List?)
                                    ?.take(10)
                                    .toList() ??
                                [];

                            return ListView.builder(
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: moreVideos.length,
                              itemBuilder: (context, videoIndex) {
                                final videoItem = moreVideos[videoIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                  child: SizedBox(
                                    width: 140.0,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TvShowsDetailsWidget(
                                              tvId: getJsonField(videoItem, r'''$.id''').toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: MovieCardWidget(
                                        key: Key('KeyMore_${videoIndex}_of_${moreVideos.length}'),
                                        imagePath: functions.cleanStorageUrl(
                                          getJsonField(videoItem, r'''$.film_cover_url''').toString(),
                                        ),
                                        title: getJsonField(videoItem, r'''$.film_original_title''').toString(),
                                        rating: '',
                                        image: functions.cleanStorageUrl(
                                          getJsonField(videoItem, r'''$.film_cover_url''').toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
