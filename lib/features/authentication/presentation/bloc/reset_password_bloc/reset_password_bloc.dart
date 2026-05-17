import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/errors/failures.dart';
import '../../../data/repositories/reset_password_repo_impl.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordRepositories repository;

  ResetPasswordBloc(this.repository) : super(ResetPasswordInitial()) {

    on<CheckEmailEvent>((event, emit) async {
      emit(ResetPasswordLoading());
      final result = await repository.checkEmail(event.email);

      result.fold(
            (failure) => emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
            (_) => emit(ResetPasswordSuccess(message: '')),
      );
    });
    //
    // on<VerifyCodeEvent>((event, emit) async {
    //   emit(ResetPasswordLoading());
    //   final result = await repository.verifyCode(params: event.verifyCodeParams);
    //
    //   result.fold(
    //         (failure) => emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
    //         (_) => emit(VerifyCodeSuccess()),
    //   );
    // });
    //
    // on<UpdatePasswordEvent>((event, emit) async {
    //   emit(ResetPasswordLoading());
    //   final result = await repository.updatePassword(params: event.updatePasswordParams);
    //
    //   result.fold(
    //         (failure) => emit(ResetPasswordFailure(message: mapFailureToMessage(failure))),
    //         (_) => emit(UpdatePasswordSuccess()),
    //   );
    // });
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return "No internet connection";
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return "Unexpected error occurred";
    }
  }
}
