import 'package:cinebox/data/models/home_movies_state.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeMoviesState> build() async {
    final movieService = ref.read(movieServiceProvider);

    try {
      // Carregar filmes populares e top filmes em paralelo
      final results = await Future.wait([
        movieService.getPopularMovies(),
        movieService.getTopRatedMovies(),
      ]);

      return HomeMoviesState(
        popular: results[0].results,
        top: results[1].results,
      );
    } catch (e) {
      throw Exception('Erro ao carregar filmes: $e');
    }
  }

  Future<void> refreshMovies() async {
    ref.invalidateSelf();
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
