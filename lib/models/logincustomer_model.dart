import 'dart:convert';

LogincustomerModel loginCustomerFromJson(String str) =>
    LogincustomerModel.fromJson(json.decode(str));

String loginResponseModelToJson(LogincustomerModel data) =>
    json.encode(data.toJson());

class LogincustomerModel {
  LogincustomerModel({
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

  factory LogincustomerModel.fromJson(Map<String, dynamic> json) =>
      LogincustomerModel(
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
