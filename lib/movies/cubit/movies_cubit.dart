import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_api/movie_api.dart';
import 'package:movie_repository/movie_repository.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this._movieRepository) : super(const MoviesState());

  final MovieRepository _movieRepository;

  Future<void> getMovies() async {
    emit(state.copyWith(moviesStatus: MoviesStatus.loading));
    try {
      final movies = await _movieRepository.getMovies();
      movies.sort((a, b) => a.releaseYear.compareTo(b.releaseYear));
      emit(
        state.copyWith(
          moviesStatus: MoviesStatus.success,
          movies: movies,
        ),
      );
    } on Exception {
      emit(state.copyWith(moviesStatus: MoviesStatus.failure));
    }
  }

  Future<void> getMovieComments(String movieId) async {
    emit(state.copyWith(commentsStatus: CommentsStatus.loading));
    try {
      final comments = await _movieRepository.getComments(movieId);
      comments.sort((a, b) => a.idSentiment.compareTo(b.idSentiment));
      emit(
        state.copyWith(
          commentsStatus: CommentsStatus.success,
          comments: comments,
        ),
      );
    } on Exception {
      emit(state.copyWith(commentsStatus: CommentsStatus.failure));
    }
  }
}
