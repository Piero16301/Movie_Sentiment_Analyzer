part of 'movies_cubit.dart';

enum MoviesStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == MoviesStatus.initial;
  bool get isLoading => this == MoviesStatus.loading;
  bool get isSuccess => this == MoviesStatus.success;
  bool get isFailure => this == MoviesStatus.failure;
}

class MoviesState extends Equatable {
  const MoviesState({
    this.status = MoviesStatus.initial,
    this.movies = const [],
  });

  final MoviesStatus status;
  final List<Movie> movies;

  MoviesState copyWith({
    MoviesStatus? status,
    List<Movie>? movies,
  }) {
    return MoviesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object> get props => [
        status,
        movies,
      ];
}
