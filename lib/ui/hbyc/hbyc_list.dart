import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/AboutAppDialoge.dart';
import 'package:pcts/constant/LogoutAppDialoge.dart';
import 'package:pcts/ui/shishutikakan/tikakaran_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../../constant/ApiUrl.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/MyAppColor.dart';
import '../childgrowthcart/chart_details.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/before/anc_expand_details.dart';
import '../prasav/before/model/GetPrasavListData.dart';
import '../prasav/before/model/GetVillageListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'PopupMenuButtonExample1.dart';
import 'hbyc_expand_details.dart';



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


class HBYCListScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HBYCListScreen();


}

var option1=Strings.logout;
var option2=Strings.sampark_sutr;
var option3=Strings.video_title;
var option4=Strings.app_ki_jankari;
var option5=Strings.help_desk;

class _HBYCListScreen extends State<HBYCListScreen> {
  late SharedPreferences preferences;
  var _get_village_list = AppConstants.app_base_url+"uspGetVillageList";
  var _get_village_list_asha = AppConstants.app_base_url+"uspGetVillageListAsha";
  var _get_shishutikakaran_list = AppConstants.app_base_url+"HBYClist";
  var _find_prasav_id = AppConstants.app_base_url + "PostPCTSID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var isscrolling = true;
  List villages_list = [];
  List response_listing = [];
  List help_response_listing = [];
  late String villageId="0";
  ScrollController? _controller = ScrollController();
  ScrollController? _controller2 = ScrollController();
  //bool isToggle=false;
  /*
  * API FOR Village  LISTING
  * */
  Future<String> checkLoginSession() async {
    preferences = await SharedPreferences.getInstance();
    if(preferences.getString("AppRoleID").toString() == '33'){
      getVillageListAshaAPI(preferences.getString('ANMAutoID'));
    }else{
      getVillageListAPI(preferences.getString('UnitID'));
    }
    return "onSucess";
  }

  Future<String> getVillageListAPI(_id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_village_list), body: {
      "LoginUnitid": _id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetVillageListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        villages_list = resBody['ResposeData'];
        villageId = resBody['ResposeData'][0]['VillageautoID'].toString();
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    getLisingAPI(villageId);
    return "Success";
  }

  Future<String> getVillageListAshaAPI(_id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_village_list_asha), body: {
      "LoginUnitid": _id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetVillageListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        villages_list = resBody['ResposeData'];
        villageId = resBody['ResposeData'][0]['VillageautoID'].toString();
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    getLisingAPI(villageId);
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


  /*
  * API FOR Prasav  LISTING
  * */
  Future<String> getLisingAPI(String village_id) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_shishutikakaran_list), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "VillageAutoid":village_id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetPrasavListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_listing = resBody['ResposeData'];
      } else {
        //reLoginDialog();
      }
    });
    await EasyLoading.dismiss();
    getHelpDesk();
    print('response:${apiResponse.message}');
    return "Success";
  }


  /*
  * API FOR FIND PRASV DATA
  * */
  Future<String> findPrasavDataByIDAPI(String id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_find_prasav_id), body: {
      "PCTSID":id,
      "TagName":"3",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetPrasavListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_listing = resBody['ResposeData'];
      } else {
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
    return "Success";
  }


  bool showbtn = true;
  @override
  void initState() {
    super.initState();
    customScroll();
    checkLoginSession();

  }
  void customScroll() {
    _isVisible = true;
    _controller = new ScrollController();
    _controller!.addListener((){

      if(_controller!.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          print("**** ${_isVisible} up"); //Move IO away from setState
          setState((){
            _isVisible = false;
          });
        }
      } else {
        if(_controller!.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            print("**** ${_isVisible} down"); //Move IO away from setState
            setState((){
              _isVisible = true;
            });
          }
        }
      }});
      print('${_controller!.keepScrollOffset}');
  }

  void handleScroll() async {
    _controller!.addListener(() {
      if (_controller!.position.userScrollDirection == ScrollDirection.reverse)  {
        hideFloationButton();
      }
      if (_controller!.position.userScrollDirection == ScrollDirection.forward) {
        showFloationButton();
      }
      print('scroll_pos==> ${ScrollDirection.idle}');
    //  print('scroll==> ${ScrollDirection.idle}');
    });
  }

  void showFloationButton() {
    setState(() {
      isscrolling = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      isscrolling = false;
    });
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

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }
  int _counter = 0;
  var _isVisible;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
        title: Text('',style: TextStyle(color: Colors.white, fontSize: 18)),
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
      body: Column(
        children:<Widget>[
          Container(
            color: ColorConstants.prsav_header_color,
            height: 40,
            child: Row(
              children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(Strings.hbyc_title,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                  ),
                ),
              ),
              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(3),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorConstants.spinner_bg_color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12,left: 5),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: false,
                          //underline: Container( height: 2, color: Colors.black,),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset('Images/ic_down.png',
                              height: 12,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          iconSize: 15,
                          elevation: 11,
                          style: TextStyle(color: Colors.black),
                          isExpanded: true,
                          hint: new Text("Select District"),
                          items: villages_list.map((item) {
                            return DropdownMenuItem(

                                child: MediaQuery.removePadding(context: context, child: Container(
                                  height: 25,
                                  child: Column(
                                    children: [
                                      Text(
                                        item['VillageName'],    //Names that the api dropdown contains
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                      //Divider(color: ColorConstants.AppColorPrimary,height: 0.3,)
                                    ],
                                  ),
                                )),
                                value: item['VillageautoID'].toString()       //Id that has to be passed that the dropdown has.....
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState((){
                              villageId = newVal!;
                              print('villageId:$villageId');
                              getLisingAPI(villageId);
                            });
                          },
                          value: villageId,                 //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  controller: _controller,
                  itemCount: getLength(),
                  itemBuilder: (BuildContext ctxt, int index) {
                    return InkWell(
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                                  crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                              //  color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Strings.mahila_ka_naam,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: ColorConstants.AppColorPrimary,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              //  color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Strings.pita_ka_naam,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: ColorConstants.AppColorPrimary,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              //  color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Strings.mobile_num,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: ColorConstants.AppColorPrimary,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
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
                                                  '${response_listing[index]['name'].toString() == "null" ? "-" : response_listing[index]['name'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              //  color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  '${response_listing[index]['Husbname'].toString() == "null" ? "-" : response_listing[index]['Husbname'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              //  color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  '${response_listing[index]['Mobileno'].toString() == "null" ? "-" : response_listing[index]['Mobileno'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  //color: ColorConstants.lifebgColor,
                                ),
                                margin: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0),
                                child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                        controller: _controller2,
                                        itemCount: response_listing[index]['infantList'].length,
                                        itemBuilder: (context, childindex) {
                                          return GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => HBYCExpandDetails(infantId:response_listing[index]['infantList'][childindex]['InfantID'].toString()),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                color: ColorConstants.lifebgColor,
                                                elevation: 5,
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
                                                                  Strings.shishu_ka_naam,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  response_listing[index]['infantList'][childindex]['ChildName'].toString() == "null" ? "-" :response_listing[index]['infantList'][childindex]['ChildName'].toString(),
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
                                                                  Strings.shishu_ki_janam_tithi,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                                  getFormattedDate(response_listing[index]['infantList'][childindex]['Birth_date'].toString()),
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
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                                  response_listing[index]['infantList'][childindex]['Sex'].toString() == "1" ? Strings.boy_title : response_listing[index]['infantList'][childindex]['Sex'].toString() == "2" ? Strings.girl_title : response_listing[index]['infantList'][childindex]['Sex'].toString() == "" ? "" : response_listing[index]['infantList'][childindex]['Sex'].toString(),
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
                                                                  Strings.shishu_ki_id,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                                  response_listing[index]['infantList'][childindex]['ChildID'].toString(),
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
          //_myListView()
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                showPopupDialog(preferences.getString('UnitCode').toString());
              },
              child: Container(
                // margin: EdgeInsets.all(20),
                // width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorConstants.AppColorPrimary,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset("Images/writing.png",width: 40,height: 40,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(Strings.pcts_id_darj_krai,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            /*Container(
              height: 40,
              margin: EdgeInsets.all(3),
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                onPressed: () {
                  showPopupDialog(preferences.getString('UnitCode').toString());
                },
                label: const Text(Strings.pcts_id_darj_krai,style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                ),
                icon: Image.asset(
                  "Images/calendar.png",
                  width: 15,
                  height: 15,
                ),
                backgroundColor: ColorConstants.AppColorPrimary,
              ),
            ),*/
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
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.mahila_ka_naam,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.pita_ka_naam,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.mobile_num,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
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
                                  '${response_listing[index]['name'].toString() == "null" ? "-" : response_listing[index]['name'].toString()}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${response_listing[index]['Husbname'].toString() == "null" ? "-" : response_listing[index]['Husbname'].toString()}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${response_listing[index]['Mobileno'].toString() == "null" ? "-" : response_listing[index]['Mobileno'].toString()}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  //color: ColorConstants.lifebgColor,
                ),
                margin: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0),
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: response_listing[index]['infantList'].length,
                        itemBuilder: (context, childindex) {
                          return GestureDetector(
                            onTap: (){
                              print('infantid: ${response_listing[index]['infantList'][childindex]['InfantID'].toString()}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HBYCExpandDetails(infantId:response_listing[index]['infantList'][childindex]['InfantID'].toString()),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: ColorConstants.lifebgColor,
                                elevation: 5,
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
                                                  Strings.shishu_ka_naam,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  response_listing[index]['infantList'][childindex]['ChildName'].toString() == "null" ? "-" :response_listing[index]['infantList'][childindex]['ChildName'].toString(),
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
                                                  Strings.shishu_ki_janam_tithi,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  getFormattedDate(response_listing[index]['infantList'][childindex]['Birth_date'].toString()),
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
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  response_listing[index]['infantList'][childindex]['Sex'].toString() == "1" ? Strings.boy_title : response_listing[index]['infantList'][childindex]['Sex'].toString() == "2" ? Strings.girl_title : response_listing[index]['infantList'][childindex]['Sex'].toString() == "" ? "" : response_listing[index]['infantList'][childindex]['Sex'].toString(),
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
                                                  Strings.shishu_ki_id,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  response_listing[index]['infantList'][childindex]['ChildID'].toString(),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  TextEditingController pctsIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> showPopupDialog(String _unitCode) async {
    pctsIdController.text= _unitCode;
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
                  color: ColorConstants.light_yellow_color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Strings.pcts_id_saish_darj_krai,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.appNewBrowne,fontSize: 13),),
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: pctsIdController,
                      decoration: InputDecoration(
                        hintText: Strings.pcts_id,
                      ),
                      textAlign: TextAlign.start,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Value Can\'t Be Empty';
                        }
                        return null;
                      },
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
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            findPrasavDataByIDAPI(pctsIdController.text.toString().trim());
                            //close popup dialoge
                            Navigator.pop(context);
                          }
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
                                child: Text(Strings.aagai_badai,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
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
                                child: Text(Strings.radd_krai,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
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


 /* Widget _helpItemBuilder(){
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
  }*/
  Widget _helpItemBuilder() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: NotificationListener(
          child: ListView.builder(
              controller: _controller,
              itemCount: getHelpLength(),
              itemBuilder: _helpitemBuilder,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true),
          onNotification: (isscrolling) {
            if (isscrolling.runtimeType == ScrollEndNotification) {
              print((isscrolling as ScrollEndNotification)
                  .dragDetails); //prints mostly null, only prints instance of DragEndDetails when either we are overscrolling at start or end, not in middle
            }
            return true;
          },
        ));
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