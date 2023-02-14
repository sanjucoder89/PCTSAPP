import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/AboutAppDialoge.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/constant/LogoutAppDialoge.dart';
import 'package:pcts/ui/prasav/edit_pnc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../constant/ApiUrl.dart';
import '../../../constant/IosVersion.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/MyAppColor.dart';
import '../../dashboard/model/GetHelpDeskData.dart';
import '../../dashboard/model/LogoutData.dart';
import '../../samparksutra/samparksutra.dart';
import '../../splashnew.dart';
import '../../videos/tab_view.dart';
import '../add_anc.dart';
import '../add_pnc.dart';
import '../edit_anc.dart';
import '../model/ActionRecordsData.dart';
import 'GetPNCDetailsData.dart';



String getFormattedDate(String date) {
  if(date != "null"){
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());
    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }else{
    return "";
  }
}
String getFormattedDate3(String date) {
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

class AfterPrasavExpandDetails extends StatefulWidget {
  const AfterPrasavExpandDetails({Key? key, required this.ancregid}) : super(key: key);
  final String ancregid;
  @override
  State<StatefulWidget> createState() => _AfterPrasavExpandDetails();

}

class _AfterPrasavExpandDetails extends State<AfterPrasavExpandDetails> {
  var option1=Strings.logout;
  var option2=Strings.sampark_sutr;
  var option3=Strings.video_title;
  var option4=Strings.app_ki_jankari;
  var option5=Strings.help_desk;
  late SharedPreferences preferences;
  var _anc_details_url = AppConstants.app_base_url + "uspDataforManagePNC";

  var _verify_record_url = AppConstants.app_base_url + "uspANMPNCVerify";
  var _delete_record_url = AppConstants.app_base_url + "DeletePNCDetail";

  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];
  List response_listing = [];
  List<CustomManageANCList> custom_anc_list=[];
  var second_tab_msg="";
  var ancRegID="";
  var mthrID="";

  var _anganbadiTitle="";
  var _anmAshaTitle="";
  var _anmName="";
  var _topHeaderName="";
  var last_pos=0;
  bool _showHideExpandableListView=false; //for enable disable covid date
  bool _showHideAddANCButtonView=false;
  bool _showHideEditButtonView=false;
  /*
  * API FOR Get ANC Details
  * */
  var _checkPlatform="0";
  Future<String> pcnDetailsAPI(String ancRegId) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    _checkPlatform=preferences.getString("CheckPlatform").toString();
    print('ancRegId ${ancRegId}');
    _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
    _anganbadiTitle=preferences.getString("AnganwariHindi").toString();
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
    var response = await post(Uri.parse(_anc_details_url), body: {
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
        print('anc-resp-.len ${response_listing.length}');
        _showHideExpandableListView=false;
        if(response_listing[0]['PNCFlag'].toString() != "null"){
          _showHideExpandableListView=true;
          for (int i = 0; i < response_listing.length; i++){
            custom_anc_list.add(
              CustomManageANCList(
                  ancregid:response_listing[i]['ancregid'].toString(),
                  pctsid:response_listing[i]['pctsid'].toString(),
                  Mobileno:response_listing[i]['Mobileno'].toString() == "null" ? "" :response_listing[i]['Mobileno'].toString(),
                  Name:response_listing[i]['Name'].toString() == "null" ? "" :response_listing[i]['Name'].toString(),
                  Husbname:response_listing[i]['Husbname'].toString()  == "null" ? "" :response_listing[i]['Husbname'].toString(),
                  Address:response_listing[i]['Address'].toString(),
                  Age:response_listing[i]['Age'].toString() == "null" ? "" :response_listing[i]['Age'].toString(),
                  RegDate:response_listing[i]['RegDate'].toString(),
                  PNCDate:response_listing[i]['PNCDate'].toString(),
                  PNCFlag:response_listing[i]['PNCFlag'].toString(),
                  weight:response_listing[i]['weight'].toString(),
                  PNCComp: response_listing[i]['PNCComp'].toString(),
                  anmname: response_listing[i]['anmname'].toString() == "null" ? "" :response_listing[i]['anmname'].toString(),
                  AshaName:response_listing[i]['AshaName'].toString() == "null" ? "" :response_listing[i]['AshaName'].toString(),
                  expand_flag:"false",
                  RegUnitID:response_listing[i]['RegUnitID'].toString(),
                  RegUnittype:response_listing[i]['RegUnittype'].toString(),
                  DischargeDT:response_listing[i]['DischargeDT'].toString(),
                  DelplaceCode:response_listing[i]['DelplaceCode'].toString(),
                  DeliveryAbortionDate:response_listing[i]['DeliveryAbortionDate'].toString(),
                  ANMVerify:response_listing[i]['ANMVerify'].toString(),
                  Freeze:response_listing[i]['ANMVerify'].toString(),
                  Ashaautoid:response_listing[i]['Ashaautoid'].toString(),
                  Media:response_listing[i]['Media'].toString()
              ),
            );
            last_pos=custom_anc_list.length-1;
            print('last_pos=> ${last_pos}');
            print('Freeze=> ${response_listing[i]['Freeze'].toString()}');


            //Show Hide Edit Button Functionality
            if(response_listing[i]['Freeze'].toString() == "0" && last_pos == i){
              setState(() {
                _showHideEditButtonView=true;
              });
            }else{
              setState(() {
                _showHideEditButtonView=false;
              });
            }

            /*if(preferences.getString("AppRoleID") == "33"){
                if(int.parse(response_listing[i]['Ashaautoid']) == 0 || response_listing[i]['Ashaautoid'].toString() == preferences.getString("ANMAutoID")){
                  setState(() {
                    _showHideEditButtonView=true;
                  });
                }
            }else{
              setState(() {
                _showHideEditButtonView=false;
              });
            }*/
          }
        }
        second_tab_msg=response_listing[response_listing.length -1]['PNCFlag'].toString() == "null" ? "0" : response_listing[response_listing.length -1]['PNCFlag'].toString();//get last position value
        print('last position flag: ${second_tab_msg}');


        // PNCFlag: second_tab_msg == "0" ?
        //                                         "1" : second_tab_msg == "1" ?
        //                                         "1" : second_tab_msg == "2" ?
        //                                         "3" : second_tab_msg == "3" ?
        //                                         "4":second_tab_msg == "4" ?
        //                                         "5":second_tab_msg == "5" ?
        //                                         "6":second_tab_msg == "6" ?
        //                                         "7":second_tab_msg == "7" ?


        //if(second_tab_msg == "7"){
        if(response_listing.length  == 6){
        //  _checkLoginType=false;
          _showHideAddANCButtonView=false;
        }else{
         // _checkLoginType=true;
          _showHideAddANCButtonView=true;
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

  Future<String> verifyPNCAPI(String _flagtype,String _ancregid) async {
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
        pcnDetailsAPI(widget.ancregid);
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

  Future<String> deletePNCAPI(String _flagtype,String _ancregid) async {
    var response = await delete(Uri.parse(_delete_record_url), body: {
      "Ancregid": _ancregid,
      "PNCFlag": _flagtype,
      "AppVersion": _checkPlatform == "0" ? preferences.getString("Appversion") : "",
      "IOSAppVersion": _checkPlatform == "1" ? IosVersion.ios_version : "",
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
        pcnDetailsAPI(widget.ancregid);
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
    pcnDetailsAPI(widget.ancregid);
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
          backgroundColor: ColorConstants.AppColorPrimary,// status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        body: Stack(
          children:<Widget> [
            Positioned(child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(bottom: 100),
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
                                      Strings.pnc_ka_vivran,
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
                        child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Name']+" w/o "+response_listing[0]['Husbname']}',
                            style: TextStyle(
                                color:Colors.black,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                    const Divider(color: ColorConstants.app_yellow_color,height: 1,thickness: 2,),
                    Row(
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
                          child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Address'].toString()}',
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
                          child: Text('${response_listing.length == 0 ? "" : response_listing[0]['ECID'].toString()}',
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
                          child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Mobileno'].toString()}',
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
                                  Strings.prasavKiDate,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color:Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('${response_listing.length == 0 ? "" : getFormattedDate3(response_listing[0]['DeliveryAbortionDate'].toString())}',
                            style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                        ))
                      ],
                    ),

                    _showHideExpandableListView == true ?
                    _myListView() : Container(),
                    Visibility(
                        visible: _showHideAddANCButtonView,
                        child: GestureDetector(
                          onTap: (){
                            //if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => AddPNCScreen(
                                        pctsID:response_listing[last_pos]['pctsid'].toString(),
                                        headerName: second_tab_msg == "0" ?
                                        Strings.pncfirst_pncdate_new : second_tab_msg == "1" ?
                                        Strings.pncfirst_pncdate_new : second_tab_msg == "2" ?
                                        Strings.pncsecond_pncdate_new : second_tab_msg == "3" ?
                                        Strings.pncthrod_pncdate_new : second_tab_msg == "4" ?
                                        Strings.pncfour_pncdate_new : second_tab_msg == "5" ?
                                        Strings.pncfive_pncdate_new : second_tab_msg == "6" ?
                                        Strings.pncsix_pncdate_new : second_tab_msg == "7" ?
                                        Strings.pncseven_pncdate_new : "",
                                        registered_date: getFormattedDate(response_listing[last_pos]['RegDate'].toString()),
                                        expected_date: response_listing[last_pos]['LMPDT'].toString(),
                                        pnc_date: response_listing[last_pos]['ANCDate'].toString() == "null" ? "" : response_listing[last_pos]['ANCDate'].toString(),
                                        weight: response_listing[last_pos]['weight'].toString(),
                                        PNCFlag: second_tab_msg == "0" ?
                                        "1" : second_tab_msg == "1" ?
                                        "1" : second_tab_msg == "2" ?
                                        "3" : second_tab_msg == "3" ?
                                        "4":second_tab_msg == "4" ?
                                        "5":second_tab_msg == "5" ?
                                        "6":second_tab_msg == "6" ?
                                        "7":second_tab_msg == "7" ?
                                        "" : second_tab_msg,
                                        TTB: response_listing[last_pos]['TTB'].toString() == "null" ? "" :response_listing[last_pos]['TTB'].toString(),
                                        TT1: response_listing[last_pos]['TT1'].toString() == "null" ? "" :response_listing[last_pos]['TT1'].toString(),
                                        TT2: response_listing[last_pos]['TT2'].toString() == "null" ? "" :response_listing[last_pos]['TT2'].toString(),
                                        UrineA: response_listing[last_pos]['UrineA'].toString(),
                                        UrineS: response_listing[last_pos]['UrineS'].toString(),
                                        motherIdIntent: response_listing[last_pos]['MotherID'].toString(),
                                        VillageAutoID: response_listing[last_pos]['VillageAutoID'].toString(),
                                        DeliveryComplication: response_listing[last_pos]['DeliveryComplication'].toString(),
                                        RegUnitID:response_listing[last_pos]['RegUnitID'].toString(),
                                        Height:response_listing[last_pos]['Height'].toString(),
                                        AncRegId:widget.ancregid,
                                        RegUnittype:response_listing[last_pos]['RegUnittype'].toString(),
                                        Age: response_listing[last_pos]['Age'].toString(),
                                        DischargeDT: response_listing[last_pos]['DischargeDT'].toString(),
                                        DelplaceCode: response_listing[last_pos]['DelplaceCode'].toString(),
                                        DeliveryAbortionDate: response_listing[last_pos]['DeliveryAbortionDate'].toString()
                                    )
                                ),
                              ).then((value){setState(() {
                                pcnDetailsAPI(widget.ancregid);
                              });});
                           // }
                          },
                          child: Container(
                              height: 35,
                              color: ColorConstants.AppColorPrimary,
                              margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                              child: Row(
                                children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${Strings.hbnc_pncdate_new}',
                                      /*Text(
                                '${second_tab_msg == "0" ?
                                Strings.pncfirst_pncdate_new : second_tab_msg == "1" ?
                                Strings.pncsecond_pncdate_new : second_tab_msg == "2" ?
                                Strings.pncthrod_pncdate_new : second_tab_msg == "3" ?
                                Strings.pncfour_pncdate_new : second_tab_msg == "4" ?
                                Strings.pncfive_pncdate_new : second_tab_msg == "5" ?
                                Strings.pncsix_pncdate_new : second_tab_msg == "6" ?
                                Strings.pncseven_pncdate_new : second_tab_msg == "7" ?
                                "" : ""}',*/
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  )),
                                ],
                              )
                          ),
                        )),
                  ],
                ),
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
                                child: Text('${Strings.delete_anc}',style: TextStyle(fontSize: 13,color: ColorConstants.black),),
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


  Future<void> _verifyPNCDetails(String msg,String _flag,String ancregId,Color _color) async {
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
                          print('flag or pncregid $_flag $ancregId');
                          verifyPNCAPI(_flag,ancregId);
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

  Future<void> _deletePNCDetails(String msg,String _flag,String ancregId,Color _color) async {
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
                          print('flag or pncregid $_flag $ancregId');
                          deletePNCAPI(_flag,ancregId);
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
                  debugPrint('List item $index tapped $expand');
                  setState(() {
                    /// XOR operand returns when either or both conditions are true
                    /// `tapped == null` on initial app start, [tapped] is null
                    /// `index == tapped` initiate action only on tapped item
                    /// `!expand` should check previous expand action
                    expand = ((tapped == null) || ((index == tapped) || !expand)) ? !expand : expand;
                    /// This tracks which index was tapped
                    tapped = index;
                    debugPrint('current expand state: $expand');
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

  bool isExpandedable=false;
  Widget expandableListView(int list_index,bool isExpanded) {
    //debugPrint('List item build $list_index $isExpanded');
    return Container(
     // margin: EdgeInsets.symmetric(vertical: 1.0),
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
           // margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
            color: custom_anc_list[list_index].ANMVerify.toString() == "null" ? ColorConstants.AppColorPrimary : custom_anc_list[list_index].ANMVerify.toString() == "0" ?  ColorConstants.AppColorPrimary : ColorConstants.hbyc_bg_green,
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child:  Row(
                  children:<Widget> [
                    isExpanded ?
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "Images/up_arrow.png", width: 15, height: 25,color: Colors.white,),
                    )
                        :
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "Images/down_arrow.png", width: 15, height: 25,color: Colors.white),
                    ),
                    Text(
                      '${custom_anc_list[list_index].PNCFlag.toString() == "null" ?
                      Strings.pncfirst_pncdate_new : custom_anc_list[list_index].PNCFlag.toString() == "2" ?
                      Strings.pncsecond_pncdate_new : custom_anc_list[list_index].PNCFlag.toString() == "3" ?
                      Strings.pncthrod_pncdate_new:custom_anc_list[list_index].PNCFlag.toString() == "4" ?
                      Strings.pncfour_pncdate_new: custom_anc_list[list_index].PNCFlag.toString() == "5" ?
                      Strings.pncfive_pncdate_new : custom_anc_list[list_index].PNCFlag.toString() == "6" ?
                      Strings.pncsix_pncdate_new : custom_anc_list[list_index].PNCFlag.toString() == "7" ?
                      Strings.pncseven_pncdate_new : ""}',
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                )),
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget> [
                      Row(
                        children: <Widget>[
                          Visibility(
                              visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ? custom_anc_list[list_index].Freeze.toString() == "0" ? true :false : false:false,
                              child: GestureDetector(
                                onTap: (){
                                  if(custom_anc_list[list_index].PNCFlag.toString() == "1"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.first_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "2"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.second_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "3"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.third_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "4"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.fourth_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "5"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.fifth_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "6"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.sixth_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "7"){
                                    _verifyPNCDetails("क्या आप"+" "+Strings.seven_pnc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
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
                              visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ? custom_anc_list[list_index].Freeze.toString() == "0" ? true :false : false :false,
                              //visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ?  true : false : preferences.getString("AppRoleID") == "33" && ((custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID')) && custom_anc_list[list_index].Media.toString() == "2" ) ? true : false,
                              child: GestureDetector(
                                onTap: (){
                                  if(custom_anc_list[list_index].PNCFlag.toString() == "1"){
                                    _deletePNCDetails("क्या आप"+" "+"प्रथम एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "2"){
                                    _deletePNCDetails("क्या आप"+" "+"द्वितीय एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "3"){
                                    _deletePNCDetails("क्या आप"+" "+"तृतीय एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "4"){
                                    _deletePNCDetails("क्या आप"+" "+"चतुर्थ एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "5"){
                                    _deletePNCDetails("क्या आप"+" "+"पंचम एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "6"){
                                    _deletePNCDetails("क्या आप"+" "+"षष्ठम एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].PNCFlag.toString() == "7"){
                                    _deletePNCDetails("क्या आप"+" "+"सप्तम एचबीएनसी"+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].PNCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
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
                              child: Column(
                                children: [
                                  //if(custom_anc_list[list_index].Freeze.toString() == "0")
                                    Visibility(
                                      visible: preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true : custom_anc_list[list_index].Freeze.toString() == "0" ?  custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? custom_anc_list[list_index].ANMVerify.toString() == "0" && custom_anc_list[list_index].Media.toString() == "2" ? true : false :false:false,
                                      //visible:custom_anc_list[list_index].Freeze.toString() == "0" ? true :preferences.getString("AppRoleID") == "33" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ,
                                      //visible: preferences.getString("AppRoleID").toString() == "33" ? custom_anc_list[list_index].Freeze.toString() == "0" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true :false:false : custom_anc_list[list_index].Freeze.toString() == "0" ? true :false,
                                      // visible: custom_anc_list[list_index].Freeze.toString() == "0" ? preferences.getString("AppRoleID").toString() == "32" ? true : custom_anc_list[list_index].Freeze.toString() == "0" ?  custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true : false :false: false,
                                      child: GestureDetector(
                                        onTap: (){
                                          // print('on edit click last_pos>>>>>>>>>> ${last_pos}');
                                          if(last_pos > 0){
                                            //print('pnc LastDate-if  ${response_listing[last_pos - 1]['PNCDate'].toString()}');
                                          }else{
                                            //print('pnc LastDate-else  ${response_listing[last_pos]['PNCDate'].toString()}');
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => EditPNCScreen(
                                                    pctsID:response_listing[list_index]['pctsid'].toString(),
                                                    headerName: second_tab_msg == "0" ?
                                                    Strings.pncfirst_pncdate_new : second_tab_msg == "1" ?
                                                    Strings.pncfirst_pncdate_new : second_tab_msg == "2" ?
                                                    Strings.pncsecond_pncdate_new : second_tab_msg == "3" ?
                                                    Strings.pncthrod_pncdate_new : second_tab_msg == "4" ?
                                                    Strings.pncfour_pncdate_new : second_tab_msg == "5" ?
                                                    Strings.pncfive_pncdate_new : second_tab_msg == "6" ?
                                                    Strings.pncsix_pncdate_new : second_tab_msg == "7" ?
                                                    Strings.pncseven_pncdate_new : "",
                                                    registered_date: getFormattedDate(response_listing[list_index]['RegDate'].toString()),
                                                    expected_date: response_listing[list_index]['LMPDT'].toString(),
                                                    pnc_date: response_listing[list_index]['PNCDate'].toString() == "null" ? "" : response_listing[list_index]['PNCDate'].toString(),
                                                    PNCFlag:response_listing[list_index]['PNCFlag'].toString(),
                                                    motherIdIntent: response_listing[list_index]['Motherid'].toString(),
                                                    VillageAutoID: response_listing[list_index]['VillageAutoID'].toString(),
                                                    DeliveryComplication: response_listing[list_index]['DeliveryComplication'].toString(),
                                                    RegUnitID:response_listing[list_index]['RegUnitID'].toString(),
                                                    Height:response_listing[list_index]['Height'].toString(),
                                                    AncRegId:widget.ancregid,
                                                    RegUnittype:response_listing[list_index]['RegUnittype'].toString(),
                                                    Age: response_listing[list_index]['Age'].toString(),
                                                    DischargeDT: response_listing[list_index]['DischargeDT'].toString(),
                                                    DelplaceCode: response_listing[list_index]['DelplaceCode'].toString(),
                                                    DeliveryAbortionDate: response_listing[list_index]['DeliveryAbortionDate'].toString(),
                                                    Ashaautoid:response_listing[list_index]['Ashaautoid'].toString(),
                                                    ANMautoid:response_listing[list_index]['ANMautoid'].toString(),
                                                    PNCComp:response_listing[list_index]['PNCComp'].toString(),
                                                    Child1_IsLive:response_listing[list_index]['Child1_IsLive'].toString() == "null" ? "" :response_listing[list_index]['Child1_IsLive'].toString(),
                                                    Child2_IsLive:response_listing[list_index]['Child2_IsLive'].toString() == "null" ? "" :response_listing[list_index]['Child2_IsLive'].toString(),
                                                    Child3_IsLive:response_listing[list_index]['Child3_IsLive'].toString() == "null" ? "" :response_listing[list_index]['Child3_IsLive'].toString(),
                                                    Child4_IsLive:response_listing[list_index]['Child4_IsLive'].toString() == "null" ? "" :response_listing[list_index]['Child4_IsLive'].toString(),
                                                    Child5_IsLive:response_listing[list_index]['Child5_IsLive'].toString() == "null" ? "" :response_listing[list_index]['Child5_IsLive'].toString(),
                                                    Child1_Weight:response_listing[list_index]['Child1_Weight'].toString() == "null" ? "" :response_listing[list_index]['Child1_Weight'].toString(),
                                                    Child2_Weight:response_listing[list_index]['Child2_Weight'].toString() == "null" ? "" :response_listing[list_index]['Child2_Weight'].toString(),
                                                    Child3_Weight:response_listing[list_index]['Child3_Weight'].toString() == "null" ? "" :response_listing[list_index]['Child3_Weight'].toString(),
                                                    Child4_Weight:response_listing[list_index]['Child4_Weight'].toString() == "null" ? "" :response_listing[list_index]['Child4_Weight'].toString(),
                                                    Child5_Weight:response_listing[list_index]['Child5_Weight'].toString() == "null" ? "" :response_listing[list_index]['Child5_Weight'].toString(),
                                                    Child1_Comp:response_listing[list_index]['Child1_Comp'].toString() == "null" ? "" :response_listing[list_index]['Child1_Comp'].toString(),
                                                    Child2_Comp:response_listing[list_index]['Child2_Comp'].toString() == "null" ? "" :response_listing[list_index]['Child2_Comp'].toString(),
                                                    Child3_Comp:response_listing[list_index]['Child3_Comp'].toString() == "null" ? "" :response_listing[list_index]['Child3_Comp'].toString(),
                                                    Child4_Comp:response_listing[list_index]['Child4_Comp'].toString() == "null" ? "" :response_listing[list_index]['Child4_Comp'].toString(),
                                                    Child5_Comp:response_listing[list_index]['Child5_Comp'].toString() == "null" ? "" :response_listing[list_index]['Child5_Comp'].toString(),
                                                    Child1_InfantID:response_listing[list_index]['Child1_InfantID'].toString() == "null" ? "0" :response_listing[list_index]['Child1_InfantID'].toString(),
                                                    Child2_InfantID:response_listing[list_index]['Child2_InfantID'].toString() == "null" ? "0" :response_listing[list_index]['Child2_InfantID'].toString(),
                                                    Child3_InfantID:response_listing[list_index]['Child3_InfantID'].toString() == "null" ? "0" :response_listing[list_index]['Child3_InfantID'].toString(),
                                                    Child4_InfantID:response_listing[list_index]['Child4_InfantID'].toString() == "null" ? "0" :response_listing[list_index]['Child4_InfantID'].toString(),
                                                    Child5_InfantID:response_listing[list_index]['Child5_InfantID'].toString() == "null" ? "0" :response_listing[list_index]['Child5_InfantID'].toString(),
                                                    ReferDistrictCode:response_listing[list_index]['ReferDistrictCode'].toString() == "null" ? "" :response_listing[list_index]['ReferDistrictCode'].toString(),
                                                    ReferUniName:response_listing[list_index]['ReferUniName'].toString() == "null" ? "" :response_listing[list_index]['ReferUniName'].toString(),
                                                    ReferUnitType:response_listing[list_index]['ReferUnitType'].toString() == "null" ? "" :response_listing[list_index]['ReferUnitType'].toString(),
                                                    Media:response_listing[list_index]['Media'].toString()
                                                )
                                            ),
                                          ).then((value){setState(() {
                                            pcnDetailsAPI(widget.ancregid);
                                          });});
                                        },
                                        child: Visibility(
                                          visible: true,
                                         // visible: preferences.getString("AppRoleID") == "33" && preferences.getString("ANMAutoID") == custom_anc_list[list_index].Ashaautoid.toString() && custom_anc_list[list_index].Media.toString() == "2" ? true : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true :false,
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
                                      ),
                                    )
                                      /*if(custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID'))
                                        Visibility(
                                          visible: true,
                                      //visible: preferences.getString("AppRoleID").toString() == "33" ? custom_anc_list[list_index].Freeze.toString() == "0" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true :false:false : custom_anc_list[list_index].Freeze.toString() == "0" ? true :false,
                                     // visible: custom_anc_list[list_index].Freeze.toString() == "0" ? preferences.getString("AppRoleID").toString() == "32" ? true : custom_anc_list[list_index].Freeze.toString() == "0" ?  custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true : false :false: false,
                                      child: Visibility(
                                        //visible: custom_anc_list[list_index].ANMVerify.toString() != "null" ? custom_anc_list[list_index].ANMVerify.toString() == "1" ? false : true : true,
                                        //visible: preferences.getString("AppRoleID") == "33" ? custom_anc_list[list_index].Freeze.toString() == "0" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true : false :true : true,
                                        visible: true,
                                        child: GestureDetector(
                                          onTap: (){
                                            // print('on edit click last_pos>>>>>>>>>> ${last_pos}');
                                            if(last_pos > 0){
                                              //print('pnc LastDate-if  ${response_listing[last_pos - 1]['PNCDate'].toString()}');
                                            }else{
                                              //print('pnc LastDate-else  ${response_listing[last_pos]['PNCDate'].toString()}');
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => EditPNCScreen(
                                                      pctsID:response_listing[last_pos]['pctsid'].toString(),
                                                      headerName: second_tab_msg == "0" ?
                                                      Strings.pncfirst_pncdate_new : second_tab_msg == "1" ?
                                                      Strings.pncfirst_pncdate_new : second_tab_msg == "2" ?
                                                      Strings.pncsecond_pncdate_new : second_tab_msg == "3" ?
                                                      Strings.pncthrod_pncdate_new : second_tab_msg == "4" ?
                                                      Strings.pncfour_pncdate_new : second_tab_msg == "5" ?
                                                      Strings.pncfive_pncdate_new : second_tab_msg == "6" ?
                                                      Strings.pncsix_pncdate_new : second_tab_msg == "7" ?
                                                      Strings.pncseven_pncdate_new : "",
                                                      registered_date: getFormattedDate(response_listing[last_pos]['RegDate'].toString()),
                                                      expected_date: response_listing[last_pos]['LMPDT'].toString(),
                                                      pnc_date: response_listing[last_pos]['PNCDate'].toString() == "null" ? "" : response_listing[last_pos]['PNCDate'].toString(),
                                                      PNCFlag: second_tab_msg == "0" ?
                                                      "1" : second_tab_msg == "1" ?
                                                      "1" : second_tab_msg == "2" ?
                                                      "3" : second_tab_msg == "3" ?
                                                      "4":second_tab_msg == "4" ?
                                                      "5":second_tab_msg == "5" ?
                                                      "6":second_tab_msg == "6" ?
                                                      "7":second_tab_msg == "7" ?
                                                      "" : second_tab_msg,
                                                      motherIdIntent: response_listing[last_pos]['Motherid'].toString(),
                                                      VillageAutoID: response_listing[last_pos]['VillageAutoID'].toString(),
                                                      DeliveryComplication: response_listing[last_pos]['DeliveryComplication'].toString(),
                                                      RegUnitID:response_listing[last_pos]['RegUnitID'].toString(),
                                                      Height:response_listing[last_pos]['Height'].toString(),
                                                      AncRegId:widget.ancregid,
                                                      RegUnittype:response_listing[last_pos]['RegUnittype'].toString(),
                                                      Age: response_listing[last_pos]['Age'].toString(),
                                                      DischargeDT: response_listing[last_pos]['DischargeDT'].toString(),
                                                      DelplaceCode: response_listing[last_pos]['DelplaceCode'].toString(),
                                                      DeliveryAbortionDate: response_listing[last_pos]['DeliveryAbortionDate'].toString(),
                                                      Ashaautoid:response_listing[last_pos]['Ashaautoid'].toString(),
                                                      ANMautoid:response_listing[last_pos]['ANMautoid'].toString(),
                                                      PNCComp:response_listing[last_pos]['PNCComp'].toString(),
                                                      Child1_IsLive:response_listing[last_pos]['Child1_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child1_IsLive'].toString(),
                                                      Child2_IsLive:response_listing[last_pos]['Child2_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child2_IsLive'].toString(),
                                                      Child3_IsLive:response_listing[last_pos]['Child3_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child3_IsLive'].toString(),
                                                      Child4_IsLive:response_listing[last_pos]['Child4_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child4_IsLive'].toString(),
                                                      Child5_IsLive:response_listing[last_pos]['Child5_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child5_IsLive'].toString(),
                                                      Child1_Weight:response_listing[last_pos]['Child1_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child1_Weight'].toString(),
                                                      Child2_Weight:response_listing[last_pos]['Child2_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child2_Weight'].toString(),
                                                      Child3_Weight:response_listing[last_pos]['Child3_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child3_Weight'].toString(),
                                                      Child4_Weight:response_listing[last_pos]['Child4_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child4_Weight'].toString(),
                                                      Child5_Weight:response_listing[last_pos]['Child5_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child5_Weight'].toString(),
                                                      Child1_Comp:response_listing[last_pos]['Child1_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child1_Comp'].toString(),
                                                      Child2_Comp:response_listing[last_pos]['Child2_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child2_Comp'].toString(),
                                                      Child3_Comp:response_listing[last_pos]['Child3_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child3_Comp'].toString(),
                                                      Child4_Comp:response_listing[last_pos]['Child4_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child4_Comp'].toString(),
                                                      Child5_Comp:response_listing[last_pos]['Child5_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child5_Comp'].toString(),
                                                      ReferDistrictCode:response_listing[last_pos]['ReferDistrictCode'].toString() == "null" ? "" :response_listing[last_pos]['ReferDistrictCode'].toString(),
                                                      ReferUniName:response_listing[last_pos]['ReferUniName'].toString() == "null" ? "" :response_listing[last_pos]['ReferUniName'].toString(),
                                                      ReferUnitType:response_listing[last_pos]['ReferUnitType'].toString() == "null" ? "" :response_listing[last_pos]['ReferUnitType'].toString()
                                                  )
                                              ),
                                            ).then((value){setState(() {
                                              pcnDetailsAPI(widget.ancregid);
                                            });});
                                          },
                                          child: Visibility(
                                            //visible: last_pos == list_index ? true : false,
                                              visible: true,
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
                                              )
                                          ),
                                        ),
                                      ),
                                    )
                                      else
                                        Visibility(
                                          visible: true,
                                          //visible: preferences.getString("AppRoleID").toString() == "33" ? custom_anc_list[list_index].Freeze.toString() == "0" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true :false:false : custom_anc_list[list_index].Freeze.toString() == "0" ? true :false,
                                          // visible: custom_anc_list[list_index].Freeze.toString() == "0" ? preferences.getString("AppRoleID").toString() == "32" ? true : custom_anc_list[list_index].Freeze.toString() == "0" ?  custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true : false :false: false,
                                          child: Visibility(
                                            //visible: custom_anc_list[list_index].ANMVerify.toString() != "null" ? custom_anc_list[list_index].ANMVerify.toString() == "1" ? false : true : true,
                                            //visible: preferences.getString("AppRoleID") == "33" ? custom_anc_list[list_index].Freeze.toString() == "0" ? custom_anc_list[list_index].Ashaautoid.toString() == "0" || custom_anc_list[list_index].Ashaautoid.toString() == preferences.getString('ANMAutoID') ? true : false :true : true,
                                            visible: true,
                                            child: GestureDetector(
                                              onTap: (){
                                                // print('on edit click last_pos>>>>>>>>>> ${last_pos}');
                                                if(last_pos > 0){
                                                  //print('pnc LastDate-if  ${response_listing[last_pos - 1]['PNCDate'].toString()}');
                                                }else{
                                                  //print('pnc LastDate-else  ${response_listing[last_pos]['PNCDate'].toString()}');
                                                }
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => EditPNCScreen(
                                                          pctsID:response_listing[last_pos]['pctsid'].toString(),
                                                          headerName: second_tab_msg == "0" ?
                                                          Strings.pncfirst_pncdate_new : second_tab_msg == "1" ?
                                                          Strings.pncfirst_pncdate_new : second_tab_msg == "2" ?
                                                          Strings.pncsecond_pncdate_new : second_tab_msg == "3" ?
                                                          Strings.pncthrod_pncdate_new : second_tab_msg == "4" ?
                                                          Strings.pncfour_pncdate_new : second_tab_msg == "5" ?
                                                          Strings.pncfive_pncdate_new : second_tab_msg == "6" ?
                                                          Strings.pncsix_pncdate_new : second_tab_msg == "7" ?
                                                          Strings.pncseven_pncdate_new : "",
                                                          registered_date: getFormattedDate(response_listing[last_pos]['RegDate'].toString()),
                                                          expected_date: response_listing[last_pos]['LMPDT'].toString(),
                                                          pnc_date: response_listing[last_pos]['PNCDate'].toString() == "null" ? "" : response_listing[last_pos]['PNCDate'].toString(),
                                                          PNCFlag: second_tab_msg == "0" ?
                                                          "1" : second_tab_msg == "1" ?
                                                          "1" : second_tab_msg == "2" ?
                                                          "3" : second_tab_msg == "3" ?
                                                          "4":second_tab_msg == "4" ?
                                                          "5":second_tab_msg == "5" ?
                                                          "6":second_tab_msg == "6" ?
                                                          "7":second_tab_msg == "7" ?
                                                          "" : second_tab_msg,
                                                          motherIdIntent: response_listing[last_pos]['Motherid'].toString(),
                                                          VillageAutoID: response_listing[last_pos]['VillageAutoID'].toString(),
                                                          DeliveryComplication: response_listing[last_pos]['DeliveryComplication'].toString(),
                                                          RegUnitID:response_listing[last_pos]['RegUnitID'].toString(),
                                                          Height:response_listing[last_pos]['Height'].toString(),
                                                          AncRegId:widget.ancregid,
                                                          RegUnittype:response_listing[last_pos]['RegUnittype'].toString(),
                                                          Age: response_listing[last_pos]['Age'].toString(),
                                                          DischargeDT: response_listing[last_pos]['DischargeDT'].toString(),
                                                          DelplaceCode: response_listing[last_pos]['DelplaceCode'].toString(),
                                                          DeliveryAbortionDate: response_listing[last_pos]['DeliveryAbortionDate'].toString(),
                                                          Ashaautoid:response_listing[last_pos]['Ashaautoid'].toString(),
                                                          ANMautoid:response_listing[last_pos]['ANMautoid'].toString(),
                                                          PNCComp:response_listing[last_pos]['PNCComp'].toString(),
                                                          Child1_IsLive:response_listing[last_pos]['Child1_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child1_IsLive'].toString(),
                                                          Child2_IsLive:response_listing[last_pos]['Child2_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child2_IsLive'].toString(),
                                                          Child3_IsLive:response_listing[last_pos]['Child3_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child3_IsLive'].toString(),
                                                          Child4_IsLive:response_listing[last_pos]['Child4_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child4_IsLive'].toString(),
                                                          Child5_IsLive:response_listing[last_pos]['Child5_IsLive'].toString() == "null" ? "" :response_listing[last_pos]['Child5_IsLive'].toString(),
                                                          Child1_Weight:response_listing[last_pos]['Child1_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child1_Weight'].toString(),
                                                          Child2_Weight:response_listing[last_pos]['Child2_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child2_Weight'].toString(),
                                                          Child3_Weight:response_listing[last_pos]['Child3_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child3_Weight'].toString(),
                                                          Child4_Weight:response_listing[last_pos]['Child4_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child4_Weight'].toString(),
                                                          Child5_Weight:response_listing[last_pos]['Child5_Weight'].toString() == "null" ? "" :response_listing[last_pos]['Child5_Weight'].toString(),
                                                          Child1_Comp:response_listing[last_pos]['Child1_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child1_Comp'].toString(),
                                                          Child2_Comp:response_listing[last_pos]['Child2_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child2_Comp'].toString(),
                                                          Child3_Comp:response_listing[last_pos]['Child3_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child3_Comp'].toString(),
                                                          Child4_Comp:response_listing[last_pos]['Child4_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child4_Comp'].toString(),
                                                          Child5_Comp:response_listing[last_pos]['Child5_Comp'].toString() == "null" ? "" :response_listing[last_pos]['Child5_Comp'].toString(),
                                                          ReferDistrictCode:response_listing[last_pos]['ReferDistrictCode'].toString() == "null" ? "" :response_listing[last_pos]['ReferDistrictCode'].toString(),
                                                          ReferUniName:response_listing[last_pos]['ReferUniName'].toString() == "null" ? "" :response_listing[last_pos]['ReferUniName'].toString(),
                                                          ReferUnitType:response_listing[last_pos]['ReferUnitType'].toString() == "null" ? "" :response_listing[last_pos]['ReferUnitType'].toString()
                                                      )
                                                  ),
                                                ).then((value){setState(() {
                                                  pcnDetailsAPI(widget.ancregid);
                                                });});
                                              },
                                              child: Visibility(
                                                //visible: last_pos == list_index ? true : false,
                                                  visible: true,
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
                                                  )
                                              ),
                                            ),
                                          ),
                                        )*/
                                  //else
                                   // Container(child: Text('dfff')),
                                ],
                              ))
                        ],
                      )
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
                                        Strings.asha_ka_naam,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].AshaName}',
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
                                        Strings.anm_ka_naam,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].anmname}',
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
                                        Strings.PNCComp,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].PNCComp.toString() == "1" ?
                                Strings.PPH : custom_anc_list[list_index].PNCComp.toString() == "2" ?
                                Strings.prasav_sankarman : custom_anc_list[list_index].PNCComp.toString() == "3" ?
                                Strings.death : custom_anc_list[list_index].PNCComp.toString() == "4" ?
                                Strings.extra : custom_anc_list[list_index].PNCComp.toString() == "5" ?
                                Strings.koi_nahi : custom_anc_list[list_index].PNCComp.toString() == "6" ?
                                Strings.bukhar : custom_anc_list[list_index].PNCComp.toString() == "7" ?
                                Strings.sepsis : custom_anc_list[list_index].PNCComp.toString() == "8" ?
                                Strings.petmedard : custom_anc_list[list_index].PNCComp.toString() == "9" ?
                                Strings.sirdard : custom_anc_list[list_index].PNCComp.toString() == "10" ?
                                Strings.sas_lene_me_taklif : custom_anc_list[list_index].PNCComp.toString() == "11" ?
                                Strings.kampkapi : ""
                                }',
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
                                        Strings.hbnc_ki_tithi,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('${custom_anc_list.length == 0 ? "" : getFormattedDate3(custom_anc_list[list_index].PNCDate.toString())}',
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


}


class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 115.0,
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

class CustomManageANCList {
  String? ancregid;
  String? pctsid;
  String? Mobileno;
  String? Name;
  String? Husbname;
  String? Address;
  String? Age;
  String? RegDate;
  String? PNCComp;
  String? PNCDate;
  String? PNCFlag;
  String? weight;
  String? anmname;
  String? AshaName;
  String? expand_flag;
  String? RegUnitID;
  String? RegUnittype;
  String? DischargeDT;
  String? DelplaceCode;
  String? DeliveryAbortionDate;
  String? ANMVerify;
  String? Freeze;
  String? Ashaautoid;
  String? Media;

  CustomManageANCList({
    this.ancregid,
    this.pctsid,
    this.Mobileno,
    this.Name,
    this.Husbname,
    this.Address,
    this.Age,
    this.RegDate,
    this.PNCComp,
    this.PNCDate,
    this.PNCFlag,
    this.weight,
    this.anmname,
    this.AshaName,
    this.expand_flag,
    this.RegUnitID,
    this.RegUnittype,
    this.DischargeDT,
    this.DelplaceCode,
    this.DeliveryAbortionDate,
    this.ANMVerify,
    this.Freeze,
    this.Ashaautoid,
    this.Media
  });
}