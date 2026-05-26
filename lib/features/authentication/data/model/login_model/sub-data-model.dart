import 'sub-client-model.dart';

class DataLoginModel {
  final ClientModel clientModel;
  final String token;
  final String refreshToken;

  const DataLoginModel({
    required this.clientModel,
    required this.token,
    required this.refreshToken,
  });

  factory DataLoginModel.fromJson(Map<String, dynamic> json) {
    return DataLoginModel(
      clientModel: ClientModel.fromJson(json['Client']),
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': clientModel.toJson(),
      'token': token,
      'refresh_token': refreshToken,
    };
  }
}
