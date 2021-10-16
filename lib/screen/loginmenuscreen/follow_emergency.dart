import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:idee_flutter/models/emergencydetail_model.dart';
import 'package:idee_flutter/screen/loginmenuscreen/list_emergency.dart';

class FollowEmergency extends StatefulWidget {
  const FollowEmergency({Key key}) : super(key: key);

  @override
  _FollowEmergencyState createState() => _FollowEmergencyState();
}

class _FollowEmergencyState extends State<FollowEmergency> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String date;
  EmergenyDetailModel emergenyDetailModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ติดตามเหตุภาวะฉุกเฉิน"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 30, right: 30),
        child: Form(
          key: _key,
          autovalidate: _validate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text("ค้นหาตามข้อความ:"),
                ),
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
                    hintText: "ระบุข้อความที่ต้องการค้นหา",
                    hintStyle: TextStyle(fontSize: 10),
                  ),
                  onSaved: (String val) {
                    //addressNo = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text("วันที่แจ้ง:"),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2200),
                  onChanged: (val) => print(val),
                  onSaved: (val) {
                    date = val;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () {
                    _searchinfo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ListDetailEmergency(emergenyDetailModel);
                      }),
                    );
                  },
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.deepPurple,
                          child: Text(
                            'ค้นหา',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _searchinfo() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("Data  $date");
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
