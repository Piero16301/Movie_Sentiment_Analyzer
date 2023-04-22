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

enum CommentsStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == CommentsStatus.initial;
  bool get isLoading => this == CommentsStatus.loading;
  bool get isSuccess => this == CommentsStatus.success;
  bool get isFailure => this == CommentsStatus.failure;
}

class MoviesState extends Equatable {
  const MoviesState({
    this.status = MoviesStatus.initial,
    this.commentsStatus = CommentsStatus.initial,
    this.movies = const [],
    this.comments = const <Comment>[],
  });

  final MoviesStatus status;
  final CommentsStatus commentsStatus;
  final List<Movie> movies;
  final List<Comment> comments;

  MoviesState copyWith({
    MoviesStatus? status,
    CommentsStatus? commentsStatus,
    List<Movie>? movies,
    List<Comment>? comments,
  }) {
    return MoviesState(
      status: status ?? this.status,
      commentsStatus: commentsStatus ?? this.commentsStatus,
      movies: movies ?? this.movies,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object> get props => [
        status,
        commentsStatus,
        movies,
        comments,
      ];
}
