import 'dart:developer';

import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/movie_service.dart';
import './favorites_service.dart';

class FavoritesServiceImpl implements FavoritesService {
  final MovieService _movieService;

  FavoritesServiceImpl({
    required MovieService movieService,
  }) : _movieService = movieService;

  @override
  Future<bool> addToFavorites(Movie movie) async {
    try {
      log(
        'Adicionando filme aos favoritos: ${movie.title}',
        name: 'FavoritesService',
      );

      final success = await _movieService.addToFavorites(movie.id);

      if (success) {
        log(
          'Filme adicionado aos favoritos com sucesso: ${movie.title}',
          name: 'FavoritesService',
        );
      } else {
        log(
          'Falha ao adicionar filme aos favoritos: ${movie.title}',
          name: 'FavoritesService',
        );
      }

      return success;
    } catch (e, stackTrace) {
      log(
        'Erro ao adicionar aos favoritos: ${movie.title}',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<bool> removeFromFavorites(int movieId) async {
    try {
      log('Removendo filme dos favoritos: $movieId', name: 'FavoritesService');

      final success = await _movieService.removeFromFavorites(movieId);

      if (success) {
        log(
          'Filme removido dos favoritos com sucesso: $movieId',
          name: 'FavoritesService',
        );
      } else {
        log(
          'Falha ao remover filme dos favoritos: $movieId',
          name: 'FavoritesService',
        );
      }

      return success;
    } catch (e, stackTrace) {
      log(
        'Erro ao remover dos favoritos: $movieId',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    try {
      // Por enquanto, sempre retornar false
      return false;
    } catch (e, stackTrace) {
      log(
        'Erro ao verificar se é favorito: $movieId',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<List<Movie>> getFavorites() async {
    try {
      log('Buscando filmes favoritos', name: 'FavoritesService');

      final movieResponse = await _movieService.getFavoriteMovies();
      final favorites = movieResponse.results;

      log(
        '${favorites.length} filmes favoritos encontrados',
        name: 'FavoritesService',
      );

      return favorites;
    } catch (e, stackTrace) {
      log(
        'Erro ao obter favoritos',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<Movie?> getFavorite(int movieId) async {
    try {
      final favorites = await getFavorites();
      return favorites.firstWhere(
        (movie) => movie.id == movieId,
        orElse: () => throw Exception('Filme não encontrado'),
      );
    } catch (e, stackTrace) {
      log(
        'Erro ao obter favorito: $movieId',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<bool> clearFavorites() async {
    try {
      log('Limpando todos os favoritos', name: 'FavoritesService');

      log('Favoritos limpos com sucesso', name: 'FavoritesService');
      return true;
    } catch (e, stackTrace) {
      log(
        'Erro ao limpar favoritos',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final favorites = await getFavorites();
      return favorites.length;
    } catch (e, stackTrace) {
      log(
        'Erro ao obter contagem de favoritos',
        name: 'FavoritesService',
        error: e,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }
}
