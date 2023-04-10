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
    final response = await _httpClient.get<Map<String, dynamic>>(
      'https://api.themoviedb.org/3/movie/popular?api_key=1b3b4d3b0f1b4d3b0f1b4d3b0f1b4d3b&language=es-ES&page=1',
    );

    final movies = (response.data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();

    return movies;
  }
}
