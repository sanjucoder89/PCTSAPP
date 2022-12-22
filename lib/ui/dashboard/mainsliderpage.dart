import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pcts/ui/anmworkplan/anmworkplan.dart';

import '../../constant/MyAppColor.dart';

void main() {
  runApp(MainSliderPage());
}

class MainSliderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainSliderPage();
}

class _MainSliderPage extends State<MainSliderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child:
            Container(color: ColorConstants.AppColorDark, child: _myListView()),
      ),
      body: Container(
        // color:Colors.red,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 29),
              color: ColorConstants.AppColorDark,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: new Image.asset(
                                'Images/menu.png',
                                height: 25.0,
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Container(
                    child: new Image.asset(
                      'Images/pcts_logo1.png',
                      height: 60.0,
                    ),
                  )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 3),
                      child: new Image.asset(
                        'Images/more.png',
                        width: 20,
                        height: 25.0,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              color: ColorConstants.appNewBrowne,
              height: 50,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(left: 3, top: 3),
                                  child: Text(
                                    "एएनएम :",
                                    style: TextStyle(
                                        color: ColorConstants.app_yellow_color,
                                        fontSize: 15),
                                  ),
                                ),
                              ))),
                      Expanded(
                          child: Container(
                        child: Text("gfuhgdhfgxdgsfdghg",
                            style: TextStyle(
                              color: ColorConstants.app_yellow_color,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 3, right: 3),
                          child: Text("संस्था :",
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 15)),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        child: Text("gfuhgdhfg",
                            style: TextStyle(
                              color: ColorConstants.app_yellow_color,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )),
                    ],
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: 3, top: 3),
                          child: Text(
                            "आँगनवाड़ी :",
                            style: TextStyle(
                                color: ColorConstants.app_yellow_color,
                                fontSize: 15),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorConstants.appNewlightyello,
              ),
              margin: EdgeInsets.only(left: 10, right: 10, top: 5),
              // color: ColorConstants.appNewlightyello,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: Text(
                                " जिले में रैंक",
                                style: TextStyle(
                                    color: ColorConstants.AppColorDark),
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Container(
                    child: Text(
                      "jaipur",
                      style: TextStyle(color: ColorConstants.AppColorDark),
                    ),
                  )),
                  Center(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 3),
                      child: Text(
                        "|",
                        style: TextStyle(color: ColorConstants.AppColorDark),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    child: Text(
                      " ब्लॉक में रैंक",
                      style: TextStyle(color: ColorConstants.AppColorDark),
                    ),
                  )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 3),
                      child: Text(
                        "blockname",
                        style: TextStyle(color: ColorConstants.AppColorDark),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              height: 500,
              child: new ListView(
                children: <Widget>[
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                print("object");
                                Fluttertoast.showToast(
                                    msg: "check toast",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.black);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AnmWorkPlan(),
                                    ));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                color: ColorConstants.AppColorDark,
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorConstants.buttongraddark,
                                          ColorConstants.buttongradlight
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.bottomRight,
                                      )),
                                  margin: EdgeInsets.only(
                                      left: 1, right: 1, top: 1, bottom: 1),
                                  height: 100.0,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "Images/anm_wo_plan.png",
                                          fit: BoxFit.fitHeight,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Text(
                                          'मासिक कार्य योजना',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/mother_des.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'महिला का विवरण',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/anc_btn.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'प्रसव पूर्व जाँच',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/pnc_btn.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'प्रसव पश्चात जाँच',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/imm_btn_1.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'शिशु टीकाकरण',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/anc_btn.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'मातृ मृत्यु',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/baby_death.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'मासिक कार्य योजना',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/search_1.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'पीसीटीएस आईडी ढूँढे',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/youtube.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'वीडियो',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/phonebook.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'सम्पर्क सूत्र',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/growthchartnew.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    'बच्चे का ग्रोथ चार्ट',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          color: ColorConstants.AppColorDark,
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.buttongraddark,
                                    ColorConstants.buttongradlight
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.bottomRight,
                                )),
                            margin: EdgeInsets.only(
                                left: 1, right: 1, top: 1, bottom: 1),
                            height: 100.0,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "Images/certificate.png",
                                    fit: BoxFit.fitHeight,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                      child: Text(
                                    'Record Verification',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  /* Container(
                    height: 75.0,
                    child: Row(
                      children: [
                        Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              ),
                              color: ColorConstants.AppColorDark,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorConstants.buttongraddark,
                                        ColorConstants.buttongradlight
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                margin: EdgeInsets.only(
                                    left: 1, right: 1, top: 1, bottom: 1),
                                height: 100.0,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "Images/anm_wo_plan.png",
                                        fit: BoxFit.fitHeight,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                            'मासिक कार्य योजना',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              ),
                              color: ColorConstants.AppColorDark,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorConstants.buttongraddark,
                                        ColorConstants.buttongradlight
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.bottomRight,
                                    )),
                                margin: EdgeInsets.only(
                                    left: 1, right: 1, top: 1, bottom: 1),
                                height: 100.0,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "Images/anm_wo_plan.png",
                                        fit: BoxFit.fitHeight,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                            'मासिक कार्य योजना',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),

            /*Positioned.fill(
              child: Container(
                child: Column(
                  children: [
                    */ /*Container(
                      color: Colors.grey,
                      height: 50,
                      child: Row(
                        children: [

                        ],
                      ),
                    ),*/ /*
                    Image.asset(
                      "Images/footerpcts.jpg",
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomLeft,
                    ),
                  ],
                ),
              ),
            ),*/
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                  width: double.infinity,
                  height: 106,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(40),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0)),
                              ),
                              color: ColorConstants.AppColorDark,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                margin: EdgeInsets.only(
                                    left: 0, right: 2, top: 0, bottom: 0),
                                height: 40.0,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "Images/anm_wo_plan.png",
                                        fit: BoxFit.fitHeight,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        'जन्म प्रमाण पत्र',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                            Expanded(
                                child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0)),
                              ),
                              color: ColorConstants.AppColorDark,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                margin: EdgeInsets.only(
                                    left: 2, right: 0, top: 0, bottom: 0),
                                height: 40.0,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "Images/anm_wo_plan.png",
                                        fit: BoxFit.fitHeight,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: Text(
                                        'मासिक कार्य योजना',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        child: const Image(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('Images/footerpcts.jpg'),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _myListView() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /*SizedBox(
              height: 29,
            ),*/
          Container(
            height: 100,
            color: ColorConstants.AppColorDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "data",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "hgfgfgg",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    /*Text(
                          "hgfgfgg",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),*/
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 1000,
            child: Column(
              children: [
                ListTile(
                  title: Text("होम पेज"),
                  onTap: () {},
                  leading: Image.asset(
                    'Images/homebtnimg.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("एएनसी के डयू केसेज"),
                  onTap: () {},
                  leading: Image.asset(
                    'Images/anc_btn_img.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("पीएनसी के डयू केसेज"),
                  onTap: () {},
                  leading: Image.asset(
                    'Images/pnc_btn.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("टीकाकरण के डयू केसेज"),
                  onTap: () {},
                  leading: Image.asset(
                    'Images/imm_btn_side.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("पीसीटीएस आईडी ढूँढे"),
                  onTap: () {},
                  leading: Image.asset(
                    'Images/search_1.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("संस्था को मैप पर चिन्हित करें"),
                  onTap: () {

                  },
                  leading: Image.asset(
                    'Images/location_icon.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}
