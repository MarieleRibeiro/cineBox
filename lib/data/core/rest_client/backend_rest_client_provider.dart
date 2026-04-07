import 'package:cinebox/config/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_rest_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio backendRestClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.backendBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';

  // Apenas adicionar log interceptor em modo debug
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        responseBody: false,
        requestBody: true,
        error: true,
      ),
    );
  }

  return dio;
}
