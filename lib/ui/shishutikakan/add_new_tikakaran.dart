import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/IosVersion.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/model/GetAashaListData.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/AddNewTikaKaranData.dart';
import 'model/GetShishuDetailsData.dart';
import 'model/UpdateShishuDetailsData.dart';

class AddNewTikakarnScreen extends StatefulWidget {
  const AddNewTikakarnScreen({Key? key,
    required this.pctsID,
    required this.infantId,
    required this.birthdate,
    required this.villageautoid,
    required this.regunitid,
    required this.immdate,
    required this.childid,
  }) : super(key: key);
  final String pctsID;
  final String infantId;
  final String birthdate;
  final String villageautoid;
  final String regunitid;
  final String immdate;
  final String childid;

  @override
  State<AddNewTikakarnScreen> createState() => _AddNewTikakarnScreenState();
}

String getConvertRegDateFormat(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  // var outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  var outputFormat = DateFormat("yyyy-MM-dd");
  // var outputFormat = DateFormat('yyy-MM-dd hh:mm:ss');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getDate(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('dd');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getMonth(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('MM');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getYear(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}



class _AddNewTikakarnScreenState extends State<AddNewTikakarnScreen> {
  var _anmName="";
  var _topHeaderName="";
  late String aashaId = "";
  late String tikaCode= "";
  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _add_new_tikakaran_api = AppConstants.app_base_url + "PostImmunizationDetail";
  var _get_remaining_tikai_list_api = AppConstants.app_base_url + "uspManageImmunizationListForAdd";
  var _get_immucode_list_url = AppConstants.app_base_url + "uspImmunizationListByInfantID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];

  late SharedPreferences preferences;
  List<CustomAashaList> custom_aasha_list = [];
  List<CustomTikaiList> custom_tikai_list = [];
  List tikai_response_list = [];
  List response_list = [];
  var UpdateUserNo="";
  var Media="";
  var PartImmu="1";
  var ANMVerify="";
  var IMMDate_post="";
  var finalIds="";
  TextEditingController _tikaDDdateController = TextEditingController();
  TextEditingController _tikaMMdateController = TextEditingController();
  TextEditingController _tikaYYYYdateController = TextEditingController();
  List immucode_response_listing = [];
  /*
  * API FOR Get Immucode Listing
  * */
  List<ImmuCodeData> immuCodeListData=[];
  var _customString="";
  var _finalImmueCodeString="";
  Future<String> getImmuCodeListAPI() async {
    preferences = await SharedPreferences.getInstance();
    //print('infantid ${widget.infantId}');
    var response = await post(Uri.parse(_get_immucode_list_url), body: {
      "InfantID":widget.infantId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetShishuDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        immucode_response_listing = resBody['ResposeData'];
        print('immu.len ${immucode_response_listing.length}');

        if(immuCodeListData != null)immuCodeListData.clear();
        for (int i = 0; i < immucode_response_listing.length; i++) {
          _customString=_customString+"["+immucode_response_listing[i]['immucode'].toString()+"],";
          immuCodeListData.add(ImmuCodeData("["+immucode_response_listing[i]['immucode'].toString()+"],"
              //.replace("[", "")
              //.replace("]", "")
              //.replace(" ", "[")
             // .replace(",", "],")
          ));
        }
        _finalImmueCodeString=_customString.substring(0, _customString.length - 1);
        print('immucode ${_finalImmueCodeString}');
        getRemainingTikaiListAPI(_finalImmueCodeString);
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

  TextEditingController _enterChildWeight = TextEditingController();


  Future<String> getRemainingTikaiListAPI(String _immucode) async {
 /*   await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    preferences = await SharedPreferences.getInstance();

    print('LoginUnitID ${preferences.getString('UnitID')}');
    print('login-unit-code ${preferences.getString('UnitCode')}');

    var response = await post(Uri.parse(_get_remaining_tikai_list_api), body: {
      //LoginUnitcode:01010100202
      // SaveImmuCodeList:[2],[3],[5],[1],[31],[32],[8],[11],[33],[13],[14],[15],[16],[17],[30],[29]
      // Birth_date:2015-11-13T00:00:00
      // TokenNo:730c8ec9-d70b-44a1-b68e-0f5cfe7e3957
      // UserID:0101010020201
      "LoginUnitcode": preferences.getString('UnitCode'),
      //"SaveImmuCodeList": "[2],[3],[5],[1],[31],[32],[8],[11],[33],[13],[14],[15],[16],[17],[30],[29]",
      "SaveImmuCodeList": _immucode,
      "Birth_date": widget.birthdate,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_tikai_list.clear();
        tikai_response_list = resBody['ResposeData'];
        for (int i = 0; i < tikai_response_list.length; i++) {
          custom_tikai_list.add(CustomTikaiList(
              TikaName: tikai_response_list[i]['ImmuName'].toString(),
              TikaImmucode: tikai_response_list[i]['Immucode'].toString(),
              TikaDueDays:tikai_response_list[i]['DueDays'].toString() == "null" ? "" : tikai_response_list[i]['DueDays'].toString(),
              TikaMaxDays: tikai_response_list[i]['MaxDays'].toString() == "null" ? "" : tikai_response_list[i]['MaxDays'].toString(),
              isChecked:false)
          );
        }
        //tikaCode = custom_tikai_list[0].TikaImmucode.toString();
        //print('tikaCode ${tikaCode}');
        print('tikaiList.len ${custom_tikai_list.length}');
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.red);
      }
     // EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }
  bool _isItAsha=false;

  var _checkPlatform="0";
  Future<String> getAashaListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _checkPlatform=preferences.getString("CheckPlatform").toString();
    IMMDate_post=widget.immdate;
    final split = widget.immdate.split('/');
    print('split.length ${split.length}');
    print('ROleiD ${preferences.getString("AppRoleID")}');
    /*_tikaDDdateController.text = split[0];
    _tikaMMdateController.text = split[1];
    _tikaYYYYdateController.text =split[2];*/
    var response = await post(Uri.parse(_aasha_list_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "DelplaceUnitid": "0",
      "RegUnitid": widget.regunitid,
      "VillageAutoid": widget.villageautoid,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_aasha_list.clear();
        response_list = resBody['ResposeData'];
        custom_aasha_list
            .add(CustomAashaList(ASHAName: Strings.choose, ASHAAutoid: "0"));
        for (int i = 0; i < response_list.length; i++) {
          custom_aasha_list.add(CustomAashaList(
              ASHAName: response_list[i]['ASHAName'].toString(),
              ASHAAutoid: response_list[i]['ASHAAutoid'].toString()));
        }
        if(preferences.getString("AppRoleID").toString() == '33'){
          aashaId = preferences.getString('ANMAutoID').toString();
          _isItAsha=true;
        }else{
          aashaId = custom_aasha_list[0].ASHAAutoid.toString();
          _isItAsha=false;
        }



        print('aashaId ${aashaId}');
        print('res.len  ${response_list.length}');
        print('custom_aasha_list.len ${custom_aasha_list.length}');
      } else {}
      getImmuCodeListAPI();
      EasyLoading.dismiss();


      setState(() {
        _choose=multiple_chooice.nill;
        _choose2=multiple_chooice.nill;
        _choose3=multiple_chooice.nill;
        _choose4=multiple_chooice.nill;
        _choose5=multiple_chooice.nill;
        _choose6=multiple_chooice.nill;
        _choose7=multiple_chooice.nill;
        _choose8=multiple_chooice.nill;
        _choose9=multiple_chooice.nill;
        _choose10=multiple_chooice.nill;
        _choose11=multiple_chooice.nill;

      });

    });
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

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }
  var _latitude="0.0";
  var _longitude="0.0";
  var _checkLoginType=false;
  Future _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Location location = new Location();
    LocationData _pos = await location.getLocation();
    print('curr lat ${_pos.latitude}');
    print('curr lng ${_pos.longitude}');
    if(_pos.latitude != null){
      _latitude=_pos.latitude.toString();
    }
    if(_pos.longitude != null){
      _longitude=_pos.longitude.toString();
    }
    print('live loc lat $_latitude');
    print('live loc lng $_longitude');

    setState(() {
      prefs.setString("latitude", _latitude);
      prefs.setString("longitude", _longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginTypeSession();
    _getLocation();
    getAashaListAPI();
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
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Strings.aasha_chunai,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black)),
              padding: EdgeInsets.all(1),
              margin: EdgeInsets.all(3),
              height: 30,
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 10),
                    // width: 411.42857142857144-10,
                    height: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'Images/ic_dropdown.png',
                            height: 12,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        iconSize: 15,
                        elevation: 11,
                        //style: TextStyle(color: Colors.black),
                        //style: Theme.of(context).textTheme.bodyText1,
                        isExpanded: true,
                        // hint: new Text("Select State"),
                        items: custom_aasha_list.map((item) {
                          return DropdownMenuItem(

                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          item.ASHAName.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.ASHAAutoid
                                  .toString() //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged:_isItAsha == true ? null : (String? newVal) {
                          setState(() {
                            aashaId = newVal!;
                            print('aashaId:$aashaId');
                          });
                        },
                        value:
                        aashaId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            /*
            * Remaining Tikai Listing
            * */
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: Strings.immName,
                          style: TextStyle(
                              color: Colors.black, fontSize: 13),
                          children: [
                            TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))
                          ]),
                      //textScaleFactor: labelTextScale,
                      //maxLines: labelMaxLines,
                      // overflow: overflow,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(1),
                    height: 100,
                    child:Scrollbar(
                      controller: _controller,
                      isAlwaysShown: true,
                      //physics: ScrollPhysics(),
                      child:  _tikaiListView(),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: Strings.immDate,
                            style: TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ]),
                        //textScaleFactor: labelTextScale,
                        //maxLines: labelMaxLines,
                        // overflow: overflow,
                        textAlign: TextAlign.left,
                      )),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(1),
                    margin: EdgeInsets.all(3),
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              height: 36,
                              child: TextField(
                                textAlign: TextAlign.center,
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                controller: _tikaDDdateController,
                                maxLines: 1,
                                style: TextStyle(fontSize: 13),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),
                                    fillColor:Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: ' dd',
                                    counterText: ''),
                              ),
                            )),
                        Text("/"),
                        Expanded(
                            child: Container(
                              height: 36,
                              padding: EdgeInsets.only(left: 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                controller: _tikaMMdateController,
                                maxLines: 1,
                                style: TextStyle(fontSize: 13),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),
                                    fillColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: ' mm',
                                    counterText: ''),
                              ),
                            )),
                        Text("/"),
                        Expanded(
                            child: Container(
                              height: 36,
                              child: TextField(
                                textAlign: TextAlign.center,
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                controller: _tikaYYYYdateController,
                                maxLines: 1,
                                style: TextStyle(fontSize: 13),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0))),
                                    fillColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: ' yyyy',
                                    counterText: ''),
                              ),
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectANCDatePopup();
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: Image.asset(
                          "Images/calendar_icon.png",
                          width: 20,
                          height: 20,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: Strings.n_child_weight,
                            style: TextStyle(
                                color: Colors.black, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ]),
                        //textScaleFactor: labelTextScale,
                        //maxLines: labelMaxLines,
                        // overflow: overflow,
                        textAlign: TextAlign.left,
                      )),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(1),
                    margin: EdgeInsets.all(3),
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                              maxLength: 5,
                              keyboardType: TextInputType.number,
                              controller:  _enterChildWeight,
                              maxLines: 1,
                              style: TextStyle(fontSize: 13,color: Colors.black),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(0))),
                                  fillColor:Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '',
                                  counterText: ''
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: false,
                        child:Image.asset(
                          "Images/calendar_icon.png",
                          width: 20,
                          height: 20,
                        ),
                      ))
                ],
              ),
            ),
            /*
              * * radio button 1
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_1_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                //_choose = value ?? _choose;
                                                _choose = value! ;
                                                print('_choose $value');
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_1_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose = value! ;
                                                print('_choose $value');
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 2
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_2_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose2,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose2 = value ?? _choose2;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_2_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose2,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose2 = value ?? _choose2;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 3
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_3_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose3,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose3 = value ?? _choose3;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_3_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose3,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose3 = value ?? _choose3;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 4
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_4_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose4,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose4 = value ?? _choose4;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_4_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose4,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose4 = value ?? _choose4;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 5
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_5_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose5,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose5 = value ?? _choose5;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_5_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose5,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose5 = value ?? _choose5;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            /*
              * * radio button 6
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_6_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose6,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose6 = value ?? _choose6;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_6_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose6,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose6 = value ?? _choose6;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            /*
              * * radio button 7
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_7_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose7,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose7 = value ?? _choose7;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_7_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose7,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose7 = value ?? _choose7;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 8
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_8_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose8,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose8 = value ?? _choose8;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_8_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose8,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose8 = value ?? _choose8;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 9
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_9_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose9,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose9 = value ?? _choose9;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_9_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose9,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose9 = value ?? _choose9;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 10
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_10_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose10,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose10 = value ?? _choose10;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_10_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose10,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose10 = value ?? _choose10;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),

            /*
              * * radio button 11
              */
            Container(
              color: ColorConstants.grey_bg_anc,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: ColorConstants.grey_bg_anc,
                          child: RichText(
                            text: TextSpan(
                                text: Strings.choose_11_tika_title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
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
                        )),
                    Expanded(
                        child: Container(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.yes,
                                            groupValue: _choose11,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose11 = value ?? _choose11;
                                                /*strType="0";*/
                                                _showgeneralMsgPopup(
                                                    Strings.tika_radio_11_title);
                                              });
                                            },
                                          ),
                                          Text(
                                            Strings.yes,
                                            style: TextStyle(fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      height: 20,
                                      //Make it equal to height of radio button
                                      width: 10,
                                      //Make it equal to width of radio button
                                      child: Row(
                                        children: [
                                          Radio<multiple_chooice>(
                                            activeColor: Colors.black,
                                            value: multiple_chooice.no,
                                            groupValue: _choose11,
                                            onChanged:
                                                (multiple_chooice? value) {
                                              setState(() {
                                                _choose11 = value ?? _choose11;
                                                /*strType="1";*/
                                              });
                                            },
                                          ),
                                          Text(Strings.no,
                                              style: TextStyle(fontSize: 11))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Visibility(
                visible: _checkLoginType,
                child: GestureDetector(
              onTap: (){
                postValidateData();
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
                            text: Strings.vivran_save_krai,
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
            )),
          ],
        ),
      ),

    );
  }


  int getLength() {
    if(custom_tikai_list.isNotEmpty){
      return custom_tikai_list.length;
    }else{
      return 0;
    }
  }
  ScrollController? _controller;

  Widget _tikaiListView(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getLength(),
            itemBuilder: _itemBuilder,
           // physics: const NeverScrollableScrollPhysics(),
            //shrinkWrap: true
        )
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: (){

        },
        child: Container(
         // height: 50,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Container(
                    child: SizedBox(
                      height: 40.0,
                      width: 50.0,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        /*title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('${custom_tikai_list[index].TikaName}',style: TextStyle(fontSize: 12),),
                        ),*/
                        value: custom_tikai_list[index].isChecked,
                        onChanged: (val) {
                          setState(() {
                            custom_tikai_list[index].isChecked = val;
                            //print('isChecked ${custom_tikai_list[index].isChecked}');
                            //print('selected ${custom_tikai_list[index].TikaImmucode}');
                            if(custom_tikai_list[index].isChecked == true){
                              custom_selected_tikakaran_cvslist.add(CustomSelectedTikaKaranList(tikaID:int.parse(custom_tikai_list[index].TikaImmucode.toString()),tikaName:custom_tikai_list[index].TikaName.toString()));
                            }else{
                              custom_selected_tikakaran_cvslist.removeWhere((item) => item.tikaID == int.parse(custom_tikai_list[index].TikaImmucode.toString()));
                            }
                            print("cvslist.len ${custom_selected_tikakaran_cvslist.length}");
                          },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${custom_tikai_list[index].TikaName}',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                  thickness: 1,
                  color: Colors.black

              )
            ],
          ),
        ),
      ),
    );
  }

  void postValidateData() {
    String csv_value="";
    for (int i = 0; i < custom_selected_tikakaran_cvslist.length; i++) {
      if(csv_value.length > 0){
        csv_value=csv_value+"["+custom_selected_tikakaran_cvslist[i].tikaID.toString()+"],";
      }else{
        csv_value="["+custom_selected_tikakaran_cvslist[i].tikaID.toString()+"],";
      }
    }
    if(csv_value.isNotEmpty) {
      finalIds=csv_value.substring(0,csv_value.length - 1);
    }
    //print('final IDs ${csv_value.substring(0,csv_value.length - 1)}');
    print('final IDs ${finalIds}');


    if(aashaId == "0"){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }else if(finalIds.isEmpty){
      _showErrorPopup(Strings.tikai_ka_naam_chunai,ColorConstants.AppColorPrimary);
    }else if(_tikaDDdateController.text.isEmpty){
      _showErrorPopup(Strings.tikai_ki_tithi_chunai,ColorConstants.AppColorPrimary);
    }else if(_tikaMMdateController.text.isEmpty){
      _showErrorPopup(Strings.tikai_ki_tithi_chunai,ColorConstants.AppColorPrimary);
    }else if(_tikaYYYYdateController.text.isEmpty){
      _showErrorPopup(Strings.tikai_ki_tithi_chunai,ColorConstants.AppColorPrimary);
    }else if(_enterChildWeight.text.isEmpty){
      _showErrorPopup(Strings.enter_shishu_ka_weight,ColorConstants.AppColorPrimary);
    }else if(double.parse(_enterChildWeight.text.toString()) < 1){
      _showErrorPopup(Strings.enter_shishu_correct_weight,ColorConstants.AppColorPrimary);
    }else if(double.parse(_enterChildWeight.text.toString()) > 99){
      _showErrorPopup(Strings.enter_shishu_correct_weight,ColorConstants.AppColorPrimary);
    }else{
      AddNewTikakaranAPI();
    }
  }
  List<CustomSelectedTikaKaranList> custom_selected_tikakaran_cvslist = [];
  /*
    * UPDATE SHISHU TIKA DETAILS
  */
  Future<AddNewTikaKaranData> AddNewTikakaranAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    if(preferences.getString("AppRoleID") == "33"){
      Media="2";
      UpdateUserNo=preferences.getString("ANMAutoID").toString();
    }else{
      Media="1";
      UpdateUserNo=preferences.getString("UserNo").toString();
    }
    print('LoginUnitID ${preferences.getString('UnitID')}');
    print('UpdateUserNo ${UpdateUserNo}');
    print('Media ${Media}');

    if(_latitude == "0.0" || _longitude == "0.0"){
      _getLocation();
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('pkg_version: ${packageInfo.version}');


    if (_tikaDDdateController.text.isNotEmpty) {
      IMMDate_post=_tikaYYYYdateController.text.toString()+"/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
    }

    print('UpdateRequest=>\n'
        'InfantID:${widget.infantId+
        "ASHAAutoid:"+aashaId+
        "ImmuDate:"+IMMDate_post+
        "ImmuCode:"+finalIds+
        "VillageAutoid:"+widget.villageautoid+
        "BirthDate:"+widget.birthdate+
        "PartImmu:"+PartImmu+
        "LoginUnitid:"+preferences.getString('UnitID').toString()+
        "AppVersion:"+packageInfo.version+
        "EntryUserNo:"+UpdateUserNo+
        "UpdateUserNo:"+UpdateUserNo+
        "Media:"+Media+
        "Latitude:"+_latitude+
        "Longitude:"+_longitude+
        "Weight:"+_enterChildWeight.text.toString().trim()+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');
    var response = await post(Uri.parse(_add_new_tikakaran_api), body: {
      "InfantID":widget.infantId,
      "ASHAAutoid": aashaId,
      "ImmuDate": IMMDate_post,
      "ImmuCode": finalIds,
      "VillageAutoid": widget.villageautoid,
      "BirthDate": widget.birthdate,
      "PartImmu": PartImmu,
      "LoginUnitid": preferences.getString('UnitID').toString(),
      "AppVersion": _checkPlatform == "0" ? preferences.getString("Appversion") : "",
      "IOSAppVersion": _checkPlatform == "1" ? IosVersion.ios_version : "",
      "EntryUserNo": UpdateUserNo,
      "UpdateUserNo": UpdateUserNo,
      "Media": Media,
      "Latitude":_latitude,
      "Longitude": _longitude,
      "Weight": _enterChildWeight.text.toString().trim(),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = AddNewTikaKaranData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _showSuccessPopup(apiResponse.message.toString(),ColorConstants.AppColorPrimary);
      }else if (apiResponse.appVersion == 1){
        //Redirect to play store for update
        reLoginDialog();
      }else{
        _showErrorPopup(apiResponse.message.toString(), Colors.black);
      }
      EasyLoading.dismiss();
    });
    print('response-status:${apiResponse.status}');
    print('response-message:${apiResponse.message}');
    print('response-appVersion:${apiResponse.appVersion}');
    return AddNewTikaKaranData.fromJson(resBody);
  }

  Future<void> _showErrorPopup(String msg,Color _color) async {
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
                          fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: ColorConstants.AppColorPrimary,
                              ),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text('OK',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 14)),
                                  ))),
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

  Future<void> _showSuccessPopup(String msg,Color _color) async {
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
                          fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: ColorConstants.AppColorPrimary,
                              ),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text('OK',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 14)),
                                  ))),
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

  /*
  * * Custom Date Picker
  * */
  late DateTime _selectedDate;

  var initalDay = 0;
  var initalMonth = 0;
  var initalYear = 0;
  var final_diff_dates=0;
  void _selectANCDatePopup() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //initialDate: DateTime(initalYear, initalMonth, initalDay),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050))
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        print(
            "Hi bro, i came from cancel button or via click outside of datepicker");
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var birthDate = DateTime.parse(getConvertRegDateFormat(widget.birthdate));
          print('birthDate ${birthDate}');//2021-03-12 00:00:00.000

          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if (selectedParsedDate.compareTo(birthDate) > 0) //2021-04-22 00:00:00.000
          {
            _tikaDDdateController.text = getDate(formattedDate4);
            _tikaMMdateController.text = getMonth(formattedDate4);
            _tikaYYYYdateController.text = getYear(formattedDate4);
            IMMDate_post=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
            print('IMMDate_post $IMMDate_post');
          }else{
            _showErrorPopup(Strings.choose_after_birth_date, ColorConstants.AppColorPrimary);
          }
        }
      });
    });
  }

  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  Future<void> _showgeneralMsgPopup(String msg) async {
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
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.redTextColor,
                          fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: ColorConstants.AppColorPrimary,
                              ),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text('OK',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 14)),
                                  ))),
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

  ScrollController? _helpcontroller;

  Widget _helpItemBuilder(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _helpcontroller,
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



enum multiple_chooice { nill, yes, no }

multiple_chooice _choose = multiple_chooice.nill; //radio button 1
multiple_chooice _choose2 = multiple_chooice.nill; //radio button 2
multiple_chooice _choose3 = multiple_chooice.nill; //radio button 3
multiple_chooice _choose4 = multiple_chooice.nill; //radio button 4
multiple_chooice _choose5 = multiple_chooice.nill; //radio button 5
multiple_chooice _choose6 = multiple_chooice.nill; //radio button 6
multiple_chooice _choose7 = multiple_chooice.nill; //radio button 6
multiple_chooice _choose8 = multiple_chooice.nill; //radio button 6
multiple_chooice _choose9 = multiple_chooice.nill; //radio button 6
multiple_chooice _choose10 = multiple_chooice.nill; //radio button 6
multiple_chooice _choose11 = multiple_chooice.nill; //radio button 6

class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}

class CustomTikaiList {
  String? TikaName;
  String? TikaImmucode;
  String? TikaDueDays;
  String? TikaMaxDays;
  bool? isChecked;

  CustomTikaiList({this.TikaName, this.TikaImmucode, this.TikaDueDays, this.TikaMaxDays, this.isChecked});
}
class CustomSelectedTikaKaranList {
  int? tikaID;//unique id for array list
  String? tikaName;

  CustomSelectedTikaKaranList({this.tikaID, this.tikaName});
}
class ImmuCodeData {
  ImmuCodeData(this.immucode);
  final String immucode;
}