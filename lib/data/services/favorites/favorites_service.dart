import 'package:cinebox/data/models/movie.dart';

abstract interface class FavoritesService {
  /// Adiciona um filme aos favoritos
  Future<bool> addToFavorites(Movie movie);

  /// Remove um filme dos favoritos
  Future<bool> removeFromFavorites(int movieId);

  /// Verifica se um filme está nos favoritos
  Future<bool> isFavorite(int movieId);

  /// Obtém todos os filmes favoritos
  Future<List<Movie>> getFavorites();

  /// Obtém um filme favorito específico
  Future<Movie?> getFavorite(int movieId);

  /// Limpa todos os favoritos
  Future<bool> clearFavorites();

  /// Obtém o número total de favoritos
  Future<int> getFavoritesCount();
}
