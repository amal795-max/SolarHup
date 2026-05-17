part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class CheckEmailEvent extends ResetPasswordEvent{
final String email;

  const CheckEmailEvent({required this.email});

}

// class VerifyCodeEvent extends ResetPasswordEvent{
//   final VerifyCodeParams verifyCodeParams;
//
//   const VerifyCodeEvent({required this.verifyCodeParams});
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];}
//
// class UpdatePasswordEvent extends ResetPasswordEvent{
//   final UpdatePasswordParams updatePasswordParams;
//
//   const UpdatePasswordEvent({required this.updatePasswordParams});
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }