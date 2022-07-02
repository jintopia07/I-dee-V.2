import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:idee_flutter/models/complaint_model.dart';
import 'package:idee_flutter/models/getfactorybyname_model.dart';
import 'package:idee_flutter/models/token_login.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class APIFollow {
  static var client = http.Client();

  static Future<TokenLogin> loginCustomer(
      String username, String password) async {
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var body = jsonEncode(
      {
        "username": username.trim(),
        "password": password.trim(),
      },
    );

    var response = await http.post(
        Uri.parse(
            '//'),
        headers: requestHeaders,
        body: body);
    var tokenlogin;
    if (response.statusCode == 200) {
      var jsonString = response.body;
      tokenlogin = tokenFromJson(jsonString);
      // return responseModel.statusCode == 200 ? true : false;
      return tokenlogin;
    }
  }
}

class APIService {
  static var client = http.Client();

  static Future<TokenLogin> loginAdmin(String username, String password) async {
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var body = jsonEncode(
      {
        "username": username.trim(),
        "password": password.trim(),
      },
    );

    var response = await http.post(
        Uri.parse('//'),
        headers: requestHeaders,
        body: body);

    var responseModel;
    if (response.statusCode == 200) {
      var jsonString = response.body;
      responseModel = tokenFromJson(jsonString);

      //return responseModel.statusCode == 200 ? true : false;
      return responseModel;
    }

    return null;
  }
}

class APIFactory {
  static var client = http.Client();

  static Future<GetFactoryByName> SearchFactorybyid(String id) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded'
    };

    var response = await http.post(
        Uri.parse(
            '//'),
        headers: requestHeaders,
        body: {
          "id": id,
        });
    var responseModel;
    if (response.statusCode == 200) {
      var jsonString = response.body;
      responseModel = getFactoryByNameFromJson(jsonString);
      // return responseModel.statusCode == 200 ? true : false;
      return responseModel;
    }

    return null;
  }
}

class GetComplaintTrans {
  static var client = http.Client();

  static Future<Map<String, dynamic>> getComplaintlist(
      String accessToken) async {
    final response = await http.get(
      Uri.parse(
          '//'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    var responseModel;

    if (response.statusCode == 200) {
      var jsonString = response.body;
      responseModel = complaintFromJson(jsonString);
      // return responseModel.statusCode == 200 ? true : false;
      return responseModel;
    }
    return null;
  }
}

class Getinfo {
  static var client = http.Client();

  static Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final response = await http.get(
      Uri.parse('//'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    var responseModel;

    if (response.statusCode == 200) {
      var jsonString = response.body;
      responseModel = complaintFromJson(jsonString);
      // return responseModel.statusCode == 200 ? true : false;
      return responseModel;
    }
    return null;
  }
}
