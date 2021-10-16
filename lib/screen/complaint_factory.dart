import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:idee_flutter/maps/blocs/application_bloc.dart';
import 'package:idee_flutter/models/complaint_model.dart';
import 'package:idee_flutter/models/place.dart';
import 'package:idee_flutter/screen/confirm_factorypage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ComplaintFactory extends StatefulWidget {
  static const routeName = '/factory';
  @override
  _ComplaintFactoryState createState() => _ComplaintFactoryState();
}

class _ComplaintFactoryState extends State<ComplaintFactory> {
  Applicationbloc applicationBloc;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;
  bool _validate = false;
  Timer _timer;
  List<Asset> images = [];
  Dio dio = Dio();
  bool _switchValue = false;
  bool visibilityTag = false;
  bool visibilityCam = false;
  bool visibilityVdo = false;
  bool visibilityMap = false;
  File imageFile;
  File videoFile;
  double lat, lng;
  Complaint complaint = new Complaint();

  String complaintTitleTypeOtherDetail,
      locationAreaDetail,
      complaintDetail,
      latitude,
      longitude,
      mapUrl,
      mapDetail,
      complaintTitleId,
      files;

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
      if (field == "Map") {
        visibilityMap = visibility;
      }
    });
  }

  Widget buildGridView() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      //childAspectRatio: (1 / .65),
      padding: const EdgeInsets.all(4.0),
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
        maxImages: 4,
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

  Future<Null> _openCamera({ImageSource source}) async {
    try {
      var picture = await ImagePicker()
          .getImage(source: source, maxHeight: 800, maxWidth: 800);
      if (picture != null) {
        setState(() {
          imageFile = File(picture.path);
        });
      }
    } catch (e) {}
  }

  _videoPic() async {
    var theVid = await ImagePicker().getVideo(source: ImageSource.gallery);
    if (theVid != null) {
      setState(() {
        videoFile = File(theVid.path);
      });
    }
  }

  Future<Null> _record({ImageSource source}) async {
    try {
      var theVid = await ImagePicker().getVideo(source: source);
      if (theVid != null) {
        setState(() {
          videoFile = File(theVid.path);
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _location() async {
    try {
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
    } catch (e) {}
  }

  // @override
  // void didChangeDependencies() {
  //   final applicationBloc =
  //       Provider.of<Applicationbloc>(context, listen: false);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<Applicationbloc>(context, listen: false);
    applicationBloc?.close();
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print("lat = $lat, lng = $lng");
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
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
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<Applicationbloc>(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ร้องเรียนโรงงานอุตสาหกรรม'),
        ),
        body: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return (applicationBloc.currentLocation == null)
                  ? Center(
                      //child: CircularProgressIndicator(),
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
                                  child: Text(
                                      "ประเด็นการร้องเรียน (Issue of Complain)"),
                                ),
                                Container(
                                  height: 450.0,
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
                                        activeColor: Colors.deepPurple[400],
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
                                    // validator: (String value) {
                                    //   if (value.length == 0)
                                    //     return 'กรุณากรอกข้อมูล';
                                    //   else
                                    //     return null;
                                    // },
                                    onChanged: (String val) {
                                      setState(() {
                                        complaintTitleTypeOtherDetail = val;
                                      });
                                    },
                                  ),
                                ),
                                showtext(),
                                Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new TextFormField(
                                          style: TextStyle(
                                              fontFamily: "Kanit",
                                              fontSize: 14),
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

                                          onChanged: (value) => applicationBloc
                                              .searchPlaces(value),

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
                                                        .currentLocation
                                                        .latitude,
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
                                                      _location();
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      )
                                    : new Container(),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 20),
                                  child: Text(
                                      "รายละเอียดเรื่องร้องเรียน (Complaint Details)"),
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
                                    onChanged: (String val) {
                                      setState(() {
                                        complaintDetail = val;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 20),
                                  child: Text(
                                      "เอกสารแนบ/รูปภาพ (File Attachment)"),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            _openCamera(
                                                source: ImageSource.camera);
                                            visibilityCam
                                                ? null
                                                : _changed(true, "camera");
                                            visibilityVdo
                                                ? null
                                                : _changed(false, "vdocam");
                                            visibilityTag
                                                ? null
                                                : _changed(false, "tag");
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
                                          icon: Icon(
                                              Icons.picture_in_picture_alt),
                                          onPressed: () {
                                            loadAssets();
                                            visibilityTag
                                                ? null
                                                : _changed(true, "tag");
                                            visibilityVdo
                                                ? null
                                                : _changed(false, "vdocam");
                                            visibilityCam
                                                ? null
                                                : _changed(false, "camera");
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
                                            _record(source: ImageSource.camera);
                                            visibilityVdo
                                                ? null
                                                : _changed(true, "vdocam");
                                            visibilityCam
                                                ? null
                                                : _changed(false, "camera");
                                            visibilityTag
                                                ? null
                                                : _changed(false, "tag");
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
                                            _videoPic();
                                            visibilityVdo
                                                ? null
                                                : _changed(true, "vdocam");
                                            visibilityCam
                                                ? null
                                                : _changed(false, "camera");
                                            visibilityTag
                                                ? null
                                                : _changed(false, "tag");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visibilityTag
                                    ? Center(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 20),
                                          width: 350.0,
                                          height: 100.0,
                                          child: buildGridView(),
                                        ),
                                      )
                                    : new Container(),
                                visibilityCam
                                    ? Center(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: 10, top: 20),
                                          width: 300.0,
                                          height: 300.0,
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
                                          color: Colors.transparent,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              (30 / 100),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (80 / 100),
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
                                // Container(
                                //   child: Row(
                                //     children: [
                                //       CupertinoSwitch(
                                //         value: _switchValue,
                                //         onChanged: (value) {
                                //           setState(() {
                                //             _switchValue = value;
                                //           });
                                //         },
                                //       ),
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 10),
                                //         child: Text("ยอมรับข้อตกลงและเงื่อนไข"),
                                //       )
                                //     ],
                                //   ),
                                // ),
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
                                    onPressed: () {
                                      _sendSave();
                                      if (_key.currentState.validate()) {
                                        complaint = generateCompaint();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmFactory(),
                                            // Pass the arguments as part of the RouteSettings. The
                                            // DetailScreen reads the arguments from these settings.
                                            settings: RouteSettings(
                                              arguments: complaint,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    textColor: Colors.white,
                                    color: Colors.deepPurple,
                                    padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            color: Colors.deepPurple,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 4, 4, 4),
                                            child: Text(
                                              'ยืนยันการแจ้งร้องเรียน (Confirm)',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                6, 0, 10, 0),
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
      ),
    );
  }

  Container showtext() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: Text("สถานที่เกิดเหตุเรื่องร้องเรียน (Issue Location)"),
      ),
    );
  }

  Container mapsfield() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new TextFormField(
              style: TextStyle(fontFamily: "Kanit"),
              controller: _locationController,
              textCapitalization: TextCapitalization.words,
              decoration: new InputDecoration(
                hintText: 'ค้นหาที่อยู่',
                hintStyle: TextStyle(fontFamily: "Kanit"),
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
              onChanged: (String val) {
                setState(() {
                  locationAreaDetail = val;
                });
              },
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.pin_drop,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  visibilityMap ? null : _changed(true, "Map");
                  visibilityCam ? null : _changed(false, "camera");
                  visibilityVdo ? null : _changed(false, "vdocam");
                  visibilityTag ? null : _changed(false, "tag");
                }),
          ),
        ],
      ),
    );
  }

  Center showMaps() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Center(
      child: Container(
        height: 300,
        child: GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
          markers: myMarker(),
        ),
      ),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('here'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งปัจจุบัน',
            snippet: 'ละติจูด  = $lat, ลองติจูด = $lng'),
      )
    ].toSet();
  }

  _sendSave() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      print("ComplainId $complaintTitleId");
      print("ComplainDetail Other $complaintTitleTypeOtherDetail");
      print("Location $_locationController");
      print("Complain Detail $complaintDetail");
      print("File image  $images");
      print("Video $videoFile");
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  Complaint generateCompaint() {
    Complaint complaint = Complaint();
    complaint.complaintDetail = complaintDetail;
    complaint.complaintTitleTypeOtherDetail = complaintTitleTypeOtherDetail;
    complaint.images = images;
    complaint.locationAreaDetail = _locationController.text;
    complaint.complaintTitleId = complaintTitleId;
    complaint.video = videoFile;
    return complaint;
  }
}
