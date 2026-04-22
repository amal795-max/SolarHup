class ContactRequestModel {
  String phone, name, message, email;
  String? modelId, modelType;
  String? startDate, endDate;

  ContactRequestModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.message,
    this.modelId,
    this.modelType,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "message": message,
    "model_id": modelId,
    "model_type": modelType,
    "start_date": startDate,
    "end_date": endDate,
  };
}
