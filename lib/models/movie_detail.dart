class MovieDetail {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String content;
  final String type;
  final String status;
  final String thumbUrl;
  final String posterUrl;
  final String trailerUrl;
  final String time;
  final String episodeCurrent;
  final String episodeTotal;
  final String quality;
  final String lang;
  final int year;
  final int view;
  final double voteAverage;
  final int voteCount;
  final List<String> actors;
  final List<String> directors;
  final List<Category> categories;
  final List<Country> countries;

  MovieDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.thumbUrl,
    required this.posterUrl,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.year,
    required this.view,
    required this.voteAverage,
    required this.voteCount,
    required this.actors,
    required this.directors,
    required this.categories,
    required this.countries,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final movie = json['movie'];
    return MovieDetail(
      id: movie['_id'] ?? '',
      name: movie['name'] ?? '',
      slug: movie['slug'] ?? '',
      originName: movie['origin_name'] ?? '',
      content: movie['content'] ?? '',
      type: movie['type'] ?? '',
      status: movie['status'] ?? '',
      thumbUrl: movie['thumb_url'] ?? '',
      posterUrl: movie['poster_url'] ?? '',
      trailerUrl: movie['trailer_url'] ?? '',
      time: movie['time'] ?? '',
      episodeCurrent: movie['episode_current'] ?? '',
      episodeTotal: movie['episode_total'] ?? '',
      quality: movie['quality'] ?? '',
      lang: movie['lang'] ?? '',
      year: movie['year'] ?? 0,
      view: movie['view'] ?? 0,
      voteAverage: (movie['tmdb']?['vote_average'] ?? 0).toDouble(),
      voteCount: movie['tmdb']?['vote_count'] ?? 0,
      actors: (movie['actor'] as List?)?.map((e) => e.toString()).toList() ?? [],
      directors: (movie['director'] as List?)?.map((e) => e.toString()).toList() ?? [],
      categories: (movie['category'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [],
      countries: (movie['country'] as List?)?.map((e) => Country.fromJson(e)).toList() ?? [],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class Country {
  final String id;
  final String name;
  final String slug;

  Country({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class Episode {
  final String serverName;
  final List<EpisodeItem> items;

  Episode({
    required this.serverName,
    required this.items,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      serverName: json['server_name'] ?? '',
      items: (json['server_data'] as List?)?.map((e) => EpisodeItem.fromJson(e)).toList() ?? [],
    );
  }
}

class EpisodeItem {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3u8;

  EpisodeItem({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  factory EpisodeItem.fromJson(Map<String, dynamic> json) {
    return EpisodeItem(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      filename: json['filename'] ?? '',
      linkEmbed: json['link_embed'] ?? '',
      linkM3u8: json['link_m3u8'] ?? '',
    );
  }
}

class MovieDetailResponse {
  final bool status;
  final String message;
  final MovieDetail movie;
  final List<Episode> episodes;

  MovieDetailResponse({
    required this.status,
    required this.message,
    required this.movie,
    required this.episodes,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
      status: json['status'] ?? false,
      message: json['msg'] ?? '',
      movie: MovieDetail.fromJson(json),
      episodes: (json['episodes'] as List?)?.map((e) => Episode.fromJson(e)).toList() ?? [],
    );
  }
} 