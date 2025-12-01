import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/onboarding/onboarding_widget.dart';
import '/pages/cms_page/cms_page_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'Profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
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
          title: Text(
            'Profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Abonnement Section
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: Text(
                      'Abonnement',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                  FutureBuilder<ApiCallResponse>(
                    future: GetUserCall.call(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final userData = getJsonField(snapshot.data!.jsonBody, r'''$.data''');
                      final currentPlan = getJsonField(userData, r'''$.current_plan''');
                      
                      if (currentPlan == null) {
                        return Container(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aucun abonnement actif',
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  'Abonnez-vous pour accéder à tous les contenus.',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      final planName = getJsonField(currentPlan, r'''$.name''')?.toString() ?? 'Abonnement';
                      final planAmount = getJsonField(currentPlan, r'''$.amount''')?.toString() ?? '0';
                      final planFrequency = getJsonField(currentPlan, r'''$.frequency''')?.toString() ?? '';
                      final nextBilling = getJsonField(currentPlan, r'''$.nextbilling_at''')?.toString();
                      final endsAt = getJsonField(currentPlan, r'''$.ends_at''')?.toString();
                      final subscriptionStart = getJsonField(currentPlan, r'''$.subscription_start_day''')?.toString();
                      
                      String formatDate(String? dateStr) {
                        if (dateStr == null || dateStr.isEmpty) return 'N/A';
                        try {
                          final date = DateTime.parse(dateStr);
                          return DateFormat('dd/MM/yyyy', 'fr_FR').format(date);
                        } catch (e) {
                          return dateStr;
                        }
                      }
                      
                      return Container(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        planName,
                                        style: FlutterFlowTheme.of(context).titleLarge.override(
                                              font: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: FlutterFlowTheme.of(context).primaryBtnText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          '$planAmount€ / ${planFrequency == 'Month' ? 'mois' : planFrequency == 'Year' ? 'an' : planFrequency}',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    'ACTIF',
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context).primary,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                              child: Divider(
                                color: FlutterFlowTheme.of(context).primaryBtnText.withOpacity(0.3),
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (subscriptionStart != null && subscriptionStart.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: FlutterFlowTheme.of(context).primaryBtnText,
                                            size: 16.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'Début: ${formatDate(subscriptionStart)}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (nextBilling != null && nextBilling.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.autorenew,
                                            color: FlutterFlowTheme.of(context).primaryBtnText,
                                            size: 16.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'Prochain paiement: ${formatDate(nextBilling)}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (endsAt != null && endsAt.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.event_busy,
                                            color: FlutterFlowTheme.of(context).primaryBtnText,
                                            size: 16.0,
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'Expire le: ${formatDate(endsAt)}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Pages CMS Section
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 16.0),
                    child: Text(
                      'Informations',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                  FutureBuilder<ApiCallResponse>(
                    future: GetPagesCall.call(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final pagesData = getJsonField(snapshot.data!.jsonBody, r'''$.data''');
                      final pages = pagesData != null && pagesData is List ? pagesData : <dynamic>[];
                      
                      if (pages.isEmpty) {
                        return SizedBox.shrink();
                      }
                      
                      return Column(
                        children: List.generate(pages.length, (index) {
                          final page = pages[index];
                          final pageId = getJsonField(page, r'''$.id''');
                          final pageTitle = getJsonField(page, r'''$.title''')?.toString() ?? '';
                          
                          if (pageTitle.isEmpty) {
                            return SizedBox.shrink();
                          }
                          
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final pageResponse = await GetPageCall.call(pageId: int.tryParse(pageId.toString()) ?? 0);
                                  if (pageResponse.succeeded && pageResponse.jsonBody != null) {
                                    final pageData = getJsonField(pageResponse.jsonBody, r'''$.data''');
                                    if (pageData != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CmsPageWidget(pageData: pageData),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pageTitle,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  // Compte Section
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 16.0),
                    child: Text(
                      'Compte',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 24.0),
                    child: Container(
                      width: double.infinity,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          FFAppState().deleteToken();
                          FFAppState().token = '';

                          safeSetState(() {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingWidget(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 0.0, 0.0),
                              child: Icon(
                                FFIcons.knameLogout,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Déconnexion',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 16.0, 0.0),
                              child: Icon(
                                FFIcons.knameRightArrow2,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
