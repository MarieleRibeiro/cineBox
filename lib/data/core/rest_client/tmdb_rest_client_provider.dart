import 'package:cinebox/config/env.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tmdb_rest_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio tmdbRestClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3', // Replace with your backend URL
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Authorization'] =
      'Bearer ${Env.theMovieDbApiKey}'; // Add your TMDB API key

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
