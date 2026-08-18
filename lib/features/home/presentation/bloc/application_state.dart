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

  const ApplicationMainState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('ar'),
  });

  @override
  List<Object?> get props => [themeMode, locale, ];
}

