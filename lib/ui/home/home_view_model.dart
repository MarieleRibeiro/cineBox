import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<Map<String, List<Movie>>> build() async {
    final movieService = ref.read(movieServiceProvider);

    try {
      // Carregar filmes populares e top filmes simultaneamente
      final popularMovies = await movieService.getPopularMovies();
      final topMovies = await movieService.getTopRatedMovies();

      return {
        'popular': popularMovies.results,
        'top': topMovies.results,
      };
    } catch (e) {
      throw Exception('Erro ao carregar filmes: $e');
    }
  }

  Future<void> refreshMovies() async {
    state = const AsyncLoading();
    await build();
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    try {
      final movieService = ref.read(movieServiceProvider);
      final result = await movieService.searchMovies(query);
      return result.results;
    } catch (e) {
      return [];
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      final movieService = ref.read(movieServiceProvider);
      final result = await movieService.getMoviesByGenre(genreId);
      return result.results;
    } catch (e) {
      return [];
    }
  }
}
