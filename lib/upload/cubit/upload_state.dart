part of 'upload_cubit.dart';

enum UploadStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == UploadStatus.initial;
  bool get isLoading => this == UploadStatus.loading;
  bool get isSuccess => this == UploadStatus.success;
  bool get isFailure => this == UploadStatus.failure;
}

class UploadState extends Equatable {
  const UploadState({
    this.status = UploadStatus.initial,
    this.pickedFile,
    this.csvData,
  });

  final UploadStatus status;
  final File? pickedFile;
  final List<List<String>>? csvData;

  UploadState copyWith({
    UploadStatus? status,
    File? pickedFile,
    List<List<String>>? csvData,
  }) {
    return UploadState(
      status: status ?? this.status,
      pickedFile: pickedFile ?? this.pickedFile,
      csvData: csvData ?? this.csvData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pickedFile,
        csvData,
      ];
}
