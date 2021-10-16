import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:idee_flutter/models/complaint_model.dart';
import 'package:idee_flutter/models/confirm_model.dart';
import 'package:idee_flutter/models/id_confirmfactory.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;

class ConfirmFactory extends StatefulWidget {
  @override
  _ConfirmFactoryState createState() => _ConfirmFactoryState();
}

class _ConfirmFactoryState extends State<ConfirmFactory> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Complaint complaint = new Complaint();
  Confirm confirm = new Confirm();
  List<Asset> images = [];
  File videoFile;
  List<String> paths = [];
  bool _load = false;

  String refBookNo,
      complaintTitleTypeOtherDetail,
      locationAreaDetail,
      complaintDetail,
      citizenNo,
      backCitizenNo,
      firstName,
      lastName,
      phone,
      email,
      latitude,
      longitude,
      mapUrl,
      mapDetail,
      complaintTitleId,
      isOfficeSent,
      citizenSkip,
      addressNo,
      provinceId,
      districtId,
      subDistrictId,
      files;

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context).settings.arguments as Complaint;
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('ยืนยันการแจ้งเรื่องร้องเรียน'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          autovalidate: _validate,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ข้อมูลส่วนบุคคลของผู้แจ้งเรื่องร้องเรียน",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("หมายเลขประจำตัวประชาชน (Citizent No)*"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    maxLength: 13,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูลหมายเลขประจำตัวประชาชน';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      citizenNo = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("หมายเลขหลังบัตร (Laser Code)*"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    maxLength: 12,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูลหมายเลขหลังบัตร';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      backCitizenNo = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("ชื่อ (First Name)*"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    // maxLength: 32,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูล';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      firstName = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("นามสกุล (Last Name)*"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    // maxLength: 32,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูล';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      lastName = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("เบอร์โทรศัพท์"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    // maxLength: 32,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูล';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      setState(() {
                        phone = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("อีเมล์"),
                ),
                Center(
                  child: TextFormField(
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                        borderSide: new BorderSide(),
                      ),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                    ),
                    // maxLength: 32,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูล';
                      else
                        return null;
                    },
                    onChanged: (String val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.deepPurple[400],
                      padding: const EdgeInsets.all(8.0),
                      elevation: 5,
                      child: new Text(
                        "บันทึก",
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                        complaintTitleId = todo.complaintTitleId;
                        complaintDetail = todo.complaintDetail;
                        locationAreaDetail = todo.locationAreaDetail;
                        images = todo.images;
                        videoFile = todo.video;
                        complaintTitleTypeOtherDetail =
                            todo.complaintTitleTypeOtherDetail;

                        _sendSave();
                        if (_key.currentState.validate()) {
                          _key.currentState.save();
                          confirm = generate();
                          setState(() {
                            _load = true;
                          });
                          infoInsertData();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Divider(
                    color: Colors.grey,
                    height: 50,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                      "คำแนะนำในการกรอก Laser Code หลังบัตรประจำตัวประชาชน"),
                ),
                Image.asset('assets/images/lasercodes.png'),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                      'กระทรวงอุตสาหกรรม ยกระดับการรักษาความปลอดภัยข้อมูลของผู้ใช้งาน เพื่อป้องกันการเข้าถึงข้อมูลส่วนบุคคลของท่าน ด้วยการตรวจสอบ Laser Code หลังบัตรประจำตัวประชาชน'),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendSave() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
    } else {
      // validation error
      setState(() {
        _validate = true;

        //infoInsertData();
      });
    }
  }

  Future<Null> infoInsertData() async {
    var client = http.Client();

    var data = confirm;

    var requestHeaders = {'Content-type': 'application/json'};

    var response = await http.post(
        Uri.parse(
            'https://8b62-2001-fb1-c1-77fc-b09f-5f2b-bd28-5c83.ngrok.io/api/Complaint/AddComplaint/P'),
        headers: requestHeaders,
        body: JsonEncoder().convert(data));

    var idconfirmfactory;
    if (response.statusCode == 200) {
      var jsonString = response.body;
      idconfirmfactory = idconfirmfactoryFromJson(jsonString);
    }

    final idNo = idconfirmfactory;

    String No = idNo.id;

    print('$No');

    complaint.images = images;

    final Dio dio = new Dio();
    String apiSaveProduct =
        'https://8b62-2001-fb1-c1-77fc-b09f-5f2b-bd28-5c83.ngrok.io/api/File/UploadFileComplaint/$No';
    if (images != null) {
      int count = 0;
      for (var i = 0; i < images.length; i++) {
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asInt8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: images[i].name,
          contentType: MediaType('image', 'jpg'),
        );

        var datapic = multipartFile.filename;
        paths.add('$datapic');
        print('$datapic');

        FormData formData = FormData.fromMap({"image": multipartFile});
        await Dio()
            .post(apiSaveProduct, data: formData)
            .then((value) => print('Success'));
        count++;
      }
    }

    complaint.video = videoFile;

    String apiSave =
        'https://8b62-2001-fb1-c1-77fc-b09f-5f2b-bd28-5c83.ngrok.io/api/File/UploadFileComplaint/$No';
    if (videoFile != null) {
      FormData data = FormData.fromMap({
        "video": await MultipartFile.fromFile(videoFile.path),
      });

      Response response = await Dio().post(apiSave, data: data);
      print("File upload response: $response");
    } else {}
    popDialog(context, 'บันทึกข้อมูลเรียบร้อย');
  }

  Complaint generateCompaint() {
    Complaint complaint = Complaint();
    complaint.complaintDetail = complaintDetail;
    complaint.complaintTitleTypeOtherDetail = complaintTitleTypeOtherDetail;
    complaint.locationAreaDetail = locationAreaDetail;
    complaint.complaintTitleId = complaintTitleId;
    complaint.video = videoFile;
    complaint.refBookNo = refBookNo;
    complaint.citizenNo = citizenNo;
    complaint.backCitizenNo = backCitizenNo;
    complaint.firstName = firstName;
    complaint.lastName = lastName;
    complaint.latitude = latitude;
    complaint.longitude = longitude;
    complaint.email = email;
    complaint.phone = phone;
    complaint.districtId = districtId;
    complaint.citizenSkip = citizenSkip;
    complaint.addressNo = addressNo;
    complaint.provinceId = provinceId;
    complaint.subDistrictId = subDistrictId;
    complaint.images = images;
    complaint.mapDetail = mapDetail;
    complaint.mapUrl = mapUrl;
    complaint.isOfficeSent = isOfficeSent;
    complaint.files = videoFile;
    return complaint;
  }

  Confirm generate() {
    Confirm confirm = Confirm();
    confirm.complaintDetail = complaintDetail;
    confirm.complaintTitleTypeOtherDetail = complaintTitleTypeOtherDetail;
    confirm.locationAreaDetail = locationAreaDetail;
    confirm.complaintTitleId = complaintTitleId;
    confirm.refBookNo = refBookNo;
    confirm.citizenNo = citizenNo;
    confirm.backCitizenNo = backCitizenNo;
    confirm.firstName = firstName;
    confirm.lastName = lastName;
    confirm.latitude = latitude;
    confirm.longitude = longitude;
    confirm.email = email;
    confirm.phone = phone;
    confirm.districtId = districtId;
    confirm.citizenSkip = citizenSkip;
    confirm.addressNo = addressNo;
    confirm.provinceId = provinceId;
    confirm.subDistrictId = subDistrictId;
    confirm.mapDetail = mapDetail;
    confirm.mapUrl = mapUrl;
    confirm.isOfficeSent = isOfficeSent;
    //confirm.files = videoFile;

    return confirm;
  }

  Future<void> normalDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(message),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/factory', (Route<dynamic> route) => false),
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future<void> popDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          message,
          style: TextStyle(color: Colors.deepPurple, fontSize: 16),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false),
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.deepPurple),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
