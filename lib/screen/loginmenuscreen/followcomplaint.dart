import 'package:flutter/material.dart';
import 'package:idee_flutter/models/detail_model.dart';
import 'package:idee_flutter/screen/loginmenuscreen/follow_detail.dart';

class FollowComplaint extends StatefulWidget {
  const FollowComplaint({Key key}) : super(key: key);

  @override
  _FollowComplaintState createState() => _FollowComplaintState();
}

class _FollowComplaintState extends State<FollowComplaint> {
  DetailModel detail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ติดตามเรื่องร้องเรียน"),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListComplaint(),
          //const Tabbar(),
        ],
      ),
    );
  }
}

class Tabbar extends StatefulWidget {
  const Tabbar({Key key}) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
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
  }
}

class ListComplaint extends StatefulWidget {
  const ListComplaint({Key key}) : super(key: key);

  @override
  _ListComplaintState createState() => _ListComplaintState();
}

class _ListComplaintState extends State<ListComplaint> {
  List<String> _dummy = List<String>.generate(10, (index) => "Row: ${index}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.all(20),
        child: _listSection(),
      ),
    );
  }

  Widget _listSection({DetailModel detail}) => ListView.builder(
      itemCount: _dummy.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return FollowDetail(detail);
                }),
              );
            },
            child: Column(
              children: <Widget>[
                _headerSectionCard(),
                _bodySectionCard(),
                _footerSectionCard(),
                _typeSectionCard(),
              ],
            ),
          ),
        );
      });

  Widget _headerSectionCard() => ListTile(
        leading: Container(
          height: 40,
          width: 40,
          child: Image.asset("assets/images/ic_action_infor.png"),
        ),
        title: Text(
          "ชื่อเลขที่ร้องเรียน",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "T-2564-05-18-0183",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );

  Widget _bodySectionCard() => Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          "โรงงานนี้ตั้งอยู่บนถนน เสม็ด อ่างศิลา โดยขับรถจากถนนสุขุวิทแล้วเลี้ยวซ้ายประมาณ 300 ม. จากปากทางปล่อยกลิ่นเหม็นและควันพิษออกจากปล่อง ลมพัดมามีกลื่นเหม็นและแสบจมูกมาก",
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      );

  Widget _footerSectionCard() => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text("สถานะ :"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
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
      );

  Widget _typeSectionCard() => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 10,
            ),
            child: Text("ประเภทร้องเรียน :"),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 10,
            ),
            child: Text(
              "ร้องเรียนโรงงาน",
            ),
          ),
          // Text(
          //   todo.actionName,
          //   style: TextStyle(fontFamily: "Kanit", fontSize: 13),
          // ),
        ],
      );
}
