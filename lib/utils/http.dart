import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motogp_calendar/services/alert.service.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:motogp_calendar/utils/enum/e_alert_status.dart';
import 'package:motogp_calendar/utils/types/alert_options.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';

class Http {
  // Singleton instance
  static final Http _instance = Http._internal();
  
  // Dio instance
  late Dio _http;
  static int _pendingRequests = 0;

  // Private constructor
  Http._internal() {
    _initHttp();
  }

  // Factory constructor for the singleton pattern
  factory Http() {
    return _instance;
  }

  void _initHttp(){
    _http = Dio();
    
    String baseUrl = dotenv.get("BASE_URL", fallback: "");
    if(baseUrl == ""){
      throw Exception("Invalid or missing ENV variable \"BASE_URL\"");
    }
    _http.options.baseUrl = baseUrl;

    if(kDebugMode){
      // allow self-signed certificate
      (_http.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
    //Add interceptors
    _http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          bool useLoading = options.extra["useLoading"] ?? true;
          if (useLoading) {
            _addPendingRequest();
          }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          bool useLoading = response.requestOptions.extra["useLoading"] ?? true;
          if (useLoading) {
            _deletePendingRequest();
          }          
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          bool useLoading = error.requestOptions.extra["useLoading"] ?? true;
          if (useLoading) {
            _deletePendingRequest();
          }

          BuildContext? context = AppRouter.router.configuration.navigatorKey.currentState?.context;
          if(context != null){
            AlertService().showAlert(AlertOptions(status: EAlertStatus.error, title:AppLocalizations.of(context)!.unexpectedError ));
          }

          return handler.next(error);
        },
      ),
    );
  }

  void _addPendingRequest() {
    if (_pendingRequests == 0) {
      EasyLoading.show();
    }
    _pendingRequests++;
  }

  void _deletePendingRequest() {
    if (_pendingRequests <= 0) {
      return;
    }

    if (_pendingRequests == 1) {
      EasyLoading.dismiss();
    }
    _pendingRequests--;
  }

  // HTTP Methods
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams, bool useLoading = true}) {
    return _http.get<T>(path, queryParameters: queryParams, options: Options(extra: {"useLoading": useLoading}));
  }

  Future<Response<T>> post<T>(String path, {Object? data, bool useLoading = true}) {
    return _http.post<T>(path, data: data, options: Options(extra: {"useLoading": useLoading}));
  }

  Future<Response<T>> put<T>(String path, {Map<String, dynamic>? queryParams, Object? data, bool useLoading = true}) {
    return _http.put<T>(path, data: data, queryParameters:queryParams, options: Options(extra: {"useLoading": useLoading}));
  }

  Future<Response<T>> delete<T>(String path, {Map<String, dynamic>? queryParams, bool useLoading = true}) {
    return _http.delete<T>(path, queryParameters: queryParams, options: Options(extra: {"useLoading": useLoading}));
  }

}