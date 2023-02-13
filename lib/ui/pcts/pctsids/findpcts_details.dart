import 'dart:convert';
import 'package:pcts/constant/LocaleString.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:pcts/ui/admindashboard/model/ANCVivranListData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../../constant/AboutAppDialoge.dart';
import '../../../constant/LogoutAppDialoge.dart';
import '../../dashboard/model/GetHelpDeskData.dart';
import '../../dashboard/model/LogoutData.dart';
import '../../samparksutra/samparksutra.dart';
import '../../splashnew.dart';
import '../../videos/tab_view.dart';
import 'model/MahilaVivranData.dart';
import 'model/WomenInfantDetailsData.dart';

String getFormattedDate(String date) {
  //print('dateformat $date');
  if (date != "null") {
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  } else {
    return "";
  }
}

class FindPCTSDetails extends StatefulWidget {
  const FindPCTSDetails({Key? key, required this.pctsID}) : super(key: key);
  final String pctsID;

  @override
  State<StatefulWidget> createState() => _FindPCTSDetails();
}

class _FindPCTSDetails extends State<FindPCTSDetails> {
  late SharedPreferences preferences;
  ScrollController? _controller;
  List _mahila_vivaran_response = [];
  List _child_vivaran_response = [];
  List _child_infantt_vivaran_response = [];
  List _women_infantt_vivaran_response = [];
  List _anc_vivaran_response = [];
  var vilage_name;
  var _mahila_vivran_api = AppConstants.app_base_url + "PostPCTSID";
  var _child_vivran_api = AppConstants.app_base_url + "uspInfantlistByPCTSIDForWomanDetails";
  var _child_infant_vivran_api = AppConstants.app_base_url + "uspInfantDataByInfantID";
  var _women_infant_vivran_api = AppConstants.app_base_url + "uspDataforPNCWomanDetails";
  var _anc_vivran_api_url = AppConstants.app_base_url + "uspDataforManageANC";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];

  /*
  * API FOR MAHILA VIVRAN
  * */
  Future<String> getMahilaVivranAPI() async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('inside api methond.....${widget.pctsID}');
    _anmName=preferences.getString("ANMName").toString();
    _districtName=preferences.getString("DistrictName").toString();
    var response = await post(Uri.parse(_mahila_vivran_api), body: {
      "PCTSID": widget.pctsID,
      "TagName": "6",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = MahilaVivranData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _mahila_vivaran_response = resBody['ResposeData'];
        vilage_name = resBody['ResposeData'][0]['VillageName'].toString();
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      _visibleHeaderView=true;
      getChildVivranAPI();
    });
    return "Success";
  }

  Future<String> getANCVivranAPI(String _ancRegid) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
   // print('inside api methond.....${widget.pctsID}');
    var response = await post(Uri.parse(_anc_vivran_api_url), body: {
      //ANCRegID:16436467
      // TokenNo:18fd4ed0-f87b-49f2-b21f-f525f7fd20af
      // UserID:sa
      "ANCRegID": _ancRegid,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ANCVivranListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _anc_vivaran_response = resBody['ResposeData'];
        //vilage_name = resBody['ResposeData'][0]['VillageName'].toString();
      } else {
        Fluttertoast.showToast(
            msg: apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black);
      }
      EasyLoading.dismiss();
      showANCVivranDetailsBSheet(context);
      print('response:${apiResponse.message}');
      print('anc.len :${_anc_vivaran_response.length}');
    });
    return "Success";
  }

  /*
  * API FOR Child VIVRAN
  * */
  Future<String> getChildVivranAPI() async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('PCTSID ${widget.pctsID}');
    print('Token ${preferences.getString('Token')}');
    print('UserID ${preferences.getString('UserId')}');
    var response = await post(Uri.parse(_child_vivran_api), body: {
      "PCTSID": widget.pctsID,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = MahilaVivranData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _child_vivaran_response = resBody['ResposeData'];
      } else {
        Fluttertoast.showToast(
            msg: resBody['Message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black);
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getWomenInfantVivranAPI(String _ancregid) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('_ancregid ${_ancregid}');
    var response = await post(Uri.parse(_women_infant_vivran_api), body: {
      "ANCRegID": _ancregid,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = WomenInfantDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _women_infantt_vivaran_response = resBody['ResposeData'];
        for (int i = 0; i < _women_infantt_vivaran_response.length; i++){
          if(_women_infantt_vivaran_response[i]['Child1_IsLive'].toString() != "null"){
            _childView1=true;
          }
          if(_women_infantt_vivaran_response[i]['Child2_IsLive'].toString() != "null"){
            _childView2=true;
          }
          if(_women_infantt_vivaran_response[i]['Child3_IsLive'].toString() != "null"){
            _childView3=true;
          }
          if(_women_infantt_vivaran_response[i]['Child4_IsLive'].toString() != "null"){
            _childView4=true;
          }
          if(_women_infantt_vivaran_response[i]['Child5_IsLive'].toString() != "null"){
            _childView5=true;
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: resBody['Message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black);
      }
      EasyLoading.dismiss();
      showWomenTikakaranDetailsBSheet(context);
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getChildInfantVivranAPI(String _InfantID) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('_InfantID ${_InfantID}');
    var response = await post(Uri.parse(_child_infant_vivran_api), body: {
      "InfantID": _InfantID,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = MahilaVivranData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _child_infantt_vivaran_response = resBody['ResposeData'];
      } else {
        Fluttertoast.showToast(
            msg: resBody['Message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black);
      }
      EasyLoading.dismiss();
      showSishuTikakaranDetailsBSheet(context);
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
        if (resBody['ResposeData'].length > 0) {
        }
      } else {}
    });
    return "Success";
  }



  @override
  Future<void> dispose() async {
    await EasyLoading.dismiss();
  }

  int getHelpLength() {
    if (help_response_listing.isNotEmpty) {
      return help_response_listing.length;
    } else {
      return 0;
    }
  }

  int getResLength() {
    if (_mahila_vivaran_response.isNotEmpty) {
      return _mahila_vivaran_response.length;
    } else {
      return 0;
    }
  }

  int getChildResLength() {
    if (_child_vivaran_response.isNotEmpty) {
      return _child_vivaran_response.length;
    } else {
      return 0;
    }
  }

  int getChildInfantResLength() {
    if (_child_infantt_vivaran_response.isNotEmpty) {
      return _child_infantt_vivaran_response.length;
    } else {
      return 0;
    }
  }
  int getWomenInfantResLength() {
    if (_women_infantt_vivaran_response.isNotEmpty) {
      return _women_infantt_vivaran_response.length;
    } else {
      return 0;
    }
  }
  int getANCVivranResLength() {
    if (_anc_vivaran_response.isNotEmpty) {
      return _anc_vivaran_response.length;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getMahilaVivranAPI();
    getHelpDesk();
  }
  var _visibleHeaderView=false;
  var _anmName="";
  var _districtName="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('महिला का विवरण',
            style: TextStyle(color: Colors.white, fontSize: 18)),
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Visibility(
                visible: _visibleHeaderView ,
                child: Container(
              color: ColorConstants.redTextColor,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'एएनएम :',
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 13),
                            ),
                            Text(
                              '${_anmName == "" ? "" : _anmName}',
                              style: TextStyle(
                                  color: ColorConstants.white, fontSize: 13),
                            )
                          ],
                        ),
                      )),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'संस्था :',
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 13),
                            ),
                            Text(
                              '${_districtName == "" ? "" : _districtName}',
                              style: TextStyle(
                                  color: ColorConstants.white, fontSize: 13),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DottedBorder(
                color: ColorConstants.redTextColor,
                strokeWidth: 1,
                child: Container(
                    padding: EdgeInsets.all(3),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      Strings.mahila_patikaName,
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['name'].toString() + " w/o " + _mahila_vivaran_response[0]['Husbname'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'आयु',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['Age'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${Strings.pcts_id_title}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['pctsid'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'लम्बाई',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['Height'].toString() == "null" ? "N/A" : _mahila_vivaran_response[0]['Height'].toString() + Strings.semi}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'गाँव/वार्ड ',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['VillageName'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'मोबाइल नं.',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        //child: Text('${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['Mobileno'].toString()}',
                                        child: Text('${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['Mobileno'].toString() == "null" ? "N/A" : _mahila_vivaran_response[0]['Mobileno'].toString().substring(0, 2) + "******" + _mahila_vivaran_response[0]['Mobileno'].toString().substring(8, 10)}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'बी.पी.एल. ',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['BPL'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'जाति',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['motherCast'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'जीवित बच्चे ',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['LiveChild'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['DeathDate'].toString() == "null" ? "" : Strings.death_date}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['DeathDate'].toString() == "null" ? "" : _mahila_vivaran_response[0]['DeathDate'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['ReasonName'].toString() == "null" ? "" : Strings.death_reason}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 14),
                                    )),
                                  ],
                                )
                              ],
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[0]['ReasonName'].toString() == "null" ? "" : _mahila_vivaran_response[0]['ReasonName'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))
                                  ],
                                )
                              ],
                            )),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Container(
              color: ColorConstants.lifebgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 30,
                    color: ColorConstants.redTextColor,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'महिला का विवरण ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          'पंजीकरण की तिथि ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'प्रसव की तिथि ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'डिस्चार्ज तिथि ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'एएनसी संख्या ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'पीएनसी संख्या ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'जीवित बच्चे ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 14),
                        ))),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 1,
                  ),
                  Container(
                    color: ColorConstants.white,
                    width: double.infinity,
                    child: _myListView(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: ColorConstants.lifebgColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 30,
                    color: ColorConstants.redTextColor,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'शिशु का विवरण',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.white, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          'शिशु का नाम  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 12),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'जन्म तिथि ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 12),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Container(
                            width: 50,
                            child: Center(
                                child: Text(
                              'शिशु का लिंग ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.AppColorPrimary,
                                  fontSize: 12),
                            ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          'शिशु पीसीटीएस आईडी ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 12),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: VerticalDivider(
                            width: 0,
                            color: ColorConstants.app_yellow_color,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 1,
                  ),
                  Container(
                    color: ColorConstants.white,
                    width: double.infinity,
                    child: _ItemBuilder2(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getResLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _womenInfantList() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getWomenInfantResLength(),
            itemBuilder: _womenInfantItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _ancVivranList() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getANCVivranResLength(),
            itemBuilder: _ancVivranItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }

  Widget _ItemBuilder2() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getChildResLength(),
            itemBuilder: _inflateItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }

  var _childView1=false;
  var _childView2=false;
  var _childView3=false;
  var _childView4=false;
  var _childView5=false;
  Widget _womenInfantItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: _childView1,
                child: Container(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                            '${_women_infantt_vivaran_response.length == 0 ? "" : getFormattedDate(_women_infantt_vivaran_response[index]['PNCDate'].toString())}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ))),
                  VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                            '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['PNCComp'].toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: VerticalDivider(
                      width: 0,
                      color: ColorConstants.app_yellow_color,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                            '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['ChildName1'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['ChildName1'].toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: VerticalDivider(
                      width: 0,
                      color: ColorConstants.app_yellow_color,
                      thickness: 2,
                    ),
                  ),
                  Container(
                      width: 50,
                      margin: EdgeInsets.all(3),
                      child: Center(
                          child: Text(
                            '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['Child1_Weight'].toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorConstants.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: VerticalDivider(
                      width: 0,
                      color: ColorConstants.app_yellow_color,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.all(3),
                          child: Center(
                              child: Text(
                                '${_women_infantt_vivaran_response.length == 0 ? "" :
                                _women_infantt_vivaran_response[index]['Child1_IsLive'].toString() == "null" ?
                                "" : _women_infantt_vivaran_response[index]['Child1_IsLive'].toString() == "2" ?
                                Strings.death_shishu : _women_infantt_vivaran_response[index]['ChildName1'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['Child1_Compl'].toString()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              )))
                  ),
                ],
              ),
            )),
            Divider(
              height: 0,
              color: ColorConstants.app_yellow_color,
              thickness: 1,
            ),
            Visibility(
                visible: _childView2,
                child: Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(child: Text(''),),
                    Expanded(child: Text(''),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['ChildName2'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['ChildName2'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Container(
                        width: 50,
                        margin: EdgeInsets.all(3),
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['Child2_Weight'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.all(3),
                            child: Center(
                                child: Text(
                                  '${_women_infantt_vivaran_response.length == 0 ? "" :
                                  _women_infantt_vivaran_response[index]['Child2_IsLive'].toString() == "null" ?
                                  "" : _women_infantt_vivaran_response[index]['Child2_IsLive'].toString() == "2" ?
                                  Strings.death_shishu : _women_infantt_vivaran_response[index]['Child2_Compl'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['Child2_Compl'].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstants.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                )))
                    ),
                  ],
                ),
            )),
            Divider(
              height: 0,
              color: ColorConstants.app_yellow_color,
              thickness: 1,
            ),
            Visibility(
                visible: _childView3,
                child: Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(child: Text(''),),
                    Expanded(child: Text(''),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['ChildName3'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['ChildName3'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Container(
                        width: 50,
                        margin: EdgeInsets.all(3),
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['Child3_Weight'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.all(3),
                            child: Center(
                                child: Text(
                                  '${_women_infantt_vivaran_response.length == 0 ? "" :
                                  _women_infantt_vivaran_response[index]['Child3_IsLive'].toString() == "null" ?
                                  "" : _women_infantt_vivaran_response[index]['Child3_IsLive'].toString() == "2" ?
                                  Strings.death_shishu : _women_infantt_vivaran_response[index]['Child3_Compl'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['Child3_Compl'].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstants.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                )))
                    ),
                  ],
                ),
            )),
            Divider(
              height: 0,
              color: ColorConstants.app_yellow_color,
              thickness: 1,
            ),
            Visibility(
                visible: _childView4,
                child: Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(child: Text(''),),
                    Expanded(child: Text(''),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['ChildName4'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['ChildName4'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Container(
                        width: 50,
                        margin: EdgeInsets.all(3),
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['Child4_Weight'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.all(3),
                            child: Center(
                                child: Text(
                                  '${_women_infantt_vivaran_response.length == 0 ? "" :
                                  _women_infantt_vivaran_response[index]['Child4_IsLive'].toString() == "null" ?
                                  "" : _women_infantt_vivaran_response[index]['Child4_IsLive'].toString() == "2" ?
                                  Strings.death_shishu : _women_infantt_vivaran_response[index]['Child4_Compl'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['Child4_Compl'].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstants.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                )))
                    ),
                  ],
                ),
            )),
            Divider(
              height: 0,
              color: ColorConstants.app_yellow_color,
              thickness: 1,
            ),
            Visibility(
                visible: _childView5,
                child: Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(child: Text(''),),
                    Expanded(child: Text(''),),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['ChildName5'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['ChildName5'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Container(
                        width: 50,
                        margin: EdgeInsets.all(3),
                        child: Center(
                            child: Text(
                              '${_women_infantt_vivaran_response.length == 0 ? "" : _women_infantt_vivaran_response[index]['Child5_Weight'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: VerticalDivider(
                        width: 0,
                        color: ColorConstants.app_yellow_color,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.all(3),
                            child: Center(
                                child: Text(
                                  '${_women_infantt_vivaran_response.length == 0 ? "" :
                                  _women_infantt_vivaran_response[index]['Child5_IsLive'].toString() == "null" ?
                                  "" : _women_infantt_vivaran_response[index]['Child5_IsLive'].toString() == "2" ?
                                  Strings.death_shishu : _women_infantt_vivaran_response[index]['Child5_Compl'].toString() == "null" ? "" : _women_infantt_vivaran_response[index]['Child5_Compl'].toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstants.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                )))
                    ),
                  ],
                ),
            )),
            Divider(
              height: 0,
              color: ColorConstants.app_yellow_color,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Container(
            color: ColorConstants.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                        '${_mahila_vivaran_response.length == 0 ? "" : getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        '${_mahila_vivaran_response.length == 0 ? "" : getFormattedDate(_mahila_vivaran_response[index]['deliveryDate'].toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[index]['DischargeDT'].toString() == "null" ? "" : getFormattedDate(_mahila_vivaran_response[index]['DischargeDT'].toString())}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          if (_mahila_vivaran_response[index]['anccount']
                                  .toString() ==
                              "0") {
                            Fluttertoast.showToast(
                                msg: "no data found",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          } else {
                            getANCVivranAPI(
                                _mahila_vivaran_response[index]['ANCRegID']
                                    .toString());
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.all(3),
                            color: ColorConstants.lifebgColor,
                            child: Center(
                                child: Text(
                              '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[index]['anccount'].toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.redTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ))),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: (){
                              if (_mahila_vivaran_response[index]['pnccount']
                                  .toString() ==
                                  "0") {
                                Fluttertoast.showToast(
                                    msg: "no data found",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              } else {
                                //show pnc  data
                                getWomenInfantVivranAPI(
                                    _mahila_vivaran_response[index]['ANCRegID']
                                        .toString());
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.all(3),
                                color: ColorConstants.lifebgColor,
                                child: Center(
                                    child: Text(
                                      '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[index]['pnccount'].toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorConstants.redTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        '${_mahila_vivaran_response.length == 0 ? "" : _mahila_vivaran_response[index]['outcome'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: ColorConstants.app_yellow_color,
                  thickness: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inflateItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Container(
            color: ColorConstants.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                        '${_child_vivaran_response == null ? "" : _child_vivaran_response[index]['ChildName'].toString() == "null" ? "" : _child_vivaran_response[index]['ChildName'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        '${getFormattedDate(_child_vivaran_response[index]['Birth_date'])}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.AppColorPrimary,
                            fontSize: 12),
                      ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Container(
                        width: 50,
                        child: Center(
                            child: Text(
                          '${_child_vivaran_response[index]['Sex'] == 1 ? Strings.boy_title : _child_vivaran_response[index]['Sex'] == 2 ? Strings.girl_title : _child_vivaran_response[index]['Sex'] == 3 ? Strings.transgender : ""}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 12),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          getChildInfantVivranAPI(_child_vivaran_response[index]['infantid'].toString());
                        },
                        child: Container(
                            margin: EdgeInsets.all(3),
                            color: ColorConstants.lifebgColor,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '${_child_vivaran_response[index]['childid']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.redTextColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: ColorConstants.app_yellow_color,
                  thickness: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Show Shishu Vivran BottomSheet Popup
  void showSishuTikakaranDetailsBSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return showSishuTikakaranDetailsItemBSheet(context, state);
          });
        });
  }

  showSishuTikakaranDetailsItemBSheet(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: ColorConstants.AppColorPrimary,
              height: 30,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    width: 50,
                    child: Container(
                      color: ColorConstants.redTextColor,
                      padding: EdgeInsets.all(5),
                      width: 30,
                      child: Container(
                          child: Center(
                        child: Text(
                          '${Strings.sishu_vivran}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.all(3.0),
              child: DottedBorder(
                color: ColorConstants.redTextColor,
                strokeWidth: 1,
                child: Container(
                    padding: EdgeInsets.all(3),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      Strings.shishu_ka_naam,
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 12),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_child_infantt_vivaran_response.length == 0 ? "" : _child_infantt_vivaran_response[0]['ChildName'].toString() == "null" ? "-" : _child_infantt_vivaran_response[0]['ChildName'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${Strings.shishu_ki_ling}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 12),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_child_infantt_vivaran_response.length == 0 ? "" : _child_infantt_vivaran_response[0]['Sex'].toString() == "null" ? "-" : _child_infantt_vivaran_response[0]['Sex'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${Strings.shishu_ka_weight2}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 12),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_child_infantt_vivaran_response.length == 0 ? "" : _child_infantt_vivaran_response[0]['Weight'].toString() == "null" ? "-" : _child_infantt_vivaran_response[0]['Weight'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${Strings.blood_group}',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 12),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_child_infantt_vivaran_response.length == 0 ? "" : _child_infantt_vivaran_response[0]['BloodGroup'].toString() == "null" ? "-" : _child_infantt_vivaran_response[0]['BloodGroup'].toString()}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${Strings.shishu_ki_janam_tithi} ',
                                      style: TextStyle(
                                          color: ColorConstants.AppColorPrimary,
                                          fontSize: 12),
                                    )),
                                    Expanded(
                                        child: Text(
                                      '${_child_infantt_vivaran_response.length == 0 ? "" : _child_infantt_vivaran_response[0]['Birth_date'].toString() == "null" ? "-" : getFormattedDate(_child_infantt_vivaran_response[0]['Birth_date'].toString())}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ))
                                  ],
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Row(
                                  children: [],
                                )
                              ],
                            ))
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Container(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    '${Strings.tikai_ka_naam}',
                    style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.AppColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 1,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${Strings.tikai_ki_tithi}',
                    style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.AppColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 1,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${Strings.tikai_ka_naam}',
                    style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.AppColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 1,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${Strings.tikai_ki_tithi}',
                    style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.AppColorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
          ),
          Container(
            //height: 300,
            //height: MediaQuery.of(context).size.height / 2,
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (9 / 1),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  reverse: true,
                  shrinkWrap: true,
                  children: List.generate(getChildInfantResLength(), (index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: ColorConstants.app_yellow_color)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                '${_child_infantt_vivaran_response[index]['immuname']}',
                                style: TextStyle(
                                    fontSize: 11, color: ColorConstants.black),
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              child: VerticalDivider(
                                width: 0,
                                color: ColorConstants.app_yellow_color,
                                thickness: 1,
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                '${getFormattedDate(_child_infantt_vivaran_response[index]['immudate'])}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _child_infantt_vivaran_response[index]['tagname'].toString() == "R" ?
                                    ColorConstants.redTextColor :
                                    _child_infantt_vivaran_response[index]['tagname'].toString() == "G" ?
                                    ColorConstants.green_text :
                                    _child_infantt_vivaran_response[index]['tagname'].toString() == "B" ?
                                    ColorConstants.AppColorPrimary :
                                    ColorConstants.black),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }),
                )),
          ),
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 10,
                        height: 10,
                        color: ColorConstants.redTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                          child: Text('टीका जो नहीं लगा ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12))),
                    )
                  ]),
                )),
                Expanded(
                    child: Container(
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 10,
                        height: 10,
                        color: ColorConstants.textBlueColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                          child: Text('टीका समय के बाद लगा ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12))),
                    )
                  ]),
                )),
                Expanded(
                    child: Container(
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 10,
                        height: 10,
                        color: ColorConstants.AppColorPrimary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Center(
                          child: Text(
                        'टीका समय पर लगा',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      )),
                    )
                  ]),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  //Show Mahila Vivran BottomSheet Popup
  void showANCVivranDetailsBSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return showANCVivranItemBSheet(context, state);
          });
        });
  }

  showANCVivranItemBSheet(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: ColorConstants.AppColorPrimary,
              height: 30,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                        width: 50,
                        child: Container(
                          color: ColorConstants.redTextColor,
                          padding: EdgeInsets.all(5),
                          width: 30,
                          child: Container(
                              child: Center(
                                child: Text(
                                  '${Strings.anc_ka_vivran}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: Text(
                          '${Strings.anc_ki_tithi}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '${Strings.tt_ki_date}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '${Strings.IFA_title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '${Strings.high_risk_case}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '${Strings.weight_kilograa}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          '${Strings.blood_preshour_title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.AppColorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const Divider(color: ColorConstants.dark_yellow_color,height: 2,),
          _ancVivranList()
        ],
      ),
    );
  }
  Widget _ancVivranItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Container(
            color: ColorConstants.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                                '${_anc_vivaran_response.length == 0 ? "" : getFormattedDate(_anc_vivaran_response[index]['ANCDate'].toString())}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.AppColorPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                                '${_anc_vivaran_response.length == 0 ? "" : _anc_vivaran_response[index]['TT1'].toString() == "null" ? _anc_vivaran_response[index]['TT2'].toString() == "null" ? _anc_vivaran_response[index]['TTB'].toString() == "null" ? "" : getFormattedDate(_anc_vivaran_response[index]['TTB'].toString()) : getFormattedDate(_anc_vivaran_response[index]['TT2'].toString()) : getFormattedDate(_anc_vivaran_response[index]['TT1'].toString())}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.AppColorPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                                '${_anc_vivaran_response.length == 0 ? "" : _anc_vivaran_response[index]['HB'].toString() == "null" ? "" : _anc_vivaran_response[index]['HB'] <= 7.0 ? "360" : "180"}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.AppColorPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(child: Container(
                          margin: EdgeInsets.all(3),
                          child: Center(
                              child: Text(
                                '${_anc_vivaran_response.length == 0 ? "" : _anc_vivaran_response[index]['HB'].toString() == "null" ? "" : _anc_vivaran_response[index]['HB'] <= 7.0 ? Strings.yes : Strings.no}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.AppColorPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ))),),
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.all(3),
                              child: Center(
                                  child: Text(
                                    '${_anc_vivaran_response.length == 0 ? "" : _anc_vivaran_response[index]['weight'].toString()}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorConstants.AppColorPrimary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  ))))
                      ,
                      Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: VerticalDivider(
                          width: 0,
                          color: ColorConstants.app_yellow_color,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.all(3),
                              child: Center(
                                  child: Text(
                                    '${_anc_vivaran_response.length == 0 ? "" : _anc_vivaran_response[index]['BloodPressureS'].toString()  == "null" ? "":_anc_vivaran_response[index]['BloodPressureS'].toString()+"/"+_anc_vivaran_response[index]['BloodPressureD'].toString()}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorConstants.AppColorPrimary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  ))))
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: ColorConstants.app_yellow_color,
                  thickness: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }




  void showWomenTikakaranDetailsBSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return showWomenTikakaranDetailsItemBSheet(context, state);
          });
        });
  }

  showWomenTikakaranDetailsItemBSheet(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: ColorConstants.AppColorPrimary,
              height: 30,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    width: 50,
                    child: Container(
                      color: ColorConstants.redTextColor,
                      padding: EdgeInsets.all(5),
                      width: 30,
                      child: Container(
                          child: Center(
                        child: Text(
                          '${Strings.pnc_vivran}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    ),
                  ))
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                        child: Text('${Strings.pncDate}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ))),
                VerticalDivider(
                  width: 0,
                  color: ColorConstants.app_yellow_color,
                  thickness: 2,
                ),
                Expanded(
                    child: Center(
                        child: Text('${Strings.prasav_jatilta}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Center(
                          child: Text('${Strings.shishu_ka_naam}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Container(
                    width: 50,
                    margin: EdgeInsets.all(3),
                    child: Center(
                        child: Text('${Strings.weight_kilograa}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorConstants.AppColorPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: VerticalDivider(
                    width: 0,
                    color: ColorConstants.app_yellow_color,
                    thickness: 2,
                  ),
                ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.all(3),
                        child: Text('${Strings.shishu_compli}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorConstants.AppColorPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),)

                )),
              ],
            ),
          ),
          const Divider(color: ColorConstants.dark_yellow_color,height: 2,),
          _womenInfantList(),
        ],
      ),
    );
  }

  ShowAboutAppDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AboutAppDialoge(),
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
}
