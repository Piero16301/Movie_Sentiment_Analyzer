import 'package:feeling_analysis/app/app.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_repository/movie_repository.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required MovieRepository movieRepository,
    super.key,
  }) : _movieRepository = movieRepository;

  final MovieRepository _movieRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _movieRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppCubit(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}
