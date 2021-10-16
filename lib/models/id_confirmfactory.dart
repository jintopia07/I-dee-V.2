// To parse this JSON data, do
//
//     final idconfirmfactory = idconfirmfactoryFromJson(jsonString);

import 'dart:convert';

Idconfirmfactory idconfirmfactoryFromJson(String str) =>
    Idconfirmfactory.fromJson(json.decode(str));

String idconfirmfactoryToJson(Idconfirmfactory data) =>
    json.encode(data.toJson());

class Idconfirmfactory {
  Idconfirmfactory({
    this.success,
    this.errors,
    this.id,
  });

  bool success;
  dynamic errors;
  String id;

  factory Idconfirmfactory.fromJson(Map<String, dynamic> json) =>
      Idconfirmfactory(
        success: json["success"],
        errors: json["errors"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "errors": errors,
        "id": id,
      };
}
