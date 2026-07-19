import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_themes.dart';

Widget pinPut(TextEditingController otpController) => Directionality(
  textDirection: TextDirection.ltr,
  child: Pinput(
    controller:otpController,
    length: 6,
    defaultPinTheme: AppThemes.defaultPinTheme,
    focusedPinTheme: AppThemes.focusedPinTheme,
    errorPinTheme: AppThemes.errorPinTheme,
    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    showCursor: true,
  ),
);
