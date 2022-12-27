import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/ui/shishudeath/shihu_death_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/before/model/GetPrasavListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/GetChildInfantDetailsData.dart';


String getFormattedDate(String date) {
  if(date != "null"){
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());
    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }else{
    return "";
  }
}

class ChildInfantList extends StatefulWidget {
  const ChildInfantList({Key? key,
    required this.pctsID,
  }) : super(key: key);
  final String pctsID;


  @override
  State<ChildInfantList> createState() => _ChildInfantListState();
}

class _ChildInfantListState extends State<ChildInfantList> {

  var _find_prasav_id = AppConstants.app_base_url + "PostPCTSID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];
  late SharedPreferences preferences;
  List response_listing = [];
  ScrollController? _controller;
  var _mahilaName="";
  var _fatherName="";
  var _mobileNo="";
  /*
  * API FOR FIND PRASV DATA
  * */
  Future<String> findPrasavDataByIDAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_find_prasav_id), body: {
      "PCTSID":widget.pctsID,
      "TagName":"5",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChildInfantDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_listing = resBody['ResposeData'];
        _mahilaName=response_listing[0]['Name'].toString();
        _fatherName=response_listing[0]['Husbname'].toString();
        _mobileNo=response_listing[0]['Mobileno'].toString();
      }else {
        response_listing.clear();
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
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
    findPrasavDataByIDAPI();
    getHelpDesk();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  int getLength() {
    if(response_listing.isNotEmpty){
      return response_listing.length;
    }else{
      return 0;
    }
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
        title: Text('${Strings.sishu_vivran}', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                  boxShadow: [
                    BoxShadow(blurRadius: 0, color: Colors.transparent)
                  ],
                  color: Colors.transparent),
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
                            Image.asset(
                              "Images/logout_img.png", width: 20, height: 20,),
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
                              "Images/sampark_sutra_img.png", width: 20,
                              height: 20,),
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
                              "Images/youtube.png", width: 20, height: 20,),
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
                              "Images/about.png", width: 20, height: 20,),
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
                              "Images/help_desk.png", width: 20, height: 20,),
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
        children:<Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('${Strings.mahila_ka_naam}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),)),
                Expanded(child: Text('${_mahilaName}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('${Strings.pita_ka_naam}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),)),
                Expanded(child: Text('${_fatherName}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('${Strings.mobile_num}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),)),
                Expanded(child: Text('${_mobileNo}',style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _myListView(),
          )

        ],
      ),

    );
  }
  Widget _myListView(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true
        )
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: (){

        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: ColorConstants.lifebgColor,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShishuDeathDetails(
                    pctsID: response_listing[index]['pctsid'].toString(),
                    infantId:  response_listing[index]['InfantID'].toString(),
                    birthdate:response_listing[index]['Birth_date'].toString(),
                    DeathReportDate:response_listing[index]['DeathReportDate'].toString()
                ),));
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => DemoChartApp(),));
              },
              child: Container(
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.shishu_ki_janam_tithi,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                  getFormattedDate(response_listing[index]['Birth_date'].toString()),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.shishu_ka_naam,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  response_listing[index]['ChildName'].toString() == "null" ? "-" :  response_listing[index]['ChildName'].toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.shishu_ki_ling,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                  response_listing[index]['Sex'].toString() == "1" ? Strings.boy_title : response_listing[index]['Sex'].toString() == "2" ? Strings.girl_title : response_listing[index]['Sex'].toString() == "3" ? Strings.transgender : "",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              )),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                        children: [
                          Text(Strings.pcts_id_vivran,
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),),
                          Container(
                            width: 80,
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              children: [
                                FlutterRipple(
                                  radius: 10,
                                  child: Image.asset('Images/cursor_click.png'),
                                  rippleColor: ColorConstants.dark_yellow_color,
                                  onTap: () {
                                    print("hello");
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        height: 2,
                        color: ColorConstants.app_yellow_color,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
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
      padding: MediaQuery
          .of(context)
          .viewInsets,
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
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  'कार्यालय का समय (${help_response_listing[0]['Time']
                      .toString()})',
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


  Widget _helpItemBuilder() {
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
            bottom: BorderSide(
                width: 2.0, color: ColorConstants.dark_yellow_color),
          ),
          color: (index % 2 == 0) ? ColorConstants.white : ColorConstants
              .greebacku,
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
                  child: Text('${help_response_listing == null
                      ? ""
                      : help_response_listing[index]['Mobile'].toString()}',
                    style: TextStyle(fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }


}
