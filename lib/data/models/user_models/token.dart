class Token {
  final String tokenType;
  final String accessToken;

  Token({required this.tokenType, required this.accessToken});

  factory Token.fromJson(Map<String, dynamic> data) {
    return Token(
      tokenType: (data["token_type"] != null) ? data["token_type"] : null,
      accessToken: data["access_token"],
    );
  }
}
