part of 'otb_cubit.dart';

@immutable
abstract class OtbState {}

class OtbInitial extends OtbState {}

class OtbLoading extends OtbState {}

class OtbSuccess extends OtbState {}

class OtbError extends OtbState {
  final String? errorMsg;

  OtbError(this.errorMsg);
}
