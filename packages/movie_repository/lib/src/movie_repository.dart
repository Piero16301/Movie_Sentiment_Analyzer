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
}
