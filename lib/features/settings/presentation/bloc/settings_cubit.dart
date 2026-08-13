import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/settings/data/models/privacy_policy_model.dart';
import 'package:untitled1/features/settings/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository) : super(PrivacyPolicyLoading());

  Future<void> getPrivacyPolicy() async {
    emit(PrivacyPolicyLoading());
    final result = await repository.getPrivacyPolicy();
    result.fold(
      (failure) => emit(SettingsError(message: mapFailureToMessage(failure))),
      (privacyPolicy) => emit(PrivacyPolicySuccess(privacyPolicy: privacyPolicy)),
    );
  }
}
