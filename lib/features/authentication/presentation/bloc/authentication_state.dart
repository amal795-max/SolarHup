part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();
}

final class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

final class AuthenticationLoading extends AuthenticationState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class AuthenticationSuccess extends AuthenticationState {
  final bool isExists;

  const AuthenticationSuccess({required this.isExists});

  @override
  // TODO: implement props
  List<Object?> get props => [isExists];

}
final class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}final class RegisterSuccess extends AuthenticationState {
  final String message;

  const RegisterSuccess({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}
