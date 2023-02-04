part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class SendMessageLoading extends ChatState {}

class SendMessageSuccess extends ChatState {}

class SendMessageError extends ChatState {
  final String? message;

  SendMessageError(this.message);
}

class GetUserDataLoading extends ChatState {}

class GetUserDataSuccess extends ChatState {}

class GetUserDataError extends ChatState {
  final String? message;

  GetUserDataError(this.message);
}
