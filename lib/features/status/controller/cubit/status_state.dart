part of 'status_cubit.dart';

@immutable
abstract class StatusState {}

class StatusInitial extends StatusState {}

class GetUserDataLoading extends StatusState {}

class GetUserDataSuccess extends StatusState {}

class GetUserDataError extends StatusState {
  final String? errorMsg;

  GetUserDataError(this.errorMsg);
}

class UploadStoryLoading extends StatusState {}

class UploadStorySuccess extends StatusState {}

class UploadStoryError extends StatusState {
  final String? errorMsg;

  UploadStoryError(this.errorMsg);
}
