part of 'reset_password_cubit.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  const ResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  const ResetPasswordFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class VerificationLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];}

final class VerificationFailure extends ResetPasswordState {
  final String message;

  const VerificationFailure({required this.message});

  @override
  List<Object> get props => [message];}

final class VerificationSuccess extends ResetPasswordState {
  final String message;

  const VerificationSuccess({required this.message});

  @override
  List<Object> get props => [message];}
final class ConfirmOtpLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];}

final class ConfirmOtpFailure extends ResetPasswordState {
  final String message;

  const ConfirmOtpFailure({required this.message});

  @override
  List<Object> get props => [message];}

final class ConfirmOtpSuccess extends ResetPasswordState {

  const ConfirmOtpSuccess();

  @override
  List<Object> get props => [];}


