import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idee_flutter/models/token_login.dart';
import 'package:idee_flutter/screen/launcher.dart';
import 'package:idee_flutter/screen/loginmenuscreen/about_info.dart';
import 'package:idee_flutter/screen/loginmenuscreen/complaint_facbyadmin.dart';
import 'package:idee_flutter/screen/loginmenuscreen/emergency_complait.dart';
import 'package:idee_flutter/screen/loginmenuscreen/follow_emergency.dart';
import 'package:idee_flutter/screen/loginmenuscreen/followcomplaint.dart';
import 'package:idee_flutter/screen/loginmenuscreen/report_screen.dart';
import 'package:idee_flutter/widgets/categoy_card.dart';
import 'package:idee_flutter/services/api_service.dart';

class MenuAdmin extends StatefulWidget {
  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context).settings.arguments as TokenLogin;

    print('$token.token');
    return Scaffold(
      body: SingleChildScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        child: Container(
          //padding: EdgeInsets.only(top: 20, bottom: 20),
          height: 900,
          width: 600,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/overlay.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            child: listmenu(context),
          ),
        ),
      ),
    );
  }
}

Widget listmenu(BuildContext context) {
  final tokenData = ModalRoute.of(context).settings.arguments as TokenLogin;

  print(tokenData.token);

  String accessToken = tokenData.token;

  return Stack(
    children: <Widget>[
      SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
              ),
              Text(
                "I-Dee V.2 ",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                "Mobile Application",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    children: <Widget>[
                      CategoryCard(
                        title: "แจ้งเรื่องร้องเรียน",
                        jpgSrc: "assets/images/ic_action_infor.png",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ComplaintFactoryByAdmin();
                            }),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "ติดตามเรื่องร้องเรียน",
                        jpgSrc: "assets/images/ic_action_list.png",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return FollowComplaint();
                            }),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "แจ้งเหตุภาวะฉุกเฉิน",
                        jpgSrc: "assets/images/ic_action_emergency.png",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return EmergencyCompliant();
                            }),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "ดิดตามเหตุภาวะฉุกเฉิน",
                        jpgSrc: "assets/images/ic_action_emergencylist.png",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return FollowEmergency();
                            }),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "สถิติ รายงาน",
                        jpgSrc: "assets/images/ic_action_chart.png",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ReportsPages();
                            }),
                          );
                        },
                      ),
                      CategoryCard(
                        title: "ข้อมูลผู้ใช้งาน",
                        jpgSrc: "assets/images/ic_action_profile.png",
                        press: () {
                          Getinfo.getUserDetails(accessToken)
                              .then((responseModel) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutAdmin(),
                                // Pass the arguments as part of the RouteSettings. The
                                // DetailScreen reads the arguments from these settings.
                                settings: RouteSettings(
                                  arguments: responseModel,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      CategoryCard(
                        title: "ออกจากระบบ",
                        jpgSrc: "assets/images/ic_action_logout1.png",
                        press: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (context) => Launcher()),
                            (_) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
