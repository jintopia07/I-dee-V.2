import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idee_flutter/models/complaint_model.dart';
import 'package:idee_flutter/screen/confirm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:video_player/video_player.dart';

class ComplaintOffice extends StatefulWidget {
  @override
  _ComplaintOfficeState createState() => _ComplaintOfficeState();
}

class _ComplaintOfficeState extends State<ComplaintOffice> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  List<Asset> images = List<Asset>();
  String _error;
  String refBookNo,
      complaintTitleTypeOtherDetail,
      locationAreaDetail,
      complaintDetail,
      citizenNo,
      backCitizenNo,
      firstName,
      lastName,
      phone,
      email,
      latitude,
      longitude,
      mapUrl,
      mapDetail,
      complaintTitleId,
      isOfficeSent,
      citizenSkip,
      addressNo,
      provinceId,
      districtId,
      subDistrictId,
      files;
  Dio dio = Dio();
  bool _switchValue = false;
  bool visibilityTag = false;
  bool visibilityCam = false;
  bool visibilityVdo = false;
  File imageFile;
  File videoFile;

  Map<String, bool> values = {
    'ขอความเป็นธรรม': false,
    'ทุจริตต่อหน้าที่ราชการ': false,
    'พ.ร.บ. ละเมิดรถยนต์ราชการ': false,
    'ความผิดทางเพศ': false,
    'พ.ร.บ. ละเมิดครุภัณฑ์ราชการ': false,
    'ละทิ้ง/ทอดทิ้ง หน้าที่ราชการ': false,
    'ใช้รถยนต์ทางราชการในการส่วนตัว': false,
    'พ.ร.บ. ละเมิดเงินราชการ': false,
    'อื่นๆ (Others)': false,
  };

  Map<String, int> valuesWithID = {
    'ขอความเป็นธรรม': 0,
    'ทุจริตต่อหน้าที่ราชการ': 1,
    'พ.ร.บ. ละเมิดรถยนต์ราชการ': 2,
    'ความผิดทางเพศ': 3,
    'พ.ร.บ. ละเมิดครุภัณฑ์ราชการ': 4,
    'ละทิ้ง/ทอดทิ้ง หน้าที่ราชการ': 5,
    'ใช้รถยนต์ทางราชการในการส่วนตัว': 6,
    'พ.ร.บ. ละเมิดเงินราชการ': 7,
    'อื่นๆ (Others)': 8,
  };

  var tmpArray = [];
  var tmpSelectedIDs = [];

  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      } else {}
    });
    // Printing all selected items on Terminal screen.
    print(tmpArray);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    tmpArray.clear();
  }

  String getSelectedCheckboxIDs() {
    values.forEach((key, value) {
      if (value == true) {
        var id = valuesWithID[key];
        if (!tmpSelectedIDs.contains(id)) {
          tmpSelectedIDs.add(id);
        }
      }
    });
    print(tmpSelectedIDs.join("|"));
    return tmpSelectedIDs.join("|");
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
      }
      if (field == "camera") {
        visibilityCam = visibility;
      }
      if (field == "vdocam") {
        visibilityVdo = visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList = [];
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  _openCamera() async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture.path);
    });
  }

  _videoPic() async {
    var theVid = await ImagePicker().getVideo(source: ImageSource.gallery);
    if (theVid != null) {
      setState(() {
        videoFile = File(theVid.path);
      });
    }
  }

  _record() async {
    var theVid = await ImagePicker().getVideo(source: ImageSource.camera);
    if (theVid != null) {
      setState(() {
        videoFile = File(theVid.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้องเรียนเจ้าหน้าที่'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              showCheckbox(),
              addForm(),
              addFiles(),
              switchButton(),
              confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton buttonAction() {
    return RaisedButton(
      child: Text("Pick images"),
      onPressed: loadAssets,
    );
  }

  Widget showCheckbox() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("ประเด็นการร้องเรียน (Issue of Complain)"),
          ),
          Container(
            height: 550,
            child: Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: values.keys.map((String key) {
                  return new CheckboxListTile(
                    title: new Text(
                      key,
                      style: TextStyle(fontSize: 14),
                    ),
                    value: values[key],
                    activeColor: Colors.pink,
                    checkColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        values[key] = value;
                        var selectedIDs = getSelectedCheckboxIDs();
                        complaintTitleId = selectedIDs;
                        print(complaintTitleId);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          //Container(height: 500, child: CheckboxWidget()),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("โปรดระบุ"),
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
                //complaintTitleTypeOtherDetail = val;
              },
            ),
          ),
        ],
      );

  Widget addForm() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Text("ชื่อเจ้าหน้าที่ประพฤติมิชอบ"),
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
            child: Text("นามสกุลเจ้าหน้าที่ประพฤติมิชอบ"),
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
            child: Text(
                "รายละเอียดพฤติกรรมที่กล่าวหาร้องเรียน \n(Description, Behavior of Government Officer, etc.)"),
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
                complaintDetail = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Text(
                "ประเด็นความต้องการให้หน่วยงานช่วยเหลือหรือแก้ไข \n(Issues that the department should help or solve.)"),
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
                complaintDetail = val;
              },
            ),
          ),
        ],
      );

  Widget addFiles() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: Text("เอกสารแนบ/รูปภาพ (File Attachment)"),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    border: Border.all(
                        color: Colors.deepPurple[300], // Set border color
                        width: 3.0), // Set border width
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.0)), // Set
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.camera_enhance),
                    onPressed: () {
                      _openCamera();
                      visibilityCam ? null : _changed(true, "camera");
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    border: Border.all(
                        color: Colors.deepPurple[300], // Set border color
                        width: 3.0), // Set border width
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.0)), // Set
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.picture_in_picture_alt),
                    onPressed: () {
                      loadAssets();
                      visibilityTag ? null : _changed(true, "tag");
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    border: Border.all(
                        color: Colors.deepPurple[300], // Set border color
                        width: 3.0), // Set border width
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.0)), // Set
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.videocam),
                    onPressed: () {
                      _record();
                      visibilityVdo ? null : _changed(true, "vdocam");
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    border: Border.all(
                        color: Colors.deepPurple[300], // Set border color
                        width: 3.0), // Set border width
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.0)), // Set
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.video_collection),
                    onPressed: () {
                      _videoPic();
                      visibilityVdo ? null : _changed(true, "vdocam");
                    },
                  ),
                ),
              ],
            ),
          ),
          showimages(),
        ],
      );

  Row showimages() {
    return Row(
      children: [
        visibilityTag
            ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  width: 350.0,
                  height: 100,
                  child: buildGridView(),
                ),
              )
            : new Container(),
        visibilityCam
            ? Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  width: 250.0,
                  child: imageFile == null
                      ? Image.asset('images/complaint.png')
                      : Image.file(imageFile),
                ),
              )
            : new Container(),
        SizedBox(
          height: 20,
        ),
        visibilityVdo
            ? Center(
                child: Container(
                  color: Colors.brown,
                  height: MediaQuery.of(context).size.height * (30 / 100),
                  width: MediaQuery.of(context).size.width * (70 / 100),
                  child: videoFile == null
                      ? Center()
                      : FittedBox(
                          fit: BoxFit.cover,
                          child: mounted
                              ? Chewie(
                                  controller: ChewieController(
                                    videoPlayerController:
                                        VideoPlayerController.file(videoFile),
                                    aspectRatio: 3 / 2,
                                    autoPlay: true,
                                    looping: true,
                                  ),
                                )
                              : Container(),
                        ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget switchButton() => Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("ยอมรับข้อตกลงและเงื่อนไข"),
            )
          ],
        ),
      );

  Widget confirmButton() => Container(
        height: 50,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          onPressed: () {
            //_sendToSave();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Confirmpages(),
                // Pass the arguments as part of the RouteSettings. The
                // DetailScreen reads the arguments from these settings.
                settings: RouteSettings(
                  arguments: _sendToSave(),
                ),
              ),
            );
          },
          textColor: Colors.white,
          color: Colors.deepPurple,
          padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.deepPurple,
                  padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                  child: Text(
                    'ยืนยันการแจ้งร้องเรียน (Confirm)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                  child: Icon(
                    Icons.backup,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _sendToSave() {
    print("Name $complaintTitleId");
  }
}
