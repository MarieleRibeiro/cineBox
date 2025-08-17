import 'package:cinebox/config/env.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_rest_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio backendRestClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.backendBaseUrl, // Replace with your backend URL
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';

  // Optionally add interceptors for logging, authentication, etc.
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      requestBody: true,
      error: true,
    ),
  );

  return dio;
}
