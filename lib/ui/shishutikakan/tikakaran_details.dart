import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/shishutikakan/update_shishu_tikakaran.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'add_new_tikakaran.dart';
import 'model/GetShishuDetailsData.dart';

class TikaKaranDetails extends StatefulWidget {
  const TikaKaranDetails({Key? key,required this.pctsID,required this.infantId}) : super(key: key);

  final String pctsID;
  final String infantId;
  @override
  State<TikaKaranDetails> createState() => _TikaKaranDetailsState();
}

class _TikaKaranDetailsState extends State<TikaKaranDetails> {
  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;
  var _anmAshaTitle="";
  var _anmName="";
  var _topHeaderName="";
  var _shishu_details_api = AppConstants.app_base_url + "uspImmunizationListByInfantID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];

  late SharedPreferences preferences;
  List response_listing = [];
  ScrollController? _controller;

  var _ashaSession=false;
  var _anmSession=false;
  /*
  * API FOR Get Shishu Details
  * */
  Future<String> getShishuDetailsAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();

    setState(() {
      if(preferences.getString("AppRoleID").toString() == '33'){
        _ashaSession=true;
        _anmSession=false;
      }else{
        _ashaSession=false;
        _anmSession=true;
      }
    });
    print('infantid ${widget.infantId}');
    print('Token ${preferences.getString('Token')}');
    print('UserId ${preferences.getString('UserId')}');
    var response = await post(Uri.parse(_shishu_details_api), body: {
      "InfantID":widget.infantId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetShishuDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_listing = resBody['ResposeData'];
        print('resp.len ${response_listing.length}');

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



  @override
  void initState() {
    super.initState();
    getShishuDetailsAPI();
    getHelpDesk();
  }

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
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
  bool _disableButton = false;
  var _decoration=TextDecoration.none;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(Strings.shishu_ka_tikakarn_title,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(widget.pctsID,
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        backgroundColor: ColorConstants.AppColorPrimary,
        actions: [
          Container(
            child:  PopupMenuButton(
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
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: Stack(
          children:<Widget> [
            Column(
              children: <Widget> [
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
                        color:  ColorConstants.lifebgColor,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    Strings.informationForupdatedateImm,
                                    style: TextStyle(
                                        color: ColorConstants.redTextColor,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            )),
                      ),

                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.app_yellow_color)
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(Strings.immName,textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.AppColorPrimary,fontSize: 12,fontWeight: FontWeight.bold),)),
                      Padding(
                        padding: const EdgeInsets.only(left: 3,right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(child: Text(Strings.immDate,textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.AppColorPrimary,fontSize: 12,fontWeight: FontWeight.bold),)),
                      Padding(
                        padding: const EdgeInsets.only(left: 3,right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(child: Text(Strings.immName,textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.AppColorPrimary,fontSize: 12,fontWeight: FontWeight.bold),)),
                      Padding(
                        padding: const EdgeInsets.only(left: 3,right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(child: Text(Strings.immDate,textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.AppColorPrimary,fontSize: 12,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                Expanded(child:Container(
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (9 / 1),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        children: List.generate(getLength(), (index) {
                          return Container(
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5,color: ColorConstants.app_yellow_color)
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text('${response_listing[index]['immuname'].toString() == "null" ? "-" : response_listing[index]['immuname'].toString()}',textAlign:TextAlign.center,style: TextStyle(color:Colors.black,fontSize: 12,fontWeight: FontWeight.normal),)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3,right: 3),
                                  child: VerticalDivider(
                                    width: 0,
                                    color: ColorConstants.app_yellow_color,
                                    thickness: 2,
                                  ),
                                ),
                                Expanded(child: _ashaSession == true ? GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       if(response_listing[index]['clickable'].toString() == "1") {
                                         if (response_listing[index]['ANMVerify'].toString() == "0") {
                                           if (response_listing[index]['ashaautoid'].toString() == "0" || response_listing[index]['ashaautoid'].toString() == preferences.getString("ANMAutoID").toString()) {
                                             Navigator.push(context,
                                                 MaterialPageRoute(builder: (context) =>
                                                     UpdateShishuTikakarnScreen(
                                                       pctsID: widget.pctsID,
                                                       infantId: widget.infantId,
                                                       immuname: response_listing[index]['immuname'].toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['immuname']
                                                           .toString(),
                                                       immucode: response_listing[index]['immucode']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['immucode']
                                                           .toString(),
                                                       birthdate: response_listing[index]['Birth_date']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['Birth_date']
                                                           .toString(),
                                                       villageautoid: response_listing[index]['VillageAutoID']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['VillageAutoID']
                                                           .toString(),
                                                       regunitid: response_listing[index]['RegUnitID']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['RegUnitID']
                                                           .toString(),
                                                       immdate: response_listing[index]['immudate']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['immudate']
                                                           .toString(),
                                                       aashaautoid: response_listing[index]['ashaautoid']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['ashaautoid']
                                                           .toString(),
                                                       childid: widget.pctsID,
                                                       weight: response_listing[index]['weight']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['weight']
                                                           .toString(),
                                                       unitcode: response_listing[index]['unitcode']
                                                           .toString() == "null"
                                                           ? ""
                                                           : response_listing[index]['unitcode']
                                                           .toString(),
                                                       Media:response_listing[index]['Media']
                                                           .toString()
                                                     )
                                                 )
                                             ).then((value) {
                                               setState(() {
                                                 this.getShishuDetailsAPI();
                                               });
                                             });
                                           } else {
                                             //disable click
                                           }
                                         }else{
                                           //disable click
                                         }
                                       }
                                     });
                                   },
                                  child: Text('${response_listing[index]['immudate'].toString() == "null" ? "-" :response_listing[index]['immudate']}',textAlign:TextAlign.center,
                                    style: TextStyle(color: response_listing[index]['ANMVerify'].toString() == "1" ? ColorConstants.hbyc_bg_green : response_listing[index]['ashaautoid'].toString() == "0" ? ColorConstants.AppColorPrimary : response_listing[index]['ashaautoid'].toString() == preferences.getString("ANMAutoID").toString() ? ColorConstants.AppColorPrimary : ColorConstants.black,
                                        fontSize: 12,
                                        decoration: response_listing[index]['ANMVerify'].toString() == "0" ? TextDecoration.underline : TextDecoration.none,
                                        fontWeight: response_listing[index]['ANMVerify'].toString() == "0" ? FontWeight.bold : FontWeight.normal ),),
                                ) : GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       print('fsdfsdfasdfas ${response_listing[response_listing.length - 1]['Freeze_Immu']}');
                                       // if (childImmBeans.get(getItemCount() - 1).getFreeze_Immu() == 1) {
                                       if(response_listing[response_listing.length - 1]['Freeze_Immu'] == 1){

                                         if(response_listing[index]['immucode'].toString() == "1" ||
                                             response_listing[index]['immucode'].toString() == "5" ||
                                             response_listing[index]['immucode'].toString() == "8" ||
                                             response_listing[index]['immucode'].toString() == "11" ||
                                             response_listing[index]['immucode'].toString() == "4"||
                                             response_listing[index]['immucode'].toString() == "7"||
                                             response_listing[index]['immucode'].toString() == "10"||
                                             response_listing[index]['immucode'].toString() == "13"||
                                             response_listing[index]['immucode'].toString() == "6"||
                                             response_listing[index]['immucode'].toString() == "9"||
                                             response_listing[index]['immucode'].toString() == "12"||
                                             response_listing[index]['immucode'].toString() == "31"||
                                             response_listing[index]['immucode'].toString() == "32"||
                                             response_listing[index]['immucode'].toString() == "33" ) {
                                           //nothing to do for ANM
                                           print('ifffffffffffff');
                                         }
                                       }
                                       if(preferences.getString("AppRoleID").toString() == "32"){
                                         if(response_listing[index]['clickable'].toString() == "1") {
                                           if (response_listing[index]['ANMVerify'].toString() == "0") {
                                                 Navigator.push(context,
                                                     MaterialPageRoute(builder: (context) =>
                                                         UpdateShishuTikakarnScreen(
                                                             pctsID: widget.pctsID,
                                                             infantId: widget.infantId,
                                                             immuname: response_listing[index]['immuname'].toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immuname']
                                                                 .toString(),
                                                             immucode: response_listing[index]['immucode']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immucode']
                                                                 .toString(),
                                                             birthdate: response_listing[index]['Birth_date']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['Birth_date']
                                                                 .toString(),
                                                             villageautoid: response_listing[index]['VillageAutoID']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['VillageAutoID']
                                                                 .toString(),
                                                             regunitid: response_listing[index]['RegUnitID']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['RegUnitID']
                                                                 .toString(),
                                                             immdate: response_listing[index]['immudate']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immudate']
                                                                 .toString(),
                                                             aashaautoid: response_listing[index]['ashaautoid']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['ashaautoid']
                                                                 .toString(),
                                                             childid: widget.pctsID,
                                                             weight: response_listing[index]['weight']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['weight']
                                                                 .toString(),
                                                             unitcode: response_listing[index]['unitcode']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['unitcode']
                                                                 .toString(),
                                                             Media:response_listing[index]['Media']
                                                                 .toString()
                                                         )
                                                     )
                                                 ).then((value) {
                                                   setState(() {
                                                     this.getShishuDetailsAPI();
                                                   });
                                                 });
                                               }else{
                                                 if(preferences.getString('ANMAutoID').toString() == response_listing[index]['ashaautoid'].toString()){
                                                   Navigator.push(context,
                                                       MaterialPageRoute(builder: (context) =>
                                                           UpdateShishuTikakarnScreen(
                                                               pctsID: widget.pctsID,
                                                               infantId: widget.infantId,
                                                               immuname: response_listing[index]['immuname'].toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immuname']
                                                                   .toString(),
                                                               immucode: response_listing[index]['immucode']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immucode']
                                                                   .toString(),
                                                               birthdate: response_listing[index]['Birth_date']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['Birth_date']
                                                                   .toString(),
                                                               villageautoid: response_listing[index]['VillageAutoID']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['VillageAutoID']
                                                                   .toString(),
                                                               regunitid: response_listing[index]['RegUnitID']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['RegUnitID']
                                                                   .toString(),
                                                               immdate: response_listing[index]['immudate']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immudate']
                                                                   .toString(),
                                                               aashaautoid: response_listing[index]['ashaautoid']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['ashaautoid']
                                                                   .toString(),
                                                               childid: widget.pctsID,
                                                               weight: response_listing[index]['weight']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['weight']
                                                                   .toString(),
                                                               unitcode: response_listing[index]['unitcode']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['unitcode']
                                                                   .toString(),
                                                               Media:response_listing[index]['Media']
                                                                   .toString()
                                                           )
                                                       )
                                                   ).then((value) {
                                                     setState(() {
                                                       this.getShishuDetailsAPI();
                                                     });
                                                   });
                                                 }
                                           }
                                         }
                                       }else if(preferences.getString("AppRoleID").toString() == "33"){
                                         if(response_listing[index]['clickable'].toString() == "1") {
                                           if (response_listing[index]['ANMVerify'].toString() == "0") {
                                             if (response_listing[index]['ashaautoid'].toString() == preferences.getString("ANMAutoID").toString()) {
                                               if(response_listing[index]['ashaautoid'].toString() == "0" && preferences.getString("AppRoleID").toString() == "32"){
                                                 Navigator.push(context,
                                                     MaterialPageRoute(builder: (context) =>
                                                         UpdateShishuTikakarnScreen(
                                                             pctsID: widget.pctsID,
                                                             infantId: widget.infantId,
                                                             immuname: response_listing[index]['immuname'].toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immuname']
                                                                 .toString(),
                                                             immucode: response_listing[index]['immucode']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immucode']
                                                                 .toString(),
                                                             birthdate: response_listing[index]['Birth_date']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['Birth_date']
                                                                 .toString(),
                                                             villageautoid: response_listing[index]['VillageAutoID']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['VillageAutoID']
                                                                 .toString(),
                                                             regunitid: response_listing[index]['RegUnitID']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['RegUnitID']
                                                                 .toString(),
                                                             immdate: response_listing[index]['immudate']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['immudate']
                                                                 .toString(),
                                                             aashaautoid: response_listing[index]['ashaautoid']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['ashaautoid']
                                                                 .toString(),
                                                             childid: widget.pctsID,
                                                             weight: response_listing[index]['weight']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['weight']
                                                                 .toString(),
                                                             unitcode: response_listing[index]['unitcode']
                                                                 .toString() == "null"
                                                                 ? ""
                                                                 : response_listing[index]['unitcode']
                                                                 .toString(),
                                                             Media:response_listing[index]['Media']
                                                                 .toString()
                                                         )
                                                     )
                                                 ).then((value) {
                                                   setState(() {
                                                     this.getShishuDetailsAPI();
                                                   });
                                                 });
                                               }else{
                                                 if(preferences.getString('ANMAutoID').toString() == response_listing[index]['ashaautoid'].toString()){
                                                   Navigator.push(context,
                                                       MaterialPageRoute(builder: (context) =>
                                                           UpdateShishuTikakarnScreen(
                                                               pctsID: widget.pctsID,
                                                               infantId: widget.infantId,
                                                               immuname: response_listing[index]['immuname'].toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immuname']
                                                                   .toString(),
                                                               immucode: response_listing[index]['immucode']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immucode']
                                                                   .toString(),
                                                               birthdate: response_listing[index]['Birth_date']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['Birth_date']
                                                                   .toString(),
                                                               villageautoid: response_listing[index]['VillageAutoID']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['VillageAutoID']
                                                                   .toString(),
                                                               regunitid: response_listing[index]['RegUnitID']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['RegUnitID']
                                                                   .toString(),
                                                               immdate: response_listing[index]['immudate']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['immudate']
                                                                   .toString(),
                                                               aashaautoid: response_listing[index]['ashaautoid']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['ashaautoid']
                                                                   .toString(),
                                                               childid: widget.pctsID,
                                                               weight: response_listing[index]['weight']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['weight']
                                                                   .toString(),
                                                               unitcode: response_listing[index]['unitcode']
                                                                   .toString() == "null"
                                                                   ? ""
                                                                   : response_listing[index]['unitcode']
                                                                   .toString(),
                                                               Media:response_listing[index]['Media']
                                                                   .toString()
                                                           )
                                                       )
                                                   ).then((value) {
                                                     setState(() {
                                                       this.getShishuDetailsAPI();
                                                     });
                                                   });
                                                 }
                                               }
                                             }
                                           }
                                         }
                                       }

                                     });
                                   },
                                  child: Text('${response_listing[index]['immudate'].toString() == "null" ? "-" :response_listing[index]['immudate']}',textAlign:TextAlign.center,
                                    style: TextStyle(color: response_listing[index]['ANMVerify'].toString() == "1" ? ColorConstants.hbyc_bg_green : response_listing[index]['ashaautoid'].toString() == "0" ? ColorConstants.AppColorPrimary : response_listing[index]['ashaautoid'].toString() == preferences.getString("ANMAutoID").toString() ? ColorConstants.AppColorPrimary : ColorConstants.black,
                                        fontSize: 12,
                                        decoration: response_listing[index]['ANMVerify'].toString() == "0" ? TextDecoration.underline : TextDecoration.none,
                                        fontWeight: response_listing[index]['ANMVerify'].toString() == "0" ? FontWeight.bold : FontWeight.normal ),),
                                )),
                              ],
                            ),
                          );
                        }),
                      )),
                ))
                // _myListView()
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){

                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddNewTikakarnScreen(
                    pctsID: widget.pctsID,
                    infantId: widget.infantId,
                    birthdate:response_listing[0]['Birth_date'].toString() == "null" ? "" : response_listing[0]['Birth_date'].toString(),
                    villageautoid:response_listing[0]['VillageAutoID'].toString() == "null" ? "" : response_listing[0]['VillageAutoID'].toString(),
                    regunitid:response_listing[0]['RegUnitID'].toString() == "null" ? "" : response_listing[0]['RegUnitID'].toString(),
                    immdate:response_listing[0]['immudate'].toString() == "null" ? "" : response_listing[0]['immudate'].toString(),
                    childid:widget.pctsID,
                  )
                  )
                  ).then((value) { setState(() {
                    this.getShishuDetailsAPI();
                  });});

                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    color: ColorConstants.AppColorPrimary,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: Strings.new_tikakaran,
                              style: TextStyle(color: Colors.white, fontSize: 13),
                              children: [
                                TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10))
                              ]),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
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
