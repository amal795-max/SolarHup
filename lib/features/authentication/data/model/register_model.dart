class RegisterModel {
  final String accessToken;

  final String securityCode;

  RegisterModel(
      {required this.accessToken, required this.securityCode});

   factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
    accessToken : json['access_token'],
    securityCode : json['security_code']);
  }

  Map<String, dynamic> toJson() => {
  'access_token': accessToken,
  'security_code': securityCode,
  };
}