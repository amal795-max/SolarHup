class LoginModel {
  final String accessToken;
  final String securityCode;

  LoginModel(
      {required this.accessToken, required this.securityCode});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        accessToken : json['access_token'],
        securityCode : json['security_code']);
  }

}