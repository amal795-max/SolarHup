import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kitch_plus/core/constants/user-parameters.dart';
import '../../../../../core/constants/failure_success_message.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/useCases/check_email_usecase.dart';
import '../../../domain/useCases/update_password_usecase.dart';
import '../../../domain/useCases/verify_code_use_case.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final CheckEmailUseCase checkEmailUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final GlobalKey<FormState> checkEmailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> verifyCodeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updatePasswordKey = GlobalKey<FormState>();
  final TextEditingController checkEmailController = TextEditingController();
  final TextEditingController otpCodeController = TextEditingController();
  final TextEditingController password = TextEditingController();



  ResetPasswordBloc(this.checkEmailUseCase, this.verifyCodeUseCase, this.updatePasswordUseCase) : super(ResetPasswordInitial()) {
    on<ResetPasswordEvent>((event, emit) async{
      if(event is CheckEmailEvent){
        emit(ResetPasswordLoading());
        final checkEmail = await checkEmailUseCase(event.email);
        checkEmail.fold(
            (failure)=> emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (success)=> emit(ResetPasswordSuccess(message: CHECK_EMAIL_MESSAGE)));

      }
      if(event is VerifyCodeEvent){
        emit(ResetPasswordLoading());
        final verifyCode = await verifyCodeUseCase(event.verifyCodeParams);
        verifyCode.fold(
            (failure)=> emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (success)=> emit(ResetPasswordSuccess(message: VERIFY_CODE_MESSAGE)));

      }
      if(event is UpdatePasswordEvent){
        emit(ResetPasswordLoading());
        final updatePassword = await updatePasswordUseCase(event.updatePasswordParams);
        updatePassword.fold(
            (failure)=> emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (success)=> emit(ResetPasswordSuccess(message: UPDATE_PASSWORD_MESSAGE)));

      }
    });
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return "Unexpected error. Please try again later.";
    }
  }
}
