class RequestVerifyOtpModel {
  String phone, code;

  RequestVerifyOtpModel({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {"code": code, "phone": phone};
}

class RequestVerifyOtpEmailModel {
  String email, code;

  RequestVerifyOtpEmailModel({required this.email, required this.code});

  Map<String, dynamic> toJson() => {"code": code, "email": email};
}
