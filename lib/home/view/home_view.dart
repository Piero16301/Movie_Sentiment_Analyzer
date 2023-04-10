import 'package:feeling_analysis/home/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: DefaultTextStyle(
          style: FluentTheme.of(context).typography.subtitle!,
          child: const Text('Movie Sentiment Analyzer'),
        ),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        selected: context.select<HomeCubit, int>(
          (cubit) => cubit.state.paneIndex,
        ),
        onChanged: context.read<HomeCubit>().changePane,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.my_movies_t_v),
            title: const Text('Películas'),
            body: const Text('Películas'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.n_u_i_face),
            title: const Text('Sentimientos'),
            body: const Text('Sentimientos'),
          ),
        ],
      ),
    );
  }
}
