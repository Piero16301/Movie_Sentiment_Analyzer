import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_api/movie_api.dart';
import 'package:movie_repository/movie_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this._movieRepository) : super(const AppState());

  final MovieRepository _movieRepository;

  void toggleMovies({required bool isMoviesSelected}) {
    emit(state.copyWith(isMoviesSelected: isMoviesSelected));
  }

  void selectMovie(Movie? movie) {
    emit(state.copyWith(movieSelected: movie));
  }

  void toggleSentiments({required bool isSentimientsSelected}) {
    emit(state.copyWith(isSentimientsSelected: isSentimientsSelected));
  }

  void clearSentiments() {
    final sentiments = state.sentiments..clear();
    emit(state.copyWith(sentiments: sentiments));
  }

  Future<void> getMovieSentiments() async {
    if (state.isMoviesSelected) {
      return;
    }

    try {
      final sentiments = await _movieRepository.getSentiments(
        state.movieSelected!.id,
      );
      emit(
        state.copyWith(
          sentiments: sentiments,
        ),
      );
    } on Exception {
      // No-op
    }
  }
}
