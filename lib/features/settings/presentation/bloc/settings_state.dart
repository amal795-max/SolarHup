part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}


class PrivacyPolicyLoading extends SettingsState {}

class PrivacyPolicySuccess extends SettingsState {
  final PrivacyPolicyModel privacyPolicy;

  const PrivacyPolicySuccess({required this.privacyPolicy});

  @override
  List<Object?> get props => [privacyPolicy];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
