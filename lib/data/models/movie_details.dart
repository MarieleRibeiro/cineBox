import 'genre.dart';

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final int? runtime;
  final String? status;
  final int? budget;
  final int? revenue;
  final List<Genre> genres;
  final String? tagline;
  final String? homepage;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    this.runtime,
    this.status,
    this.budget,
    this.revenue,
    required this.genres,
    this.tagline,
    this.homepage,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'],
      status: json['status'],
      budget: json['budget'],
      revenue: json['revenue'],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => Genre.fromJson(genre))
              .toList() ??
          [],
      tagline: json['tagline'],
      homepage: json['homepage'],
    );
  }

  String get fullPosterPath =>
      posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  String get year => releaseDate.isNotEmpty ? releaseDate.split('-')[0] : '';

  String get formattedRuntime {
    if (runtime == null) return 'Não informado';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes}min';
  }

  String get formattedBudget {
    if (budget == null || budget == 0) return 'Não informado';
    return '\$${(budget! / 1000000).toStringAsFixed(1)}M';
  }

  String get formattedRevenue {
    if (revenue == null || revenue == 0) return 'Não informado';
    return '\$${(revenue! / 1000000).toStringAsFixed(1)}M';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetails &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
