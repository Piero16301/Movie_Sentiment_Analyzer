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
        '/GetAllMovies',
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

  @override
  Future<List<Comment>> getComments(String movieId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/GetMovieComments',
        data: {
          'idMovie': movieId,
        },
      );

      if (response.statusCode != 200) throw Exception(response.statusMessage);
      if (response.data == null) throw Exception('No data found');
      if (response.data?['comments'] == null) return [];

      final commentsJson = response.data?['comments'] as List<dynamic>;
      final comments = commentsJson
          .map((json) => Comment.fromJson(json as Map<String, dynamic>))
          .toList();

      return comments;
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
