part of 'call_cubit.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CreatCallLoading extends CallState {}

class CreatCallSuccess extends CallState {}

class CreatCallError extends CallState {
  final String? errorMsg;

  CreatCallError(this.errorMsg);
}

class GetUserDataCallLoading extends CallState {}

class GetUserDataCallSuccess extends CallState {}

class GetUserDataCallError extends CallState {
  final String? errorMsg;

  GetUserDataCallError(this.errorMsg);
}
