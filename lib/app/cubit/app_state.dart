part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.isMoviesSelected = true,
    this.movieSelected,
    this.isSentimientsSelected = true,
  });

  final bool isMoviesSelected;
  final Movie? movieSelected;
  final bool isSentimientsSelected;

  AppState copyWith({
    bool? isMoviesSelected,
    Movie? movieSelected,
    bool? isSentimientsSelected,
  }) {
    return AppState(
      isMoviesSelected: isMoviesSelected ?? this.isMoviesSelected,
      movieSelected: movieSelected ?? this.movieSelected,
      isSentimientsSelected:
          isSentimientsSelected ?? this.isSentimientsSelected,
    );
  }

  @override
  List<Object?> get props => [
        isMoviesSelected,
        movieSelected,
        isSentimientsSelected,
      ];
}
