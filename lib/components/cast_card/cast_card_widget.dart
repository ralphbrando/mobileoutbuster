import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cast_card_model.dart';
export 'cast_card_model.dart';

class CastCardWidget extends StatefulWidget {
  const CastCardWidget({
    super.key,
    this.image,
    this.name,
  });

  final String? image;
  final String? name;

  @override
  State<CastCardWidget> createState() => _CastCardWidgetState();
}

class _CastCardWidgetState extends State<CastCardWidget> {
  late CastCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CastCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 112.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              valueOrDefault<String>(
                widget.image,
                'https://www.themoviedb.org/t/p/w276_and_h350_face/3bOGNsHlrswhyW79uvIHH1V43JI.jpg',
              ),
              width: 60.0,
              height: 70.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.name,
                'Chris Evans',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w300,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
