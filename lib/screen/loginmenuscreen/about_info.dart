import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idee_flutter/models/token_login.dart';

class AboutAdmin extends StatefulWidget {
  const AboutAdmin({Key key}) : super(key: key);

  @override
  _AboutAdminState createState() => _AboutAdminState();
}

class _AboutAdminState extends State<AboutAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลผู้ใช้งาน"),
      ),
      body: Stack(
        children: [
          const Tabbar(),
          Info(),
        ],
      ),
    );
  }
}

class Info extends StatefulWidget {
  const Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context).settings.arguments as TokenLogin;
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 80),
                child: Text("ชื่อผู้ใช้งาน:"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 80, left: 20),
                child: Text(
                  todo.token,
                  style: TextStyle(fontFamily: "Kanit", fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("ชื่อ - นามสกุล :"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20),
                child: Text("สมชาย  เผ่าทอง"),
                // Text(
                //   todo.actionName,
                //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
                // ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("เลขบัตรประจำตัว :"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20),
                child: Text("123456789012"),
              ),
              // Text(
              //   todo.actionName,
              //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
              // ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("อีเมล์ :"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20),
                child: Text("usertest@gmail.com"),
              ),
              // Text(
              //   todo.actionName,
              //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
              // ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("เบอร์โทรศัพท์ :"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20),
                child: Text("0823345678"),
              ),
              // Text(
              //   todo.actionName,
              //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class Tabbar extends StatelessWidget {
  const Tabbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 10, right: 20),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      alignment: FractionalOffset.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/images/ic_action_contacts.png",
            width: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("ข้อมูลผู้ใช้งาน (Profile)"),
          ),
        ],
      ),
    );
  }
}
