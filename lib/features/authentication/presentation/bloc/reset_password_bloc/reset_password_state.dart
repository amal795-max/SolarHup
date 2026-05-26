part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object> get props => <Object>[];
}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}
final class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  const ResetPasswordSuccess({required this.message});

}
final class ResetPasswordFailure extends ResetPasswordState {
  final String message;

  const ResetPasswordFailure({required this.message});

}
