import 'package:cinebox/data/core/rest_client/tmdb_rest_client_provider.dart';
import 'package:cinebox/data/models/movie_details.dart';
import 'package:cinebox/data/models/movie_response.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_service.g.dart';

abstract class MovieService {
  Future<MovieResponse> getPopularMovies({int page = 1});
  Future<MovieResponse> getTopRatedMovies({int page = 1});
  Future<MovieResponse> getMoviesByGenre(int genreId, {int page = 1});
  Future<MovieResponse> searchMovies(String query, {int page = 1});

  // Métodos para favoritos
  Future<bool> addToFavorites(int movieId);
  Future<bool> removeFromFavorites(int movieId);
  Future<MovieResponse> getFavoriteMovies({int page = 1});

  // Métodos para conta do usuário
  Future<Map<String, dynamic>> getAccountInfo();
  Future<MovieResponse> getRatedMovies({int page = 1});
  Future<MovieResponse> getWatchlist({int page = 1});

  // Método para detalhes do filme
  Future<MovieDetails> getMovieDetails(int movieId);
}

class MovieServiceImpl implements MovieService {
  final Dio _dio;

  // Account ID obtido dinamicamente
  String? _accountId;

  MovieServiceImpl(this._dio);

  /// Obtém o account ID da sessão atual do TMDB
  Future<String> _getAccountId() async {
    if (_accountId != null) return _accountId!;

    try {
      final response = await _dio.get(
        '/account',
        queryParameters: {'language': 'pt-BR'},
      );
      _accountId = response.data['id'].toString();
      return _accountId!;
    } on DioException catch (e) {
      throw Exception('Erro ao obter account ID: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'region': 'BR',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar filmes populares: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/top_rated',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'region': 'BR',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar top filmes: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/discover/movie',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'region': 'BR',
          'with_genres': genreId,
          'sort_by': 'popularity.desc',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar filmes por gênero: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'region': 'BR',
          'query': query,
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar filmes: ${e.message}');
    }
  }

  @override
  Future<bool> addToFavorites(int movieId) async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.post(
        '/account/$accountId/favorite',
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception('Erro ao adicionar aos favoritos: ${e.message}');
    }
  }

  @override
  Future<bool> removeFromFavorites(int movieId) async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.post(
        '/account/$accountId/favorite',
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception('Erro ao remover dos favoritos: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getFavoriteMovies({int page = 1}) async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.get(
        '/account/$accountId/favorite/movies',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'sort_by': 'created_at.desc',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar filmes favoritos: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getAccountInfo() async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.get(
        '/account/$accountId',
        queryParameters: {
          'language': 'pt-BR',
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar informações da conta: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getRatedMovies({int page = 1}) async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.get(
        '/account/$accountId/rated/movies',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'sort_by': 'created_at.desc',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar filmes avaliados: ${e.message}');
    }
  }

  @override
  Future<MovieResponse> getWatchlist({int page = 1}) async {
    try {
      final accountId = await _getAccountId();
      final response = await _dio.get(
        '/account/$accountId/watchlist/movies',
        queryParameters: {
          'page': page,
          'language': 'pt-BR',
          'sort_by': 'created_at.desc',
        },
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar watchlist: ${e.message}');
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {
          'language': 'pt-BR',
          'append_to_response': 'credits,videos,images,recommendations',
        },
      );

      return MovieDetails.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Erro ao buscar detalhes do filme: ${e.message}');
    }
  }
}

@riverpod
MovieService movieService(Ref ref) {
  final dio = ref.watch(tmdbRestClientProvider);
  return MovieServiceImpl(dio);
}
