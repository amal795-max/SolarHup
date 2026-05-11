part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess({required this.message});
}
final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

}
final class AuthLoading extends AuthState {}



final class SettingsSuccess extends AuthState {
  final String data;
  const SettingsSuccess({required this.data});

}
final class SettingsFailure extends AuthState {
  final String message;
  const SettingsFailure({required this.message});

}
final class SettingsLoading extends AuthState {}
