part of 'user_information_cubit.dart';

@immutable
abstract class UserInformationState {}

class UserInformationInitial extends UserInformationState {}

class UpdateProfileImage extends UserInformationState {}

class UploadProfileImageLoading extends UserInformationState {}

class UploadProfileImageSuccess extends UserInformationState {}

class UploadProfileImageError extends UserInformationState {
  final String? errorMsg;

  UploadProfileImageError(this.errorMsg);
}

class SaveUserDataToFirebaseLoading extends UserInformationState {}

class SaveUserDataToFirebaseSuccess extends UserInformationState {}

class SaveUserDataToFirebaseError extends UserInformationState {
  final String? errorMsg;

  SaveUserDataToFirebaseError(this.errorMsg);
}

class GetUserDataLoading extends UserInformationState {}

class GetUserDataSuccess extends UserInformationState {}

class GetUserDataError extends UserInformationState {
  final String? errorMsg;

  GetUserDataError(this.errorMsg);
}
