import 'data_model.dart';

class RegisterModel {
  final DataModel dataModel;

  const RegisterModel({required this.dataModel});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(dataModel: DataModel.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() {
    return {
      'data': dataModel.toJson(),
    };
  }
}