class LoginModel {
  final String ? accessToken;
  final String? securityCode;
  final bool? isVerified;

  LoginModel(
      {required this.accessToken, required this.securityCode,required this.isVerified});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        accessToken : json['access_token']??'',
        isVerified : json['is_verified']??'',
        securityCode : json['security_code']??'');
  }

}