import 'dart:convert';

GetFactoryByName getFactoryByNameFromJson(String str) =>
    GetFactoryByName.fromJson(json.decode(str));

String getFactoryByNameToJson(GetFactoryByName data) =>
    json.encode(data.toJson());

class GetFactoryByName {
  GetFactoryByName({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  List<Result> result;

  factory GetFactoryByName.fromJson(Map<String, dynamic> json) =>
      GetFactoryByName(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.ampname,
    this.dispfacreg,
    this.faddr,
    this.fflag,
    this.fid,
    this.fmoo,
    this.fname,
    this.object,
    this.oname,
    this.proname,
    this.road,
    this.soi,
    this.trade,
    this.tumname,
    this.zipcode,
  });

  String ampname;
  String dispfacreg;
  int faddr;
  dynamic fflag;
  String fid;
  dynamic fmoo;
  String fname;
  String object;
  String oname;
  String proname;
  String road;
  String soi;
  String trade;
  String tumname;
  int zipcode;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        ampname: json["ampname"],
        dispfacreg: json["dispfacreg"],
        faddr: json["faddr"],
        fflag: json["fflag"],
        fid: json["fid"],
        fmoo: json["fmoo"],
        fname: json["fname"],
        object: json["object"],
        oname: json["oname"],
        proname: json["proname"],
        road: json["road"],
        soi: json["soi"],
        trade: json["trade"],
        tumname: json["tumname"],
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "ampname": ampname,
        "dispfacreg": dispfacreg,
        "faddr": faddr,
        "fflag": fflag,
        "fid": fid,
        "fmoo": fmoo,
        "fname": fname,
        "object": object,
        "oname": oname,
        "proname": proname,
        "road": road,
        "soi": soi,
        "trade": trade,
        "tumname": tumname,
        "zipcode": zipcode,
      };
}

