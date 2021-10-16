import 'dart:convert';

EmergencyAdminModel detailModelFromJson(String str) =>
    EmergencyAdminModel.fromJson(json.decode(str));

String mergencyAdminModelToJson(EmergencyAdminModel data) =>
    json.encode(data.toJson());

class EmergencyAdminModel {
  EmergencyAdminModel({
    this.emergencyTypeId,
    this.emergencyTypeOther,
    this.emergencyLocation,
    this.latitude,
    this.longitude,
    this.factoryCode,
    this.emergencyDate,
    this.emergencyDescription,
    this.emergencyChanelId,
    this.numberOfCasualties,
    this.numberOfDeaths,
    this.damageEstimate,
    this.introPresumedCause,
    this.operationDescription,
    this.factoryName,
    this.files,
  });

  int emergencyTypeId;
  String emergencyTypeOther;
  String emergencyLocation;
  double latitude;
  double longitude;
  String factoryCode;
  String emergencyDate;
  String emergencyDescription;
  int emergencyChanelId;
  int numberOfCasualties;
  int numberOfDeaths;
  double damageEstimate;
  String introPresumedCause;
  String operationDescription;
  String factoryName;
  String files;

  factory EmergencyAdminModel.fromJson(Map<String, dynamic> json) =>
      EmergencyAdminModel(
        emergencyTypeId: json["emergencyTypeId"],
        emergencyTypeOther: json["emergencyTypeOther"],
        emergencyLocation: json["emergencyLocation"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        factoryCode: json["factoryCode"],
        emergencyDate: json["emergencyDate"],
        emergencyDescription: json["emergencyDescription"],
        emergencyChanelId: json["emergencyChanelId"],
        numberOfCasualties: json["numberOfCasualties"],
        numberOfDeaths: json["numberOfDeaths"],
        damageEstimate: json["damageEstimate"],
        introPresumedCause: json["introPresumedCause"],
        operationDescription: json["operationDescription"],
        factoryName: json["factoryName"],
        files: json["files"],
      );

  Map<String, dynamic> toJson() => {
        "emergencyTypeId": emergencyTypeId,
        "emergencyTypeOther": emergencyTypeOther,
        "emergencyLocation": emergencyLocation,
        "latitude": latitude,
        "longitude": longitude,
        "factoryCode": factoryCode,
        "emergencyDate": emergencyDate,
        "emergencyDescription": emergencyDescription,
        "emergencyChanelId": emergencyChanelId,
        "numberOfCasualties": numberOfCasualties,
        "numberOfDeaths": numberOfDeaths,
        "damageEstimate": damageEstimate,
        "introPresumedCause": introPresumedCause,
        "operationDescription": operationDescription,
        "factoryName": factoryName,
        "files": files,
      };
}
