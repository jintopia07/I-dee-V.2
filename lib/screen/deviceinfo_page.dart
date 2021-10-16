import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfo extends StatefulWidget {
  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Devicename': build.brand,
      'Platform': build.device,
      'Version': build.version.release,
      'Manufacturer': build.manufacturer,
      'Model': build.model,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'Devicename': data.name,
      'Platform': data.systemName,
      'Version': data.systemVersion,
      'Model': data.model,
      'Manufacturer': data.localizedModel,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //       Platform.isAndroid ? 'Android Device Info' : 'iOS Device Info'),
      // ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        children: _deviceData.keys.map((String property) {
          return Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  property,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Text(
                  '${_deviceData[property]}',
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
