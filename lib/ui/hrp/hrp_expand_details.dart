import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/AboutAppDialoge.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/constant/LogoutAppDialoge.dart';
import 'package:pcts/ui/dashboard/model/GetHelpDeskData.dart';
import 'package:pcts/ui/dashboard/model/LogoutData.dart';
import 'package:pcts/ui/hbyc/add_hbyc.dart';
import 'package:pcts/ui/hbyc/edit_hbyc.dart';
import 'package:pcts/ui/prasav/add_pnc.dart';
import 'package:pcts/ui/prasav/after/GetPNCDetailsData.dart';
import 'package:pcts/ui/prasav/edit_pnc.dart';
import 'package:pcts/ui/samparksutra/samparksutra.dart';
import 'package:pcts/ui/videos/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../constant/ApiUrl.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/MyAppColor.dart';
import '../prasav/model/ActionRecordsData.dart';
import 'add_hrp.dart';
import 'edit_hrp.dart';




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

class HRPExpandDetails extends StatefulWidget {
  const HRPExpandDetails({Key? key, required this.ANCRegID, required this.MotherID}) : super(key: key);
  final String ANCRegID;
  final String MotherID;
  @override
  State<StatefulWidget> createState() => _HRPExpandDetails();

}

class _HRPExpandDetails extends State<HRPExpandDetails> {
  var option1=Strings.logout;
  var option2=Strings.sampark_sutr;
  var option3=Strings.video_title;
  var option4=Strings.app_ki_jankari;
  var option5=Strings.help_desk;
  late SharedPreferences preferences;
  var _anc_details_url = AppConstants.app_base_url + "uspDataforManageHighRiskCases";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";

  var _verify_record_url = AppConstants.app_base_url + "uspANMHighRiskVerify";
  var _delete_record_url = AppConstants.app_base_url + "DeleteHighRiskDetail";


  List help_response_listing = [];
  List response_listing = [];
  List<CustomManageHRPList> custom_anc_list=[];
  var second_tab_msg="";
  var ancRegID="";
  var mthrID="";
  var _anmAshaTitle="";
  var _anmName="";
  var _topHeaderName="";
  var last_pos=0;
  bool _showHideExpandableListView=false;

  bool _showHideAddFirstHRPButtonView=true;
  bool _showHideAddSecondHRPButtonView=true;
  bool _showHideAddfourthdHRPButtonView=true;
  bool _showHideAddThirdHRPButtonView=true;
  bool _showHideAddFifthHRPButtonView=true;

  bool _showHideEditButtonView=false;
  bool _showVerifyButtonView=false;
  var _selectedhbycFlag="";
  var _selectedhbycANCRegId="";
  /*
  * API FOR Get ANC Details
  * */
  Future<String> hbycDetailsAPI(String ancRegId,String mthrId) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
    print('ancRegId ${ancRegId}');
    print('mthrId ${mthrId}');
    var response = await post(Uri.parse(_anc_details_url), body: {
     //  "ANCRegID":"10145777",
      //"MotherID":"8250299",
      "MotherID":mthrId,
      "ANCRegID":ancRegId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetPNCDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_anc_list.clear();
        response_listing = resBody['ResposeData'];
       // print('anc-resp-.len ${response_listing.length}');
        _showHideExpandableListView=false;
        if(response_listing[0]['AncFlag'].toString() != "null"){
          _showHideExpandableListView=true;
          for (int i = 0; i < response_listing.length; i++){
            custom_anc_list.add(
              CustomManageHRPList(
                Name: response_listing[i]['Name'].toString(),
                HusbName:response_listing[i]['HusbName'].toString(),
                Age: response_listing[i]['Age'].toString() == "null" ? "" : response_listing[i]['Age'].toString(),
                MobileNo: response_listing[i]['MobileNo'].toString(),
                VillageName:response_listing[i]['VillageName'].toString(),
                VillageAutoID: response_listing[i]['VillageAutoID'].toString(),
                RegDate: response_listing[i]['RegDate'].toString(),
                LmpDate: response_listing[i]['LmpDate'].toString(),
                ExpectedDate:response_listing[i]['ExpectedDate'].toString(),
                ANCDate: response_listing[i]['ANCDate'].toString(),
                ContactDate:response_listing[i]['ContactDate'].toString(),
                AncFlag: response_listing[i]['AncFlag'].toString() == "null" ? "0" : response_listing[i]['AncFlag'].toString(),
                Ashaautoid: response_listing[i]['Ashaautoid'].toString(),
                AshaName: response_listing[i]['AshaName'].toString(),
                ContactUnitType: response_listing[i]['ContactUnitType'].toString(),
                ContactDistrictUnitCode: response_listing[i]['ContactDistrictUnitCode'].toString(),
                ContactUnitID:response_listing[i]['ContactUnitID'].toString(),
                DelUnitType: response_listing[i]['DelUnitType'].toString(),
                DelDistrictUnitCode: response_listing[i]['DelDistrictUnitCode'].toString(),
                DelPlaceUnitID: response_listing[i]['DelPlaceUnitID'].toString(),
                ReferUnitType: response_listing[i]['ReferUnitType'].toString(),
                ReferDistrictUnitCode: response_listing[i]['ReferDistrictUnitCode'].toString(),
                ReferUnitID: response_listing[i]['ReferUnitID'].toString(),
                ANMVerify:  response_listing[i]['ANMVerify'].toString(),
                Freeze: response_listing[i]['Freeze'].toString(),
                Media: response_listing[i]['Media'].toString(),
                ContactUnitName: response_listing[i]['ContactUnitName'].toString()
              ),
            );
            last_pos=custom_anc_list.length-1;
          }

          for (int i = 0; i < custom_anc_list.length; i++){
                if(custom_anc_list[i].AncFlag == "0"){
                    _showHideAddFirstHRPButtonView=true;
                    _showHideAddSecondHRPButtonView=true;
                    _showHideAddThirdHRPButtonView=true;
                    _showHideAddfourthdHRPButtonView=true;
                    _showHideAddFifthHRPButtonView=true;
                }
                if(custom_anc_list[i].AncFlag == "5"){
                  _showHideAddFirstHRPButtonView=false;
                }
                if(custom_anc_list[i].AncFlag == "6"){
                  _showHideAddSecondHRPButtonView=false;
                }
                if(custom_anc_list[i].AncFlag == "7"){
                  _showHideAddThirdHRPButtonView=false;
                }
                if(custom_anc_list[i].AncFlag == "8"){
                  _showHideAddfourthdHRPButtonView=false;
                }
                if(custom_anc_list[i].AncFlag == "9"){
                  _showHideAddFifthHRPButtonView=false;
                }
          }
        }else{
          _showHideAddFirstHRPButtonView=true;
          _showHideAddSecondHRPButtonView=true;
          _showHideAddThirdHRPButtonView=true;
          _showHideAddfourthdHRPButtonView=true;
          _showHideAddFifthHRPButtonView=true;
        }

        second_tab_msg=response_listing[response_listing.length -1]['AncFlag'].toString() == "null" ? "0" : response_listing[response_listing.length -1]['AncFlag'].toString();//get last position value
        print('last position flag: ${second_tab_msg}');
        /*
          * IF ALL 4 ANC FILLED THEN HIDE FOURTH BUTTON LAYOUT , NO OTHER ANC FORM WILL BE FILED
         */
        print('last_pos ${last_pos}');
        if(last_pos == 5){
         // _showHideAddANCButtonView=false;
        }else{
        //  _showHideAddANCButtonView=true;
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

  Future<String> logoutSession() async {
    preferences = await SharedPreferences.getInstance();
    print('UserID:....> ${preferences.getString("UserId")}');
    print('DeviceID:....> ${preferences.getString("deviceId")}');
    var response = await post(Uri.parse(_logout_url), body: {
      "UserID":preferences.getString("UserId"),
      "DeviceID":preferences.getString("deviceId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = LogoutData.fromJson(resBody);
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


  Future<String> verifyHBYCAPI(String _flagtype,String _ancregid) async {
    var response = await post(Uri.parse(_verify_record_url), body: {
      "ANCRegID": _ancregid,
      "type": _flagtype,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ActionRecordsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
      } else {
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    return "Success";
  }

  Future<String> deleteHBYCAPI(String _flagtype,String _ancregid,String _motherid) async {
    var response = await delete(Uri.parse(_delete_record_url), body: {
      "motherid": _motherid,
      "ANCRegid": _ancregid,
      "ANCFlag": _flagtype,
      "AppVersion": "5.5.5.22",
      "IOSAppVersion": "",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ActionRecordsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
      } else {
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
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
  var _checkLoginType=false;
  @override
  void initState() {
    super.initState();
    hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
    checkLoginTypeSession();
    getHelpDesk();
  }

  Future<String> checkLoginTypeSession() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      if(preferences.getString("LoginType") == "superadmin"){
        _checkLoginType=false;
      }else{
        _checkLoginType=true;
      }
    });
    return "Success";
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
  int getANCLength() {
    if(custom_anc_list.isNotEmpty){
      return custom_anc_list.length;
    }else{
      return 0;
    }
  }
  ScrollController? _controller;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Image.asset("Images/pcts_logo1.png",width: 100,height: 80,),
          actions: <Widget>[
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
                /*Container(
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
                ),*/
              ],
            )
          ],
          backgroundColor: ColorConstants.AppColorPrimary,// status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        body: Stack(
          children: <Widget>[
            Positioned(child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children:<Widget> [
                  Container(
                    color: ColorConstants.redTextColor,
                    height: 50,
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
                                    child: Text(_anmName == "null" ? "-" :_anmName,
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
                        Container(
                          color:  ColorConstants.brown_grey,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                child: Container(
                                  child: Text(
                                    Strings.hrp_title,
                                    style: TextStyle(
                                        color: ColorConstants.white,
                                        fontSize: 15),
                                  ),
                                ),
                              )),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 25,
                    color: ColorConstants.grey_light,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Name']+" w/o "+response_listing[0]['HusbName']}',
                          style: TextStyle(
                              color:Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),
                  const Divider(color: ColorConstants.app_yellow_color,height: 1,thickness: 2,),
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.pcts_id_title,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['pctsid'].toString()}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),*/
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.village,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['VillageName'].toString()}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.mobile_num,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['MobileNo'].toString()}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.age,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Age'].toString()}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.yugye_dampati_count,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['ECID'].toString() == "null" ? "" : response_listing[0]['ECID'].toString()}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.panjikaran_ki_tithi,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : getFormattedDate(response_listing[0]['RegDate'].toString())}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                            //  color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                Strings.akhri_mahaveer_ki_tareek,
                                style: TextStyle(
                                    fontSize: 13,
                                    color:Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          )),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${response_listing.length == 0 ? "" : getFormattedDate(response_listing[0]['ExpectedDate'].toString())}',
                          style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                      ))
                    ],
                  ),
                  _showHideExpandableListView == true ?
                  _myListView() : Container(),
                  Visibility(
                      visible: _showHideAddFirstHRPButtonView,
                      child: GestureDetector(
                        onTap: (){
                         // if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddHRPScreen(
                                      VillageAutoID:response_listing[last_pos]['VillageAutoID'].toString(),
                                      HRFlag: "5",
                                      ANCRegId: widget.ANCRegID,
                                      MotherId: widget.MotherID,
                                      ContactDate: response_listing[last_pos]['ContactDate'].toString(),
                                      ExpectedDate: response_listing[last_pos]['ExpectedDate'].toString(),
                                      ANCDate: response_listing[last_pos]['ANCDate'].toString()
                                  )
                              ),
                            ).then((value){setState(() {
                              hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                            });});
                         // }
                        },
                        child: Container(
                            height: 35,
                            color: ColorConstants.AppColorPrimary,
                            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${Strings.add_first_pravsti_hrp_vivran}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      /*Text(
                                  '${second_tab_msg == "0" ?
                                  Strings.first_hbyc_prasti_vivran : second_tab_msg == "3" ?
                                  Strings.second_hbyc_vivran : second_tab_msg == "6" ?
                                  Strings.third_hbyc_vivran : second_tab_msg == "9" ?
                                  Strings.fourth_hbyc_vivran : second_tab_msg == "12" ?
                                  Strings.fifth_hbyc_vivran : second_tab_msg == "15" ?
                                  "" : ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                )*/
                                    ),
                                  ],
                                )),
                              ],
                            )
                        ),
                      )),
                  Visibility(
                      visible: _showHideAddSecondHRPButtonView,
                      child: GestureDetector(
                        onTap: (){
                         // if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddHRPScreen(
                                      VillageAutoID:response_listing[last_pos]['VillageAutoID'].toString(),
                                      HRFlag: "6",
                                      ANCRegId: widget.ANCRegID,
                                      MotherId: widget.MotherID,
                                      ContactDate: response_listing[last_pos]['ContactDate'].toString(),
                                      ExpectedDate: response_listing[last_pos]['ExpectedDate'].toString(),
                                      ANCDate: response_listing[last_pos]['ANCDate'].toString()
                                  )
                              ),
                            ).then((value){setState(() {
                              hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                            });});
                        //  }
                        },
                        child: Container(
                            height: 35,
                            color: ColorConstants.AppColorPrimary,
                            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${Strings.add_second_pravsti_hrp_vivran}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      /*Text(
                                  '${second_tab_msg == "0" ?
                                  Strings.first_hbyc_prasti_vivran : second_tab_msg == "3" ?
                                  Strings.second_hbyc_vivran : second_tab_msg == "6" ?
                                  Strings.third_hbyc_vivran : second_tab_msg == "9" ?
                                  Strings.fourth_hbyc_vivran : second_tab_msg == "12" ?
                                  Strings.fifth_hbyc_vivran : second_tab_msg == "15" ?
                                  "" : ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                )*/
                                    ),
                                  ],
                                )),
                              ],
                            )
                        ),
                      )),
                  Visibility(
                      visible: _showHideAddThirdHRPButtonView,
                      child: GestureDetector(
                        onTap: (){
                          //if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddHRPScreen(
                                      VillageAutoID:response_listing[last_pos]['VillageAutoID'].toString(),
                                      HRFlag: "7",
                                      ANCRegId: widget.ANCRegID,
                                      MotherId: widget.MotherID,
                                      ContactDate: response_listing[last_pos]['ContactDate'].toString(),
                                      ExpectedDate: response_listing[last_pos]['ExpectedDate'].toString(),
                                      ANCDate: response_listing[last_pos]['ANCDate'].toString()

                                  )
                              ),
                            ).then((value){setState(() {
                              hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                            });});
                         // }
                        },
                        child: Container(
                            height: 35,
                            color: ColorConstants.AppColorPrimary,
                            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${Strings.add_third_pravsti_hrp_vivran}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      /*Text(
                                  '${second_tab_msg == "0" ?
                                  Strings.first_hbyc_prasti_vivran : second_tab_msg == "3" ?
                                  Strings.second_hbyc_vivran : second_tab_msg == "6" ?
                                  Strings.third_hbyc_vivran : second_tab_msg == "9" ?
                                  Strings.fourth_hbyc_vivran : second_tab_msg == "12" ?
                                  Strings.fifth_hbyc_vivran : second_tab_msg == "15" ?
                                  "" : ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                )*/
                                    ),
                                  ],
                                )),
                              ],
                            )
                        ),
                      )),
                  Visibility(
                      visible: _showHideAddfourthdHRPButtonView,
                      child: GestureDetector(
                        onTap: (){
                          //if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddHRPScreen(
                                      VillageAutoID:response_listing[last_pos]['VillageAutoID'].toString(),
                                      HRFlag: "8",
                                      ANCRegId: widget.ANCRegID,
                                      MotherId: widget.MotherID,
                                      ContactDate: response_listing[last_pos]['ContactDate'].toString(),
                                      ExpectedDate: response_listing[last_pos]['ExpectedDate'].toString(),
                                      ANCDate: response_listing[last_pos]['ANCDate'].toString()
                                  )
                              ),
                            ).then((value){setState(() {
                              hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                            });});
                         // }
                        },
                        child: Container(
                            height: 35,
                            color: ColorConstants.AppColorPrimary,
                            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${Strings.add_fourth_pravsti_hrp_vivran}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      /*Text(
                                  '${second_tab_msg == "0" ?
                                  Strings.first_hbyc_prasti_vivran : second_tab_msg == "3" ?
                                  Strings.second_hbyc_vivran : second_tab_msg == "6" ?
                                  Strings.third_hbyc_vivran : second_tab_msg == "9" ?
                                  Strings.fourth_hbyc_vivran : second_tab_msg == "12" ?
                                  Strings.fifth_hbyc_vivran : second_tab_msg == "15" ?
                                  "" : ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                )*/
                                    ),
                                  ],
                                )),
                              ],
                            )
                        ),
                      )),
                  Visibility(
                      visible: _showHideAddFifthHRPButtonView,
                      child: GestureDetector(
                        onTap: (){
                        //  if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddHRPScreen(
                                      VillageAutoID:response_listing[last_pos]['VillageAutoID'].toString(),
                                      HRFlag: "9",
                                      ANCRegId: widget.ANCRegID,
                                      MotherId: widget.MotherID,
                                      ContactDate: response_listing[last_pos]['ContactDate'].toString(),
                                      ExpectedDate: response_listing[last_pos]['ExpectedDate'].toString(),
                                      ANCDate: response_listing[last_pos]['ANCDate'].toString()
                                  )
                              ),
                            ).then((value){setState(() {
                              hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                            });});
                          //}
                        },
                        child: Container(
                            height: 35,
                            color: ColorConstants.AppColorPrimary,
                            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${Strings.add_fifth_pravsti_hrp_vivran}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      /*Text(
                                  '${second_tab_msg == "0" ?
                                  Strings.first_hbyc_prasti_vivran : second_tab_msg == "3" ?
                                  Strings.second_hbyc_vivran : second_tab_msg == "6" ?
                                  Strings.third_hbyc_vivran : second_tab_msg == "9" ?
                                  Strings.fourth_hbyc_vivran : second_tab_msg == "12" ?
                                  Strings.fifth_hbyc_vivran : second_tab_msg == "15" ?
                                  "" : ""}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                )*/
                                    ),
                                  ],
                                )),
                              ],
                            )
                        ),
                      )),
                ],
              ),
            )),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  color: ColorConstants.grey_bg_anc,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(child: Row(children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'Images/delete_record.png',
                                  width: 20,
                                  height: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text('${Strings.delete_hrp}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
                              )
                            ],)),
                            Expanded(child: Row(children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'Images/verify_record.png',
                                  width: 20,
                                  height: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text('${Strings.verify_anc}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
                              )
                            ],)),
                            Expanded(child: Row(children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'Images/writing.png',
                                  width: 20,
                                  height: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text('${Strings.edit_anc}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
                              )
                            ],))
                          ],
                        ),
                        Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        Row(

                          children: <Widget>[
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: ColorConstants.hbyc_bg_green,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text('${Strings.verify_by_anm}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
                                )
                              ],)),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: ColorConstants.AppColorPrimary,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text('${Strings.verify_pending_by_anm}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
                                )
                              ],))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
  bool expand = false;
  int? tapped;
  Widget _myListView(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getLength(),
            //itemBuilder: _itemBuilder,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                 // debugPrint('List item $index tapped $expand');
                  setState(() {
                    /// XOR operand returns when either or both conditions are true
                    /// `tapped == null` on initial app start, [tapped] is null
                    /// `index == tapped` initiate action only on tapped item
                    /// `!expand` should check previous expand action
                    expand = ((tapped == null) || ((index == tapped) || !expand)) ? !expand : expand;
                    /// This tracks which index was tapped
                    tapped = index;
                    //debugPrint('current expand state: $expand');
                  });
                },
                /// We set ExpandableListView to be a Widget
                /// for Home StatefulWidget to be able to manage
                /// ExpandableListView expand/retract actions
                child:expandableListView(
                  index,
                  index == tapped ? expand: false,
                ),
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true
        )
    );
  }

  bool _editable=false;
  Widget expandableListView(int list_index,bool isExpanded) {
    //debugPrint('List item build $list_index $isExpanded');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
            color: custom_anc_list.length != 0 ? custom_anc_list[list_index].ANMVerify.toString() == "1" ? ColorConstants.hbyc_bg_green : ColorConstants.AppColorPrimary : ColorConstants.AppColorPrimary,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child:  Row(
                  children:<Widget> [
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Container(
                          height: 30.0,
                          width: 30.0,
                          child: Center(
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          // setState(() {
                          //   expandFlag = !expandFlag;
                          // });
                        }),
                    Flexible(child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        '${custom_anc_list.length != 0 ? custom_anc_list[list_index].AncFlag.toString() == "0" ?
                        list_index == 0 && isExpanded == true ? Strings.first_hrp_vivran_close : Strings.first_hrp_vivran  : custom_anc_list[list_index].AncFlag.toString() == "5" ?
                        list_index == 0 && isExpanded == true ? Strings.first_hrp_vivran_close : Strings.first_hrp_vivran :  custom_anc_list[list_index].AncFlag.toString() == "6" ?
                        list_index == 1 && isExpanded == true ? Strings.second_hrp_vivran_close : Strings.second_hrp_vivran: custom_anc_list[list_index].AncFlag.toString() == "7" ?
                        list_index == 2 && isExpanded == true ? Strings.third_hrp_vivran_close : Strings.third_hrp_vivran: custom_anc_list[list_index].AncFlag.toString() == "8" ?
                        list_index == 3 && isExpanded == true ? Strings.fourth_hrp_vivran_close : Strings.fourth_hrp_vivran : custom_anc_list[list_index].AncFlag.toString() == "9" ?
                        list_index == 4 && isExpanded == true ? Strings.fifth_hrp_vivran_close : Strings.fifth_hrp_vivran : "" : Strings.first_hrp_vivran_close}',
                        style: TextStyle(
                            color:Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )),
                  ],
                )),
                Container(
                  width: 135,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget> [
                      Visibility(
                          visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ? true : false :false,
                          child: GestureDetector(
                            onTap: (){
                              if(custom_anc_list[list_index].AncFlag.toString() == "5"){
                                _verifyHBYCDetails("क्या आप"+" "+Strings.first_hrp+" "+"को सत्यापित करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "6"){
                                _verifyHBYCDetails("क्या आप"+" "+Strings.sec_hrp+" "+"को सत्यापित करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "7"){
                                _verifyHBYCDetails("क्या आप"+" "+Strings.third_hrp+" "+"को सत्यापित करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "8"){
                                _verifyHBYCDetails("क्या आप"+" "+Strings.fourth_hrp+" "+"को सत्यापित करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "9"){
                                _verifyHBYCDetails("क्या आप"+" "+Strings.fifth_hrp+" "+"को सत्यापित करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    ColorConstants.black);
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                width: 30,
                                height: 30,
                                color: Colors.transparent,
                                child: Center(child: Image.asset(
                                  'Images/verify_record.png',
                                  height: 30.0,
                                )),
                              ),
                            ),
                          )
                      ),
                      Visibility(
                          visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ? true : false :false,
                          child: GestureDetector(
                            onTap: (){
                              if(custom_anc_list[list_index].AncFlag.toString() == "5"){
                                _deleteHBYCDetails("क्या आप"+" "+Strings.first_hrp+" "+"को डिलीट करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    widget.MotherID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "6"){
                                _deleteHBYCDetails("क्या आप"+" "+Strings.sec_hrp+" "+"को डिलीट करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    widget.MotherID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "7"){
                                _deleteHBYCDetails("क्या आप"+" "+Strings.third_hrp+" "+"को डिलीट करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    widget.MotherID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "8"){
                                _deleteHBYCDetails("क्या आप"+" "+Strings.fourth_hrp+" "+"को डिलीट करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    widget.MotherID,
                                    ColorConstants.black);
                              }else if(custom_anc_list[list_index].AncFlag.toString() == "9"){
                                _deleteHBYCDetails("क्या आप"+" "+Strings.fifth_hrp+" "+"को डिलीट करना चाहते है |",
                                    custom_anc_list[list_index].AncFlag.toString(),
                                    widget.ANCRegID,
                                    widget.MotherID,
                                    ColorConstants.black);
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                width: 30,
                                height: 30,
                                color: Colors.transparent,
                                child: Center(child: Image.asset(
                                  'Images/delete_record.png',
                                  height: 30.0,
                                )),
                              ),
                            ),
                          )
                      ),
                      Visibility(
                          visible: _checkLoginType,
                          child: Visibility(
                            visible: preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ANMVerify.toString() == "1" ? false :preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ANMVerify.toString() == "0" && custom_anc_list[list_index].Media.toString() == "2" ? true : custom_anc_list[list_index].Freeze.toString() != "0" && preferences.getString("AppRoleID") == "33" ? false : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true :false,
                           //  visible: preferences.getString("AppRoleID").toString() == "33" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ?  custom_anc_list[list_index].ashaAutoID.toString() == "0" || custom_anc_list[list_index].ashaAutoID.toString() == preferences.getString('ANMAutoID') ? true: false : false : custom_anc_list[list_index].Freeze.toString() == "0" ? true : true ,
                            child: GestureDetector(
                            onTap: (){
                               //print('AncFlag >>>>>>>>>> ${response_listing[list_index]['AncFlag'].toString()}');
                              if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => EditHRPScreen(
                                          VillageAutoID:response_listing[list_index]['VillageAutoID'].toString(),
                                          HRFlag: response_listing[list_index]['AncFlag'].toString(),
                                          ANCRegId: widget.ANCRegID,
                                          MotherId: widget.MotherID,
                                          ContactDate: response_listing[list_index]['ContactDate'].toString(),
                                          Ashaautoid: response_listing[list_index]['Ashaautoid'].toString(),
                                          ContactUnitType: response_listing[list_index]['ContactUnitType'].toString(),
                                          ContactDistrictUnitCode: response_listing[list_index]['ContactDistrictUnitCode'].toString(),
                                          DelUnitType: response_listing[list_index]['DelUnitType'].toString(),
                                          DelDistrictUnitCode: response_listing[list_index]['DelDistrictUnitCode'].toString(),
                                          Media: response_listing[list_index]['Media'].toString(),
                                          ContactUnitCode: response_listing[list_index]['ContactUnitCode'].toString(),
                                          DelUnitCode: response_listing[list_index]['DelUnitCode'].toString(),
                                          ExpectedDate: response_listing[list_index]['ExpectedDate'].toString(),
                                          ANCDate: response_listing[last_pos]['ANCDate'].toString()
                                      )
                                  ),
                                ).then((value){setState(() {
                                  hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                                });});
                              }
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => EditHBYCForm(
                                        RegUnitID:response_listing[list_index]['RegUnitid'].toString(),
                                        VillageAutoID:response_listing[list_index]['villageautoid'].toString(),
                                        RegUnittype: response_listing[list_index]['RegUnittype'].toString(),
                                        HBYCFlag: response_listing[list_index]['HBYCFlag'].toString(),
                                        Birth_date: response_listing[list_index]['Birth_date'].toString(),
                                        motherid: response_listing[list_index]['motherid'].toString(),
                                        ancregid: response_listing[list_index]['ancregid'].toString(),
                                        infantid: response_listing[list_index]['infantid'].toString(),
                                        ashaAutoID: response_listing[list_index]['ashaAutoID'].toString(),
                                        VisitDate: response_listing[list_index]['VisitDate'].toString(),
                                        HBYCWeight: response_listing[list_index]['HBYCWeight'].toString(),
                                        Height: response_listing[list_index]['Height'].toString(),
                                        ORSPacket: response_listing[list_index]['ORSPacket'].toString(),
                                        IFASirap: response_listing[list_index]['IFASirap'].toString(),
                                        GrowthChart: response_listing[list_index]['GrowthChart'].toString(),
                                        Color: response_listing[list_index]['Color'].toString(),
                                        FoodAccordingAge: response_listing[list_index]['FoodAccordingAge'].toString(),
                                        GrowthLate: response_listing[list_index]['GrowthLate'].toString(),
                                        Refer: response_listing[list_index]['Refer'].toString(),
                                        ReferUnittype: response_listing[list_index]['ReferUnittype'].toString(),
                                        ReferUnitcode: response_listing[list_index]['ReferUnitcode'].toString(),
                                        ReferUnitID: response_listing[list_index]['ReferUnitID'].toString(),
                                        ANMVerify: response_listing[list_index]['ANMVerify'].toString() == "null" ? "" : response_listing[list_index]['ANMVerify'].toString(),
                                        Media: response_listing[list_index]['Media'].toString()
                                    )
                                ),
                              ).then((value){setState(() {
                                hbycDetailsAPI(widget.ANCRegID,widget.MotherID);
                              });});*/
                            },
                            child: Visibility(
                              //visible:  true,
                              visible: preferences.getString("AppRoleID") == "33" && preferences.getString("ANMAutoID") == custom_anc_list[list_index].Ashaautoid.toString() ? true : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true :false,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  width: 30,
                                  height: 30,
                                  color: Colors.transparent,
                                  child: Center(child: Image.asset(
                                    'Images/writing.png',
                                    height: 30.0,
                                  )),
                                ),
                              ),
                            ),
                          ),))
                    ],
                  ),
                )
              ],
            ),
          ),
          ExpandableContainer(
              expanded: isExpanded,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    child: Container(
                      margin:EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                      color: Colors.white,
                      //width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget> [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                    //  color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        Strings.sanstha_ka_naam,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].ContactUnitName}',
                                  style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                              ))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                    //  color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        Strings.sanstha_ki_tithi,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : getFormattedDate(custom_anc_list[list_index].ContactDate.toString())}',
                                  style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 1,
                shrinkWrap: true,
              ))
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


  _showLogoutAppDialoge() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          LogoutAppDialoge(context),
    );
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



  Future<void> _verifyHBYCDetails(String msg,String _flag,String ancregId,Color _color) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: ColorConstants.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: _color,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          //close popup dialoge
                          Navigator.pop(context);
                          print('flag or ancregid $_flag $ancregId');
                          verifyHBYCAPI(_flag,ancregId);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child:Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(Strings.yes,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Strings.no,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteHBYCDetails(String msg,String _flag,String ancregId,String motherid,Color _color) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: ColorConstants.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: _color,
                          fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          //close popup dialoge
                          Navigator.pop(context);
                          print('flag or ancregid or motherid $_flag $ancregId $motherid');
                          deleteHBYCAPI(_flag,ancregId,motherid);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child:Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(Strings.yes,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Strings.no,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}


class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 80,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        //decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}

class ExpandedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ExpansionTile(
          //backgroundColor: Colors.white,
          title: _buildTitle(),
          trailing: SizedBox(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Herzlich Willkommen"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Das Kursmenu"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              Strings.prathm_anc_ka_vivran,
              style: TextStyle(color:Colors.white,fontSize: 13),
            ),
            Spacer(),
            Text(
              Strings.mobile_num,
              style: TextStyle(color:Colors.white,fontSize: 13),
            ),
          ],
        ),
       // Text("Kursubersicht"),
        Row(
          children: <Widget>[
            //Text("6 Aufgaben"),
            Spacer(),
            /*FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {},
              icon: Icon(Icons.play_arrow),
              label: Text("Fortsetzen"),
            ),*/
          ],
        ),
      ],
    );
  }
}

class CustomManageHRPList {
  String? Name;
  String? HusbName;
  String? Age;
  String? MobileNo;
  String? VillageName;
  String? VillageAutoID;
  String? RegDate;
  String? LmpDate;
  String? ExpectedDate;
  String? ANCDate;
  String? ContactDate;
  String? AncFlag;
  String? Ashaautoid;
  String? AshaName;
  String? ContactUnitType;
  String? ContactDistrictUnitCode;
  String? ContactUnitID;
  String? DelUnitType;
  String? DelDistrictUnitCode;
  String? DelPlaceUnitID;
  String? ReferUnitType;
  String? ReferDistrictUnitCode;
  String? ReferUnitID;
  String? ANMVerify;
  String? Freeze;
  String? Media;
  String? ContactUnitName;
  String? ECID;

  CustomManageHRPList({
    this.Name,
    this.HusbName,
    this.Age,
    this.MobileNo,
    this.VillageName,
    this.VillageAutoID,
    this.RegDate,
    this.LmpDate,
    this.ExpectedDate,
    this.ANCDate,
    this.ContactDate,
    this.AncFlag,
    this.Ashaautoid,
    this.AshaName,
    this.ContactUnitType,
    this.ContactDistrictUnitCode,
    this.ContactUnitID,
    this.DelUnitType,
    this.DelDistrictUnitCode,
    this.DelPlaceUnitID,
    this.ReferUnitType,
    this.ReferDistrictUnitCode,
    this.ReferUnitID,
    this.ANMVerify,
    this.Freeze,
    this.Media,
    this.ContactUnitName,
    this.ECID
  });
}