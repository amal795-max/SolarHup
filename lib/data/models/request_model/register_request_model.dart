class RegisterRequestModel {
  String phone, name, password, passwordConfirm, fcmToken, udId, email;
  int gender;

  RegisterRequestModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.gender,
    required this.fcmToken,
    required this.udId,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "gender": gender,
    "password": password,
    "password_confirmation": passwordConfirm,
    "fcm_token": fcmToken,
    "udid": udId,
  };
}

class SubscribeRequestModel {
  String phone,
      name,
      password,
      passwordConfirm,
      isCustom,
      email,
      packageId,
      period;

  SubscribeRequestModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.isCustom,
    required this.packageId,
    required this.period,
  });

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "is_custom": isCustom,
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "password_confirmation": passwordConfirm,
    "period": period,
  }..removeWhere((String key, value) => value == "" || value == "null");
}

class SubscribeCustomRequestModel {
  String phone, name, password, passwordConfirm, email, period;
  List<Map<String, dynamic>> items;

  SubscribeCustomRequestModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.items,
    required this.period,
  });

  Map<String, dynamic> toJson() => {
    "items": items,
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "password_confirmation": passwordConfirm,
    "period": period,
  }..removeWhere((String key, value) => value == "" || value == "null");
}
