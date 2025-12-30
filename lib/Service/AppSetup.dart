import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppSetup{

  //Dio
  static Dio createDio(){

    final String baseUrl = kIsWeb
        ? 'http://localhost:8083'   // Web
        : 'http://10.0.2.2:8083';

    final dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json',},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('🌐 Request: ${options.method} ${options.path}');
          print('📤 Headers: ${options.headers}');
          if (options.data != null) {
            print('📦 Body: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
          print('📥 Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print('❌ Error: ${error.response?.statusCode} ${error.requestOptions.path}');
          print('📥 Error Data: ${error.response?.data}');

          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            print("⚠️ Token expired. Removed locally.");
          }

          return handler.next(error);
        },
      ),
    );

    return dio;

  }
}