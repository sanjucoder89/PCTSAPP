import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';

class AddHRPScreen extends StatefulWidget {
  const AddHRPScreen({Key? key}) : super(key: key);

  @override
  State<AddHRPScreen> createState() => _AddHRPScreenState();
}

class _AddHRPScreenState extends State<AddHRPScreen> {




  late SharedPreferences preferences;
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];
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
  Future<String> getHelpDesk() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text('',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text('',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        backgroundColor: ColorConstants.AppColorPrimary,
        actions: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 10),
                child:Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                      child: Image.asset("Images/nationalem.png")//widget.country_img
                  ),
                  alignment: Alignment.centerRight,

                ),
              ),
              Container(
                width: 50,
                child: PopupMenuButton(
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
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}
