import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/ui/admindashboard/model/AnmNotUsagesModel.dart';
import 'package:pcts/ui/prasav/add_anc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/AboutAppDialoge.dart';
import '../../../constant/ApiUrl.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/LogoutAppDialoge.dart';
import '../../../constant/MyAppColor.dart';
import '../../dashboard/model/GetHelpDeskData.dart';
import '../../dashboard/model/LogoutData.dart';
import '../../samparksutra/samparksutra.dart';
import '../../splashnew.dart';
import '../../videos/tab_view.dart';
import 'dist_click_anm_uses_reports.dart';


class AnmLoginButNotEnterData extends StatefulWidget {
  AnmLoginButNotEnterData({
    Key? key,
    required this.unitype,
    required this.unitcode,
    required this.flag,
  }) : super(key: key);
  final String unitype;
  final String unitcode;
  final String flag;

  @override
  State<AnmLoginButNotEnterData> createState() => _AnmLoginButNotEnterData();
}

class _AnmLoginButNotEnterData extends State<AnmLoginButNotEnterData> {
  List help_response_listing = [];
  final _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  late SharedPreferences preferences;
  var _PostANMNotUsageDetails_url = AppConstants.app_base_url + "PostANMNotUsageDetails";
  List anm_not_usaes_list = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
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
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 0, color: Colors.transparent)
              ], color: Colors.transparent),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            onSelected: (value) {
              if (Strings.logout == value) {
                _showLogoutAppDialoge();
              } else if (Strings.sampark_sutr == value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SamparkSutraWebView(), //TabViewScreen ,VideoScreen
                    ));
              } else if (Strings.video_title == value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TabViewScreen(), //TabViewScreen ,VideoScreen
                    ));
              } else if (Strings.app_ki_jankari == value) {
                ShowAboutAppDetails();
              } else if (Strings.help_desk == value) {
                showHelpDeskBSheet(context);
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
                            Image.asset(
                              "Images/logout_img.png",
                              width: 20,
                              height: 20,
                            ),
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
                            Image.asset(
                              "Images/sampark_sutra_img.png",
                              width: 20,
                              height: 20,
                            ),
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
                            Image.asset(
                              "Images/youtube.png",
                              width: 20,
                              height: 20,
                            ),
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
                            Image.asset(
                              "Images/about.png",
                              width: 20,
                              height: 20,
                            ),
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
                            Image.asset(
                              "Images/help_desk.png",
                              width: 20,
                              height: 20,
                            ),
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
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black)),
            height: 60,
            child: Container(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 25,
                    child: const Text(Strings.Kramnk,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.redTextColor)),
                  ),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(
                      child: Container(
                        child: const Text(Strings.unit_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.redTextColor)),
                      )),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),

                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(

                            width: MediaQuery.of(context).size.width,
                            child: const Text(Strings.anm_not_login_and_entry,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.redTextColor)),

                          ),

                          const Divider(
                            thickness: 1.5,
                            color:ColorConstants.redTextColor,

                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,

                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  child: const Text(Strings.anm_name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.redTextColor)),
                                )),
                                const VerticalDivider(
                                  thickness: 1.5,
                                  color: ColorConstants.app_yellow_color,
                                ),
                                Expanded(child: Container(
                                  child: const Text(Strings.mobile_no,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.redTextColor)),
                                ))
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Expanded(child: SingleChildScrollView(
            physics:  ScrollPhysics(),
            child: _myListView(),)
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDataAnmNotUses();
  }

  Widget _myListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }

  int getLength() {
    if (anm_not_usaes_list.isNotEmpty) {
      return anm_not_usaes_list.length;
    } else {
      return 0;
    }
  }

  Future<String> getDataAnmNotUses() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    // print('login-unit-id ${preferences.getString('UnitID')}');
    //print('login-unit-code ${preferences.getString('UnitCode')}');

    print('LoginUnitcode${widget.unitcode}');
    print('LoginUnitType${widget.unitype}');
    print('TokenNo${preferences.getString('Token')}');
    print('UserID${preferences.getString('UserId')}');
    var response = await post(Uri.parse(_PostANMNotUsageDetails_url), body: {
      /*"LoginUnitcode":"01010650302",
      "FromDate": "201805",
      "TokenNo": "4c6b6e7e-0e84-4d23-a774-d0c17c9d0e8e",
      "UserID": "0101065030203"*/

      "Unitcode": widget.unitcode,
      "UnitType": widget.unitype,
      "flag": widget.flag,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = AnmNotUsagesModel.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        anm_not_usaes_list = resBody['ResposeData'];
        print('anm_not_usaes_list.len ${anm_not_usaes_list.length}');
      } else {
        anm_not_usaes_list.clear();
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

      //EasyLoading.dismiss();
    });
    EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
  }
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  Widget _itemBuilder(BuildContext context, int index) {

    return InkWell(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              height: 30,
              child: Row(
                children: [
                  Container(
                    width: 25,
                    child:  Text(anm_not_usaes_list == null ? "" : (index+1).toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.black)),
                  ),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),

                  Expanded(
                      child: Container(
                          child: GestureDetector(
                            onTap: (){

                            },
                            child: Text('${anm_not_usaes_list[index]['phcchcname'].toString().trim()+" -> "+anm_not_usaes_list[index]['unitname'].toString().trim()}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.black)),
                          )
                      )),

                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),

                  Expanded(
                      child: Row(
                        children: [
                          Expanded(child: Container(
                            //'${anm_not_usaes_list[index]['unitname'].toString().trim()}
                            child: Text('${anm_not_usaes_list[index]['anmname'].toString().trim()}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.black)),
                          )),
                          const VerticalDivider(
                            thickness: 1,
                            color: ColorConstants.app_yellow_color,
                          ),
                          Expanded(child: GestureDetector(

                            onTap: (){
                              print('phonecall:${anm_not_usaes_list[index]['Phone'].toString().trim()}');

                              _callNumber(anm_not_usaes_list[index]['Phone'].toString().trim());
                          },
                            child: Container(
                              child:  Text('${anm_not_usaes_list[index]['Phone'].toString().trim()}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.AppColorPrimary)),
                            ),
                          ))
                        ],
                      )),

                ],
              ),
            ),
            const Divider(
              color: ColorConstants.redTextColor,
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
  _callNumber(String num) async{
     //number = num; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(num);
  }
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
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

  ShowAboutAppDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AboutAppDialoge(),
    );
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

  Future<String> getHelpDesk() async {
    var response = await post(Uri.parse(_help_desk_url), body: {
      "type": "2",
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetHelpDeskData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        help_response_listing = resBody['ResposeData'];
        if (resBody['ResposeData'].length > 0) {
        }
      } else {}
    });
    return "Success";
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
                                  style: TextStyle(color: Colors.white, fontSize: 13),
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
                bottom: BorderSide(
                    width: 2.0, color: ColorConstants.dark_yellow_color),
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

  Widget _helpItemBuilder() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getHelpLength(),
            itemBuilder: _helpitemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }

  Widget _helpitemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom:
            BorderSide(width: 2.0, color: ColorConstants.dark_yellow_color),
          ),
          color: (index % 2 == 0)
              ? ColorConstants.white
              : ColorConstants.greebacku,
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
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${help_response_listing == null ? "" : help_response_listing[index]['Mobile'].toString()}',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  int getHelpLength() {
    if (help_response_listing.isNotEmpty) {
      return help_response_listing.length;
    } else {
      return 0;
    }
  }
}
