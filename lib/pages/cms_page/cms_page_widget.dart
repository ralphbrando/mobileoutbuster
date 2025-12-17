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

  /// Wrap HTML content with dark theme CSS
  String _wrapWithDarkThemeCSS(String htmlContent) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    html, body {
      background-color: #1A1A1A !important;
      color: #FFFFFF !important;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      font-size: 14px;
      line-height: 1.6;
      padding: 8px;
    }
    h1 {
      font-size: 22px;
      font-weight: 700;
      margin-bottom: 16px;
      color: #FFFFFF !important;
    }
    h2 {
      font-size: 18px;
      font-weight: 600;
      margin-top: 20px;
      margin-bottom: 12px;
      color: #FFFFFF !important;
    }
    h3 {
      font-size: 16px;
      font-weight: 600;
      margin-top: 16px;
      margin-bottom: 10px;
      color: #FFFFFF !important;
    }
    h4, h5, h6 {
      font-size: 14px;
      font-weight: 600;
      margin-top: 12px;
      margin-bottom: 8px;
      color: #FFFFFF !important;
    }
    p {
      margin-bottom: 12px;
      color: #E0E0E0 !important;
    }
    a {
      color: #D9F500 !important;
      text-decoration: underline;
    }
    ul, ol {
      margin-left: 20px;
      margin-bottom: 12px;
      color: #E0E0E0 !important;
    }
    li {
      margin-bottom: 6px;
      color: #E0E0E0 !important;
    }
    strong, b {
      font-weight: 600;
      color: #FFFFFF !important;
    }
    em, i {
      font-style: italic;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 16px;
    }
    th, td {
      padding: 8px;
      border: 1px solid #444;
      color: #E0E0E0 !important;
    }
    th {
      background-color: #333;
      color: #FFFFFF !important;
    }
    blockquote {
      border-left: 3px solid #D9F500;
      padding-left: 16px;
      margin: 12px 0;
      color: #CCCCCC !important;
      font-style: italic;
    }
    hr {
      border: none;
      border-top: 1px solid #444;
      margin: 16px 0;
    }
    img {
      max-width: 100%;
      height: auto;
      border-radius: 8px;
    }
    span, div, section, article, header, footer, main, aside, nav {
      color: #E0E0E0 !important;
      background-color: transparent !important;
    }
    /* Override any inline styles */
    [style] {
      color: #E0E0E0 !important;
      background-color: transparent !important;
    }
  </style>
</head>
<body>
$htmlContent
</body>
</html>
''';
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FlutterFlowWebView(
                          content: _wrapWithDarkThemeCSS(repeaterContent),
                          bypass: false,
                          html: true,
                          width: MediaQuery.sizeOf(context).width - 48.0,
                          height: 400.0,
                          verticalScroll: true,
                          horizontalScroll: false,
                        ),
                      ),
                    );
                  })
                else if (pageContent.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FlutterFlowWebView(
                      content: _wrapWithDarkThemeCSS(pageContent),
                      bypass: false,
                      html: true,
                      width: MediaQuery.sizeOf(context).width - 48.0,
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

