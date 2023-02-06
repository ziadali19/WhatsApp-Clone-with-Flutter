part of 'layout_cubit.dart';

@immutable
abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class SetUserStatusError extends LayoutState {
  final String errorMsg;

  SetUserStatusError(this.errorMsg);
}
