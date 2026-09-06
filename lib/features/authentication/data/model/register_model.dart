class RegisterModel {
  final String accessToken;
  final bool isVerified;

  final String securityCode;

  RegisterModel(
      {required this.accessToken, required this.securityCode, required this.isVerified});

   factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
    accessToken : json['access_token'],
    securityCode : json['security_code'],
    isVerified : json['is_verified']);
  }

}