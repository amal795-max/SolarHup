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

final class SendVerificationLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];}

final class SendVerificationFailure extends ResetPasswordState {
  final String message;

  const SendVerificationFailure({required this.message});

  @override
  List<Object> get props => [message];}

final class SendVerificationSuccess extends ResetPasswordState {
  final String message;

  const SendVerificationSuccess({required this.message});

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


