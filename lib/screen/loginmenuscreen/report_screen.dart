import 'package:flutter/material.dart';
import 'package:idee_flutter/widgets/categoy_card.dart';

class ReportsPages extends StatefulWidget {
  const ReportsPages({Key key}) : super(key: key);

  @override
  _ReportsPagesState createState() => _ReportsPagesState();
}

class _ReportsPagesState extends State<ReportsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายงาน"),
      ),
      body: Container(
        height: 420,
        width: 600,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/overlay.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: _reportSetup(context),
        ),
      ),
    );
  }
}

Widget _reportSetup(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                    crossAxisCount: 2,
                    childAspectRatio: .99,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 20,
                    children: <Widget>[
                      CategoryCard(
                        title: "รายงานเรื่องร้องเรียน",
                        jpgSrc: "assets/images/ic_reportcomplaint.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "รายงานเหตุภาวะฉุนเฉิน",
                        jpgSrc: "assets/images/ic_reportemergency.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "รายงานการรับเรื่องร้องเรียน",
                        jpgSrc: "assets/images/ic_reportgetemergency.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Dashboard Report",
                        jpgSrc: "assets/images/ic_dashboardreport.png",
                        press: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
