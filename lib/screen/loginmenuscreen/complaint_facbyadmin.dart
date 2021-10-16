import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idee_flutter/maps/blocs/application_bloc.dart';
import 'package:idee_flutter/models/place.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

enum SingingCharacter { admin, noadmin }

class ComplaintFactoryByAdmin extends StatefulWidget {
  const ComplaintFactoryByAdmin({Key key}) : super(key: key);

  @override
  _ComplaintFactoryByAdminState createState() =>
      _ComplaintFactoryByAdminState();
}

class _ComplaintFactoryByAdminState extends State<ComplaintFactoryByAdmin> {
  GlobalKey<FormState> _key = new GlobalKey();
  final _locationController = TextEditingController();
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;
  bool _validate = false;
  bool _switchValue = false;
  List<Asset> images = [];
  int _radioValue1 = -1;
  bool visibilityAdmin = false;
  bool visibilityTag = false;
  bool visibilityCam = false;
  bool visibilityVdo = false;
  bool visibilityMap = false;
  File imageFile;
  File videoFile;

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

  List provincesList;
  List subDistrictList;
  List districtList;
  List subDistrictsList;

  SingingCharacter _character = SingingCharacter.admin;

  int _currentTimeValue = 1;

  final _buttonOptions = [
    DataValue(0, "ดำเนินการร้องเรียนโดยหน่วยงาน"),
    DataValue(1, "ส่งเรื่องร้องเรียนให้ส่วนกลาง"),
  ];

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          Fluttertoast.showToast(
              msg: 'Correct !', toastLength: Toast.LENGTH_SHORT);
          break;
        case 1:
          Fluttertoast.showToast(
              msg: 'Try again !', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "Admin") {
        visibilityAdmin = visibility;
      }
      if (field == "tag") {
        visibilityTag = visibility;
      }
      if (field == "camera") {
        visibilityCam = visibility;
      }
      if (field == "vdocam") {
        visibilityVdo = visibility;
      }
      if (field == "Map") {
        visibilityMap = visibility;
      }
    });
  }

  Widget buildGridView() {
    return GridView.count(
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

  Map<String, bool> values = {
    'กลิ่นเหม็น (Stink)': false,
    'กากของเสียอันตราย และสิ่งปฏิกูล (Sewage)': false,
    'น้ำเสีย (Waste Water)': false,
    'ฝุ่นละออง/เขม่าควัน (Dust)': false,
    'เสียงดัง (Disturbance Sound)': false,
    'การบริการของเจ้าหน้าที่รัฐ (Service of goverment)': false,
    'มาตรฐานผลิตภัณฑ์ชุมชน (Community Product)': false,
    'อื่นๆ (Others)': false,
  };

  Map<String, int> valuesWithID = {
    'กลิ่นเหม็น (Stink)': 1,
    'กากของเสียอันตราย และสิ่งปฏิกูล (Sewage)': 2,
    'น้ำเสีย (Waste Water)': 3,
    'ฝุ่นละออง/เขม่าควัน (Dust)': 5,
    'เสียงดัง (Disturbance Sound)': 6,
    'การบริการของเจ้าหน้าที่รัฐ (Service of goverment)': 42,
    'มาตรฐานผลิตภัณฑ์ชุมชน (Community Product)': 43,
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

  @override
  void initState() {
    final applicationBloc =
        Provider.of<Applicationbloc>(context, listen: false);

    //Listen for selected Location
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name;
        _goToPlace(place);
      } else
        _locationController.text = "";
    });

    applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<Applicationbloc>(context, listen: false);
    applicationBloc.dispose();
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<Applicationbloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งเรื่องร้องเรียน'),
      ),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return (applicationBloc.currentLocation == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _key,
                        autovalidate: _validate,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text("ประเภทการแจ้ง"),
                              ),
                              RadioListTile<SingingCharacter>(
                                title: const Text(
                                  'ระบุข้อมูลผู้แจ้ง',
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: SingingCharacter.admin,
                                groupValue: _character,
                                onChanged: (SingingCharacter value) {
                                  setState(() {
                                    _character = value;
                                    visibilityAdmin
                                        ? null
                                        : _changed(true, "Admin");
                                    print(_character);
                                  });
                                },
                              ),
                              RadioListTile<SingingCharacter>(
                                title: const Text(
                                  'ไม่ระบุข้อมูลผู้แจ้ง',
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: SingingCharacter.noadmin,
                                groupValue: _character,
                                onChanged: (SingingCharacter value) {
                                  setState(() {
                                    _character = value;
                                    _changed(false, "Admin");
                                    print(_character);
                                  });
                                },
                              ),
                              visibilityAdmin
                                  ? Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Divider(
                                              color: Colors.grey,
                                              height: 50,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: Text(
                                                "ข้อมูลผู้ร้องเรียน (Complainant)"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                                "หมายเลขประจำตัวประชาชน (Citizen No)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                              ),
                                              // maxLength: 32,
                                              validator: (String value) {
                                                if (value.length == 0)
                                                  return 'กรุณากรอกข้อมูล';
                                                else
                                                  return null;
                                              },
                                              onSaved: (String val) {
                                                citizenNo = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text(
                                                "หมายเลขหลังบัตร (Laser Code)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                              ),
                                              // maxLength: 32,
                                              validator: (String value) {
                                                if (value.length == 0)
                                                  return 'กรุณากรอกข้อมูล';
                                                else
                                                  return null;
                                              },
                                              onSaved: (String val) {
                                                backCitizenNo = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("ชื่อ (First Name)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("นามสกุล (Last Name)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
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
                                          Container(
                                            child: Divider(
                                              color: Colors.grey,
                                              height: 50,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text(
                                                "ข้อมูลการติดต่อ (Contact)"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("โทรศัพท์ (Telephone)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                              ),
                                              // maxLength: 32,
                                              validator: (String value) {
                                                if (value.length == 0)
                                                  return 'กรุณากรอกข้อมูล';
                                                else
                                                  return null;
                                              },
                                              onSaved: (String val) {
                                                phone = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("อีเมล (Email)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                              ),
                                              // maxLength: 32,
                                              onSaved: (String val) {
                                                email = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 20),
                                            child: Text(
                                                "ที่อยู่ที่สามารถติดต่อได้ (Address)"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("ที่อยู่  (Address)"),
                                          ),
                                          Center(
                                            child: TextFormField(
                                              decoration: new InputDecoration(
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  borderSide: new BorderSide(),
                                                ),
                                                isDense: true, // Added this
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                              ),
                                              // maxLength: 32,
                                              validator: (String value) {
                                                if (value.length == 0)
                                                  return 'กรุณากรอกข้อมูล';
                                                else
                                                  return null;
                                              },
                                              onSaved: (String val) {
                                                addressNo = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("จังหวัด (Province)"),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: ButtonTheme(
                                                      alignedDropdown: true,
                                                      child: DropdownButton<
                                                          String>(
                                                        //value: _provinces,
                                                        iconSize: 20,
                                                        icon: (null),
                                                        style: TextStyle(
                                                            fontFamily: "Kanit",
                                                            color:
                                                                Colors.black),
                                                        hint:
                                                            Text('กรุณาเลือก'),
                                                        onChanged: (String
                                                            provincesValue) {
                                                          setState(() {
                                                            // _provinces = provincesValue;
                                                            // _getDistrict();
                                                          });
                                                        },
                                                        items: provincesList
                                                                ?.map((item) {
                                                              return new DropdownMenuItem(
                                                                child: new Text(
                                                                  item[
                                                                      'provinceNameTH'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                value: item[
                                                                        'oid']
                                                                    .toString(),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("อำเภอ (District)"),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: ButtonTheme(
                                                      alignedDropdown: true,
                                                      child: DropdownButton<
                                                          String>(
                                                        //value: _district,
                                                        iconSize: 20,
                                                        icon: (null),
                                                        style: TextStyle(
                                                            fontFamily: "Kanit",
                                                            color:
                                                                Colors.black),
                                                        hint:
                                                            Text('กรุณาเลือก'),
                                                        onChanged: (String
                                                            districtValue) {
                                                          setState(() {
                                                            //_district = districtValue;
                                                            //_getsubDistrict();
                                                          });
                                                        },
                                                        items: districtList
                                                                ?.map((item) {
                                                              return new DropdownMenuItem(
                                                                child: new Text(
                                                                  item[
                                                                      'districtNameTH'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                value: item[
                                                                        'oid']
                                                                    .toString(),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Text("ตำบล (Sub District)"),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: Listener(
                                                      onPointerDown: (_) =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      child: ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: DropdownButton<
                                                            String>(
                                                          //value: _subDistrict,
                                                          iconSize: 20,
                                                          icon: (null),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Kanit",
                                                              color:
                                                                  Colors.black),
                                                          hint: Text(
                                                              'กรุณาเลือก'),
                                                          onChanged: (String
                                                              subDistrictValue) {
                                                            setState(() {
                                                              //_subDistrict = subDistrictValue;
                                                            });
                                                          },
                                                          items: subDistrictsList
                                                                  ?.map((item) {
                                                                return new DropdownMenuItem(
                                                                  child:
                                                                      new Text(
                                                                    item[
                                                                        'subDistrictNameTH'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  value: item[
                                                                          'oid']
                                                                      .toString(),
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
                                          Container(
                                            child: Divider(
                                              color: Colors.grey,
                                              height: 50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : new Container(),
                              Container(
                                child: Text("แจ้งเรื่องร้องเรียน"),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Radio(
                                        value: 0,
                                        groupValue: _radioValue1,
                                        onChanged: _handleRadioValueChange1),
                                    new Text(
                                      'แจ้งโดยเจ้าหน้าที่',
                                      style: new TextStyle(fontSize: 12.0),
                                    ),
                                    new Radio(
                                        value: 1,
                                        groupValue: _radioValue1,
                                        onChanged: _handleRadioValueChange1),
                                    new Text(
                                      'เจ้าหน้าที่แจ้งแทนประชาชน',
                                      style: new TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text("เลขที่หนังสือ (ถ้ามี)"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    refBookNo = val;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Text(
                                    "ประเด็นการร้องเรียน (Issue of Complain)"),
                              ),
                              Container(
                                height: 450,
                                child: Expanded(
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                            var selectedIDs =
                                                getSelectedCheckboxIDs();
                                            complaintTitleId = selectedIDs;
                                            print(complaintTitleId);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text("โปรดระบุ"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
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
                                    complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text(
                                    "ช่องทางการร้องเรียน (Complaint Channel)"),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: Listener(
                                          onPointerDown: (_) =>
                                              FocusScope.of(context).unfocus(),
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              //value: _subDistrict,
                                              iconSize: 20,
                                              icon: (null),
                                              style: TextStyle(
                                                  fontFamily: "Kanit",
                                                  color: Colors.black),
                                              hint: Text('กรุณาเลือก'),
                                              onChanged:
                                                  (String subDistrictValue) {
                                                setState(() {
                                                  //_subDistrict = subDistrictValue;
                                                });
                                              },
                                              items:
                                                  subDistrictsList?.map((item) {
                                                        return new DropdownMenuItem(
                                                          child: new Text(
                                                            item[
                                                                'subDistrictNameTH'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          value: item['oid']
                                                              .toString(),
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
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 20),
                                child: Text(
                                    "สถานที่เกิดเหตุเรื่องร้องเรียน (Issue Location)"),
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new TextFormField(
                                        style: TextStyle(
                                            fontFamily: "Kanit", fontSize: 14),
                                        controller: _locationController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: new InputDecoration(
                                          hintText: 'ค้นหาที่อยู่',
                                          hintStyle:
                                              TextStyle(fontFamily: "Kanit"),
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10),
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
                                        onSaved: (String value) {
                                          _locationController.text =
                                              locationAreaDetail;
                                        },

                                        onChanged: (value) =>
                                            applicationBloc.searchPlaces(value),
                                        onTap: () => applicationBloc
                                            .clearSelectedLocation(),
                                      ),
                                    ),
                                    new Container(
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: new IconButton(
                                          icon: new Icon(
                                            Icons.pin_drop,
                                            color: Colors.deepPurple,
                                          ),
                                          onPressed: () {
                                            visibilityMap
                                                ? null
                                                : _changed(true, "Map");
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              visibilityMap
                                  ? Stack(
                                      children: [
                                        Container(
                                          height: 300.0,
                                          child: GoogleMap(
                                            myLocationEnabled: true,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  applicationBloc
                                                      .currentLocation.latitude,
                                                  applicationBloc
                                                      .currentLocation
                                                      .longitude),
                                              zoom: 11.0,
                                            ),
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              _mapController
                                                  .complete(controller);
                                            },
                                            markers: Set<Marker>.of(
                                                applicationBloc.markers),
                                          ),
                                        ),
                                        if (applicationBloc.searchResults !=
                                                null &&
                                            applicationBloc
                                                    .searchResults.length !=
                                                0)
                                          Container(
                                            height: 300.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(.6),
                                                backgroundBlendMode:
                                                    BlendMode.darken),
                                          ),
                                        if (applicationBloc.searchResults !=
                                                null &&
                                            applicationBloc
                                                    .searchResults.length !=
                                                0)
                                          Container(
                                            height: 200.0,
                                            child: ListView.builder(
                                              itemCount: applicationBloc
                                                  .searchResults.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                    applicationBloc
                                                        .searchResults[index]
                                                        .description,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Kanit"),
                                                  ),
                                                  onTap: () {
                                                    applicationBloc
                                                        .setSelectedLocation(
                                                            applicationBloc
                                                                .searchResults[
                                                                    index]
                                                                .placeId);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    )
                                  : new Container(),
                              SizedBox(height: 20),
                              Container(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text("ข้อมูลโรงงาน"),
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  onPressed: () {},
                                  textColor: Colors.white,
                                  color: Colors.deepPurple,
                                  padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          color: Colors.deepPurple,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 4, 4),
                                          child: Text(
                                            'ค้นหาข้อมูลโรงงาน',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text("ชื่อโรงงาน"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    //complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text("สถานที่ตั้ง"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    //complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text("ประกอบกิจการ"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    //complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text("เลขทะเบียนโรงงาน"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    //complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Text("หมดอายุปี พ.ศ."),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    //complaintTitleTypeOtherDetail = val;
                                  },
                                ),
                              ),
                              Container(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text("รายละเอียด"),
                              ),
                              Center(
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      borderSide: new BorderSide(),
                                    ),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  // maxLength: 32,
                                  onSaved: (String val) {
                                    complaintDetail = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 20),
                                child:
                                    Text("เอกสารแนบ/รูปภาพ (File Attachment)"),
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
                                            color: Colors.deepPurple[
                                                300], // Set border color
                                            width: 3.0), // Set border width
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)), // Set
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.camera_enhance),
                                        onPressed: () {
                                          visibilityCam
                                              ? null
                                              : _changed(true, "camera");
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple[400],
                                        border: Border.all(
                                            color: Colors.deepPurple[
                                                300], // Set border color
                                            width: 3.0), // Set border width
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)), // Set
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon:
                                            Icon(Icons.picture_in_picture_alt),
                                        onPressed: () {
                                          visibilityTag
                                              ? null
                                              : _changed(true, "tag");
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple[400],
                                        border: Border.all(
                                            color: Colors.deepPurple[
                                                300], // Set border color
                                            width: 3.0), // Set border width
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)), // Set
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.videocam),
                                        onPressed: () {
                                          visibilityVdo
                                              ? null
                                              : _changed(true, "vdocam");
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple[400],
                                        border: Border.all(
                                            color: Colors.deepPurple[
                                                300], // Set border color
                                            width: 3.0), // Set border width
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)), // Set
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.video_collection),
                                        onPressed: () {
                                          visibilityVdo
                                              ? null
                                              : _changed(true, "vdocam");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              visibilityTag
                                  ? Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        width: 350.0,
                                        height: 100,
                                        child: buildGridView(),
                                      ),
                                    )
                                  : new Container(),
                              visibilityCam
                                  ? Center(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        width: 250.0,
                                        child: imageFile == null
                                            ? Image.asset(
                                                'images/complaint.png')
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
                                            MediaQuery.of(context).size.height *
                                                (30 / 100),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (70 / 100),
                                        child: videoFile == null
                                            ? Center()
                                            : FittedBox(
                                                fit: BoxFit.cover,
                                                child: mounted
                                                    ? Chewie(
                                                        controller:
                                                            ChewieController(
                                                          videoPlayerController:
                                                              VideoPlayerController
                                                                  .file(
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text("การดำเนินการเรื่องร้องเรียน"),
                              ),
                              Container(
                                height: 120,
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(8.0),
                                  children: _buttonOptions
                                      .map((dataValue) => RadioListTile(
                                            groupValue: _currentTimeValue,
                                            title: Text(
                                              dataValue._value,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            value: dataValue._key,
                                            onChanged: (val) {
                                              setState(() {
                                                debugPrint('VAL = $val');
                                                _currentTimeValue = val;
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                              Container(
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
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  onPressed: () {},
                                  textColor: Colors.white,
                                  color: Colors.deepPurple,
                                  padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          color: Colors.deepPurple,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 4, 4),
                                          child: Text(
                                            'ยืนยันการแจ้งร้องเรียน (Confirm)',
                                            style:
                                                TextStyle(color: Colors.white),
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
          }),
    );
  }
}

class DataValue {
  final int _key;
  final String _value;
  DataValue(this._key, this._value);
}
