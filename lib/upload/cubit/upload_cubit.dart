// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(const UploadState());

  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (pickedFile != null) {
      final file = File(pickedFile.files.single.path!);
      final csvData = file.readAsStringSync().split('\n').map((line) {
        return line.split(',');
      }).toList();
      for (var i = 0; i < csvData.length; i++) {
        if (i == 0) {
          csvData[i] = csvData[i].map((e) => e.toUpperCase()).toList();
        }
        if (csvData[i].length != 3) {
          csvData.removeAt(i);
        }
      }
      emit(
        state.copyWith(
          pickedFile: File(pickedFile.files.single.path!),
          csvData: csvData,
        ),
      );
    }
  }

  Future<void> sendFile() async {
    emit(state.copyWith(status: UploadStatus.loading));
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: UploadStatus.success, pickedFile: null));
    } catch (e) {
      emit(state.copyWith(status: UploadStatus.failure));
    }
  }
}
