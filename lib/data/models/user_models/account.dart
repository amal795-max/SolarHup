class AccountModel {
  final String token;

  AccountModel({required this.token});

  factory AccountModel.fromJson(Map<String, dynamic> data) {
    return AccountModel(
      token: data["data"]['accessToken'] ?? "",
    );
  }
}