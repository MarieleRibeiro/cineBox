import 'movie.dart';

class HomeMoviesState {
  final List<Movie> popular;
  final List<Movie> top;

  const HomeMoviesState({
    required this.popular,
    required this.top,
  });

  HomeMoviesState copyWith({
    List<Movie>? popular,
    List<Movie>? top,
  }) {
    return HomeMoviesState(
      popular: popular ?? this.popular,
      top: top ?? this.top,
    );
  }
}
