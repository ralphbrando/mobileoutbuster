import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cms_page_model.dart';
export 'cms_page_model.dart';

class CmsPageWidget extends StatefulWidget {
  const CmsPageWidget({
    super.key,
    required this.pageData,
  });

  final dynamic pageData;

  static String routeName = 'CmsPage';
  static String routePath = '/cmsPage';

  @override
  State<CmsPageWidget> createState() => _CmsPageWidgetState();
}

class _CmsPageWidgetState extends State<CmsPageWidget> {
  late CmsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CmsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = getJsonField(widget.pageData, r'''$.title''')?.toString() ?? '';
    final pageContent = getJsonField(widget.pageData, r'''$.body''')?.toString() ?? '';
    final pageBodyRepeater = getJsonField(widget.pageData, r'''$.body_repeater''');

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
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
          ),
          title: Text(
            pageTitle,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pageBodyRepeater != null && pageBodyRepeater is List && (pageBodyRepeater as List).isNotEmpty)
                  ...List.generate((pageBodyRepeater as List).length, (index) {
                    final repeaterItem = (pageBodyRepeater as List)[index];
                    final attributes = getJsonField(repeaterItem, r'''$.attributes''');
                    final repeaterContent = attributes != null 
                        ? getJsonField(attributes, r'''$.body''')?.toString() ?? ''
                        : '';
                    
                    if (repeaterContent.isEmpty) {
                      return SizedBox.shrink();
                    }
                    
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, index == 0 ? 0.0 : 16.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: FlutterFlowWebView(
                          content: repeaterContent,
                          bypass: false,
                          html: true,
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 400.0,
                          verticalScroll: true,
                          horizontalScroll: false,
                        ),
                      ),
                    );
                  })
                else if (pageContent.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: FlutterFlowWebView(
                      content: pageContent,
                      bypass: false,
                      html: true,
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 500.0,
                      verticalScroll: true,
                      horizontalScroll: false,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

