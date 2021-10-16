import 'package:flutter/material.dart';
import 'package:idee_flutter/screen/complaint_factory.dart';
import 'package:idee_flutter/screen/complaint_office.dart';
import 'package:idee_flutter/widgets/categoy_card.dart';

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้องเรียน'),
      ),
      body: Container(
        height: 250,
        width: 600,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/overlay.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: _complaintmenu(context),
        ),
      ),
    );
  }
}

Widget _complaintmenu(BuildContext context) {
  return Stack(
    children: <Widget>[
      Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
                    child: CategoryCard(
                      title: "ร้องเรียนโรงงานอุตสาหกรรม",
                      jpgSrc: "assets/images/ic_reportcomplaint.png",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ComplaintFactory();
                          }),
                        );
                      },
                    ),
                  ),
                ),
                // Expanded(
                //   child: GridView.count(
                //     physics: const NeverScrollableScrollPhysics(),
                //     padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                //     crossAxisCount: 2,
                //     childAspectRatio: .99,
                //     crossAxisSpacing: 30,
                //     mainAxisSpacing: 20,
                //     children: <Widget>[
                //       CategoryCard(
                //         title: "ร้องเรียนโรงงานอุตสาหกรรม",
                //         jpgSrc: "assets/images/ic_reportcomplaint.png",
                //         press: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(builder: (context) {
                //               return ComplaintFactory();
                //             }),
                //           );
                //         },
                //       ),
                //       // CategoryCard(
                //       //   title: "ร้องเรียนเจ้าหน้าที่",
                //       //   jpgSrc: "assets/images/ic_action_profile.png",
                //       //   press: () {
                //       //     Navigator.push(
                //       //       context,
                //       //       MaterialPageRoute(builder: (context) {
                //       //         return ComplaintOffice();
                //       //       }),
                //       //     );
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
