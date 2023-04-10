import 'package:feeling_analysis/movies/movies.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MoviesCubit>().getMovies();

    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Center(child: ProgressRing());
        } else if (state.status.isFailure) {
          return const Center(child: Text('Error al cargar las películas'));
        } else {
          return ListView.builder(
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text(movie.overview),
              );
            },
          );
        }
      },
    );
  }
}
