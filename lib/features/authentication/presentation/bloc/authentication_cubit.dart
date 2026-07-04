import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../data/repositories/authentication_repo.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepositories repository;
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> authKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  AuthenticationCubit(this.repository) : super(AuthenticationInitial());

  void checkPhoneNumber() async {
    if (authKey.currentState!.validate()) {
      emit(AuthenticationLoading());
      final result = await repository.checkPhoneNumber(
        DataHelper.formatePhoneNumber(phoneNumberController.text),
      );
      result.fold(
        (failure) =>
            emit(AuthenticationFailure(message: mapFailureToMessage(failure))),
        (success) => emit(AuthenticationSuccess(isExists: success)),
      );
    }
  }

  void register() async {
    RegisterParams registerParams = RegisterParams(
      DataHelper.formatePhoneNumber(phoneNumberController.text),
      passwordController.text.trim(),
      'customer',
    );
    if (registerKey.currentState!.validate()) {
      emit(AuthenticationLoading());
      final result = await repository.register(registerParams);
      result.fold(
        (failure) =>
            emit(AuthenticationFailure(message: mapFailureToMessage(failure))),
        (success) =>
            emit(const RegisterSuccess(message: registerSuccessMessage)),
      );
    }
  }
}
