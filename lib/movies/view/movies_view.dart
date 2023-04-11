import 'package:feeling_analysis/app/app.dart';
import 'package:feeling_analysis/movies/movies.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_api/movie_api.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  void initState() {
    context.read<MoviesCubit>().getMovies();
    // context.read<AppCubit>().toggleMovies(isMoviesSelected: true);
    // context.read<AppCubit>().selectMovie(null);
    super.initState();
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
        if (state.status.isLoading) {
          return const Center(child: ProgressRing());
        } else if (state.status.isFailure) {
          return const Center(child: Text('Error al cargar las películas'));
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
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
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
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(child: ProgressRing()),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Ubuntu-Medium',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: 150,
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
                      height: 200,
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
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Card(
                      padding: const EdgeInsets.all(1),
                      borderRadius: BorderRadius.circular(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const Positioned.fill(
                          child: Placeholder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
            },
          ),
        ),
      ],
    );
  }
}
