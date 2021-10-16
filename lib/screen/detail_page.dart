import 'package:flutter/material.dart';

class DetailPages extends StatelessWidget {
  final DetailP detailP;

  DetailPages(this.detailP);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดเรื่องร้องเรียน'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          margin: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              _headerSection(),
              _titleSection(),
              _bodySection(),
              _typeSection(),
              _locationSection(),
              _detailSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() => Container(
        margin: EdgeInsets.only(left: 30, right: 20),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        alignment: FractionalOffset.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/ic_action_infor.png",
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("ติดตามเรื่องร้องเรียน Complaints"),
            ),
          ],
        ),
      );

  Widget _titleSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text("เลขที่ใบร้องเรียน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "T-2564-05-18-0183",
              ),
            ),
          ],
        ),
      );

  Widget _typeSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("สถานะเรื่องร้องเรียน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "อยู่ระหว่างดำเนินการ",
                style: TextStyle(color: Colors.red),
              ),
            ),
            // Text(
            //   todo.actionName,
            //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
            // ),
          ],
        ),
      );

  Widget _bodySection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("วันที่ร้องเรียน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "01/06/2020",
              ),
            ),
          ],
        ),
      );

  Widget _locationSection() => ListTile(
        title: Text(
          "รายละเอียดสถานที่ (Location) ;",
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "โรงก๋วยเตี๋ยว ตั้งบ่วนเส็ง ต.เสม็ด อ.เมือง จ.ชลบุรี",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      );

  Widget _detailSection() => ListTile(
        title: Text(
          "รายละเอียดเรื่องร้องเรียน (Complaint Detaills) :",
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
              "โรงงานนี้ตั้งอยู่บนถนน เสม็ด อ่างศิลา โดยขับรถจากถนนสุขุวิทแล้วเลี้ยวซ้ายประมาณ 300 ม. จากปากทางปล่อยกลิ่นเหม็นและควันพิษออกจากปล่อง ลมพัดมามีกลื่นเหม็นและแสบจมูกมาก"),
        ),
      );
}

class DetailP {
  final String complaintId;
  final String complaintDate;
  final String refBookNo;
  final String complaintStatusName;
  final String complainSystems;
  final String complaintDetail;
  final String locationAreaDetail;
  final String isReceive;
  final String complaintAnswer;
  final String complaintDocument;

  DetailP(
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
  );
}
