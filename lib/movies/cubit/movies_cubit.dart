import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_api/movie_api.dart';
import 'package:movie_repository/movie_repository.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this._movieRepository) : super(const MoviesState());

  final MovieRepository _movieRepository;

  Future<void> getMovies() async {
    emit(state.copyWith(status: MoviesStatus.loading));
    try {
      final movies = await _movieRepository.getMovies();
      emit(
        state.copyWith(
          status: MoviesStatus.success,
          movies: movies,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: MoviesStatus.failure));
    }
  }
}
