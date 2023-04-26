import 'package:dio/dio.dart';
import 'package:feeling_analysis/app/app.dart';
import 'package:feeling_analysis/bootstrap.dart';
import 'package:movie_api_remote/movie_api_remote.dart';
import 'package:movie_repository/movie_repository.dart';

void main() async {
  // Cliente HTTP
  final httpClient = Dio(
    BaseOptions(
      baseUrl: 'https://fzdw2ou3ee.execute-api.us-west-2.amazonaws.com/v1',
      sendTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Inicializar Movie API
  final movieApiRemote = MovieApiRemote(httpClient: httpClient);
  final movieRepository = MovieRepository(movieApiRemote: movieApiRemote);

  await bootstrap(
    () => AppPage(
      movieRepository: movieRepository,
    ),
  );
}
