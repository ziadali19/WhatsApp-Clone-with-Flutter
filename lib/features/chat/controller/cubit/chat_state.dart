part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class GetUserDataForChatLoading extends ChatState {}

class GetUserDataForChatSuccess extends ChatState {}

class GetUserDataForChatError extends ChatState {
  final String? message;

  GetUserDataForChatError(this.message);
}
