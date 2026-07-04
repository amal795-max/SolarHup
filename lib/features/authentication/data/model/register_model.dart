class RegisterModel {
  final String accessToken;
  final String tokenType;
  final String role;
  final String securityCode;

  RegisterModel({
    required this.accessToken,
    required this.tokenType,
    required this.role,
    required this.securityCode,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      role: json['role'],
      securityCode: json['security_code'],
    );
  }
}
