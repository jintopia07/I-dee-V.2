import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:idee_flutter/models/DetaildataP_model.dart';
import 'package:idee_flutter/models/detail_model.dart';
import 'package:idee_flutter/models/token_login.dart';
import 'package:idee_flutter/screen/detail_page.dart';

class FollowPageCustomer extends StatefulWidget {
  @override
  _FollowPageCustomerState createState() => _FollowPageCustomerState();
}

class _FollowPageCustomerState extends State<FollowPageCustomer> {
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
          GroupList(),
        ],
      ),
    );
  }
}

class GroupList extends StatefulWidget {
  const GroupList({Key key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context).settings.arguments as TokenLogin;
    String token = todo.token;

    Future<List<FollowdataP>> _callData() async {
      var response = await http.get(
          Uri.parse(
              'https://8b62-2001-fb1-c1-77fc-b09f-5f2b-bd28-5c83.ngrok.io/api/Complaint/GetComplaintTrans'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      var jsonData = json.decode(response.body);

      List<FollowdataP> followdataPs = [];

      for (var u in jsonData) {
        FollowdataP followdataP = FollowdataP(
          u["complaintId"],
          u["complaintDate"],
          u["refBookNo"],
          u["complaintStatusName"],
          u["complainSystems"],
          u["complaintDetail"],
          u["locationAreaDetail"],
          u["isReceive"],
          u["complaintAnswer"],
          u["complaintDocument"],
          u["documentUrl"],
          u["thumbnailUrl"],
        );

        followdataPs.add(followdataP);
      }
      print(followdataPs.length);

      return followdataPs;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20),
        margin: EdgeInsets.all(20),
        child: FutureBuilder(
          future: _callData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                  child: Center(
                child: Text("Loading..."),
              ));
            }
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPagesP(snapshot.data[index])));
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: GestureDetector(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                  "assets/images/ic_action_infor.png"),
                            ),
                          ),
                          title: Text(
                            "ชื่อเลขที่ร้องเรียน",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            snapshot.data[index].complaintId,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            snapshot.data[index].complaintDetail,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text("สถานะ :"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                snapshot.data[index].complaintStatusName,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        Row(
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
                                snapshot.data[index].complainSystems,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailPagesP extends StatelessWidget {
  final FollowdataP followdataP;

  DetailPagesP(this.followdataP);

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
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: Container(
              //     height: 50,
              //     padding: EdgeInsets.only(
              //       left: 20,
              //       right: 20,
              //     ),
              //     child: RaisedButton(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       textColor: Colors.white,
              //       color: Colors.deepPurple,
              //       padding: EdgeInsets.fromLTRB(40, 0, 5, 0),
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //               color: Colors.deepPurple,
              //               padding: EdgeInsets.fromLTRB(50, 4, 4, 4),
              //               child: Text(
              //                 'กลับ',
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
              //               child: Icon(
              //                 Icons.cancel,
              //                 color: Colors.redAccent,
              //                 size: 30,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
              child: Text(followdataP.complaintId),
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
                followdataP.complaintStatusName,
                style: TextStyle(color: Colors.red),
              ),
            ),
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
                followdataP.complaintDate,
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
            followdataP.locationAreaDetail,
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
          child: Text(followdataP.complaintDetail),
        ),
      );
}

class FollowdataP {
  final String complaintId;
  final String complaintDate;
  final String refBookNo;
  final String complaintStatusName;
  final String complainSystems;
  final String complaintDetail;
  final String locationAreaDetail;
  final String isReceive;
  List<dynamic> complaintAnswer;
  List<dynamic> complaintDocument;
  final String documentUrl;
  final String thumbnailUrl;

  FollowdataP(
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
    this.documentUrl,
    this.thumbnailUrl,
  );
}
