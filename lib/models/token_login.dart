import 'dart:convert';

TokenLogin tokenFromJson(String str) => TokenLogin.fromJson(json.decode(str));

String tokenToJson(TokenLogin data) => json.encode(data.toJson());

class TokenLogin {
  TokenLogin({
    this.loginStatus,
    this.token,
  });

  bool loginStatus;
  String token;

  factory TokenLogin.fromJson(Map<String, dynamic> json) => TokenLogin(
        loginStatus: json["loginStatus"],
        token: json["token"],
      );

  get statusCode => null;

  Map<String, dynamic> toJson() => {
        "loginStatus": loginStatus,
        "token": token,
      };
}
