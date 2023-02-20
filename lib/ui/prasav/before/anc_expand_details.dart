import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/ui/videos/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../constant/AboutAppDialoge.dart';
import '../../../constant/ApiUrl.dart';
import '../../../constant/IosVersion.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/LogoutAppDialoge.dart';
import '../../../constant/MyAppColor.dart';
import '../../dashboard/model/GetHelpDeskData.dart';
import '../../dashboard/model/LogoutData.dart';
import '../../samparksutra/samparksutra.dart';
import '../../splashnew.dart';
import '../add_anc.dart';
import '../edit_anc.dart';
import '../model/ActionRecordsData.dart';
import 'model/GenerateANCMthrIDData.dart';
import 'model/GetANCDetailsData.dart';


String getConvertRegDateFormat(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  // var outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  var outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  // var outputFormat = DateFormat('yyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}
String getCustomAddDaysDate(String date) {
  if(date != "null"){
    var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(date));
    //print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
    final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
    //print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000

    var localDate = DateTime.parse(exptedDate_281.toString()).toLocal();
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

class AncExpandDetails extends StatefulWidget {
  const AncExpandDetails({Key? key, required this.ancregid}) : super(key: key);
  final String ancregid;
  @override
  State<StatefulWidget> createState() => _AncExpandDetails();

}

class _AncExpandDetails extends State<AncExpandDetails> {
  var option1=Strings.logout;
  var option2=Strings.sampark_sutr;
  var option3=Strings.video_title;
  var option4=Strings.app_ki_jankari;
  var option5=Strings.help_desk;
  late SharedPreferences preferences;
  var _anc_details_url = AppConstants.app_base_url + "uspDataforManageANC";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";

  var _verify_record_url = AppConstants.app_base_url + "uspANMANCVerify";
  var _delete_record_url = AppConstants.app_base_url + "DeleteANCDetail";
  List help_response_listing = [];
  List response_listing = [];
  List<CustomManageANCList> custom_anc_list=[];
  var second_tab_msg="";
  var ancRegID="";
  var mthrID="";
  var _anmAshaTitle="";
  var _anmName="";
  var _topHeaderName="";
  var last_pos=0;
  bool _showHideExpandableListView=false; //for enable disable covid date
  bool _showHideAddANCButtonView=false;
  bool _showEditButtonView=false;

  bool _showDeleteButtonView=false;
  /*
  * API FOR Get ANC Details
  * */
  var _checkPlatform="0";
  Future<String> acnDetailsAPI(String ancRegId) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _checkPlatform=preferences.getString("CheckPlatform").toString();
    print('ancRegId ${ancRegId}');
    print('TokenNo ${preferences.getString('Token')}');
    print('UserID ${preferences.getString('UserId')}');
    print('ANMAutoID ${preferences.getString('ANMAutoID')}');

    _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
    var response = await post(Uri.parse(_anc_details_url), body: {
      //ANCRegID:15373090
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
      //"ANCRegID":"15373090",
      "ANCRegID":ancRegId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetANCDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
          custom_anc_list.clear();
          response_listing = resBody['ResposeData'];
          print('anc-resp-.len ${response_listing.length}');
          _showHideExpandableListView=false;
          if(response_listing[0]['ANCFlag'].toString() != "0"){
            _showHideExpandableListView=true;
            for (int i = 0; i < response_listing.length; i++){
              custom_anc_list.add(
                CustomManageANCList(
                    ancregid:response_listing[i]['ancregid'].toString(),
                    pctsid:response_listing[i]['pctsid'].toString(),
                    Mobileno:response_listing[i]['Mobileno'].toString(),
                    Name:response_listing[i]['Name'].toString(),
                    Husbname:response_listing[i]['Husbname'].toString(),
                    Address:response_listing[i]['Address'].toString(),
                    Age:response_listing[i]['Age'].toString(),
                    RegDate:response_listing[i]['RegDate'].toString(),
                    LMPDT:response_listing[i]['LMPDT'].toString(),
                    AnganwariName:response_listing[i]['AnganwariName'].toString() == "null" ? "" :response_listing[i]['AnganwariName'].toString(),
                    ANCDate:response_listing[i]['ANCDate'].toString(),
                    ANCFlag:response_listing[i]['ANCFlag'].toString(),
                    weight:response_listing[i]['weight'].toString(),
                    HB:response_listing[i]['HB'].toString(),
                    AshaName:response_listing[i]['AshaName'].toString() == "null" ? "" :response_listing[i]['AshaName'].toString(),
                    Height:response_listing[i]['Height'].toString(),
                    anganwariNo:response_listing[i]['anganwariNo'].toString(),
                    CompL:(response_listing[i]['CompL'].toString() == "" || response_listing[i]['CompL'].toString() == "null") ? Strings.no : Strings.yes,
                    RTI:response_listing[i]['RTI'].toString() == "1" ? Strings.no : response_listing[i]['RTI'].toString() == "0" ? Strings.yes :response_listing[i]['RTI'].toString() == ""?"":"",
                    expand_flag:"false",
                    RegUnitID:response_listing[i]['RegUnitID'].toString(),
                    RegUnittype:response_listing[i]['RegUnittype'].toString(),
                    ashaAutoID:response_listing[i]['ashaAutoID'].toString(),
                    ANMVerify:response_listing[i]['ANMVerify'].toString(),
                    Media:response_listing[i]['Media'].toString(),
                    Freeze_ANC3Checkup: response_listing[i]['Freeze_ANC3Checkup'].toString(),
                    MinANCFlagUnVerify: response_listing[i]['MinANCFlagUnVerify'].toString()
                ),
              );
              last_pos=custom_anc_list.length-1;
              print('last_pos ${last_pos}');
            }
          }
          second_tab_msg=response_listing[response_listing.length -1]['ANCFlag'].toString();//get last position value
          print('last position flag: ${second_tab_msg}');
          print('second_tab_msg=> '
          '${second_tab_msg == "3" ?
          Strings.fourth_anc_ki_pravsti : second_tab_msg == "2" ?
          Strings.third_anc_ki_pravsti : second_tab_msg == "1" ?
          Strings.second_anc_ki_pravsti : second_tab_msg == "0" ?
          Strings.prathm_anc_ki_pravsti : second_tab_msg == "4" ? "" : ""}');
          print('anc-cust-.len ${custom_anc_list.length}');

          /*
            * IF ALL 4 ANC FILLED THEN HIDE FOURTH BUTTON LAYOUT , NO OTHER ANC FORM WILL BE FILED
           */
          if(response_listing.length == 4){
            _showHideAddANCButtonView=false;
          }else{
            _showHideAddANCButtonView=true;
          }



          /*for (int list_index = 0; list_index < custom_anc_list.length; list_index++) {
            if (last_pos == list_index) {
              if (preferences.getString("AppRoleID") == "32") { //anm
                if (custom_anc_list[list_index].ANMVerify.toString() == "0") {
                  _showDeleteButtonView = true;
                } else {
                  _showDeleteButtonView = false;
                }
              } else if (preferences.getString("AppRoleID") == "33") {
                if (custom_anc_list[list_index].ashaAutoID.toString() ==
                    preferences.getString('ANMAutoID')) {
                  _showDeleteButtonView = true;
                } else {
                  _showDeleteButtonView = false;
                }
              }
            }else{
              _showDeleteButtonView = false;
            }
          }*/
          /*if(preferences.getString("AppRoleID") == "33" && ){
            setState(() {
              _showEditButtonView=false;
            });
          }else{
            setState(() {

            });
          }*/

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

  Future<String> verifyANCAPI(String _flagtype,String _ancregid) async {
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
        acnDetailsAPI(widget.ancregid);
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

  Future<String> deleteANCAPI(String _flagtype,String _ancregid) async {
    var response = await delete(Uri.parse(_delete_record_url), body: {
      "ANCRegID": _ancregid,
      "ANCFlag": _flagtype,
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
        acnDetailsAPI(widget.ancregid);
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


  @override
  void initState() {
    super.initState();
    acnDetailsAPI(widget.ancregid);
    getHelpDesk();
  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
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
                                      Strings.anc_ka_vivran,
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
                      height: 20,
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
                    const Divider(color: ColorConstants.app_yellow_color,height: 0.5,thickness: 1.5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5,top: 5,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 5,bottom: 2,right: 5),
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                                child: Text(
                                  Strings.prsav_hone_ki_date,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color:Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text('${response_listing.length == 0 ? "" : getCustomAddDaysDate(response_listing[0]['LMPDT'].toString())}',
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                                padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
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
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text('${response_listing.length == 0 ? "" : response_listing[0]['Mobileno'].toString()}',
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
                            print('CheckHRCase ${response_listing[last_pos]['HighRisk'].toString()}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddNewANCScreen(
                                      pctsID:response_listing[last_pos]['pctsid'].toString(),
                                      headerName: second_tab_msg == "3" ?
                                      Strings.fourth_anc : second_tab_msg == "2" ?
                                      Strings.third_anc : second_tab_msg == "1" ?
                                      Strings.second_anc : second_tab_msg == "0" ?
                                      Strings.pratham_anc : second_tab_msg == "4" ? Strings.anc_ka_vivran : Strings.anc_ka_vivran,
                                      registered_date: getFormattedDate(response_listing[last_pos]['RegDate'].toString()),
                                      registered_date2: response_listing[last_pos]['RegDate'].toString(),
                                      expected_date: response_listing[last_pos]['LMPDT'].toString(),
                                      anc_date:response_listing[last_pos]['ANCDate'].toString() == "null" ? "" : response_listing[last_pos]['ANCDate'].toString(),
                                      weight: response_listing[last_pos]['weight'].toString(),
                                      AncFlag: second_tab_msg == "0" ?
                                      "1" : second_tab_msg == "1" ?
                                      "2" : second_tab_msg == "2" ?
                                      "3" : second_tab_msg == "3" ?
                                      "4":second_tab_msg == "4" ?
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
                                      //Height:"30",
                                      Height:response_listing[last_pos]['Height'].toString(),
                                      AncRegId:widget.ancregid,
                                      RegUnittype:response_listing[last_pos]['RegUnittype'].toString(),
                                      //Age: "17",
                                      Age: response_listing[last_pos]['Age'].toString(),
                                      ANC1Date: response_listing[last_pos]['ANC1Date'].toString() == "null" ? "" :response_listing[last_pos]['ANC1Date'].toString(),
                                      ANC2Date: response_listing[last_pos]['ANC2Date'].toString() == "null" ? "" :response_listing[last_pos]['ANC2Date'].toString(),
                                      ANC3Date: response_listing[last_pos]['ANC3Date'].toString() == "null" ? "" :response_listing[last_pos]['ANC3Date'].toString(),
                                      ANC4Date: response_listing[last_pos]['ANC4Date'].toString() == "null" ? "" :response_listing[last_pos]['ANC4Date'].toString(),
                                      PreviousTT1Date: response_listing[last_pos]['PreviousTT1Date'].toString() == "null" ? "" :response_listing[last_pos]['PreviousTT1Date'].toString(),
                                      PreviousTT2Date: response_listing[last_pos]['PreviousTT2Date'].toString() == "null" ? "" :response_listing[last_pos]['PreviousTT2Date'].toString(),
                                      PreviousTTBDate: response_listing[last_pos]['PreviousTTBDate'].toString() == "null" ? "" :response_listing[last_pos]['PreviousTTBDate'].toString(),
                                      HighRisk: response_listing[last_pos]['HighRisk'].toString() == "null" ? "0" :response_listing[last_pos]['HighRisk'].toString()
                                      //HighRisk: "1"
                                  )
                              ),
                            ).then((value){setState(() {
                              acnDetailsAPI(widget.ancregid);
                            });});
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
                                      '${second_tab_msg == "3" ?
                                      Strings.fourth_anc_ki_pravsti : second_tab_msg == "2" ?
                                      Strings.third_anc_ki_pravsti : second_tab_msg == "1" ?
                                      Strings.second_anc_ki_pravsti : second_tab_msg == "0" ?
                                      Strings.prathm_anc_ki_pravsti : second_tab_msg == "4" ? "" : Strings.prathm_anc_ki_pravsti_default}',
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

  bool _editable=false;
  var _lastTT1Date="";
  var _lastTT2Date="";
  Widget expandableListView(int list_index,bool isExpanded) {
    //debugPrint('List item build $list_index $isExpanded');
    return Container(
     // margin: EdgeInsets.symmetric(vertical: 1.0),
      margin: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          Container(
           // margin:EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
            color: custom_anc_list[list_index].ANMVerify.toString() == "null" ? ColorConstants.AppColorPrimary : custom_anc_list[list_index].ANMVerify.toString() == "0" ?  ColorConstants.AppColorPrimary : ColorConstants.hbyc_bg_green,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
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
                      '${custom_anc_list[list_index].ANCFlag == "1" ?
                      Strings.prathm_anc_ka_vivran : custom_anc_list[list_index].ANCFlag == "2" ?
                      Strings.second_anc_ka_vivran : custom_anc_list[list_index].ANCFlag == "3" ?
                      Strings.third_anc_ka_vivran:custom_anc_list[list_index].ANCFlag == "4" ?
                      Strings.fourth_anc_ka_vivran:""}',
                      style: TextStyle(
                          color:Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                )),
                Expanded(child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget> [
                      Row(
                        children: <Widget>[
                          Visibility(
                            //visible: last_pos == list_index ? true : false,
                              visible: preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" && custom_anc_list[list_index].MinANCFlagUnVerify.toString() == (list_index+1).toString() ? true :false :false,
                              child: GestureDetector(
                                onTap: (){
                                  if(custom_anc_list[list_index].ANCFlag.toString() == "1"){
                                    _verifyANCDetails("क्या आप"+" "+Strings.pratham_anc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "2"){
                                    _verifyANCDetails("क्या आप"+" "+Strings.second_anc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "3"){
                                    _verifyANCDetails("क्या आप"+" "+Strings.third_anc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "4"){
                                    _verifyANCDetails("क्या आप"+" "+Strings.fourth_anc+" "+"को सत्यापित करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
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
                            //visible: last_pos == list_index ? preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ? true : preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ashaAutoID.toString() == preferences.getString('ANMAutoID') ? true : false : preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ashaAutoID.toString() == preferences.getString('ANMAutoID') ? true : false  : false,
                            visible: last_pos == list_index ? preferences.getString("AppRoleID") == "32" ? custom_anc_list[list_index].ANMVerify.toString() == "0" ?  true : false : preferences.getString("AppRoleID") == "33" && ((custom_anc_list[list_index].ashaAutoID.toString() == preferences.getString('ANMAutoID')) && custom_anc_list[list_index].Media.toString() == "2" ) ? true : false : false,
                            //visible: preferences.getString("AppRoleID") == "33" ? false : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true : false,
                              child: GestureDetector(
                                onTap: (){
                                  if(custom_anc_list[list_index].ANCFlag.toString() == "1"){
                                    _deleteANCDetails("क्या आप"+" "+Strings.pratham_anc+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "2"){
                                    _deleteANCDetails("क्या आप"+" "+Strings.second_anc+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "3"){
                                    _deleteANCDetails("क्या आप"+" "+Strings.third_anc+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
                                        custom_anc_list[list_index].ancregid.toString(),
                                        ColorConstants.black);
                                  }else if(custom_anc_list[list_index].ANCFlag.toString() == "4"){
                                    _deleteANCDetails("क्या आप"+" "+Strings.fourth_anc+" "+"को डिलीट करना चाहते है |",
                                        custom_anc_list[list_index].ANCFlag.toString(),
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
                             // visible: custom_anc_list[list_index].ANMVerify.toString() != "null" ? custom_anc_list[list_index].ANMVerify.toString() == "1" ? false : true : true,
                            visible: preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ANMVerify.toString() == "1" ? false :preferences.getString("AppRoleID") == "33" && custom_anc_list[list_index].ANMVerify.toString() == "0" && custom_anc_list[list_index].Media.toString() == "2" ? true : custom_anc_list[list_index].Freeze_ANC3Checkup.toString() != "0" ? false : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true :false,
                            child: GestureDetector(
                            onTap: (){
                              /*if(last_pos > 0){
                                print('anc LastDate-if  ${response_listing[last_pos - 1]['ANCDate'].toString()}');
                              }else{
                                print('anc LastDate-else  ${response_listing[last_pos]['ANCDate'].toString()}');
                              }*/
                              print('on edit click last_pos>>>>>>>>>> ${list_index}');
                                for(int i=0 ;i<=list_index; i++) {
                                    if(response_listing[i]['TT1'].toString() != "null"){
                                      _lastTT1Date=response_listing[i]['TT1'].toString();
                                    }else{
                                      _lastTT1Date="";
                                    }
                                    if(response_listing[i]['TT2'].toString() != "null"){
                                      _lastTT2Date=response_listing[i]['TT2'].toString();
                                    }else{
                                      _lastTT2Date="";
                                    }
                                }
                                print('_lastTT1Date ${_lastTT1Date}');
                                print('_lastTT2Date ${_lastTT2Date}');
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => EditANCScreen(
                                        pctsID:response_listing[list_index]['pctsid'].toString(),
                                        registered_date: getFormattedDate(response_listing[list_index]['RegDate'].toString()),
                                        registered_date2: response_listing[list_index]['RegDate'].toString(),
                                        expected_date: response_listing[list_index]['LMPDT'].toString(),
                                        anc_date:response_listing[list_index]['ANCDate'].toString() == "null" ? "" : response_listing[list_index]['ANCDate'].toString(),
                                        weight: response_listing[list_index]['weight'].toString(),
                                        AncFlag: response_listing[list_index]['ANCFlag'].toString() == "null" ? "" :response_listing[list_index]['ANCFlag'].toString(),
                                        TTB: response_listing[list_index]['TTB'].toString() == "null" ? "" :response_listing[list_index]['TTB'].toString(),
                                        TT1: response_listing[list_index]['TT1'].toString() == "null" ? "" :response_listing[list_index]['TT1'].toString(),
                                        TT2: response_listing[list_index]['TT2'].toString() == "null" ? "" :response_listing[list_index]['TT2'].toString(),
                                        UrineA:response_listing[list_index]['UrineA'].toString() == "null" ? "" :response_listing[list_index]['UrineA'].toString(),
                                        UrineS:response_listing[list_index]['UrineS'].toString() == "null" ? "" :response_listing[list_index]['UrineS'].toString(),
                                        motherIdIntent: response_listing[list_index]['MotherID'].toString(),
                                        VillageAutoID: response_listing[list_index]['VillageAutoID'].toString(),
                                        DeliveryComplication: response_listing[list_index]['DeliveryComplication'].toString(),
                                        RegUnitID:response_listing[list_index]['RegUnitID'].toString(),
                                        Height:response_listing[list_index]['Height'].toString() == "null" ? "" :response_listing[list_index]['Height'].toString(),
                                        AncRegId:widget.ancregid,
                                        RegUnittype:response_listing[list_index]['RegUnittype'].toString(),
                                        Age: response_listing[list_index]['Age'].toString(),
                                        AshaAutoID: response_listing[list_index]['ashaAutoID'].toString(),
                                        AnganBadiNo:response_listing[list_index]['anganwariNo'].toString(),
                                        HBCount: response_listing[list_index]['HB'].toString(),
                                        IFA: response_listing[list_index]['IFA'].toString() == "null" ? "" :response_listing[list_index]['IFA'].toString(),
                                        BPS: response_listing[list_index]['BloodPressureS'].toString() == "null" ? "" :response_listing[list_index]['BloodPressureS'].toString(),
                                        BPD: response_listing[list_index]['BloodPressureD'].toString() == "null" ? "" :response_listing[list_index]['BloodPressureD'].toString(),
                                        COMPL: response_listing[list_index]['CompL'].toString() == "null" ? "" :response_listing[list_index]['CompL'].toString(),
                                        ALBE400: response_listing[list_index]['ALBE400'].toString() == "null" ? "" :response_listing[list_index]['ALBE400'].toString(),
                                        CAL500: response_listing[list_index]['CAL500'].toString() == "null" ? "" :response_listing[list_index]['CAL500'].toString(),
                                        RTI: response_listing[list_index]['RTI'].toString() == "null" ? "" :response_listing[list_index]['RTI'].toString(),
                                        Media: response_listing[list_index]['Media'].toString() == "null" ? "" :response_listing[list_index]['Media'].toString(),
                                        CovidCase: response_listing[list_index]['CovidCase'].toString() == "null" ? "" :response_listing[list_index]['CovidCase'].toString(),
                                        CovidFromDate: response_listing[list_index]['CovidFromDate'].toString() == "null" ? "" :response_listing[list_index]['CovidFromDate'].toString(),
                                        CovidForeignTrip: response_listing[list_index]['CovidForeignTrip'].toString() == "null" ? "" :response_listing[list_index]['CovidForeignTrip'].toString(),
                                        CovidRelativePossibility: response_listing[list_index]['CovidRelativePossibility'].toString() == "null" ? "" :response_listing[list_index]['CovidRelativePossibility'].toString(),
                                        CovidRelativePositive: response_listing[list_index]['CovidRelativePositive'].toString() == "null" ? "" :response_listing[list_index]['CovidRelativePositive'].toString(),
                                        CovidQuarantine: response_listing[list_index]['CovidQuarantine'].toString() == "null" ? "" :response_listing[list_index]['CovidQuarantine'].toString(),
                                        CovidIsolation: response_listing[list_index]['CovidIsolation'].toString() == "null" ? "" :response_listing[list_index]['CovidIsolation'].toString(),
                                        IronSucrose1: response_listing[list_index]['IronSucrose1'].toString() == "null" ? "" :response_listing[list_index]['IronSucrose1'].toString(),
                                        IronSucrose2: response_listing[list_index]['IronSucrose2'].toString() == "null" ? "" :response_listing[list_index]['IronSucrose2'].toString(),
                                        IronSucrose3: response_listing[list_index]['IronSucrose3'].toString() == "null" ? "" :response_listing[list_index]['IronSucrose3'].toString(),
                                        IronSucrose4: response_listing[list_index]['IronSucrose4'].toString() == "null" ? "" :response_listing[list_index]['IronSucrose4'].toString(),
                                        NormalLodingIronSucrose1: response_listing[list_index]['NormalLodingIronSucrose1'].toString() == "null" ? "" :response_listing[list_index]['NormalLodingIronSucrose1'].toString(),
                                        TreatmentCode: response_listing[list_index]['TreatmentCode'].toString() == "null" ? "" :response_listing[list_index]['TreatmentCode'].toString(),
                                        ReferDistrictCode: response_listing[list_index]['ReferDistrictCode'].toString() == "null" ? "" :response_listing[list_index]['ReferDistrictCode'].toString(),
                                        ReferUnitType: response_listing[list_index]['ReferUnitType'].toString() == "null" ? "" :response_listing[list_index]['ReferUnitType'].toString(),
                                        ReferUniName: response_listing[list_index]['ReferUniName'].toString() == "null" ? "" :response_listing[list_index]['ReferUniName'].toString(),
                                        headerName: response_listing[list_index]['ANCFlag'].toString() == "1" ?
                                        Strings.pratham_anc : response_listing[list_index]['ANCFlag'].toString() == "2" ?
                                        Strings.second_anc : response_listing[list_index]['ANCFlag'].toString() == "3" ?
                                        Strings.third_anc : response_listing[list_index]['ANCFlag'].toString() == "4" ?
                                        Strings.fourth_anc : Strings.anc_ka_vivran,
                                        ANC1Date: response_listing[list_index]['ANC1Date'].toString() == "null" ? "" :response_listing[list_index]['ANC1Date'].toString(),
                                        ANC2Date: response_listing[list_index]['ANC2Date'].toString() == "null" ? "" :response_listing[list_index]['ANC2Date'].toString(),
                                        ANC3Date: response_listing[list_index]['ANC3Date'].toString() == "null" ? "" :response_listing[list_index]['ANC3Date'].toString(),
                                        ANC4Date: response_listing[list_index]['ANC4Date'].toString() == "null" ? "" :response_listing[list_index]['ANC4Date'].toString(),
                                        PreviousTT1Date: response_listing[list_index]['PreviousTT1Date'].toString() == "null" ? "" :response_listing[list_index]['PreviousTT1Date'].toString(),
                                        PreviousTT2Date: response_listing[list_index]['PreviousTT2Date'].toString() == "null" ? "" :response_listing[list_index]['PreviousTT2Date'].toString(),
                                        PreviousTTBDate: response_listing[list_index]['PreviousTTBDate'].toString() == "null" ? "" :response_listing[list_index]['PreviousTTBDate'].toString(),
                                        HighRisk: response_listing[list_index]['HighRisk'].toString() == "null" ? "" :response_listing[list_index]['HighRisk'].toString()
                                    )
                                ),
                              ).then((value){setState(() {
                                acnDetailsAPI(widget.ancregid);
                                });});
                            },
                            child: Visibility(
                                //visible: last_pos == list_index ? true : false,
                                visible: preferences.getString("AppRoleID") == "33" && preferences.getString("ANMAutoID") == custom_anc_list[list_index].ashaAutoID.toString() ? true : preferences.getString("AppRoleID") == "32" && custom_anc_list[list_index].ANMVerify.toString() == "0" ? true :false,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8),
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
                          ))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          ExpandableContainer(
              expanded: isExpanded,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:EdgeInsets.only(left: 5,right: 5,top: 0,bottom: 0),
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
                                      Strings.anganbadi,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].AnganwariName}',
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
                                      Strings.anc_ki_tithi,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "" : getFormattedDate(custom_anc_list[list_index].ANCDate.toString())}',
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
                                      Strings.rti_sti_grasit,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "":custom_anc_list[list_index].RTI}',
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
                                      Strings.animiya,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].HB}',
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
                                      Strings.weight,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "" : custom_anc_list[list_index].weight}',
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
                                      Strings.high_risk_case,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${custom_anc_list.length == 0 ? "" :custom_anc_list[list_index].CompL}',
                                style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),

                      ],
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


  Future<void> _verifyANCDetails(String msg,String _flag,String ancregId,Color _color) async {
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
                          verifyANCAPI(_flag,ancregId);
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

  Future<void> _deleteANCDetails(String msg,String _flag,String ancregId,Color _color) async {
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
                          deleteANCAPI(_flag,ancregId);
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
    this.expandedHeight = 185.0,
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
  String? pctsid;
  String? ancregid;
  String? Mobileno;
  String? Name;
  String? Husbname;
  String? Address;
  String? Age;
  String? RegDate;
  String? LMPDT;
  String? AnganwariName;
  String? ANCDate;
  String? ANCFlag;
  String? weight;
  String? HB;
  String? AshaName;
  String? Height;
  String? anganwariNo;
  String? CompL;
  String? RTI;
  String? expand_flag;
  String? RegUnitID;
  String? RegUnittype;
  String? ashaAutoID;
  String? ANMVerify;
  String? Media;
  String? Freeze_ANC3Checkup;
  String? MinANCFlagUnVerify;

  CustomManageANCList({
    this.pctsid,
    this.ancregid,
    this.Mobileno,
    this.Name,
    this.Husbname,
    this.Address,
    this.Age,
    this.RegDate,
    this.LMPDT,
    this.AnganwariName,
    this.ANCDate,
    this.ANCFlag,
    this.weight,
    this.HB,
    this.AshaName,
    this.Height,
    this.anganwariNo,
    this.CompL,
    this.RTI,
    this.expand_flag,
    this.RegUnitID,
    this.RegUnittype,
    this.ashaAutoID,
    this.ANMVerify,
    this.Media,
    this.Freeze_ANC3Checkup,
    this.MinANCFlagUnVerify
  });
}