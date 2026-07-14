
import 'package:easy_localization/easy_localization.dart';

String? phoneValid(String? phone) {
  if (phone!.trim().isEmpty) {
    return 'validation_required'.tr();
  }else if (!phone.startsWith('09')) {
    return'validation_phone_start'.tr();
  }else if (phone.length<10 || phone.length>10) {
    return'validation_phone_length'.tr();
  }  else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
    return 'validation_phone_digits'.tr();
  }
  return null;
}

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'validation_required'.tr();
  }
  return null;
}

String? notRequiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return null;
}


String? passwordValidator(String? val) {
  return val!.isEmpty || val.length < 6
      ? 'validation_password_required'.tr()
      : null;
}


