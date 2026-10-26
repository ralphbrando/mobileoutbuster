import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

// Base URL for Outbuster API - Update this to match your Laravel API URL
const String kOutbusterApiBaseUrl = 'https://www.outbuster.com/api';

class LoginCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
  }) async {
    final response = await ApiManager.instance.makeApiCall(
      callName: 'LOGIN',
      apiUrl: '$kOutbusterApiBaseUrl/login',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      params: {
        'email': email,
        'password': password,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
    
    return response;
  }
}

class RegisterCall {
  static Future<ApiCallResponse> call({
    String? firstname = '',
    String? lastname = '',
    String? email = '',
    String? password = '',
    String? passwordConfirmation = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'REGISTER',
      apiUrl: '$kOutbusterApiBaseUrl/register',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      params: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetHomeFilmCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'HOME_FILM',
      apiUrl: '$kOutbusterApiBaseUrl/home-film',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFilmsCall {
  static Future<ApiCallResponse> call({
    String? search = '',
  }) async {
    final callType = search != null && search.isNotEmpty 
        ? ApiCallType.POST 
        : ApiCallType.GET;
    
    return ApiManager.instance.makeApiCall(
      callName: 'FILMS',
      apiUrl: '$kOutbusterApiBaseUrl/films',
      callType: callType,
      headers: {
        'Accept': 'application/json',
      },
      params: search != null && search.isNotEmpty 
          ? {'search': search}
          : {},
      bodyType: search != null && search.isNotEmpty 
          ? BodyType.X_WWW_FORM_URL_ENCODED 
          : null,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
  
  static List<dynamic> films(dynamic response) {
    final data = getJsonField(response, r'''$.data''');
    if (data is List) {
      return data;
    }
    return [];
  }
  
  static int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data[:].id''',
      ));
  static String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_original_title''',
      ));
  static String? cover(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_cover_url''',
      ));
  static String? synopsis(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_synopsis''',
      ));
}

class GetFilmDetailsCall {
  static Future<ApiCallResponse> call({
    required int filmId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'FILM_DETAILS',
      apiUrl: '$kOutbusterApiBaseUrl/film/$filmId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPopularFilmsCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'POPULAR_FILMS',
      apiUrl: '$kOutbusterApiBaseUrl/popular-films',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetCategoriesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'CATEGORIES',
      apiUrl: '$kOutbusterApiBaseUrl/categories',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetCategoriesWithFilmsCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'CATEGORIES_WITH_FILMS',
      apiUrl: '$kOutbusterApiBaseUrl/categories-with-films',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFilmsByCategoryCall {
  static Future<ApiCallResponse> call({
    required int categoryId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'FILMS_BY_CATEGORY',
      apiUrl: '$kOutbusterApiBaseUrl/category/$categoryId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPagesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'PAGES',
      apiUrl: '$kOutbusterApiBaseUrl/pages',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPageCall {
  static Future<ApiCallResponse> call({
    required int pageId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'PAGE_DETAILS',
      apiUrl: '$kOutbusterApiBaseUrl/page/$pageId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'USER',
      apiUrl: '$kOutbusterApiBaseUrl/user',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetVideoLinkCall {
  static Future<ApiCallResponse> call({
    required int videoId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'VIDEO_LINK',
      apiUrl: '$kOutbusterApiBaseUrl/video/$videoId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetSerieDetailsCall {
  static Future<ApiCallResponse> call({
    required int serieId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'SERIE_DETAILS',
      apiUrl: '$kOutbusterApiBaseUrl/serie/$serieId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetSerieVideoLinkCall {
  static Future<ApiCallResponse> call({
    required int episodeId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'SERIE_VIDEO_LINK',
      apiUrl: '$kOutbusterApiBaseUrl/serie-video/$episodeId',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFavoritesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'FAVORITES',
      apiUrl: '$kOutbusterApiBaseUrl/favorites',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ToggleFavoriteCall {
  static Future<ApiCallResponse> call({
    required int filmId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'TOGGLE_FAVORITE',
      apiUrl: '$kOutbusterApiBaseUrl/favorites/toggle',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      params: {
        'film_id': filmId,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

// Legacy SeriesCall for backward compatibility - maps to Films
class SeriesCall {
  static Future<ApiCallResponse> call({
    int? id,
    String? search = '',
    String? tvid = '',
  }) async {
    // If id is provided and it's 999 (home), get home film
    if (id == 999) {
      return GetHomeFilmCall.call();
    }
    
    // Otherwise get films (with search if provided)
    return GetFilmsCall.call(search: search);
  }

  static int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data[:].id''',
      ));
  static String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_original_title''',
      ));
  static String? origin(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_country_of_origin''',
      ));
  static String? synopsis(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_synopsis''',
      ));
  static String? pic(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].film_cover_url''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
