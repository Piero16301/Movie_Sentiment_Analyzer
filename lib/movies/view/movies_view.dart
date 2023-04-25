import 'dart:async';

import 'package:feeling_analysis/app/app.dart';
import 'package:feeling_analysis/movies/movies.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hovering/hovering.dart';
import 'package:movie_api/movie_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> with WidgetsBindingObserver {
  late StreamSubscription<void> _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = Stream<void>.periodic(const Duration(seconds: 5))
        .listen((_) => context.read<AppCubit>().getMovieSentiments());

    context.read<MoviesCubit>().getMovies();
    context.read<AppCubit>().toggleMovies(isMoviesSelected: true);
    context.read<AppCubit>().selectMovie(null);
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _subscription.resume();
    } else {
      if (!_subscription.isPaused) {
        _subscription.pause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final isMoviesSelected = context.select<AppCubit, bool>(
      (cubit) => cubit.state.isMoviesSelected,
    );
    final movieSelected = context.select<AppCubit, Movie?>(
      (cubit) => cubit.state.movieSelected,
    );

    return BlocBuilder<MoviesCubit, MoviesState>(
      bloc: context.read<MoviesCubit>(),
      builder: (context, state) {
        if (state.moviesStatus.isLoading) {
          return const Center(child: ProgressRing());
        } else if (state.moviesStatus.isFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error al cargar las películas',
                style: TextStyle(
                  fontFamily: 'Ubuntu-Medium',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                width: 100,
                child: FilledButton(
                  child: const Center(
                    child: Text(
                      'Reintentar',
                      style: TextStyle(
                        fontFamily: 'Ubuntu-Medium',
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<MoviesCubit>().getMovies();
                  },
                ),
              ),
            ],
          );
        } else {
          if (isMoviesSelected) {
            return MoviesGrid(movies: state.movies);
          } else {
            return MovieDetails(movie: movieSelected!);
          }
        }
      },
    );
  }
}

class MoviesGrid extends StatelessWidget {
  const MoviesGrid({
    required this.movies,
    super.key,
  });

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: GridView.count(
        crossAxisCount: 7,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 3 / 4,
        physics: const BouncingScrollPhysics(),
        children: movies
            .map(
              (movie) => MovieCard(movie: movie),
            )
            .toList(),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    super.key,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          context.read<AppCubit>().toggleMovies(isMoviesSelected: false);
          context.read<AppCubit>().selectMovie(movie);
          context.read<MoviesCubit>().getMovieComments(movie.id);
        },
        child: Card(
          padding: const EdgeInsets.all(1),
          borderRadius: BorderRadius.circular(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      FluentIcons.file_image,
                      color: Colors.white,
                      size: 40,
                    ),
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: ProgressRing()),
                  ),
                ),
                SizedBox.expand(
                  child: HoverWidget(
                    hoverChild: ColoredBox(
                      color: Colors.black.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: 'Ubuntu-Medium',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '(${movie.releaseYear})',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Ubuntu-Medium',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onHover: (event) {},
                    child: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    required this.movie,
    super.key,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              MovieDetailsRow(movie: movie),
              const SizedBox(height: 30),
              Expanded(child: MovieComments(movie: movie)),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: const Icon(FluentIcons.skype_arrow, size: 20),
            onPressed: () {
              context.read<AppCubit>().toggleMovies(isMoviesSelected: true);
              context.read<AppCubit>().selectMovie(null);
              context.read<AppCubit>().clearSentiments();
            },
          ),
        ),
      ],
    );
  }
}

class MovieDetailsRow extends StatelessWidget {
  const MovieDetailsRow({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          width: 175,
          child: Card(
            padding: const EdgeInsets.all(1),
            borderRadius: BorderRadius.circular(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Positioned.fill(
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(child: ProgressRing()),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${movie.title} (${movie.releaseYear})',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Ubuntu-Medium',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.overview,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  maxLines: 10,
                  style: const TextStyle(
                    fontFamily: 'Ubuntu-Light',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        const SentimentCountVisualizer(),
      ],
    );
  }
}

class SentimentCountVisualizer extends StatelessWidget {
  const SentimentCountVisualizer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state.sentiments.isEmpty) {
          return SizedBox(
            height: 250,
            width: 250,
            child: Card(
              padding: const EdgeInsets.all(1),
              borderRadius: BorderRadius.circular(5),
              child: const Center(
                child: Text(
                  'Aún no hay comentarios',
                  style: TextStyle(fontFamily: 'Ubuntu-Medium'),
                ),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 250,
            width: 250,
            child: Card(
              padding: const EdgeInsets.all(1),
              borderRadius: BorderRadius.circular(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Positioned.fill(
                  child: SfCircularChart(
                    palette: [
                      Colors.blue,
                      Colors.red,
                      Colors.purple,
                    ],
                    title: ChartTitle(
                      text: 'Sentimientos',
                      textStyle: const TextStyle(
                        fontFamily: 'Ubuntu-Medium',
                        fontSize: 14,
                      ),
                    ),
                    legend: Legend(isVisible: false),
                    onTooltipRender: (TooltipArgs args) {
                      final dataPoints = args.dataPoints as List<Sentiment>?;
                      args.text =
                          '${dataPoints![args.pointIndex!.toInt()].sentiment}: '
                          '${dataPoints[args.pointIndex!.toInt()].count}';
                    },
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: [
                      PieSeries<Sentiment, String>(
                        animationDelay: 0,
                        animationDuration: 0,
                        dataSource: state.sentiments,
                        xValueMapper: (Sentiment data, _) => data.sentiment,
                        yValueMapper: (Sentiment data, _) => data.count,
                        dataLabelMapper: (Sentiment data, _) =>
                            data.count.toString(),
                        startAngle: 100,
                        endAngle: 100,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(
                            fontFamily: 'Ubuntu-Medium',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class MovieComments extends StatelessWidget {
  const MovieComments({
    super.key,
    required this.movie,
  });

  final Movie movie;
  static const sentiments = <int, String>{
    1: 'POSITIVE',
    2: 'NEGATIVE',
    3: 'NEUTRAL',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        if (state.commentsStatus.isLoading) {
          return const Center(child: ProgressRing());
        } else if (state.commentsStatus.isSuccess) {
          if (state.comments.isEmpty) {
            return const Center(
              child: Text(
                'No existen comentarios para esta película',
                style: TextStyle(
                  fontFamily: 'Ubuntu-Medium',
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: const [
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Divider(
                            direction: Axis.vertical,
                            size: 30,
                            style: DividerThemeData(
                              thickness: 2,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Comment',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Ubuntu-Medium',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Divider(
                            direction: Axis.vertical,
                            size: 30,
                            style: DividerThemeData(
                              thickness: 2,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Sentiment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Ubuntu-Medium',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Divider(
                            direction: Axis.vertical,
                            size: 30,
                            style: DividerThemeData(
                              thickness: 2,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...state.comments.map(
                    (comment) => CommentRow(
                      title: comment.title,
                      comment: comment.content,
                      date: comment.registerDate,
                      sentiment: sentiments[comment.idSentiment] ?? 'NEUTRAL',
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error al cargar los comentarios',
                style: TextStyle(
                  fontFamily: 'Ubuntu-Medium',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                width: 100,
                child: FilledButton(
                  child: const Center(
                    child: Text(
                      'Reintentar',
                      style: TextStyle(
                        fontFamily: 'Ubuntu-Medium',
                      ),
                    ),
                  ),
                  onPressed: () =>
                      context.read<MoviesCubit>().getMovieComments(movie.id),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class CommentRow extends StatelessWidget {
  const CommentRow({
    required this.title,
    required this.comment,
    required this.date,
    required this.sentiment,
    super.key,
  });

  final String title;
  final String comment;
  final String date;
  final String sentiment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          child: Center(
            child: Divider(
              direction: Axis.vertical,
              size: 80,
              style: DividerThemeData(
                thickness: 2,
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: RichText(
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontFamily: 'Ubuntu-Medium',
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: ' ($date)',
                  style: const TextStyle(
                    fontFamily: 'Ubuntu-Light',
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: ' $comment',
                  style: const TextStyle(
                    fontFamily: 'Ubuntu-Light',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
          child: Center(
            child: Divider(
              direction: Axis.vertical,
              size: 80,
              style: DividerThemeData(
                thickness: 2,
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            sentiment,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Ubuntu-Medium',
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
          child: Center(
            child: Divider(
              direction: Axis.vertical,
              size: 80,
              style: DividerThemeData(
                thickness: 2,
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
