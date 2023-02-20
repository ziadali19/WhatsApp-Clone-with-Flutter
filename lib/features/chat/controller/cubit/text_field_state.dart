part of 'text_field_cubit.dart';

@immutable
abstract class TextFieldState {}

class TextFieldInitial extends TextFieldState {}

class GetUserDataLoading extends TextFieldState {}

class GetUserDataSuccess extends TextFieldState {}

class GetUserDataError extends TextFieldState {
  final String? message;

  GetUserDataError(this.message);
}

class SendMessageLoading extends TextFieldState {}

class SendMessageSuccess extends TextFieldState {}

class SendMessageError extends TextFieldState {
  final String? message;

  SendMessageError(this.message);
}

class SendFileLoading extends TextFieldState {}

class SendFileSuccess extends TextFieldState {}

class SendFileError extends TextFieldState {
  final String? message;

  SendFileError(this.message);
}

class CancelReply extends TextFieldState {}

class MessageReplyContainer extends TextFieldState {}
