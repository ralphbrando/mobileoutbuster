import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'player_model.dart';
export 'player_model.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    super.key,
    this.videoUrl,
  });

  final String? videoUrl;

  static String routeName = 'Player';
  static String routePath = '/player';

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late PlayerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlayerModel());
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF04192C),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 24.0, 24.0, 0.0),
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
                          ],
                        ),
                      ),
                      if ((widget.videoUrl ?? '').isNotEmpty)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 100.0, 0.0, 0.0),
                          child: FlutterFlowWebView(
                            content: '''
                              <!DOCTYPE html>
                              <html>
                              <head>
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <style>
                                  body { margin: 0; padding: 0; overflow: hidden; }
                                  iframe { width: 100%; height: 100vh; border: none; }
                                </style>
                              </head>
                              <body>
                                <iframe src="${widget.videoUrl}" allowfullscreen></iframe>
                              </body>
                              </html>
                            ''',
                            bypass: false,
                            html: true,
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 500.0,
                            verticalScroll: true,
                            horizontalScroll: true,
                          ),
                        )
                      else
                        Center(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 100.0, 24.0, 0.0),
                            child: Text(
                              'Lien vidéo indisponible.',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                    ],
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
