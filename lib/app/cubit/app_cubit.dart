import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_api/movie_api.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void toggleMovies({required bool isMoviesSelected}) {
    emit(state.copyWith(isMoviesSelected: isMoviesSelected));
  }

  void selectMovie(Movie? movie) {
    emit(state.copyWith(movieSelected: movie));
  }

  void toggleSentiments({required bool isSentimientsSelected}) {
    emit(state.copyWith(isSentimientsSelected: isSentimientsSelected));
  }
}
