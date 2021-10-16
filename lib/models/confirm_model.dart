import 'dart:convert';
import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';

Confirm confirmFromJson(String str) => Confirm.fromJson(json.decode(str));

String confirmToJson(Confirm data) => json.encode(data.toJson());

class Confirm {
  Confirm({
    this.refBookNo,
    this.complaintTitleTypeOtherDetail,
    this.locationAreaDetail,
    this.complaintDetail,
    this.citizenNo,
    this.backCitizenNo,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.mapDetail,
    this.complaintTitleId,
    this.isOfficeSent,
    this.citizenSkip,
    this.addressNo,
    this.provinceId,
    this.districtId,
    this.subDistrictId,
    //this.files,
  });

  dynamic refBookNo;
  dynamic complaintTitleTypeOtherDetail;
  String locationAreaDetail;
  String complaintDetail;
  String citizenNo;
  String backCitizenNo;
  String firstName;
  String lastName;
  String phone;
  String email;
  String latitude;
  String longitude;
  String mapUrl;
  String mapDetail;
  String complaintTitleId;
  dynamic isOfficeSent;
  dynamic citizenSkip;
  dynamic addressNo;
  dynamic provinceId;
  dynamic districtId;
  dynamic subDistrictId;
  //dynamic files;

  factory Confirm.fromJson(Map<String, dynamic> json) => Confirm(
        refBookNo: json["RefBookNo"],
        complaintTitleTypeOtherDetail: json["ComplaintTitleTypeOtherDetail"],
        locationAreaDetail: json["LocationAreaDetail"],
        complaintDetail: json["ComplaintDetail"],
        citizenNo: json["CitizenNo"],
        backCitizenNo: json["BackCitizenNo"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        phone: json["Phone"],
        email: json["Email"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        mapUrl: json["MapUrl"],
        mapDetail: json["MapDetail"],
        complaintTitleId: json["ComplaintTitleId"],
        isOfficeSent: json["IsOfficeSent"],
        citizenSkip: json["CitizenSkip"],
        addressNo: json["AddressNo"],
        provinceId: json["ProvinceId"],
        districtId: json["DistrictId"],
        subDistrictId: json["SubDistrictId"],
        //files: json["Files"],
      );

  Map<String, dynamic> toJson() => {
        "RefBookNo": refBookNo,
        "ComplaintTitleTypeOtherDetail": complaintTitleTypeOtherDetail,
        "LocationAreaDetail": locationAreaDetail,
        "ComplaintDetail": complaintDetail,
        "CitizenNo": citizenNo,
        "BackCitizenNo": backCitizenNo,
        "FirstName": firstName,
        "LastName": lastName,
        "Phone": phone,
        "Email": email,
        "Latitude": latitude,
        "Longitude": longitude,
        "MapUrl": mapUrl,
        "MapDetail": mapDetail,
        "ComplaintTitleId": complaintTitleId,
        "IsOfficeSent": isOfficeSent,
        "CitizenSkip": citizenSkip,
        "AddressNo": addressNo,
        "ProvinceId": provinceId,
        "DistrictId": districtId,
        "SubDistrictId": subDistrictId,
        //"Files": files,
      };
}
