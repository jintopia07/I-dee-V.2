// To parse this JSON data, do
//
//     final detaildataP = detaildataPFromJson(jsonString);

import 'dart:convert';

DetaildataP detaildataPFromJson(String str) =>
    DetaildataP.fromJson(json.decode(str));

String detaildataPToJson(DetaildataP data) => json.encode(data.toJson());

class DetaildataP {
  DetaildataP({
    this.complaintId,
    this.complaintDate,
    this.refBookNo,
    this.complaintStatusName,
    this.complainSystems,
    this.complaintDetail,
    this.locationAreaDetail,
    this.isReceive,
    this.complaintAnswer,
    this.complaintDocument,
  });

  String complaintId;
  String complaintDate;
  dynamic refBookNo;
  String complaintStatusName;
  String complainSystems;
  String complaintDetail;
  String locationAreaDetail;
  String isReceive;
  List<dynamic> complaintAnswer;
  List<ComplaintDocument> complaintDocument;

  factory DetaildataP.fromJson(Map<String, dynamic> json) => DetaildataP(
        complaintId: json["complaintId"],
        complaintDate: json["complaintDate"],
        refBookNo: json["refBookNo"],
        complaintStatusName: json["complaintStatusName"],
        complainSystems: json["complainSystems"],
        complaintDetail: json["complaintDetail"],
        locationAreaDetail: json["locationAreaDetail"],
        isReceive: json["isReceive"],
        complaintAnswer:
            List<dynamic>.from(json["complaintAnswer"].map((x) => x)),
        complaintDocument: List<ComplaintDocument>.from(
            json["complaintDocument"]
                .map((x) => ComplaintDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "complaintId": complaintId,
        "complaintDate": complaintDate,
        "refBookNo": refBookNo,
        "complaintStatusName": complaintStatusName,
        "complainSystems": complainSystems,
        "complaintDetail": complaintDetail,
        "locationAreaDetail": locationAreaDetail,
        "isReceive": isReceive,
        "complaintAnswer": List<dynamic>.from(complaintAnswer.map((x) => x)),
        "complaintDocument":
            List<dynamic>.from(complaintDocument.map((x) => x.toJson())),
      };
}

class ComplaintDocument {
  ComplaintDocument({
    this.documentUrl,
    this.thumbnailUrl,
  });

  String documentUrl;
  String thumbnailUrl;

  factory ComplaintDocument.fromJson(Map<String, dynamic> json) =>
      ComplaintDocument(
        documentUrl: json["documentUrl"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "documentUrl": documentUrl,
        "thumbnailUrl": thumbnailUrl,
      };
}





