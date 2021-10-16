import 'dart:convert';

DetailModel detailModelFromJson(String str) =>
    DetailModel.fromJson(json.decode(str));

String detailModelToJson(DetailModel data) => json.encode(data.toJson());

class DetailModel {
  DetailModel({
    this.objRolesInfo,
    this.userName,
    this.status,
    this.tokenKey,
    this.actionName,
  });

  dynamic objRolesInfo;
  String userName;
  int status;
  String tokenKey;
  String actionName;

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        objRolesInfo: json["objRoles_info"],
        userName: json["user_Name"],
        status: json["status"],
        tokenKey: json["token_key"],
        actionName: json["actionName"],
      );

  Map<String, dynamic> toJson() => {
        "objRoles_info": objRolesInfo,
        "user_Name": userName,
        "status": status,
        "token_key": tokenKey,
        "actionName": actionName,
      };
}
