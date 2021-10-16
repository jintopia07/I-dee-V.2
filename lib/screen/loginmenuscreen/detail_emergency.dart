import 'package:flutter/material.dart';
import 'package:idee_flutter/models/emergencydetail_model.dart';

class DetailEmergency extends StatelessWidget {
  EmergenyDetailModel emergenyDetailModel;

  DetailEmergency(this.emergenyDetailModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดเหตุภาวะฉุกเฉิน'),
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
              _typeinfoSection(),
              _locationSection(),
              _detailSection(),
              _emergencySection(),
              _infoSection(),
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
              "assets/images/ic_action_emergency.png",
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("ติดตามเหตุภาวะฉุกเฉิน"),
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
              child: Text("รหัสเรื่องภาวะเหตุฉุกเฉิน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "E-2563-03-20-0009",
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
                "13/01/2019",
              ),
            ),
          ],
        ),
      );

  Widget _typeinfoSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("ประเภทเหตุภาวะฉุกเฉิน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "อุบัติเหตุจากการทำการและเครื่องจักร",
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

  Widget _locationSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("สถานที่ :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "ตึกใบหยก 2",
              ),
            ),
          ],
        ),
      );

  Widget _detailSection() => ListTile(
        title: Text(
          "รายละเอียดเหตุการณ์ :",
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text("คนงานตกจากตึก 20 ชั้น ตอนนี้ได้รับบาดเจ็บสาหัส 1 คน"),
        ),
      );

  Widget _emergencySection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("สันนิษฐานสาเหตุเบื้องต้น :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "เกิดจากสาเหตุเครื่องมือชำรุด",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            // Text(
            //   todo.actionName,
            //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
            // ),
          ],
        ),
      );

  Widget _infoSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text("รายละเอียดการปฏิบัติงาน :"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                "รวบรวมข้อมูลในเหตุการณ์",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            // Text(
            //   todo.actionName,
            //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
            // ),
          ],
        ),
      );
}
