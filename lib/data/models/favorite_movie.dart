import 'package:cinebox/data/models/movie.dart';

class FavoriteMovie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;
  final DateTime addedAt;

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
    required this.addedAt,
  });

  // Converter Movie para FavoriteMovie
  factory FavoriteMovie.fromMovie(Movie movie) {
    return FavoriteMovie(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      releaseDate: movie.releaseDate,
      genreIds: movie.genreIds,
      adult: movie.adult,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      popularity: movie.popularity,
      video: movie.video,
      addedAt: DateTime.now(),
    );
  }

  // Converter FavoriteMovie para Movie
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      releaseDate: releaseDate,
      genreIds: genreIds,
      adult: adult,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      popularity: popularity,
      video: video,
    );
  }

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'] ?? false,
      addedAt: DateTime.parse(
        json['added_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
      'added_at': addedAt.toIso8601String(),
    };
  }

  // Getters úteis
  String get fullPosterPath =>
      posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  String get year => releaseDate.isNotEmpty ? releaseDate.split('-')[0] : '';

  String get formattedVoteAverage => voteAverage.toStringAsFixed(1);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMovie &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FavoriteMovie{id: $id, title: $title, addedAt: $addedAt}';
  }
}
