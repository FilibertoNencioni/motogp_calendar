import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
          //TODO: gestire snackbar
          //https://stackoverflow.com/questions/60319051/how-to-create-and-use-snackbar-for-reuseglobally-in-flutter
          return handler.next(error);
        },
      ),
    );
  }
}