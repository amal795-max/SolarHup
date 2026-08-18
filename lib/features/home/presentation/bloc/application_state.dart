part of 'application_cubit.dart';

sealed class ApplicationState extends Equatable {
  const ApplicationState();
}

final class ApplicationInitial extends ApplicationState {
  @override
  List<Object> get props => [];
}
final class ApplicationMainState extends ApplicationState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isVerified;

  const ApplicationMainState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('ar'),
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [themeMode, locale, isVerified];
}

