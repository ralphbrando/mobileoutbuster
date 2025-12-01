// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class ImdbImage extends StatefulWidget {
  const ImdbImage({
    Key? key,
    this.width,
    this.height,
    required this.imagePath,
    this.radious = 0,
    this.isPoster = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String imagePath;
  final double radious;
  final bool isPoster;

  @override
  _ImdbImageState createState() => _ImdbImageState();
}

class _ImdbImageState extends State<ImdbImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.radious)),
      child: Image.network(
        widget.isPoster
            ? "https://www.themoviedb.org/t/p/w440_and_h660_face/${widget.imagePath}"
            : "https://image.tmdb.org/t/p/w1066_and_h600_bestv2/${widget.imagePath}",
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
