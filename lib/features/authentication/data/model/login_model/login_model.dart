import 'package:untitled1/features/authentication/data/model/login_model/sub-data-model.dart' ;

class LoginModel {
  final DataLoginModel dataLoginModel;

  const LoginModel({required this.dataLoginModel});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(dataLoginModel: DataLoginModel.fromJson(json['data']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': dataLoginModel.toJson(),
    };
  }
}