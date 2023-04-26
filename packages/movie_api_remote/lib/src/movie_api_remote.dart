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

  @override
  Future<List<Sentiment>> getSentiments(String movieId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/GetCommentSentimentCount',
        data: {
          'idMovie': movieId,
        },
      );

      if (response.statusCode != 200) throw Exception(response.statusMessage);
      if (response.data == null) throw Exception('No data found');
      if (response.data?['sentiments'] == null) return [];

      final sentimentsJson = response.data?['sentiments'] as List<dynamic>;
      final sentiments = sentimentsJson
          .map((json) => Sentiment.fromJson(json as Map<String, dynamic>))
          .toList();

      return sentiments;
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> uploadFile(String fileName, String filePath) async {
    try {
      final uploadClient = Dio(
        BaseOptions(
          baseUrl: 'https://74qg9o1f2j.execute-api.us-east-1.amazonaws.com/v2',
          sendTimeout: const Duration(seconds: 10),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final response = await uploadClient.put<Map<String, dynamic>>(
          '/rawuteclespapus/$fileName',
          data: FormData.fromMap({
            'thefile': await MultipartFile.fromFile(filePath),
          }));

      if (response.statusCode != 200) throw Exception(response.statusMessage);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
