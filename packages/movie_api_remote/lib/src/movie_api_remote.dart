// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:movie_api/movie_api.dart';

/// {@template movie_api_remote}
/// Movie API Remote Connection
/// {@endtemplate}
class MovieApiRemote implements IMovieApiRemote {
  /// {@macro movie_api_remote}
  const MovieApiRemote({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  final Dio _httpClient;

  @override
  Future<List<Movie>> getMovies() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '/default/GetAllMovies',
      );

      if (response.statusCode != 200) throw Exception(response.statusMessage);
      if (response.data == null) throw Exception('No data found');
      if (response.data?['movies'] == null) throw Exception('No results found');

      final moviesJson = response.data?['movies'] as List<dynamic>;
      final movies = moviesJson
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();

      return movies;
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
