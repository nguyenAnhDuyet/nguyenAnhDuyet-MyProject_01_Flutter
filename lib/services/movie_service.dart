import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';

class MovieService {
  static const String baseUrl = 'https://phimapi.com';

  Future<MovieResponse> getLatestMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/danh-sach/phim-moi-cap-nhat?page=$page'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<MovieDetailResponse> getMovieDetail(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/phim/$slug'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MovieDetailResponse.fromJson(data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 