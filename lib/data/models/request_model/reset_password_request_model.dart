class ResetPasswordRequestModel {
  String code, password;

  ResetPasswordRequestModel({required this.code, required this.password});

  Map<String, dynamic> toJson() => {"code": code, "password": password};
}
