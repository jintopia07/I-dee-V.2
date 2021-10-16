import 'dart:convert';

EmergenyDetailModel detailModelFromJson(String str) =>
    EmergenyDetailModel.fromJson(json.decode(str));

String detailModelToJson(EmergenyDetailModel data) =>
    json.encode(data.toJson());

class EmergenyDetailModel {
  EmergenyDetailModel({
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

  factory EmergenyDetailModel.fromJson(Map<String, dynamic> json) =>
      EmergenyDetailModel(
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
