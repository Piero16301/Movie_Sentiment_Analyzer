import 'package:feeling_analysis/home/home.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.dark(),
      home: const HomePage(),
    );
  }
}
