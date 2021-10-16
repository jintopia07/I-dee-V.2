import 'package:flutter/material.dart';
import 'package:idee_flutter/models/emergencydetail_model.dart';
import 'package:idee_flutter/screen/loginmenuscreen/detail_emergency.dart';

class ListDetailEmergency extends StatefulWidget {
  EmergenyDetailModel emergenyDetailModel;

  ListDetailEmergency(this.emergenyDetailModel);

  @override
  _ListDetailEmergencyState createState() => _ListDetailEmergencyState();
}

class _ListDetailEmergencyState extends State<ListDetailEmergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ติดตามเหตุภาวะฉุกเฉิน'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        margin: EdgeInsets.all(20),
        child: ListEmergency(),
      ),
    );
  }
}

class ListEmergency extends StatefulWidget {
  const ListEmergency({Key key}) : super(key: key);

  @override
  _ListEmergencyState createState() => _ListEmergencyState();
}

class _ListEmergencyState extends State<ListEmergency> {
  List<String> _dummy = List<String>.generate(10, (index) => "Row: ${index}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _listSection(),
      ),
    );
  }

  Widget _listSection({EmergenyDetailModel emergenyDetailModel}) =>
      ListView.builder(
          itemCount: _dummy.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DetailEmergency(emergenyDetailModel);
                    }),
                  );
                },
                child: Column(
                  children: <Widget>[
                    _headerSectionCard(),
                    _dateSectionCard(),
                    _typeSectionCard(),
                    _bodySectionCard(),
                  ],
                ),
              ),
            );
          });

  Widget _headerSectionCard() => ListTile(
        leading: Container(
          height: 40,
          width: 40,
          child: Image.asset("assets/images/ic_action_emergency.png"),
        ),
        title: Text(
          "รหัสเรื่องภาวะเหตุฉุกเฉิน",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "E-2563-03-20-0009",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );

  Widget _typeSectionCard() => Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("ประเภทเหตุภาวะฉุกเฉิน :"),
            SizedBox(
              height: 5,
            ),
            Text(
              "อุบัติเหตุจากการทำงานและเครื่องจักร",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );

  Widget _bodySectionCard() => ListTile(
        title: Text(
          "รายละเอียดเหตุการณ์ :",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "คนงานตกจากตึก 20 ชั้น ตอนนี้ได้รับบาดเจ็บสาหัส 1 คน",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );

  Widget _dateSectionCard() => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text("วันที่เกิดเหตุ :"),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(
              "13/01/2019",
              style: TextStyle(color: Colors.red),
            ),
          ),
          // Text(
          //   todo.actionName,
          //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
          // ),
        ],
      );
}
