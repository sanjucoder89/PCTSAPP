import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/ui/admindashboard/admin_app_uses_repots/anm_uses_reports.dart';
import 'package:pcts/ui/admindashboard/rchchart_dashboard.dart';
import 'package:pcts/ui/admindashboard/show_marker_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../loginui/model/ValidateOTPData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'HomePage.dart';
import 'anm_panel.dart';
import 'chart_app.dart';
import 'model/DeathCountData.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List help_response_listing = [];
  var _death_count_data_url = AppConstants.app_base_url + "PostDeathData";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  late SharedPreferences preferences;
  var _loginUserName="";

  var today_motherDeath="";
  var sevanDays_motherDeath="";
  var thartyDays_motherDeath="";

  var today_childDeath="";
  var sevanDays_childDeath="";
  var thartyDays_childDeath="";
  var isMotherView = false;
  var isChildView = false;
  Future<String> deathCountAPI() async {
    preferences = await SharedPreferences.getInstance();
    _loginUserName=preferences.getString("UserId").toString();
    var response = await post(Uri.parse(_death_count_data_url), body: {
      "LoginUnitcode":preferences.getString("UnitCode"),
      "LoginUnitType":preferences.getString("UnitID"),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = DeathCountData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        today_motherDeath = apiResponse.resposeData![0].maternalDayCount.toString();
        sevanDays_motherDeath = apiResponse.resposeData![0].maternalWeekCount.toString();
        thartyDays_motherDeath = apiResponse.resposeData![0].maternalMonthCount.toString();

        today_childDeath = apiResponse.resposeData![0].infantDayCount.toString();
        sevanDays_childDeath = apiResponse.resposeData![0].infantWeekCount.toString();
        thartyDays_childDeath = apiResponse.resposeData![0].infantMonthCount.toString();

        if(thartyDays_motherDeath == "0"){
          isMotherView= false;
        }else{
          isMotherView= true;
        }
        if(thartyDays_childDeath == "0"){
          isChildView= false;
        }else{
          isChildView= true;
        }


      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    return "Success";
  }

  Future<String> getHelpDesk() async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_help_desk_url), body: {
      "type": "2",
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetHelpDeskData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        help_response_listing = resBody['ResposeData'];
        if(resBody['ResposeData'].length > 0){
        }

      } else {

      }
      if(preferences.getString("AppRoleID").toString() == "0"){
        _isSuperAdminSession=true;
      }else{
        _isSuperAdminSession=false;
      }
    });
    return "Success";
  }
  var _isSuperAdminSession=false;

  Future<String> logoutSession() async {

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_logout_url), body: {
      "UserID":preferences.getString("UserId"),
      "DeviceID":preferences.getString("deviceId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = LogoutData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        preferences.setString("isLogin", "false");
        print('isLogin ${preferences.getString("isLogin").toString()}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  SplashNew(),
            ));
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    return "Success";
  }

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  late Timer _timer;
  int _start = 20000;

  @override
  void initState() {
    super.initState();
    getHelpDesk();
    deathCountAPI();
    startTimer();
  }
  void startTimer() {
    print('on tap start timerrrrr....');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          print('cancel timer');
          timer.cancel();
          logoutSession();
        });
      } else {
        setState(() {
          _start--;
          print('timer runing $_start');
        });
      }
    },
    );
  }
  void stopTimer() {
    setState(() {
      print('on tap stop timerrrrr....');
      _start = 20000;
      _timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('${Strings.exit_from_app}',style: TextStyle(fontSize: 15,color: ColorConstants.AppColorPrimary),),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        willLeave = true;
                        //  Navigator.of(context).pop();
                        Navigator.pop(
                            context, true); // It worked for me instead of above line
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                    style: ElevatedButton.styleFrom(
                        primary: ColorConstants.AppColorPrimary,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    child: const Text('${Strings.yes}',style: TextStyle(color: ColorConstants.white),)),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                    child: const Text('${Strings.no}',style: TextStyle(color: ColorConstants.AppColorPrimary),),)
                ],
              ));
          return willLeave;
        },
        child: Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Visibility(
                  visible: isMotherView,
                  child:GestureDetector(
                    onTap: (){
                      showMotherDeathSheet(context);
                    },
                    child:  Container(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(300)),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('Images/anc_btn.png'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: new Image.asset(
                                    'Images/ic_cross.png',
                                    height: 12.0,
                                    alignment: Alignment.topRight,
                                    color: ColorConstants.redTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(Strings.mother_death_alert,style: TextStyle(fontSize: 8),)
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                width: 3,
              ),
              Visibility(
                  visible: isChildView,
                  child: GestureDetector(
                    onTap: (){
                      showChildDeathSheet(context);
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(300)),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('Images/anc_btn.png'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: new Image.asset(
                                    'Images/ic_cross.png',
                                    height: 12.0,
                                    alignment: Alignment.topRight,
                                    color: ColorConstants.redTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(Strings.shishu_death_alert,style: TextStyle(fontSize: 8),)
                        ],
                      ),
                    ),
                  )),

              SizedBox(
                width: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                    children: [
                      new Image.asset(
                        'Images/pcts_logo1.png',
                        height: 60.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Image.asset(
                        'Images/nationalem.png',
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: ColorConstants.AppColorPrimary,
        actions: [
          _isSuperAdminSession == true
              ? PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
                    .copyWith(topRight: Radius.circular(0))),
            padding: EdgeInsets.all(10),
            elevation: 10,
            color: Colors.grey.shade100,
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: 45,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 0, color: Colors.transparent)],
                  color: Colors.transparent),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            onSelected: (value) {
              if(Strings.logout == value){
                _showLogoutAppDialoge();
              }else if(Strings.sampark_sutr == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SamparkSutraWebView(),//TabViewScreen ,VideoScreen
                    )).then((value){setState(() {
                 // startTimer();
                });});
              }else if(Strings.video_title == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TabViewScreen(),//TabViewScreen ,VideoScreen
                    )).then((value){setState(() {
                 // startTimer();
                });});
              }else if(Strings.app_ki_jankari == value){
                stopTimer();
                ShowAboutAppDetails();
              }else if(Strings.help_desk == value){
                stopTimer();
                showHelpDeskBSheet(context);
              }else if(Strings.sanstha_ko_map == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MarketCentrePoints(), //MarketCentrePoints ,HomePage
                    )).then((value){setState(() {
                  //startTimer();
                });});
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.logout,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/logout_img.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.logout,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.sampark_sutr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/sampark_sutra_img.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.sampark_sutr,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.video_title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/youtube.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.video_title,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.app_ki_jankari,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/about.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.app_ki_jankari,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.help_desk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/help_desk.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.help_desk,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.sanstha_ko_map,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/map.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.sanstha_ko_map,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ))
              ];
            },
          )
              : PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
                    .copyWith(topRight: Radius.circular(0))),
            padding: EdgeInsets.all(10),
            elevation: 10,
            color: Colors.grey.shade100,
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: 45,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 0, color: Colors.transparent)],
                  color: Colors.transparent),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            onSelected: (value) {
              if(Strings.logout == value){
                _showLogoutAppDialoge();
              }else if(Strings.sampark_sutr == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SamparkSutraWebView(),//TabViewScreen ,VideoScreen
                    )).then((value){setState(() {
            //      startTimer();
                });});
              }else if(Strings.video_title == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TabViewScreen(),//TabViewScreen ,VideoScreen
                    )).then((value){setState(() {
              //    startTimer();
                });});
              }else if(Strings.app_ki_jankari == value){
                stopTimer();
                ShowAboutAppDetails();
              }else if(Strings.help_desk == value){
                stopTimer();
                showHelpDeskBSheet(context);
              }else if(Strings.sanstha_ko_map == value){
                stopTimer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MarketCentrePoints(), //MarketCentrePoints ,HomePage
                    )).then((value){setState(() {
                //  startTimer();
                });});
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.logout,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/logout_img.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.logout,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.sampark_sutr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/sampark_sutra_img.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.sampark_sutr,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.video_title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/youtube.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.video_title,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.app_ki_jankari,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/about.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.app_ki_jankari,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    )),
                PopupMenuItem(
                    padding: EdgeInsets.only(right: 50, left: 20),
                    value: Strings.help_desk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("Images/help_desk.png",width: 20,height: 20,),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              Strings.help_desk,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ))
              ];
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: (){
          stopTimer();
        },
        child: Container(
          // color: ColorConstants.white,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Images/report_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(child: Column(children:<Widget> [
                  Container(
                    width: 200,
                    height: 50,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:ColorConstants.white,
                    ),
                    child: Row(
                      children:<Widget> [
                        Expanded(child: Text('Welcome',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: ColorConstants.AppColorPrimary),)),
                        Text('|'),
                        Expanded(child: Text('${_loginUserName == "" ? "-" : _loginUserName}',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: ColorConstants.redTextColor),)),
                      ],
                    ),
                  ),
                  //First Option
                  GestureDetector(
                    onTap: (){
                      stopTimer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RCHChartDashboard(),
                          )).then((value){setState(() {
                   //     startTimer();
                      });});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("Images/design_course1_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(Strings.rch_dashboard,style: TextStyle(fontSize: 16,color: ColorConstants.white,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ),
                                //Center(child: Image.asset("Images/circle_arrow.jpg",width: 20,height: 20,)),
                                Center(child: Image.asset(
                                  'Images/circle_arrow.png',
                                  height: 80,
                                  width: 80,
                                )),
                              ],
                            ),
                          )),
                    ),
                  ),

                  Container(
                    width: 200,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(color: ColorConstants.redTextColor,height: 2,thickness: 2),),
                        Image.asset(
                          'Images/ic_launcher.png',
                          height: 35,
                          width: 35,
                        ),
                        Expanded(child: Divider(color: ColorConstants.redTextColor,height: 2,thickness: 2),)
                      ],
                    ),
                  ),
                  //Second Option
                  GestureDetector(
                    onTap: (){
                      stopTimer();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ANMPanelScreen(),
                          )).then((value){setState(() {
                     //   startTimer();
                      });});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("Images/design_course2_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin:EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(Strings.anm_panel,style: TextStyle(fontSize: 16,color: ColorConstants.white,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ),
                                //Center(child: Image.asset("Images/circle_arrow.jpg",width: 20,height: 20,)),
                                Center(child: Image.asset(
                                  'Images/circle_arrow.png',
                                  height: 80,
                                  width: 80,
                                )),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                      visible: _isSuperAdminSession,
                      child: Container(
                        width: 200,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Divider(color: ColorConstants.redTextColor,height: 2,thickness: 2),),
                            Image.asset(
                              'Images/ic_launcher.png',
                              height: 35,
                              width: 35,
                            ),
                            Expanded(child: Divider(color: ColorConstants.redTextColor,height: 2,thickness: 2),)
                          ],
                        ),
                      )),
                  //Third Option
                  Visibility(
                      visible: _isSuperAdminSession,
                      child: GestureDetector(
                        onTap: (){
                          stopTimer();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AnmUsesReports(),
                              )).then((value){setState(() {
                         //   startTimer();
                          });});
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("Images/design_course1_bg.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:EdgeInsets.only(top: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(Strings.anm_app_use,style: TextStyle(fontSize: 16,color: ColorConstants.white,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                    //Center(child: Image.asset("Images/circle_arrow.jpg",width: 20,height: 20,)),
                                    Center(child: Image.asset(
                                      'Images/circle_arrow.png',
                                      height: 80,
                                      width: 80,
                                    )),
                                  ],
                                ),
                              )),
                        ),
                      )),
                ],)),
                Image.asset(
                  "Images/footerpcts.jpg",
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomLeft,
                ),

              ],
            ),
          ),
        ),
      ),

    ));
  }

  void showMotherDeathSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return mothercreateBox(context, state);
              });
        });
  }

  mothercreateBox(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    color: ColorConstants.AppColorPrimary,
                    height: 40,
                    child: Container(
                      child: const Center(
                        child: Text(
                          Strings.death_reason_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    color: ColorConstants.dark_bar_color,
                    height: 30,
                    child: Container(
                      child: const Center(
                        child: Text(
                          Strings.mother_death_reason_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(Strings.today_death_count)),
                        Container(width:100,child: Text(today_motherDeath))
                      ],

                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(Strings.last_7_death_count)),
                        Container(width:100,child: Text(sevanDays_motherDeath))
                      ],

                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(Strings.last_30_death_count,style: TextStyle(color: Colors.black),)),
                        Container(width:100,child: Text(thartyDays_motherDeath))
                      ],

                    ),
                  ),
                )

              ])
        ],
      ),
    );
  }

  void showChildDeathSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return childcreateBox(context, state);
              });
        });
  }

  childcreateBox(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    color: ColorConstants.AppColorPrimary,
                    height: 40,
                    child: Container(
                      child: const Center(
                        child: Text(
                          Strings.death_reason_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    color: ColorConstants.dark_bar_color,
                    height: 30,
                    child: Container(
                      child: const Center(
                        child: Text(
                          Strings.child_death_reason_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: const Text(Strings.today_child_death_count)),
                        Container(width:100,child: Text(today_childDeath))
                      ],

                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(Strings.last_7_child_death_count)),
                        Container(width:100,child: Text(sevanDays_childDeath))
                      ],

                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(Strings.last_30_child_death_count)),
                        Container(width:100,child: Text(thartyDays_childDeath))
                      ],

                    ),
                  ),
                )

              ])
        ],
      ),
    );
  }

  ShowAboutAppDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AboutAppDialoge(),
    );
  }

  _showLogoutAppDialoge() async {

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('${Strings.exit_from_app}',style: TextStyle(fontSize: 15,color: ColorConstants.AppColorPrimary),),
          actions: [
            ElevatedButton(
                onPressed: () {
                  logoutSession();
                },
                style: ElevatedButton.styleFrom(
                    primary: ColorConstants.AppColorPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                child: const Text('${Strings.yes}',style: TextStyle(color: ColorConstants.white),)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('${Strings.no}',style: TextStyle(color: ColorConstants.AppColorPrimary),),)
          ],
        ));

    /*showDialog(
      context: context,
      builder: (BuildContext context) =>
          LogoutAppDialoge(context),
    );*/
  }

  //Show Help Desk
  void showHelpDeskBSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return createHelpDeskBox(context, state);
              });
        });
  }

  createHelpDeskBox(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: ColorConstants.AppColorPrimary,
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                        width: 50,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          width: 30,
                          child: Container(
                              child: Center(
                                child: Text(
                                  'Help Desk',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              )),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: ColorConstants.dark_yellow_color),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'कार्यालय का समय (${help_response_listing[0]['Time'].toString()})',
                  style: TextStyle(
                      fontSize: 14,
                      color: ColorConstants.AppColorPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          _helpItemBuilder()
        ],
      ),
    );
  }

  ScrollController? _controller;

  Widget _helpItemBuilder(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getHelpLength(),
            itemBuilder: _helpitemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true
        )
    );
  }

  Widget _helpitemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.0, color: ColorConstants.dark_yellow_color),
          ),
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.greebacku,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                      //  color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          help_response_listing[index]['Name'].toString(),
                          style: TextStyle(
                              fontSize: 13,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${help_response_listing == null ? "" : help_response_listing[index]['Mobile'].toString()}',
                    style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }


}
