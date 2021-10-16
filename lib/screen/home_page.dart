import 'package:flutter/material.dart';
import 'package:idee_flutter/maps/mapgoogle.dart';
import 'package:idee_flutter/screen/emergency_page.dart';
import 'package:idee_flutter/screen/follow_page.dart';
import 'package:idee_flutter/widgets/categoy_card.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 400,
        width: 600,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/overlay.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: _menuSetup(context),
        ),
      ),
    );
  }
}

Widget _menuSetup(BuildContext context) {
  return new Container(
    child: new Form(
      child: _menuUI(context),
    ),
  );
}

Widget _menuUI(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "I-Dee V.1 ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  "Mobile Application",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Expanded(
                    child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 50),
                  crossAxisCount: 2,
                  childAspectRatio: .99,
                  crossAxisSpacing: 30,
                  children: <Widget>[
                    CategoryCard(
                      title: "แจ้งเรื่องร้องเรียน",
                      jpgSrc: "assets/images/ic_action_infor.png",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return EmergencyPage();
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
                            return FollowPage();
                          }),
                        );
                      },
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
