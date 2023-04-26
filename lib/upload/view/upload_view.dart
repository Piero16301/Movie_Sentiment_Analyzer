import 'package:feeling_analysis/upload/upload.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text(
          'Subir',
          style: TextStyle(
            fontFamily: 'Ubuntu-Medium',
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subir archivo .csv con comentarios de una película.',
                    style: TextStyle(
                      fontFamily: 'Ubuntu-Medium',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: FilledButton(
                      onPressed: context.read<UploadCubit>().pickFile,
                      child: const Center(
                        child: Text(
                          'Seleccionar archivo',
                          style: TextStyle(
                            fontFamily: 'Ubuntu-Medium',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: BlocBuilder<UploadCubit, UploadState>(
                builder: (context, state) {
                  if (state.isFileSelected) {
                    final fileName = state.pickedFile!.path
                        .split(r'\')
                        .last
                        .split('.')
                        .first;
                    return Column(
                      children: [
                        Text(
                          'ID película: '
                          '$fileName',
                          style: const TextStyle(
                            fontFamily: 'Ubuntu-Medium',
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Table(
                              children: [
                                for (final row in state.csvData!)
                                  TableRow(
                                    children: [
                                      for (final cell in row)
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            cell,
                                            style: const TextStyle(
                                              fontFamily: 'Ubuntu-Medium',
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: FilledButton(
                            onPressed: state.status.isLoading
                                ? null
                                : context.read<UploadCubit>().sendFile,
                            child: state.status.isLoading
                                ? const Center(child: ProgressBar())
                                : const Center(
                                    child: Text(
                                      'Enviar',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu-Medium',
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No se ha seleccionado ningún archivo',
                        style: TextStyle(
                          fontFamily: 'Ubuntu-Medium',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
