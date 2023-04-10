import 'package:feeling_analysis/movies/movies.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_api/movie_api.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MoviesCubit>().getMovies();

    return BlocBuilder<MoviesCubit, MoviesState>(
      bloc: context.read<MoviesCubit>(),
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Center(child: ProgressRing());
        } else if (state.status.isFailure) {
          return const Center(child: Text('Error al cargar las películas'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
              children: state.movies
                  .map(
                    (movie) => MovieCard(movie: movie),
                  )
                  .toList(),
            ),
          );
        }
      },
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
      child: Card(
        padding: const EdgeInsets.all(2.5),
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
    );
  }
}
