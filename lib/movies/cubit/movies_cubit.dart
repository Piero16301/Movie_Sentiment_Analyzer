import 'package:equatable/equatable.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(const MoviesState());

  Future<void> getMovies() async {
    emit(state.copyWith(status: MoviesStatus.loading));
    try {
      final movies = await _getMovies();
      emit(state.copyWith(status: MoviesStatus.success, movies: movies));
    } on Exception {
      emit(state.copyWith(status: MoviesStatus.failure));
    }
  }
}
