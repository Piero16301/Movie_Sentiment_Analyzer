import 'package:movie_api/movie_api.dart';

/// {@template movie_repository}
/// Movie Repository Connection
/// {@endtemplate}
class MovieRepository {
  /// {@macro movie_repository}
  const MovieRepository({
    required IMovieApiRemote movieApiRemote,
  }) : _movieApiRemote = movieApiRemote;

  final IMovieApiRemote _movieApiRemote;

  /// Obtener peliculas analizadas
  Future<List<Movie>> getMovies() async {
    return _movieApiRemote.getMovies();
  }

  /// Obtener comentarios de una pelicula
  Future<List<Comment>> getComments(String movieId) async {
    return _movieApiRemote.getComments(movieId);
  }

  /// Obtener sentimientos de una pelicula
  Future<List<Sentiment>> getSentiments(String movieId) async {
    return _movieApiRemote.getSentiments(movieId);
  }

  /// Subir archivo csv
  Future<void> uploadFile(String fileName, String filePath) async {
    return _movieApiRemote.uploadFile(fileName, filePath);
  }
}
