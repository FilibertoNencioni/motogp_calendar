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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Http {
  /// The http client used to interrogate the main service API
  static late Dio serviceHttp;

  static int pendingRequests = 0;

  static void addPendingRequest(){
    if(pendingRequests == 0) {
      EasyLoading.show();
    }
    pendingRequests++;
  }

  static void deletePendingRequest(){
    if(pendingRequests <= 0) {
      return;
    }

    if(pendingRequests == 1){
      EasyLoading.dismiss();
    }
    pendingRequests--;
  }

  static void initHttp(){
    serviceHttp = Dio();
    
    String baseUrl = dotenv.get("BASE_URL", fallback: "");
    if(baseUrl == ""){
      throw Exception("Invalid or missing ENV variable \"BASE_URL\"");
    }
    serviceHttp.options.baseUrl = baseUrl;

    if(kDebugMode){
      // allow self-signed certificate
      (serviceHttp.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
    //Add interceptors
    serviceHttp.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          addPendingRequest();
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          deletePendingRequest();
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          deletePendingRequest();
          BuildContext? context = AppRouter.router.configuration.navigatorKey.currentState?.context;
          if(context != null){
            AlertService().showAlert(AlertOptions(status: EAlertStatus.error, title:AppLocalizations.of(context)!.unexpectedError ));
          }

          return handler.next(error);
        },
      ),
    );
  }
}