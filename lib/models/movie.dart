class Movie {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String posterUrl;
  final String thumbUrl;
  final int year;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.year,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      originName: json['origin_name'],
      posterUrl: json['poster_url'],
      thumbUrl: json['thumb_url'],
      year: json['year'],
      voteAverage: json['tmdb']['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['tmdb']['vote_count'] ?? 0,
    );
  }
}

class MovieResponse {
  final bool status;
  final List<Movie> items;
  final int currentPage;
  final int totalPages;

  MovieResponse({
    required this.status,
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      status: json['status'],
      items: (json['items'] as List).map((item) => Movie.fromJson(item)).toList(),
      currentPage: json['pagination']['currentPage'],
      totalPages: json['pagination']['totalPages'],
    );
  }
} 