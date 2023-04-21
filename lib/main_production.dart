import 'package:dio/dio.dart';
import 'package:feeling_analysis/app/app.dart';
import 'package:feeling_analysis/bootstrap.dart';
import 'package:movie_api_remote/movie_api_remote.dart';
import 'package:movie_repository/movie_repository.dart';

void main() async {
  // Cliente HTTP
  final httpClient = Dio(
    BaseOptions(
      baseUrl: 'https://oo3bbe7zo3.execute-api.us-west-2.amazonaws.com',
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
