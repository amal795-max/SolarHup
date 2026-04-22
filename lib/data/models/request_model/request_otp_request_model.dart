class RequestOtpRequestModel {
  String phone;

  RequestOtpRequestModel({required this.phone});

  Map<String, dynamic> toJson() => {"phone": phone};
}

class RequestOtpEmailModel {
  String email;

  RequestOtpEmailModel({required this.email});

  Map<String, dynamic> toJson() => {"email": email};
}
