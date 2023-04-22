import 'package:movie_api/movie_api.dart';

/// {@template movie_api}
/// Movie API Connection
/// {@endtemplate}
abstract class IMovieApiRemote {
  /// Obtener peliculas analizadas
  Future<List<Movie>> getMovies();

  /// Obtener comentarios de una pelicula
  Future<List<Comment>> getComments(String movieId);
}
