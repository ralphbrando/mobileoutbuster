import 'dart:convert';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key, this.videoUrl});
  final String? videoUrl;
  static String routeName = 'Player';
  static String routePath = '/player';

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(videoUrl ?? '');
    final valid = uri != null &&
        ['http', 'https'].contains(uri.scheme) &&
        uri.host.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                    tooltip: 'Retour',
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.maybePop(context)))),
        Expanded(
            child: valid
                ? LayoutBuilder(
                    builder: (context, constraints) => FlutterFlowWebView(
                          content:
                              '<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1"><style>html,body{margin:0;width:100%;height:100%;background:#000;overflow:hidden}iframe{width:100%;height:100%;border:0}</style></head><body><iframe src="${const HtmlEscape(HtmlEscapeMode.attribute).convert(videoUrl!)}" allow="autoplay; fullscreen; picture-in-picture; encrypted-media" allowfullscreen></iframe></body></html>',
                          html: true,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        ))
                : const Center(
                    child: Text('Lien vidéo indisponible.',
                        style: TextStyle(color: Colors.white)))),
      ])),
    );
  }
}
