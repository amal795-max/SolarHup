import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/helper/local_storage.dart';
part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationInitial()){
    _initApp();
  }

  void _initApp() {
    String? mode = LocalStorage().getData(key: StorageKeys.mode);
    String? langCode = LocalStorage().getData(key: StorageKeys.langCode);

    ThemeMode currentMode = (mode == 'd') ? ThemeMode.dark : ThemeMode.light;
    Locale currentLocale = Locale(langCode ?? 'ar');

    emit(ApplicationMainState(themeMode: currentMode, locale: currentLocale));
  }

  void toggleTheme() {
    if (state is ApplicationMainState) {
      final currentState = state as ApplicationMainState;
      String? mode = LocalStorage().getData(key: StorageKeys.mode);

      ThemeMode newMode;
      if (mode == 'd') {
        LocalStorage().saveData(key: StorageKeys.mode, value: 'l');
        newMode = ThemeMode.light;
      } else {
        LocalStorage().saveData(key: StorageKeys.mode, value: 'd');
        newMode = ThemeMode.dark;
      }

      emit(ApplicationMainState(
        themeMode: newMode,
        locale: currentState.locale,
      ));
    }
  }

  void changeLanguage(BuildContext context, String langCode) async {
    if (state is ApplicationMainState) {
      final currentState = state as ApplicationMainState;
      Locale newLocale = Locale(langCode);

      await context.setLocale(newLocale);
      LocalStorage().saveData(key: StorageKeys.langCode, value: langCode);

      emit(ApplicationMainState(
        themeMode: currentState.themeMode,
        locale: newLocale,
      ));
    }
  }
}