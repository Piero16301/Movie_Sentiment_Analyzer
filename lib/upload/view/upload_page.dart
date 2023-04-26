import 'package:feeling_analysis/upload/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_repository/movie_repository.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCubit(context.read<MovieRepository>()),
      child: const UploadView(),
    );
  }
}
