import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for search_text widget.
  FocusNode? searchTextFocusNode;
  TextEditingController? searchTextTextController;
  String? Function(BuildContext, String?)? searchTextTextControllerValidator;
  // Stores action output result for [Backend Call - API (SERIES)] action in search_text widget.
  ApiCallResponse? movies;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchTextFocusNode?.dispose();
    searchTextTextController?.dispose();
  }
}
