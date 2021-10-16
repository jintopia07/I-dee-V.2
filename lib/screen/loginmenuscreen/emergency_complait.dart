import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class EmergencyCompliant extends StatefulWidget {
  const EmergencyCompliant({Key key}) : super(key: key);

  @override
  _EmergencyCompliantState createState() => _EmergencyCompliantState();
}

class _EmergencyCompliantState extends State<EmergencyCompliant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แจ้งเหตุภาวะฉุกเฉิน"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              const Forminfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class Forminfo extends StatefulWidget {
  const Forminfo({Key key}) : super(key: key);

  @override
  _ForminfoState createState() => _ForminfoState();
}

class _ForminfoState extends State<Forminfo> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  List placelist;
  List eventList;
  String _placelist;
  String _evenList;
  List<Asset> images = [];
  Dio dio = Dio();
  bool visibilityTag = false;
  bool visibilityCam = false;
  bool visibilityVdo = false;
  File imageFile;
  File videoFile;
  String emergencyTypeId,
      emergencyTypeOther,
      emergencyLocation,
      latitude,
      longitude,
      factoryCode,
      emergencyDate,
      emergencyDescription,
      emergencyChanelId,
      numberOfCasualties,
      numberOfDeaths,
      damageEstimate,
      introPresumedCause,
      operationDescription,
      factoryName,
      files;

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

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
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
    return Container(
      child: new Form(
        key: _key,
        autovalidate: _validate,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text("แหล่งที่มา :"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: Listener(
                            onPointerDown: (_) =>
                                FocusScope.of(context).unfocus(),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: _placelist,
                                iconSize: 20,
                                icon: (null),
                                style: TextStyle(
                                    fontFamily: "Kanit", color: Colors.black),
                                hint: Text('กรุณาเลือก'),
                                onChanged: (String placeValue) {
                                  setState(() {
                                    //_subDistrict = subDistrictValue;
                                  });
                                },
                                items: placelist?.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          item['subDistrictNameTH'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: item['oid'].toString(),
                                      );
                                    })?.toList() ??
                                    [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("ประเภทเหตุการณ์ *:"),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: _evenList,
                              iconSize: 20,
                              icon: (null),
                              style: TextStyle(
                                  fontFamily: "Kanit", color: Colors.black),
                              hint: Text('กรุณาเลือก'),
                              onChanged: (String eventValue) {
                                setState(() {
                                  // _provinces = provincesValue;
                                  // _getDistrict();
                                });
                              },
                              items: eventList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                        item['provinceNameTH'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      value: item['oid'].toString(),
                                    );
                                  })?.toList() ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Text("รายละเอียดสถานที่เกิดเหตุ :"),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.deepPurple,
                            padding: EdgeInsets.fromLTRB(5, 4, 10, 4),
                            child: Text(
                              'รายละเอียดสถานที่ (LOCATION DETAIL)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                    onSaved: (String val) {
                      emergencyLocation = val;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text("รายละเอียดโรงงาน :"),
                ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SearchFactory();
                        }),
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.deepPurple,
                            padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                            child: Text(
                              'ค้นหาข้อมูลโรงงาน',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                      hintText:
                          "คลิกปุ่มค้นหาข้อมูลโรงงานและเลือกข้อมูลโรงงานที่ต้องการ",
                      hintStyle: TextStyle(fontSize: 10),
                    ),
                    // maxLength: 32,
                    validator: (String value) {
                      if (value.length == 0)
                        return 'กรุณากรอกข้อมูล';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      factoryName = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("รายละเอียดสถานที่เกิดเหตุ:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("วัน/เดือน/ปีที่เกิดเหตุ"),
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
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) {
                      emergencyDate = val;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("เหตุการณ์ที่เกิดขึ้น:"),
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
                      emergencyDescription = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("ความเสียหาย"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text(" - ผู้บาดเจ็บ (คน)*:"),
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
                      numberOfCasualties = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text(" - เสียชีวิต (คน)*:"),
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
                      numberOfDeaths = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text(" - ประมาณการค่าความเสียหาย (บาท)*:"),
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
                      damageEstimate = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("สันนิษฐานสาเหตุเบื้องต้น*:"),
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
                      introPresumedCause = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Text("การดำเนินการ*:"),
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
                      operationDescription = val;
                    },
                  ),
                ),
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
                            visibilityVdo ? null : _changed(false, "vdocam");
                            visibilityTag ? null : _changed(false, "tag");
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
                            visibilityVdo ? null : _changed(false, "vdocam");
                            visibilityCam ? null : _changed(false, "camera");
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
                            visibilityCam ? null : _changed(false, "camera");
                            visibilityTag ? null : _changed(false, "tag");
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
                            visibilityCam ? null : _changed(false, "camera");
                            visibilityTag ? null : _changed(false, "tag");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                visibilityTag
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          width: 300.0,
                          height: 250,
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
                          height:
                              MediaQuery.of(context).size.height * (30 / 100),
                          width: MediaQuery.of(context).size.width * (70 / 100),
                          child: videoFile == null
                              ? Center()
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: mounted
                                      ? Chewie(
                                          controller: ChewieController(
                                            videoPlayerController:
                                                VideoPlayerController.file(
                                                    videoFile),
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
                      _saveinfo();
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
                              'แจ้งเตือนเหตุการณ์ฉุกเฉิน',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveinfo() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}

class SearchFactory extends StatefulWidget {
  const SearchFactory({Key key}) : super(key: key);

  @override
  _SearchFactoryState createState() => _SearchFactoryState();
}

class _SearchFactoryState extends State<SearchFactory> {
  int _radioValue = -1;
  GlobalKey<FormState> _key = new GlobalKey();
  String numberid;
  bool isApicallProcess = false;
  bool visibilitybyId = false;
  bool visibilityTaxId = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          // Fluttertoast.showToast(
          //     msg: 'เลขทะเบียนค้นหา', toastLength: Toast.LENGTH_SHORT);
          _changed(true, "byid");
          _changed(false, "taxid");

          break;
        case 1:
          _changed(false, "byid");
          _changed(true, "taxid");
          break;
      }
    });
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "byid") {
        visibilitybyId = visibility;
      }
      if (field == "taxid") {
        visibilityTaxId = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ค้นหาข้อมูลโรงงาน"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("ค้นหาข้อมูลโรงงาน ตามเงื่อนไข :"),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange),
                      new Text(
                        'เลขทะเบียนโรงงาน',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange),
                      new Text(
                        'เลขนิติบุคคล',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
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
                        hintText: "กรุณากรอกเลขค้นหาข้อมูล"),
                    onSaved: (String val) {
                      numberid = val;
                    },
                  ),
                ),
                SizedBox(height: 20),
                visibilitybyId
                    ? Container(
                        height: 50,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () {
                            setState(() {
                              _getData();
                            });
                          },
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : Container(),
                //SizedBox(height: 5),
                visibilityTaxId
                    ? Container(
                        height: 50,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          onPressed: () {
                            setState(() {
                              _getFactoryByTax();
                            });

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'กรุณาเลือก',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                      color: Colors.deepPurple,
                                    ),
                                    content:
                                        setupAlertDialoadContainer(context),
                                  );
                                });
                          },
                          textColor: Colors.white,
                          color: Colors.deepPurple,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 40),
                  child: Text("คำแนะนำ"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text("- ให้ทำการค้นหาข้อมูลโรงงานที่ต้องการ"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                      "- คลิกเลือกชื่อโรงงานที่ต้องการจากผลการค้นหาที่พบข้อมูล"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getData() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("ById $numberid");
      _getFactoryById();
    } else {
      // validation error
      setState(() {
        //_validate = true;
        //_saveDataFarmer();
      });
    }
  }

  _getFactoryByTax() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      print("TaxId $numberid");
      _getFactoryByTaxId();
    } else {
      // validation error
      setState(() {
        //_validate = true;
        //_saveDataFarmer();
      });
    }
  }

  Future<String> _getFactoryById() async {
    await http.post(
        Uri.parse(
            'http://webapitest.industry.go.th/api/Factory/GetFactoryById'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"Id": numberid}).then((response) {
      var data = json.decode(response.body);
      //subDistrictsList = data;
    });
  }

  Future<String> _getFactoryByTaxId() async {
    await http.post(
        Uri.parse(
            'http://webapitest.industry.go.th/api/Factory/GetFactoryByTaxId'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"Id": numberid}).then((response) {
      var data = json.decode(response.body);
      //subDistrictsList = data;
    });
  }

  Widget setupAlertDialoadContainer(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.grey,
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('List Item $index'),
                )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyCompliant(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        )
      ],
    );
  }
}
