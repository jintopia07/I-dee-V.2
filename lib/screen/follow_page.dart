import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:idee_flutter/models/token_login.dart';
import 'package:idee_flutter/screen/followpage_customer.dart';
import 'package:idee_flutter/services/api_service.dart';
import 'package:idee_flutter/services/progressHUD.dart';
import 'package:idee_flutter/utils/form_helper.dart';

class FollowPage extends StatefulWidget {
  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String _username = "";
  String _pwd = "";
  bool hidePassword = true;
  bool isApicallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบรับเรื่องร้องเรียนกลาง'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: ProgressHUD(
            child: _loginSetup(context),
            inAsyncCall: isApicallProcess,
            opacity: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _loginSetup(BuildContext context) {
    return new Container(
      child: new Form(
        key: globalFormKey,
        child: _loginFollow(context),
      ),
    );
  }

  Widget _loginFollow(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height / 3.8,
          child: Column(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            "เข้าสู่ระบบ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: FormHelper.inputFieldWidget(context, Icon(Icons.verified_user),
              "username", "ระบุหมายเลขประจำตัวประชาชน", (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return 'กรุณากรอกข้อมูล';
            }
            return null;
          }, (onSavedValue) {
            _username = onSavedValue.toString().trim();
          }),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: FormHelper.inputFieldWidget(
              context,
              Icon(Icons.lock),
              "password",
              "ระบุหมายเลขหลังบัตรประจำตัวประชาชน", (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return 'กรุณากรอกรหัสผ่าน';
            }
            return null;
          }, (onSavedValue) {
            _pwd = onSavedValue.toString().trim();
          },
              initialValue: "",
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.deepPurple[400].withOpacity(0.4),
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
              )),
        ),
        SizedBox(
          height: 15,
        ),
        new Center(
          child: FormHelper.saveButton(
            "ตกลง (OK)",
            () {
              if (validateAndSave()) {
                setState(() {
                  this.isApicallProcess = true;
                });

                APIFollow.loginCustomer(_username, _pwd).then((tokenlogin) {
                  setState(() {
                    this.isApicallProcess = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowPageCustomer(),
                      // Pass the arguments as part of the RouteSettings. The
                      // DetailScreen reads the arguments from these settings.
                      settings: RouteSettings(
                        arguments: tokenlogin,
                      ),
                    ),
                  );
                });
              }
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextButton(
            style: TextButton.styleFrom(primary: Colors.deepPurple[300]),
            onPressed: () {},
            child: const Text('ลืม/เปลี่ยนแปลงหมายเลขหลังบัตร'),
          ),
        ),
      ],
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
