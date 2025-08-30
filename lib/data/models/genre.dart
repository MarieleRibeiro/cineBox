class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Gêneros principais do TMDB
class MovieGenres {
  static const Map<String, int> genres = {
    'Ação': 28,
    'Aventura': 12,
    'Animação': 16,
    'Comédia': 35,
    'Crime': 80,
    'Documentário': 99,
    'Drama': 18,
    'Família': 10751,
    'Fantasia': 14,
    'História': 36,
    'Terror': 27,
    'Música': 10402,
    'Mistério': 9648,
    'Romance': 10749,
    'Ficção Científica': 878,
    'Filme de TV': 10770,
    'Thriller': 53,
    'Guerra': 10752,
    'Faroeste': 37,
  };

  static int? getGenreId(String name) {
    return genres[name];
  }

  static String? getGenreName(int id) {
    for (var entry in genres.entries) {
      if (entry.value == id) return entry.key;
    }
    return null;
  }
}
