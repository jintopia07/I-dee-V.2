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





// {
//     "complaintId": "T-2564-09-29-0370",
//     "complaintDate": "29/09/2021",
//     "refBookNo": null,
//     "complaintStatusName": "แจ้งเรื่องร้องเรียน",
//     "complainSystems": "ร้องเรียนโรงงาน",
//     "complaintDetail": "ทดสอบ",
//     "locationAreaDetail": "เมืองพัทยา อำเภอบางละมุง ชลบุรี 20150",
//     "isReceive": "Temp",
//     "complaintAnswer": [],
//     "complaintDocument": [
//         {
//             "documentUrl": "http://0848-2001-fb1-c3-49c-c1b1-b7be-1bd3-e632.ngrok.io/api/File/VideoStream/1/RNtDdb9l4SYbClOlq-hUYQd7_xTTHg8Vj53oJpisYg56KMqvxNjghCVuwbRyzohZwcRch44qMNp38lMrnLjnyA",
//             "thumbnailUrl": "http://0848-2001-fb1-c3-49c-c1b1-b7be-1bd3-e632.ngrok.io/api/File/ImageStream/3/DV-Ga5GQzT_rF2CH4-ZyLR-OvWiaxDZEoGVleEbjygjXQG-R5fFka7VoDqjZP1eaLbQY356Zv0EBlTTkqL-OwLCgzBzMDJM-kl4f30W3PIQ"
//         }
//     ]
// }