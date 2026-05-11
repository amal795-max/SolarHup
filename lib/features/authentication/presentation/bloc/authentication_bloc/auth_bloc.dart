import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/failure_success_message.dart';
import '../../../../../core/constants/user-parameters.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/useCases/login_use_case.dart';
import '../../../domain/useCases/logout_use_case.dart';
import '../../../domain/useCases/privacy_policy_case.dart';
import '../../../domain/useCases/register_use_case.dart';
import '../../../domain/useCases/terms_of_use_case.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  AuthBloc() : super(AuthInitial()) {

    on<AuthEvent>((event, emit) async {
      if(event is RegisterEvent){
        emit(AuthLoading());
        final registerUser=await registerUesCase(event.registerParams);
        registerUser.fold(
          (failure)=>emit( AuthFailure(message:mapFailureToMessage(failure))),
            (success)=>emit((AuthSuccess(message: REGISTER_SUCCESS_MESSAGE))));

      }
      if( event is LoginEvent){
        emit(AuthLoading());
        final loginUser= await loginUseCase(event.loginParams);
        loginUser.fold(
          (failure)=>emit(AuthFailure(message: mapFailureToMessage(failure))),
          (success)=>emit(AuthSuccess(message: LOGIN_SUCCESS_MESSAGE))
        );
      }
      if(event is LogoutEvent){
        emit(AuthLoading());
        final logoutUser= await logoutUseCase();
        logoutUser.fold(
          (failure)=>emit(AuthFailure(message: mapFailureToMessage(failure))),
          (success)=>emit(AuthSuccess(message: LOGOUT_SUCCESS_MESSAGE))
        );
      }

      if(event is PrivacyPolicyEvent){
        emit(SettingsLoading());
        final privacyPolicy = await privacyPolicyUseCase();
        privacyPolicy.fold(
          (failure)=>emit(SettingsFailure(message: mapFailureToMessage(failure))),
          (success)=>emit(SettingsSuccess(data: success.privacyPolicy))
        );
      }
      if(event is TermsOfUseEvent){
        emit(SettingsLoading());
        final termsOfUse = await termsOfUseUseCase();
        termsOfUse.fold(
          (failure)=>emit(SettingsFailure(message: mapFailureToMessage(failure))),
          (success)=>emit(SettingsSuccess(data: success.termsOfUse))
        );
      }
    
  });}
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case ServerFailure:
        return (failure as ServerFailure).message;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error. Please try again later.";
    }
  }
}
