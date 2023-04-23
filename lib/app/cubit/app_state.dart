part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.isMoviesSelected = true,
    this.movieSelected,
    this.isSentimientsSelected = true,
    this.sentiments = const <Sentiment>[],
  });

  final bool isMoviesSelected;
  final Movie? movieSelected;
  final bool isSentimientsSelected;
  final List<Sentiment> sentiments;

  AppState copyWith({
    bool? isMoviesSelected,
    Movie? movieSelected,
    bool? isSentimientsSelected,
    List<Sentiment>? sentiments,
  }) {
    return AppState(
      isMoviesSelected: isMoviesSelected ?? this.isMoviesSelected,
      movieSelected: movieSelected ?? this.movieSelected,
      isSentimientsSelected:
          isSentimientsSelected ?? this.isSentimientsSelected,
      sentiments: sentiments ?? this.sentiments,
    );
  }

  @override
  List<Object?> get props => [
        isMoviesSelected,
        movieSelected,
        isSentimientsSelected,
        sentiments,
      ];
}
