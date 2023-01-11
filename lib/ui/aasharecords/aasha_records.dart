import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/ui/aasharecords/pending_cases_list.dart';
import 'package:pcts/ui/aasharecords/total_cases_list.dart';
import 'package:pcts/ui/aasharecords/verify_cases_list.dart';
import 'package:pcts/ui/anmworkplan/model/GetYearListData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../anmworkplan/model/AncWorkPlanModel.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/GetAashaRecordListData.dart';

class AashaRecords extends StatefulWidget {
  const AashaRecords({Key? key}) : super(key: key);

  @override
  State<AashaRecords> createState() => _AashaRecordsState();
}

class _AashaRecordsState extends State<AashaRecords> {

  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _get_asha_records_url = AppConstants.app_base_url + "uspDueListForANMVerification";

  List Ancresponse_list = [];
  Future<String> getANCAshaRecordsAPI() async {
    preferences = await SharedPreferences.getInstance();
    //print('LoginUnitid ${preferences.getString('UnitID')}');
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "1",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Ancresponse_list = resBody['ResposeData'];
        print('Ancresponse_list.len ${Ancresponse_list.length}');
        if(Ancresponse_list.length > 0){
          isANCFound=true;
        }else{
          isANCFound=false;
        }
      }
    });
    return "Success";
  }
  List Pncresponse_list = [];
  Future<String> getPncWorkPlan() async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "2",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Pncresponse_list = resBody['ResposeData'];
        print('Pncresponse_list.len ${Pncresponse_list.length}');
        if(Pncresponse_list.length > 0){
          isPNCFound=true;
        }else{
          isPNCFound=false;
        }
      }
    });
    return "Success";
  }
  List Immresponse_list = [];
  Future<String> getImmWorkPlan() async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "3",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Immresponse_list = resBody['ResposeData'];
        print('Immresponse_list.len ${Immresponse_list.length}');
        if(Immresponse_list.length > 0){
          isImmuFound=true;
        }else{
          isImmuFound=false;
        }
      }
    });
    return "Success";
  }

  List hbyc_list = [];
  Future<String> getHbycWorkPlan() async {

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "6",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        hbyc_list = resBody['ResposeData'];
        print('hbyc_list.len ${hbyc_list.length}');
        if(hbyc_list.length > 0){
          isHbycFount=true;
        }else {
          isHbycFount = false;
        }
      }
    });
    return "Success";
  }

  List motherDeath_list = [];
  Future<String> getMotherDeathWorkPlan() async {

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "4",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        motherDeath_list = resBody['ResposeData'];
        print('motherDeath_list.len ${motherDeath_list.length}');
        if(motherDeath_list.length > 0){
          isMotherDeathFound=true;
        }else {
          isMotherDeathFound = false;
        }
      }
    });
    return "Success";
  }

  List infant_list = [];
  Future<String> getInfantWorkPlan() async {

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_asha_records_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "type": "5",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaRecordListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        infant_list = resBody['ResposeData'];
        print('infant_list.len ${infant_list.length}');
        if(infant_list.length > 0){
          isInfantFound=true;
        }else {
          isInfantFound = false;
        }
      }
    });
    return "Success";
  }

  late SharedPreferences preferences;
  var _anganbadiTitle="";
  var _anmAshaTitle="";
  var _anmName="";
  var _topHeaderName="";

  var isANCFound=false;
  var isPNCFound=false;
  var isImmuFound=false;
  var isHbycFount=false;
  var isMotherDeathFound=false;
  var isInfantFound=false;

  Future<String> getHelpDesk() async {
    preferences = await SharedPreferences.getInstance();
    _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
    _anganbadiTitle=preferences.getString("AnganwariHindi").toString();
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
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
    });
    return "Success";
  }

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
                  SplashNew(),//TabViewScreen ,VideoScreen
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

  List help_response_listing = [];

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getANCAshaRecordsAPI();
    getHelpDesk();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('आशा रिकॉर्ड ',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
        actions: [
          PopupMenuButton(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SamparkSutraWebView(),//TabViewScreen ,VideoScreen
                    ));
              }else if(Strings.video_title == value){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TabViewScreen(),//TabViewScreen ,VideoScreen
                    ));
              }else if(Strings.app_ki_jankari == value){
                ShowAboutAppDetails();
              }else if(Strings.help_desk == value){
                showModalSheet(context);
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
              ];
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children:<Widget> [
            Container(
              color: ColorConstants.redTextColor,
              height: 40,
              child: Column(
                children: [
                  Expanded(child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      '$_anmAshaTitle',
                                      style: TextStyle(
                                          color: ColorConstants.app_yellow_color,
                                          fontSize: 13),
                                    ),
                                  ),
                                )),
                            Flexible(child: Container(
                              child: Text(_anmName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: ColorConstants.white,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: Text(Strings.sanstha_title,
                                      style: TextStyle(
                                          color: ColorConstants.app_yellow_color,
                                          fontSize: 13)),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(_topHeaderName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                              )
                            ],
                          )),
                    ],
                  )),
                ],
              ),
            ),
            Expanded(child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  DefaultTabController(
                    length: 6, // length of tabs
                    initialIndex: 0,
                    child: Builder(builder: (context){
                      final tabController = DefaultTabController.of(context)!;
                      tabController.addListener(() {
                        print("New tab index: ${tabController.index}");
                        if(tabController.index == 0){
                          getANCAshaRecordsAPI();
                        }else if(tabController.index == 1){
                          getPncWorkPlan();
                        }else if(tabController.index == 2){
                          getImmWorkPlan();
                        }else if(tabController.index == 3){
                          getHbycWorkPlan();
                        }else if(tabController.index == 4){
                          getMotherDeathWorkPlan();
                        }else if(tabController.index == 5){
                          getInfantWorkPlan();
                        }
                      });
                      return Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: TabBar(
                                  isScrollable: true,
                                  //labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                                  labelColor: ColorConstants.AppColorPrimary,
                                  unselectedLabelColor: Colors.black,
                                  tabs: [
                                    Container(
                                      child: new Tab(text: 'एएनसी'),
                                    ),
                                    Container(
                                      child: new Tab(text: 'एचबीएनसी'),
                                    ),
                                    Container(
                                      child: new Tab(text: 'टीकाकरण'),
                                    ),
                                    Container(
                                      child: new Tab(text: 'एचबीवाईसी'),
                                    ),
                                    Container(
                                      child: new Tab(text: 'मातृ मृत्यु'),
                                    ),
                                    Container(
                                      child: new Tab(
                                        text: 'शिशु मृत्यु',
                                      ),
                                    )
                                  ],
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 14),
                                  unselectedLabelStyle:
                                  TextStyle(fontStyle: FontStyle.normal),
                                ),
                              ),
                              Container(
                                  height: 500.0, //height of TabBarView
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                  child: TabBarView(children: <Widget>[
                                    isANCFound == false ? Container(
                                      child: Center(child: Text(Strings.anc_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _AncListView(),
                                              )
                                            ],
                                          )),
                                    ),
                                    isPNCFound == false ? Container(
                                      child: Center(child: Text(Strings.pnc_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _PncListView(),
                                              )
                                            ],
                                          )),
                                    ),
                                    isImmuFound == false ? Container(
                                      child: Center(child: Text(Strings.tikai_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _ImmListView(),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                    isHbycFount == false ? Container(
                                      child: Center(child: Text(Strings.hbyc_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container( width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(
                                                      width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)))
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _HbycListView(),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                    isMotherDeathFound == false ? Container(
                                      child: Center(child: Text(Strings.mothrdeath_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _MotherDeathListView(),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                    isInfantFound == false ? Container(
                                      child: Center(child: Text(Strings.infant_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ) :SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Container(
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    child: Container(
                                                      height: 20,
                                                      color: ColorConstants.redTextColor,
                                                      margin:
                                                      EdgeInsets.only(left: 0, top: 1),
                                                      child: const Center(
                                                        child: Text(
                                                          '${Strings.verification_on_click}',
                                                          style: TextStyle(
                                                              color: ColorConstants
                                                                  .white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      child: Text(Strings.Kramnk,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Expanded(child: Container(child: Text(Strings.asha_ka_naam,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    Container(
                                                      width: 70,
                                                      child: Text(Strings.total_case,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.verify_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                      color: ColorConstants.app_yellow_color,
                                                    ),
                                                    Container(width: 70,child: Text(Strings.reject_cases,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)
                                                  ],
                                                ),

                                              ),
                                              const Divider(
                                                color: ColorConstants.app_yellow_color,
                                                height: 2,
                                              ),
                                              Container(
                                                child: _InfantListView(),
                                              )
                                            ],
                                          )
                                      ),
                                    ),

                                  ]))
                            ]),
                      );
                    }),
                  )
                ],
              ),
            ))
          ],
        ),
      ),

    );



  }


  int getAncWorkPlanResLength() {
    if (Ancresponse_list.isNotEmpty) {
      return Ancresponse_list.length;
    } else {
      return 0;
    }
  }

  Widget _AncListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getAncWorkPlanResLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }


  Widget _itemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Ancresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Ancresponse_list == null ? "" : Ancresponse_list[index]['AshaName'].toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Ancresponse_list[index]['TotalCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TotalCasesList(ashaAutoID:Ancresponse_list[index]['ashaAutoID'].toString(),type: "1"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                          '${Ancresponse_list == null ? "": Ancresponse_list[index]['TotalCases'].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,color: Ancresponse_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Ancresponse_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:Ancresponse_list[index]['ashaAutoID'].toString(),type: "1"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Ancresponse_list == null ? "": Ancresponse_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Ancresponse_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Ancresponse_list[index]['TotalUnVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:Ancresponse_list[index]['ashaAutoID'].toString(),type: "1"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Ancresponse_list == null ? "": Ancresponse_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Ancresponse_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }
  int getPncWorkPlanResLength() {
    if (Pncresponse_list.isNotEmpty) {
      return Pncresponse_list.length;
    } else {
      return 0;
    }
  }

  ScrollController? _pnccontroller;
  Widget _PncListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _pnccontroller,
            itemCount: getPncWorkPlanResLength(),
            itemBuilder: _pncItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _pncItemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Pncresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Pncresponse_list == null ? "" : Pncresponse_list[index]['AshaName'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  GestureDetector(
                    onTap: (){
                      if(Pncresponse_list[index]['TotalCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TotalCasesList(ashaAutoID:Pncresponse_list[index]['ashaAutoID'].toString(),type: "2"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                          '${Pncresponse_list == null ? "": Pncresponse_list[index]['TotalCases'].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,color: Pncresponse_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Pncresponse_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:Pncresponse_list[index]['ashaAutoID'].toString(),type: "2"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Pncresponse_list == null ? "": Pncresponse_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Pncresponse_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Pncresponse_list[index]['TotalUnVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:Pncresponse_list[index]['ashaAutoID'].toString(),type: "2"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Pncresponse_list == null ? "": Pncresponse_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Pncresponse_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }


  int getImmWorkPlanResLength() {
    if (Immresponse_list.isNotEmpty) {
      return Immresponse_list.length;
    } else {
      return 0;
    }
  }
  ScrollController? _immucontroller;
  Widget _ImmListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _immucontroller,
            itemCount: getImmWorkPlanResLength(),
            itemBuilder: _ImmuItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _ImmuItemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Immresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Immresponse_list == null ? "" : Immresponse_list[index]['AshaName'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  GestureDetector(
                    onTap: (){
                      if(Immresponse_list[index]['TotalCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TotalCasesList(ashaAutoID:Immresponse_list[index]['ashaAutoID'].toString(),type: "3"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                          '${Immresponse_list == null ? "": Immresponse_list[index]['TotalCases'].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,color: Immresponse_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Immresponse_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:Immresponse_list[index]['ashaAutoID'].toString(),type: "3"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Immresponse_list == null ? "": Immresponse_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Immresponse_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(Immresponse_list[index]['TotalUnVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:Immresponse_list[index]['ashaAutoID'].toString(),type: "3"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${Immresponse_list == null ? "": Immresponse_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: Immresponse_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }
  ScrollController? _hbyccontroller;
  Widget _HbycListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _hbyccontroller,
            itemCount: gethbycPlanResLength(),
            itemBuilder: _hbycItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _hbycItemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(hbyc_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${hbyc_list == null ? "" : hbyc_list[index]['AshaName'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  GestureDetector(
                    onTap: (){
                      if(hbyc_list[index]['TotalCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TotalCasesList(ashaAutoID:hbyc_list[index]['ashaAutoID'].toString(),type: "6"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                          '${hbyc_list == null ? "": hbyc_list[index]['TotalCases'].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,color: hbyc_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(hbyc_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:hbyc_list[index]['ashaAutoID'].toString(),type: "6"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container( width: 70,child: Text(
                        '${hbyc_list == null ? "": hbyc_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: hbyc_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(hbyc_list[index]['TotalUnVerifiedCases'].toString() != "0" ){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:hbyc_list[index]['ashaAutoID'].toString(),type: "6"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container( width: 70,child: Text(
                        '${hbyc_list == null ? "": hbyc_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: hbyc_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }
  int gethbycPlanResLength() {
    if (hbyc_list.isNotEmpty) {
      return hbyc_list.length;
    } else {
      return 0;
    }
  }
  ScrollController? _motherdeathcontroller;
  Widget _MotherDeathListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _motherdeathcontroller,
            itemCount: motherdeathPlanResLength(),
            itemBuilder: _motherdItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _motherdItemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(motherDeath_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${motherDeath_list == null ? "" : motherDeath_list[index]['AshaName'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  GestureDetector(
                    onTap: (){
                      if(motherDeath_list[index]['TotalCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TotalCasesList(ashaAutoID:hbyc_list[index]['ashaAutoID'].toString(),type: "4"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(
                      width: 70,
                      child: Text(
                          '${motherDeath_list == null ? "": motherDeath_list[index]['TotalCases'].toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11,color: motherDeath_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(motherDeath_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:motherDeath_list[index]['ashaAutoID'].toString(),type: "4"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${motherDeath_list == null ? "": motherDeath_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: motherDeath_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(motherDeath_list[index]['TotalUnVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:motherDeath_list[index]['ashaAutoID'].toString(),type: "4"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${motherDeath_list == null ? "": motherDeath_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: motherDeath_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }
  int motherdeathPlanResLength() {
    if (motherDeath_list.isNotEmpty) {
      return motherDeath_list.length;
    } else {
      return 0;
    }
  }

  ScrollController? _infantcontroller;
  Widget _InfantListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _infantcontroller,
            itemCount: getInfantPlanResLength(),
            itemBuilder: _infantItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _infantItemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Ancresponse_list[index]['pctsid'].toString(),
              infantId:Ancresponse_list[index]['infantid'].toString()
          ),));
          print('Ancresponse_listname>> : ${Ancresponse_list[index]['name'].toString()}');*/
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(infant_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${infant_list == null ? "" : infant_list[index]['AshaName'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                 GestureDetector(
                   onTap: (){
                     if(infant_list[index]['TotalCases'].toString() != "0"){
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (BuildContext context) =>
                                 TotalCasesList(ashaAutoID:infant_list[index]['ashaAutoID'].toString(),type: "5"), //TabViewScreen ,VideoScreen
                           ));
                     }
                   },
                   child:  Container(
                     width: 70,
                     child: Text(
                         '${infant_list == null ? "": infant_list[index]['TotalCases'].toString()}',
                         textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 11,color: infant_list[index]['TotalCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                 ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(infant_list[index]['TotalVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerifyCasesList(ashaAutoID:infant_list[index]['ashaAutoID'].toString(),type: "5"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${infant_list == null ? "": infant_list[index]['TotalVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: infant_list[index]['TotalVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(infant_list[index]['TotalUnVerifiedCases'].toString() != "0"){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PendingCasesList(ashaAutoID:infant_list[index]['ashaAutoID'].toString(),type: "5"), //TabViewScreen ,VideoScreen
                            ));
                      }
                    },
                    child: Container(width: 70,child: Text(
                        '${infant_list == null ? "": infant_list[index]['TotalUnVerifiedCases'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color: infant_list[index]['TotalUnVerifiedCases'].toString() != "0" ? ColorConstants.AppColorPrimary : ColorConstants.black)),),
                  )

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
      ),

    );
  }
  int getInfantPlanResLength() {
    if (infant_list.isNotEmpty) {
      return infant_list.length;
    } else {
      return 0;
    }
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
  }

  //Show Help Desk
  void showModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return createBox(context, state);
              });
        });
  }

  createBox(BuildContext context, StateSetter state) {
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
class CustomMonthsList {
  String? mid;
  String? name;

  CustomMonthsList({
    this.mid,
    this.name,
  });
}

class CustomYearList {
  String? yid;
  String? name;

  CustomYearList({
    this.yid,
    this.name,
  });
}
