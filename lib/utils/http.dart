import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motogp_calendar/services/alert.service.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:motogp_calendar/utils/enum/e_alert_status.dart';
import 'package:motogp_calendar/utils/types/alert_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Http {
  static late Dio http;
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
    http = Dio();

    http.interceptors.add(
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