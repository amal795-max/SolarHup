import 'package:kitch_plus/features/authentication/data/model/login_model/sub-data-model.dart';


class LoginModel {
  final DataLoginModel dataLoginModel;

  const LoginModel({required this.dataLoginModel});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(dataLoginModel: DataLoginModel.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() {
    return {
      'data': dataLoginModel.toJson(),
    };
  }
}