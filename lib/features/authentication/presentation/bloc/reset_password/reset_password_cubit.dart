import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/local_storage.dart';
import 'package:untitled1/features/authentication/data/repositories/reset_password_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository repository;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpCodeController = TextEditingController();
  final GlobalKey<FormState> resetPasswordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();

  ResetPasswordCubit(this.repository) : super(ResetPasswordInitial());

  void setNewPassword() async {
    if (resetPasswordKey.currentState!.validate()) {
      emit(ResetPasswordLoading());

      final params = ResetPasswordParams(
        phoneNumber: LocalStorage().getData(key: ApiKeys.phoneNumber) ?? '',
        resetToken: otpCodeController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      final result = await repository.setNewPassword(params);

      result.fold(
            (failure) =>
            emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (success) =>
            emit(
              const ResetPasswordSuccess(message: resetPasswordSuccessMessage),
            ),
      );
    }
  }

  void changePassword() async {
    if (changePasswordKey.currentState!.validate()) {
      emit(ResetPasswordLoading());
      final params = ChangePasswordParams(
        currentPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      final result = await repository.changePassword(params);

      result.fold(
            (failure) =>
            emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (success) =>
            emit(const ResetPasswordSuccess(
                message: changePasswordSuccessMessage)),
      );
    }
  }

  void sendOtpVerification({required bool isReset}) async {
    OtpParams otpParams = OtpParams(
        DataHelper.formatePhoneNumber(''),
        isReset: isReset
    );
    emit(SendVerificationLoading());
    final result = await repository.otpVerification(otpParams);
    result.fold(
          (failure) =>
          emit(SendVerificationFailure(message: mapFailureToMessage(failure))),
          (success) =>
          emit(const SendVerificationSuccess(message: sendOtpSuccessMessage)),
    );
  }

  void confirmOtp({required bool isReset}) async {
    ConfirmOtpParams otpParams = ConfirmOtpParams(
      DataHelper.formatePhoneNumber(''),
      otpCodeController.text.trim(),
      isReset,
    );
    emit(ConfirmOtpLoading());
    final result = await repository.confirmOtp(otpParams);
    result.fold(
          (failure) =>
          emit(ConfirmOtpFailure(message: mapFailureToMessage(failure))),
          (success) {
            !isReset ? LocalStorage().saveData(key: ApiKeys.isVerified, value: true):null;
            emit(const ConfirmOtpSuccess());}
    );
  }

  @override
  Future<void> close() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    otpCodeController.dispose();
    return super.close();
  }
}
