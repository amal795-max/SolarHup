import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../data/repositories/authentication_repo.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final ResetPasswordRepositories repository;
final phoneNumberController = TextEditingController();
final GlobalKey<FormState> authKey = GlobalKey<FormState>();

  AuthenticationCubit(this.repository) : super(AuthenticationInitial());


  void checkPhoneNumber() async {
    if (authKey.currentState!.validate()) {
    emit(AuthenticationLoading());
    final result = await repository.checkPhoneNumber(phoneNumberController.text);

    result.fold(
          (failure) =>
          emit(AuthenticationFailure(message: mapFailureToMessage(failure))),
          (success) => emit( AuthenticationSuccess(isExists:success)),
    );
  }
}}