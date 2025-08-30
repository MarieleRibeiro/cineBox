import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_service.dart';
import 'package:cinebox/data/services/favorites/favorites_service_impl.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_provider.g.dart';

@riverpod
FavoritesService favoritesService(Ref ref) {
  final movieService = ref.watch(movieServiceProvider);
  return FavoritesServiceImpl(movieService: movieService);
}

// Provider simples para gerenciar favoritos
@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  Future<List<Movie>> build() async {
    final favoritesService = ref.watch(favoritesServiceProvider);
    return await favoritesService.getFavorites();
  }

  Future<void> addToFavorites(Movie movie) async {
    final favoritesService = ref.read(favoritesServiceProvider);
    final success = await favoritesService.addToFavorites(movie);

    if (success) {
      // Atualizar o estado após adicionar
      ref.invalidateSelf();
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    final favoritesService = ref.read(favoritesServiceProvider);
    final success = await favoritesService.removeFromFavorites(movieId);

    if (success) {
      // Atualizar o estado após remover
      ref.invalidateSelf();
    }
  }

  Future<bool> isFavorite(int movieId) async {
    final favoritesService = ref.read(favoritesServiceProvider);
    return await favoritesService.isFavorite(movieId);
  }

  Future<void> clearFavorites() async {
    final favoritesService = ref.read(favoritesServiceProvider);
    final success = await favoritesService.clearFavorites();

    if (success) {
      // Atualizar o estado após limpar
      ref.invalidateSelf();
    }
  }
}
