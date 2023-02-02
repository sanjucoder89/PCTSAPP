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
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/model/GetAashaListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/UpdateShishuDetailsData.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

class UpdateShishuTikakarnScreen extends StatefulWidget {
  const UpdateShishuTikakarnScreen({Key? key,
    required this.pctsID,
    required this.infantId,
    required this.immuname,
    required this.immucode,
    required this.birthdate,
    required this.villageautoid,
    required this.regunitid,
    required this.immdate,
    required this.aashaautoid,
    required this.childid,
    required this.weight,
    required this.unitcode,
    required this.Media,
  }) : super(key: key);
  final String pctsID;
  final String infantId;
  final String immuname;
  final String immucode;
  final String birthdate;
  final String villageautoid;
  final String regunitid;
  final String immdate;
  final String aashaautoid;
  final String childid;
  final String weight;
  final String unitcode;
  final String Media;

  @override
  State<UpdateShishuTikakarnScreen> createState() => _UpdateShishuTikakarnScreenState();
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



class _UpdateShishuTikakarnScreenState extends State<UpdateShishuTikakarnScreen> {
  var _anmName="";
  var _topHeaderName="";
  late String aashaId = "";
  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _update_shishu_url = AppConstants.app_base_url + "PutImmunizationDetail";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];

  late SharedPreferences preferences;
  List<CustomAashaList> custom_aasha_list = [];
  List response_list = [];
  var UpdateUserNo="";
  var Media="";
  var PartImmu="1";
  var ANMVerify="";
  var IMMDate_post="";
  TextEditingController _tikaDDdateController = TextEditingController();
  TextEditingController _tikaMMdateController = TextEditingController();
  TextEditingController _tikaYYYYdateController = TextEditingController();

  TextEditingController _enterChildWeight = TextEditingController();
  bool _isItAsha=false;
  bool _isAshaEntryORANMEntry=false;//false= anm , true =asha
  Future<String> getAashaListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    IMMDate_post=widget.immdate;
    final split = widget.immdate.split('/');
    print('split.length ${split.length}');
    _tikaDDdateController.text = split[0];
    _tikaMMdateController.text = split[1];
    _tikaYYYYdateController.text =split[2];

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

        if(widget.Media == "2"){
          if(preferences.getString("AppRoleID") == "32"){
            Media="3";
          }else{
            Media=widget.Media;
          }
        }else{
          Media="1";
        }


        //aashaId = custom_aasha_list[0].ASHAAutoid.toString();

        if(preferences.getString("AppRoleID").toString() == '33'){
          _isItAsha=true;
          aashaId = preferences.getString('ANMAutoID').toString();
          _isAshaEntryORANMEntry=false;
        }else{
          if(preferences.getString("AppRoleID").toString() == '32') {
            if(widget.Media == "1" || widget.Media == "0"){
              _isAshaEntryORANMEntry=false;
              _isItAsha=false;
              aashaId = widget.aashaautoid;
            }else{
              if(preferences.getString('ANMAutoID').toString() == widget.aashaautoid){
                _isAshaEntryORANMEntry=false;//update btn will show
              }else{
                if(preferences.getString("AppRoleID").toString() == '32') {//if last is anm btn will show for all asha
                  _isAshaEntryORANMEntry=false;//update btn will show
                }

              }
              _isItAsha=true;//not editable
              aashaId = widget.aashaautoid;//set to last asha
            }
          }else{
            _isAshaEntryORANMEntry=true;
            _isItAsha=true;
            aashaId = widget.aashaautoid;
          }
        }
        _enterChildWeight.text=widget.weight.toString().trim();
        //print('aashaId ${aashaId}');
       // print('res.len  ${response_list.length}');
       // print('custom_aasha_list.len ${custom_aasha_list.length}');
      } else {}
      EasyLoading.dismiss();
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


  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  /*
    * UPDATE SHISHU TIKA DETAILS
  */
  Future<UpdateShishuDetailsData> updateShishuTikaDetailsAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    if(preferences.getString("AppRoleID") == "33"){
      //Media="2";
      UpdateUserNo=preferences.getString("ANMAutoID").toString();
    }else{
      //Media="3";
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
    /*print('UpdateRequest=>\n'
        'InfantID:${widget.infantId+
        "ASHAAutoid:"+aashaId+
        "ImmuDate:"+IMMDate_post+
        "ImmuCode:"+widget.immucode+
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
        "UnitCode:"+widget.unitcode+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');*/
    var response = await put(Uri.parse(_update_shishu_url), body: {
      "InfantID":widget.infantId,
      "ASHAAutoid": aashaId,
      "ImmuDate": IMMDate_post,
      "ImmuCode": widget.immucode,
      "VillageAutoid": widget.villageautoid,
      "BirthDate": widget.birthdate,
      "PartImmu": PartImmu,
      "LoginUnitid": preferences.getString('UnitID').toString(),
      "AppVersion":"5.5.5.22",
      "EntryUserNo": UpdateUserNo,
      "UpdateUserNo": UpdateUserNo,
      "Media": Media,
      "Latitude":_latitude,
      "Longitude": _longitude,
      "Weight": _enterChildWeight.text.toString().trim(),
      "UnitCode": widget.unitcode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = UpdateShishuDetailsData.fromJson(resBody);
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
    return UpdateShishuDetailsData.fromJson(resBody);
  }

  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }
  var _latitude="0.0";
  var _longitude="0.0";
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
  var _checkLoginType=false;
  @override
  void initState() {
    super.initState();
    checkLoginTypeSession();
    _getLocation();
    getAashaListAPI();
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children:<Widget>[
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
                            style: Theme.of(context).textTheme.bodyText1,
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
                                               /// color: Colors.black,
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
                          _selectANCDatePopup(int.parse(_tikaYYYYdateController.text.toString()),int.parse(_tikaMMdateController.text.toString()) ,int.parse(_tikaDDdateController.text.toString()));

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
                                  child: SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: Checkbox(
                                        activeColor:Colors.grey ,
                                        value: true,
                                        onChanged: (bool? value) {

                                        }),
                                  ),
                                )),
                            Expanded(
                                child: Text('${widget.immuname == "" ? "" : widget.immuname}',textAlign:TextAlign.center,style: TextStyle(color:Colors.black,fontSize: 12,fontWeight: FontWeight.normal),))
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
                                  textAlign: TextAlign.center,
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
              ],
            ),
          ),
          _isAshaEntryORANMEntry == false
              ?
          Visibility(
              visible: _checkLoginType,
              child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                            text: Strings.vivran_update_krai,
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
          ))
              :
          Container()
        ],
      ),

    );
  }

  void postValidateData() {
    if(_tikaDDdateController.text.isEmpty){
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
      updateShishuTikaDetailsAPI();
    }
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
  void _selectANCDatePopup(int yyyy,int mm ,int dd) {
    showDatePicker(
        context: context,
        initialDate: DateTime(yyyy, mm , dd ),
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

          var _newtikaAPIDate= DateTime.parse(getConvertRegDateFormat(_tikaYYYYdateController.text.toString()+"-"+_tikaMMdateController.text.toString()+"-"+_tikaDDdateController.text.toString()));;
          if (_newtikaAPIDate.compareTo(birthDate) > 0) {


            _tikaDDdateController.text = getDate(formattedDate4);
            _tikaMMdateController.text = getMonth(formattedDate4);
            _tikaYYYYdateController.text = getYear(formattedDate4);


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

class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}
