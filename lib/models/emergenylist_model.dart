import 'dart:convert';

EmergenylistModel detailModelFromJson(String str) =>
    EmergenylistModel.fromJson(json.decode(str));

String detailModelToJson(EmergenylistModel data) => json.encode(data.toJson());

class EmergenylistModel {
  EmergenylistModel({
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

  factory EmergenylistModel.fromJson(Map<String, dynamic> json) =>
      EmergenylistModel(
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
