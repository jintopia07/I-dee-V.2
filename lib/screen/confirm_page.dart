import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idee_flutter/screen/home_page.dart';
import 'package:idee_flutter/screen/launcher.dart';
import 'package:idee_flutter/utils/form_helper.dart';

class Confirmpages extends StatefulWidget {
  @override
  _ConfirmpagesState createState() => _ConfirmpagesState();
}

class _ConfirmpagesState extends State<Confirmpages> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName, lastName, citizenID, laserCode, tel, email;
  @override
  Widget build(BuildContext context) {
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
                      citizenID = val;
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
                      laserCode = val;
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
                      tel = val;
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
                    onSaved: (String val) {
                      email = val;
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
                        _sendToSave();
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

  _sendToSave() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Name $firstName");
      print("LastName $lastName");
      print("CitizenID $citizenID");
      print("LaserCode $laserCode");
      print("Tel $tel");
      print("Email $email");

      FormHelper.showMessage(context, "I-Dee", "บันทึกข้อมูล", "ตกลง", () {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => Launcher()),
          (_) => false,
        );
      });
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}
