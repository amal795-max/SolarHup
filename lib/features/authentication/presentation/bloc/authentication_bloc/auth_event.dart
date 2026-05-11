part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];}

class RegisterEvent extends AuthEvent{
  final RegisterParams registerParams;
  const RegisterEvent({required this.registerParams});

  @override
  // TODO: implement props
  List<Object?> get props => [registerParams];
}

class LoginEvent extends AuthEvent{
  final LoginParams loginParams;
  const LoginEvent({required this.loginParams});

  @override
  // TODO: implement props
  List<Object?> get props => [loginParams];
}
class LogoutEvent extends AuthEvent{
  const LogoutEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TermsOfUseEvent extends AuthEvent{
  const TermsOfUseEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PrivacyPolicyEvent extends AuthEvent{
  const PrivacyPolicyEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}