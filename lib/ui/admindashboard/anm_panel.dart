import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/AboutAppDialoge.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/LogoutAppDialoge.dart';
import 'package:pcts/ui/admindashboard/model/UnitTypeListData.dart';
import 'package:pcts/ui/dashboard/dashboard.dart';
import 'package:pcts/ui/samparksutra/samparksutra.dart';
import 'package:pcts/ui/videos/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/model/GetDistrictListData.dart';
import '../splashnew.dart';
import 'model/AnmBlockListData.dart';
import 'model/AnmListData.dart';
import 'model/CHCPHCListData.dart';
import 'model/GetANMLoginData.dart';
import 'model/UpkendraListData.dart';

class ANMPanelScreen extends StatefulWidget {
  const ANMPanelScreen({Key? key}) : super(key: key);

  @override
  State<ANMPanelScreen> createState() => _ANMPanelScreenState();
}

class _ANMPanelScreenState extends State<ANMPanelScreen> {

  List help_response_listing = [];
  late SharedPreferences preferences;
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _unittype_code_url = AppConstants.app_base_url + "PostUnittypeList";
  var _district_code_url = AppConstants.app_base_url + "PostDistdataAdmin";
  var _block_code_url = AppConstants.app_base_url + "PostBlockList";
  var _chcphc_code_url = AppConstants.app_base_url + "PostCHCPHC";
  var _subcentre_code_url = AppConstants.app_base_url + "postfillSubcenter1";
  var _anm_code_url = AppConstants.app_base_url + "postANMListByUnitcode";
  var _anm_login_data_url = AppConstants.app_base_url + "PostANMAutoid";

  var _selected_unit_code="0";
  var _selected_district_code="0";
  var _selected_block_code="0";
  var _selected_chcphc_code="0";
  var _selected_upkendra_code="0";
  var _selected_anm_code="0";
  var _selected_asha_autoid="0";
  var _selected_asha_phoneno="";


  var _showCHCView=false;
  var _showUpkendraView=false;
  var _dynamicTitle=Strings.sa_pra_kendra;
  List response_unitype_list= [];
  List response_district_list= [];
  List response_block_list= [];
  List response_chcphc_list= [];
  List response_upkendra_list= [];
  List response_anm_list= [];
  List response_anm_data_list= [];
  List<CustomUnitTypeCodeList> custom_unitype_list = [];
  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomBlockCodeList> custom_block_list = [];
  List<CustomCHCPHCCodeList> custom_chcphc_list = [];
  List<CustomUpkendraCodeList> custom_upkendra_list = [];
  List<CustomANMCodeList> custom_anm_list = [];

  Future<UnitTypeListData> getUnitTypeCodeListAPI() async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitCode ${preferences.getString('UnitCode')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_unittype_code_url), body: {
      "LoginUnitType": preferences.getString('UnitType'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = UnitTypeListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_unitype_list = resBody['ResposeData'];
        custom_unitype_list.clear();
        //custom_unitype_list.add(CustomUnitTypeCodeList(UnitTypeCode:"0", UnittypeNameHindi:Strings.choose));
        for (int i = 0; i < response_unitype_list.length; i++) {
          custom_unitype_list.add(CustomUnitTypeCodeList(UnitTypeCode: resBody['ResposeData'][i]['UnitTypeCode'].toString(),
              UnittypeNameHindi: resBody['ResposeData'][i]['UnittypeNameHindi'].toString()));
        }
        _selected_unit_code = custom_unitype_list[0].UnitTypeCode.toString();
       // print('_selected_unit_code ${_selected_unit_code}');
       // print('unittype_list ${custom_unitype_list.length}');
      } else {
        custom_unitype_list.clear();
        //print('unitype_list.len ${custom_unitype_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return UnitTypeListData.fromJson(resBody);
  }

  Future<GetDistrictListData> getDistrictCodeListAPI() async {
    preferences = await SharedPreferences.getInstance();
   /* print('UnitCode ${preferences.getString('UnitCode')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_district_code_url), body: {
      "UnitCode": preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString(),
      "UnitType": preferences.getString('UnitType'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetDistrictListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_district_list = resBody['ResposeData'];
        custom_district_list.clear();
        //custom_district_list.add(CustomUnitTypeCodeList(UnitTypeCode:"0", UnittypeNameHindi:Strings.choose));
        for (int i = 0; i < response_district_list.length; i++) {
          custom_district_list.add(CustomDistrictCodeList(unitcode: resBody['ResposeData'][i]['unitcode'].toString(),
              unitNameHindi: resBody['ResposeData'][i]['unitNameHindi'].toString()));
        }
        _selected_district_code = custom_district_list[0].unitcode.toString();
       // print('_dis_code ${_selected_district_code}');
        //print('dis_list ${custom_district_list.length}');
      } else {
        custom_district_list.clear();
       // print('dis_list.len ${custom_district_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }

  Future<AnmBlockListData> getBlockCodeListAPI(String _unitCode,String _unitType) async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitCode ${_unitCode}');
    print('UnitType ${_unitType}');
    print('LoginUnitCode ${preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString()}');
    print('LoginUnitType ${preferences.getString('UnitType')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_block_code_url), body: {
      //UnitType:11
      // LoginUnitCode:00000000000
      // LoginUnitType:1
      // UnitCode:01010000000
      // TokenNo:d345c03f-8681-43d3-8901-ca836ad2a617
      // UserID:sa
      "UnitCode": _unitCode,
      "UnitType": _unitType,
      "LoginUnitCode": preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString(),
      "LoginUnitType": preferences.getString('UnitType'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = AnmBlockListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_block_list = resBody['ResposeData'];
        custom_block_list.clear();
        //custom_district_list.add(CustomUnitTypeCodeList(UnitTypeCode:"0", UnittypeNameHindi:Strings.choose));
        for (int i = 0; i < response_block_list.length; i++) {
          custom_block_list.add(CustomBlockCodeList(UnitName:resBody['ResposeData'][i]['UnitName'].toString(),
              UnitCode:resBody['ResposeData'][i]['UnitCode'].toString()));
        }
        _selected_block_code = custom_block_list[0].UnitCode.toString();
       // print('_block_code ${_selected_block_code}');
       // print('block_list ${custom_block_list.length}');
      } else {
        custom_block_list.clear();
       // print('block_list.len ${custom_block_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return AnmBlockListData.fromJson(resBody);
  }

  Future<CHCPHCListData> getCHCPHCCodeListAPI(String _unitCode,String _unitType) async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitCode ${_unitCode}');
    print('UnitType ${_unitType}');
    print('LoginUnitCode ${preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString()}');
    print('LoginUnitType ${preferences.getString('UnitType')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_chcphc_code_url), body: {
      //UnitCode:01010100000
      // UnitType:11
      // LoginUnitCode:00000000000
      // LoginUnitType:1
      // TokenNo:ea116e9c-841a-4a3c-ac63-d21867f2d577
      // UserID:sa
      "UnitCode": _unitCode,
      "UnitType": _unitType,
      "LoginUnitCode": preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString(),
      "LoginUnitType": preferences.getString('UnitType'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = CHCPHCListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {

        response_chcphc_list = resBody['ResposeData'];
        custom_chcphc_list.clear();
        //custom_chcphc_list.add(CustomCHCPHCCodeList(UnitName:Strings.choose, UnitCode:"0"));
        for (int i = 0; i < response_chcphc_list.length; i++) {
          custom_chcphc_list.add(CustomCHCPHCCodeList(UnitName:resBody['ResposeData'][i]['UnitName'].toString(),
              UnitCode:resBody['ResposeData'][i]['UnitCode'].toString()));
        }
        _selected_chcphc_code = custom_chcphc_list[0].UnitCode.toString();
       // print('_chcphc_code ${_selected_chcphc_code}');
        //print('chcphc_list ${custom_chcphc_list.length}');
      } else {
        custom_chcphc_list.clear();
       // print('chcphc_list.len ${custom_chcphc_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return CHCPHCListData.fromJson(resBody);
  }

  Future<UpkendraListData> getUpkendraCodeListAPI(String _unitCode,String _unitType) async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitCode ${_unitCode}');
    print('UnitType ${_unitType}');
    print('LoginUnitCode ${preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString()}');
    print('LoginUnitType ${preferences.getString('UnitType')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_subcentre_code_url), body: {
      //UnitCode:01010100000
      // UnitType:11
      // LoginUnitCode:00000000000
      // LoginUnitType:1
      // TokenNo:ea116e9c-841a-4a3c-ac63-d21867f2d577
      // UserID:sa
      "UnitCode": _unitCode,
      "UnitType": _unitType,
      "LoginUnitCode": preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString(),
      "LoginUnitType": preferences.getString('UnitType'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = UpkendraListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {

        response_upkendra_list = resBody['ResposeData'];
        custom_upkendra_list.clear();
       // custom_upkendra_list.add(CustomUpkendraCodeList(UnitName:Strings.choose, UnitCode:"0"));
        for (int i = 0; i < response_upkendra_list.length; i++) {
          custom_upkendra_list.add(CustomUpkendraCodeList(UnitName:resBody['ResposeData'][i]['UnitName'].toString(),
              UnitCode:resBody['ResposeData'][i]['UnitCode'].toString()));
        }
        _selected_upkendra_code = custom_upkendra_list[0].UnitCode.toString();
       // print('_upkendra_code ${_selected_upkendra_code}');
        //print('upkendra_list ${custom_upkendra_list.length}');
      } else {
        custom_upkendra_list.clear();
       // print('upkendra_list.len ${custom_upkendra_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return UpkendraListData.fromJson(resBody);
  }

  Future<AnmListData> getANMCodeListAPI(String _unitCode,String _unitType) async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitCode ${_unitCode}');
    print('UnitType ${_unitType}');
    print('LoginUnitCode ${preferences.getString('UnitCode').toString().length == 0 ? "00000000000" : preferences.getString('UnitCode').toString()}');
    print('LoginUnitType ${preferences.getString('UnitType')}');
    print('unit_type ${preferences.getString('UnitType')}');*/
    var response = await post(Uri.parse(_anm_code_url), body: {
      "UnitCode": _unitCode,
      "AshaType": "2",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = AnmListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_anm_list = resBody['ResposeData'];
        custom_anm_list.clear();
       // custom_upkendra_list.add(CustomUpkendraCodeList(UnitName:Strings.choose, UnitCode:"0"));
        for (int i = 0; i < response_anm_list.length; i++) {
          custom_anm_list.add(CustomANMCodeList(AshaName:resBody['ResposeData'][i]['AshaName'].toString(),
              ashaAutoID:resBody['ResposeData'][i]['ashaAutoID'].toString(),
              AshaPhone: resBody['ResposeData'][i]['AshaPhone'].toString())
          );
        }
        _selected_anm_code = custom_anm_list[0].ashaAutoID.toString();
        print('_selected_anm_code ${_selected_anm_code}');
        print('anm_list ${custom_anm_list.length}');
      } else {
        custom_anm_list.clear();
        print('anm_list.len ${custom_anm_list.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return AnmListData.fromJson(resBody);
  }

  Future<GetANMLoginData> getANMDataAPI(String _anmAutoID) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('_anmAutoID ${_anmAutoID}');
    var response = await post(Uri.parse(_anm_login_data_url), body: {
      //UnitID:42903
      // TokenNo:d345c03f-8681-43d3-8901-ca836ad2a617
      // UserID:sa
      "UnitID": _anmAutoID,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetANMLoginData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_anm_data_list = resBody['ResposeData'];
        /*Temprory Sa Storage*/
        preferences.setString("temp_unitcode", preferences.getString("UnitCode").toString());
        preferences.setString("temp_unitid", preferences.getString("UnitID").toString());
        preferences.setString("temp_anmname", preferences.getString("ANMName").toString());
        print('temp_unitcode ${preferences.getString("temp_unitcode")}');
        print('temp_unitid ${preferences.getString("temp_unitid")}');
        print('temp_anmname ${preferences.getString("temp_anmname")}');

        //{
        //             "AshaName": "Smt. Sunita Rathor",
        //             "unitid": 18,
        //             "unitcode": "01010100202",
        //             "unitname": "Kanpura",
        //             "DistrictName": "अजमेर",
        //             "BlockName": "श्रीनगर\t",
        //             "PCHCHCName": "तिहारी\t",
        //             "PCHCHCAbbr": "PHC",
        //             "UnitAbbr": "SC",
        //             "UnitType": 11,
        //             "ANMAutoID": 42903
        //         }
        //topName=>अजमेर -> श्रीनगर	 -> Kanpura (SC)
        //userid=>c2E=
        //UnitType=>11
        // unitcode=>01010100202
        preferences.setString("UnitCode", response_anm_data_list[0]['unitcode'].toString());
        preferences.setString("DistrictName",  response_anm_data_list[0]['DistrictName'].toString());
        preferences.setString("BlockName",  response_anm_data_list[0]['BlockName'].toString());
       // preferences.setString("Token", _Token);
       // preferences.setString("AnganwariHindi", _AnganwariHindi);
        preferences.setString("UserId", preferences.getString("UserId").toString());
       // preferences.setString("AppRoleID", _AppRoleID);
       // preferences.setString("UserNo", _UserNo);
        preferences.setString("UnitType", preferences.getString("UnitType").toString());
        preferences.setString("UnitID", response_anm_data_list[0]['unitid'].toString());
        preferences.setString("ANMName", response_anm_data_list[0]['AshaName'].toString());
        preferences.setString("ANMAutoID", response_anm_data_list[0]['ANMAutoID'].toString());
        preferences.setString("UnitName", response_anm_data_list[0]['unitname'].toString());
        preferences.setString("LoginType","superadmin");

        var topName = '';
        if (response_anm_data_list[0]['DistrictName'].toString() != null) {
          topName = response_anm_data_list[0]['DistrictName'].toString();
        }

        if (response_anm_data_list[0]['BlockName'].toString() != null && response_anm_data_list[0]['BlockName'].toString() != 'null') {
          topName = topName + " -> " + response_anm_data_list[0]['BlockName'].toString();
        }
        topName = topName + " -> " + response_anm_data_list[0]['unitname'].toString() + " (" + response_anm_data_list[0]['UnitAbbr'].toString() + ")";

        print('topName:....> $topName');
        preferences.setString('topName', topName);

        //print('anm_name ${response_anm_data_list[0]['AshaName'].toString()}');
        print('UnitCode ${preferences.getString("UnitCode")}');
        print('UserId ${preferences.getString("UserId")}');
        print('UnitID ${preferences.getString("UnitID")}');
        print('ANMName ${preferences.getString("ANMName")}');


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen(),
          ),
        );

      } else {

      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetANMLoginData.fromJson(resBody);
  }



  Future<String> getHelpDesk() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
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
      }
      getUnitTypeCodeListAPI();
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
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                    children: [
                      new Image.asset(
                        'Images/pcts_logo1.png',
                        height: 60.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Image.asset(
                        'Images/nationalem.png',
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
      body: Container(
        color: ColorConstants.anmpanel_bg_color,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              color: ColorConstants.redTextColor,
              height: 30,
              child: Center(child: Text('${Strings.anm_panel}',textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.white,fontSize: 16),))
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Text('${Strings.choose_unit_type}'
                      ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                    width:
                    (MediaQuery.of(context).size.width - 10),
                    height: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Padding(
                          padding:
                          const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'Images/ic_dropdown.png',
                            height: 12,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        iconSize: 15,
                        elevation: 11,
                        //style: TextStyle(color: Colors.black),
                        style:
                        Theme.of(context).textTheme.bodyText1,
                        isExpanded: true,
                        // hint: new Text("Select State"),
                        items: custom_unitype_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Text(item.UnittypeNameHindi.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.UnitTypeCode.toString() //Id that has to be passed that the dropdown has.....
                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selected_unit_code = newVal!;
                            print('_selected_unit_code:$_selected_unit_code');
                            //getBlockListAPI(_selectedPlacesReferCode,_selectedDistrictUnitCode.substring(0, 4));
                            if(_selected_unit_code == "8" || _selected_unit_code == "9" || _selected_unit_code == "10" || _selected_unit_code == "14"){
                              _showCHCView=true;
                              _showUpkendraView=false;
                            }else if(_selected_unit_code == "11"){
                              _showCHCView=true;
                              _showUpkendraView=true;
                            }else{
                              _showCHCView=false;
                              _showUpkendraView=false;
                            }
                            getDistrictCodeListAPI();
                          });
                        },
                        value: _selected_unit_code,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Text('${Strings.choose_jila}'
                      ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                    width:
                    (MediaQuery.of(context).size.width - 10),
                    height: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Padding(
                          padding:
                          const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'Images/ic_dropdown.png',
                            height: 12,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        iconSize: 15,
                        elevation: 11,
                        //style: TextStyle(color: Colors.black),
                        style:
                        Theme.of(context).textTheme.bodyText1,
                        isExpanded: true,
                        // hint: new Text("Select State"),
                        items: custom_district_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Text(item.unitNameHindi.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.unitcode.toString() //Id that has to be passed that the dropdown has.....
                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selected_district_code = newVal!;
                            print('_selected_district_code:$_selected_district_code');
                            getBlockCodeListAPI(_selected_district_code,_selected_unit_code);
                          });
                        },
                        value: _selected_district_code,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Text('${Strings.choose_block}'
                      ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                    width:
                    (MediaQuery.of(context).size.width - 10),
                    height: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Padding(
                          padding:
                          const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'Images/ic_dropdown.png',
                            height: 12,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        iconSize: 15,
                        elevation: 11,
                        //style: TextStyle(color: Colors.black),
                        style:
                        Theme.of(context).textTheme.bodyText1,
                        isExpanded: true,
                        // hint: new Text("Select State"),
                        items: custom_block_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Text(item.UnitName.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.UnitCode.toString() //Id that has to be passed that the dropdown has.....
                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selected_block_code = newVal!;
                            print('_selected_block_code:$_selected_block_code');
                            getCHCPHCCodeListAPI(_selected_block_code,_selected_unit_code);
                          });
                        },
                        value: _selected_block_code,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _showCHCView,
              child: Container(
              child: Column(
                children:<Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          child: Text('${_dynamicTitle}'
                            ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                          width:
                          (MediaQuery.of(context).size.width - 10),
                          height: 40,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Padding(
                                padding:
                                const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  'Images/ic_dropdown.png',
                                  height: 12,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              iconSize: 15,
                              elevation: 11,
                              //style: TextStyle(color: Colors.black),
                              style:
                              Theme.of(context).textTheme.bodyText1,
                              isExpanded: true,
                              // hint: new Text("Select State"),
                              items: custom_chcphc_list.map((item) {
                                return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Flexible(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(2.0),
                                              child: Text(item.UnitName.toString(),
                                                //Names that the api dropdown contains
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    value: item.UnitCode.toString() //Id that has to be passed that the dropdown has.....
                                  //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                );
                              }).toList(),
                              onChanged: (String? newVal) {
                                setState(() {
                                  _selected_chcphc_code = newVal!;
                                  print('_selected_chcphc_code:$_selected_chcphc_code');
                                  getUpkendraCodeListAPI(_selected_chcphc_code,_selected_unit_code);
                                });
                              },
                              value: _selected_chcphc_code,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Visibility(
              visible: _showUpkendraView,
              child: Container(
              child: Column(
                children:<Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          child: Text('${Strings.up_swasthya}'
                            ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                          width:
                          (MediaQuery.of(context).size.width - 10),
                          height: 40,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Padding(
                                padding:
                                const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  'Images/ic_dropdown.png',
                                  height: 12,
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              iconSize: 15,
                              elevation: 11,
                              //style: TextStyle(color: Colors.black),
                              style:
                              Theme.of(context).textTheme.bodyText1,
                              isExpanded: true,
                              // hint: new Text("Select State"),
                              items: custom_upkendra_list.map((item) {
                                return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Flexible(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(2.0),
                                              child: Text(item.UnitName.toString(),
                                                //Names that the api dropdown contains
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    value: item.UnitCode.toString() //Id that has to be passed that the dropdown has.....
                                  //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                );
                              }).toList(),
                              onChanged: (String? newVal) {
                                setState(() {
                                  _selected_upkendra_code = newVal!;
                                  print('_selected_upkendra_code:$_selected_upkendra_code');
                                  getANMCodeListAPI(_selected_upkendra_code,_selected_unit_code);
                                });
                              },
                              value: _selected_upkendra_code,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Text('${Strings.choose_anm}'
                      ,style: TextStyle(color: ColorConstants.black,fontSize: 13),)
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
                    width:
                    (MediaQuery.of(context).size.width - 10),
                    height: 40,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Padding(
                          padding:
                          const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'Images/ic_dropdown.png',
                            height: 12,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        iconSize: 15,
                        elevation: 11,
                        //style: TextStyle(color: Colors.black),
                        style:
                        Theme.of(context).textTheme.bodyText1,
                        isExpanded: true,
                        // hint: new Text("Select State"),
                        items: custom_anm_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Text(item.AshaName.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.ashaAutoID.toString() //Id that has to be passed that the dropdown has.....
                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selected_anm_code = newVal!;
                            print('_selected_anm_code:$_selected_anm_code');
                            for (int i = 0; i < custom_anm_list.length; i++) {
                                if(_selected_anm_code == custom_anm_list[i].ashaAutoID.toString()){
                                  _selected_asha_autoid=custom_anm_list[i].ashaAutoID.toString();
                                  _selected_asha_phoneno=custom_anm_list[i].AshaPhone.toString();
                                  print('_selected_asha_phoneno:$_selected_asha_phoneno');
                                }
                            }
                            });
                        },
                        value: _selected_anm_code,


                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black)),
              child: Row(
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.call_anm}'),
                  ),),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Text('${_selected_asha_phoneno}',style: TextStyle(color: ColorConstants.AppColorDark,decoration: TextDecoration.underline,),),
                        SizedBox(width: 5,),
                        Icon(Icons.local_phone,color: ColorConstants.AppColorDark,size: 20,)
                      ],
                    ),
                  ))
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                getANMDataAPI(_selected_asha_autoid);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                height: 40,
                decoration: BoxDecoration(
                  color: ColorConstants.AppColorPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('${Strings.view_selected_anm}',textAlign: TextAlign.center,style: TextStyle(color: ColorConstants.white,fontWeight: FontWeight.normal),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getHelpDesk();
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

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
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

class CustomUnitTypeCodeList {
  String UnitTypeCode;
  String UnittypeNameHindi;

  CustomUnitTypeCodeList({required this.UnitTypeCode,required this.UnittypeNameHindi});
}
class CustomDistrictCodeList {
  String? unitcode;
  String? unitNameHindi;

  CustomDistrictCodeList({this.unitcode,this.unitNameHindi});
}
class CustomBlockCodeList {
  String? UnitName;
  String? UnitCode;

  CustomBlockCodeList({this.UnitName,this.UnitCode});
}
class CustomCHCPHCCodeList {
  String? UnitName;
  String? UnitCode;

  CustomCHCPHCCodeList({this.UnitName,this.UnitCode});
}
class CustomUpkendraCodeList {
  String? UnitName;
  String? UnitCode;

  CustomUpkendraCodeList({this.UnitName,this.UnitCode});
}
class CustomANMCodeList {
  String? AshaName;
  String? ashaAutoID;
  String? AshaPhone;

  CustomANMCodeList({this.AshaName,this.ashaAutoID,this.AshaPhone});
}
