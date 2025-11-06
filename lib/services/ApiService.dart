import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mcommerce/components/Snackbar.dart';
import 'package:mcommerce/main.dart';
import 'package:mcommerce/services/SecureStoreService.dart';

class Apiservice {
  static Dio? _dio;
  // static final _BASE_URL = "http://10.0.2.2:8080/api/v1";
  static final _BASE_URL = "http://192.168.1.101:8080/api/v1";

  static Dio _getDio() {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        connectTimeout: Duration(milliseconds: 5000),
      ));
      _addInterceptors(_dio!);
    }
    return _dio!;
  }

  static void _addInterceptors(Dio dioInstance) {
    dioInstance.interceptors.add(
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        //check with access token

        String? accessToken = await Securestoreservice.getItem('accessToken');
        if (accessToken != null) {
          if (!JwtDecoder.isExpired(accessToken)) {
            options.headers["Authorization"] = 'Bearer ${accessToken}';
          }
          //check with refrewsh token
          else {
            String? refreshToken =
                await Securestoreservice.getItem('refreshToken');
            if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
              options.headers["Authorization"] = 'Bearer ${refreshToken}';
            }
          }
        }

        //configure status code
        options.validateStatus = (status) {
          return status! < 500;
        };
        return handler.next(options);
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      }),
    );
  }

  static Future<void> postRequest(String url, Object? formData,
      Options? options, Function(Response) func) async {
    final dio = _getDio();

    try {
      final response = await dio.post(_BASE_URL + "${url}",
          data: formData, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        func(response);
      } else if (response.statusCode == 400) {
        showSnackBar(response.data[0], navigatorKey.currentContext!,backgroundColor: Colors.orange);
      }
    } on DioException catch (e) {
      showSnackBar("Network Error", navigatorKey.currentContext!,backgroundColor: Colors.red);
    } catch (e) {
      showSnackBar("unexpected error occurred", navigatorKey.currentContext!,backgroundColor: Colors.red);
    }
  }

  static Future<void> getRequest(String url, Function(Response) func) async {
    final dio = _getDio();

    try {
      final response = await dio.get(_BASE_URL + "${url}");

      if (response.statusCode == 200) {
        func(response);
      } else if (response.statusCode == 400) {
        showSnackBar(response.data[0], navigatorKey.currentContext!,backgroundColor: Colors.orange);
      }
    } on DioException catch (e) {
      showSnackBar("Network Error", navigatorKey.currentContext!,backgroundColor: Colors.red);
    } catch (e) {
      print(e);
      showSnackBar("unexpected error occurred", navigatorKey.currentContext!,backgroundColor: Colors.red);
    }
  }

  static Future<void> putRequest(String url, Object? formData,
      Options? options, Function(Response) func) async {
    final dio = _getDio();

    try {
      final response = await dio.put(_BASE_URL + "${url}",
          data: formData, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        func(response);
      } else if (response.statusCode == 400) {
        showSnackBar(response.data[0], navigatorKey.currentContext!,backgroundColor: Colors.orange);
      }
    } on DioException catch (e) {
      showSnackBar("Network Error", navigatorKey.currentContext!,backgroundColor: Colors.red);
    } catch (e) {
      showSnackBar("unexpected error occurred", navigatorKey.currentContext!,backgroundColor: Colors.red);
    }
  }

  static Future<void> deleteRequest(String url, Object? formData,
      Options? options, Function(Response) func) async {
    final dio = _getDio();

    try {
      final response = await dio.delete(_BASE_URL + "${url}",
          data: formData, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        func(response);
      } else if (response.statusCode == 400) {
        showSnackBar(response.data[0], navigatorKey.currentContext!,backgroundColor: Colors.yellow);
      }
    } on DioException catch (e) {
      showSnackBar("Network Error", navigatorKey.currentContext!,backgroundColor: Colors.red);
    } catch (e) {
      showSnackBar("unexpected error occurred", navigatorKey.currentContext!,backgroundColor: Colors.red);
    }
  }
}
