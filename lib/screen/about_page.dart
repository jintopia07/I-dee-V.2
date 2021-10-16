import 'package:flutter/material.dart';
import 'package:idee_flutter/screen/deviceinfo_page.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InfoSection(),
      ],
    );
  }
}

class InfoSection extends StatefulWidget {
  @override
  _InfoSectionState createState() => _InfoSectionState();
}

class _InfoSectionState extends State<InfoSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                "I-Dee Mobile Application",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "I = Industry  Dee = ดี",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                  "   เพื่อวัตถุประสงค์ในการนำเสนอข้อมูลรายงานสถิติต่างๆที่เกี่ยวข้องจากหน่วยงานต่างๆในสังกัด และระบบการรับเรื่องร้องเรียนกลางของหน่วยงานผ่าน Mobile Application เพื่อเพิ่มช่องทางในการใช้งานและให้บริการข้อมูลแก่ประชาชนทั่วไป โดยนำเทคโนโลยีสมัยใหม่มาช่วยในการอำนวยความสะดวกให้ดียิ่งขึ้น"),
            ),
            SizedBox(height: 30),
            Text(
              "------- Device Information -------",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(height: 250, child: DeviceInfo()),
          ],
        ),
      ),
    );
  }
}
