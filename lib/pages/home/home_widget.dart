import '/backend/api_requests/api_calls.dart';
import '/components/movie_card/movie_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/tv_shows_details/tv_shows_details_widget.dart';
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
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
          title: Image.asset(
            'assets/images/app_launcher_icon.png',
            height: 40.0,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<ApiCallResponse>(
                future: SeriesCall.call(
                  id: 999,
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
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
                  final pageViewSeriesResponse = snapshot.data!;

                  return Builder(
                    builder: (context) {
                      // API Laravel returns single film in data field for home-film
                      final filmData = getJsonField(
                        pageViewSeriesResponse.jsonBody,
                        r'''$.data''',
                      );
                      final results = filmData != null ? [filmData] : [];

                      return Container(
                        width: double.infinity,
                        height: 400.0,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _model.pageViewController ??=
                                  PageController(
                                      initialPage:
                                          max(0, min(0, results.length - 1))),
                              scrollDirection: Axis.horizontal,
                              itemCount: results.length,
                              itemBuilder: (context, resultsIndex) {
                                final resultsItem = results[resultsIndex];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        functions.cleanStorageUrl(
                                          getJsonField(
                                            resultsItem,
                                            r'''$.film_cover_url''',
                                          ).toString(),
                                        ),
                                        width: double.infinity,
                                        height: 400.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 1.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, 0.85),
                                      child: Container(
                                        width: double.infinity,
                                        height: 68.0,
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 8.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        getJsonField(
                                                          resultsItem,
                                                          r'''$.film_original_title''',
                                                        ).toString(),
                                                        maxLines: 1,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      20.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    8.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          '',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.7),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TvShowsDetailsWidget(
                                                          tvId: getJsonField(
                                                            resultsItem,
                                                            r'''$.id''',
                                                          ).toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.play,
                                                        color: FlutterFlowTheme.of(context).primaryBtnText,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.83, 0.95),
                              child: smooth_page_indicator.SmoothPageIndicator(
                                controller: _model.pageViewController ??=
                                    PageController(
                                        initialPage:
                                            max(0, min(0, results.length - 1))),
                                count: results.length,
                                axisDirection: Axis.horizontal,
                                onDotClicked: (i) async {
                                  await _model.pageViewController!
                                      .animateToPage(
                                    i,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                  safeSetState(() {});
                                },
                                effect:
                                    smooth_page_indicator.ExpandingDotsEffect(
                                  expansionFactor: 2.0,
                                  spacing: 8.0,
                                  radius: 16.0,
                                  dotWidth: 12.0,
                                  dotHeight: 6.0,
                                  dotColor: Color(0x33EF233C),
                                  activeDotColor:
                                      FlutterFlowTheme.of(context).primary,
                                  paintStyle: PaintingStyle.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              // Dynamic Categories Section - Single API call for all categories with films
              FutureBuilder<ApiCallResponse>(
                future: GetCategoriesWithFilmsCall.call(),
                builder: (context, categoriesSnapshot) {
                  if (!categoriesSnapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  final categoriesData = getJsonField(
                    categoriesSnapshot.data!.jsonBody,
                    r'''$.data''',
                  );
                  
                  if (categoriesData == null || !(categoriesData is List)) {
                    return SizedBox.shrink();
                  }
                  
                  final categories = categoriesData as List;
                  
                  return Column(
                    children: List.generate(categories.length, (categoryIndex) {
                      final category = categories[categoryIndex];
                      final categoryId = getJsonField(category, r'''$.id''');
                      final categoryName = getJsonField(category, r'''$.category''')?.toString() ?? '';
                      final films = getJsonField(category, r'''$.films''');
                      
                      if (categoryId == null || categoryName.isEmpty) {
                        return SizedBox.shrink();
                      }
                      
                      final filmsList = films != null && films is List ? films : <dynamic>[];
                      
                      if (filmsList.isEmpty) {
                        return SizedBox.shrink();
                      }
                      
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  categoryName,
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 224.0,
                            child: ListView.builder(
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filmsList.length,
                              itemBuilder: (context, filmIndex) {
                                final filmItem = filmsList[filmIndex];
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
                                            builder: (context) =>
                                                TvShowsDetailsWidget(
                                              tvId: getJsonField(
                                                filmItem,
                                                r'''$.id''',
                                              ).toString(),
                                              serie: filmItem,
                                            ),
                                          ),
                                        );
                                      },
                                      child: MovieCardWidget(
                                        key: Key(
                                            'KeyCat_${categoryIndex}_Film_${filmIndex}_of_${filmsList.length}'),
                                        imagePath: functions.cleanStorageUrl(
                                          getJsonField(
                                            filmItem,
                                            r'''$.film_cover_url''',
                                          ).toString(),
                                        ),
                                        title: getJsonField(
                                          filmItem,
                                          r'''$.film_original_title''',
                                        ).toString(),
                                        rating: '',
                                        image: functions.cleanStorageUrl(
                                          getJsonField(
                                            filmItem,
                                            r'''$.film_cover_url''',
                                          ).toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
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
        ),
      ),
    );
  }
}

