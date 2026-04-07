import 'package:cinebox/data/models/movie_details.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_details_view_model.g.dart';

@riverpod
Future<MovieDetails> movieDetails(Ref ref, int movieId) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.getMovieDetails(movieId);
}
