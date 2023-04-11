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
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              MovieDetailsRow(movie: movie),
              const SizedBox(height: 30),
              MovieComments(movie: movie),
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
    );
  }
}

class MovieComments extends StatelessWidget {
  const MovieComments({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ...List.generate(
          5,
          (index) => const CommentRow(
            title: 'A Must-See Silent Comedy',
            comment:
                'While perhaps not as celebrated now as some of Chaplin\'s later features "The Kid" is an excellent achievement and a thoroughly enjoyable film. Charlie and young Jackie Coogan make an entertaining and unforgettable pair and there is a lot of good slapstick plus a story that moves quickly and makes you want to know what will happen. Chaplin also wrote a particularly good score for this one and most of the time the music sets off the action very nicely.While it\'s a fairly simple story this is one of Chaplin\'s most efficiently designed movies. Every scene either is necessary to the plot or is very funny for its own sake or both. Except for Chaplin and Coogan most of the other characters (even frequent Chaplin leading lady Edna Purviance) are just there to advance the plot when needed and the two leads are allowed to carry the show which they both do extremely well."The Kid" is also impressive in that while the story is a sentimental one it strikes an ideal balance maintaining sympathy for the characters while never overdoing it with the pathos which Chaplin occasionally lapsed into even in some of his greatest movies. Here the careful balance makes the few moments of real emotion all the more effective and memorable.This is one of Chaplin\'s very best movies by any measure. If you enjoy silent comedies don\'t miss it.',
            date: '4 March 2002',
            sentiment: 'Positive',
          ),
        ),
      ],
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
