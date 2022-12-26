import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcts/ui/hbyc/model/SavedHBYCDetailsData.dart';
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
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../prasav/model/GetBlockListData.dart';
import '../prasav/model/GetDistrictListData.dart';
import '../prasav/model/TreatmentListData.dart';
import '../samparksutra/samparksutra.dart';
import '../shishudeath/model/GetDeathDetailsData.dart';
import '../shishudeath/model/GetDeathReasonListData.dart';
import '../shishutikakan/model/AddNewTikaKaranData.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/GetMotherDeathReasonListData.dart';



class MotherDeathDetailsScreen extends StatefulWidget {
  const MotherDeathDetailsScreen({Key? key,
    required this.pctsID,
    required this.MotherID,
    required this.StatusMother,
    required this.CheckWhere,
  }) : super(key: key);
  final String pctsID;
  final String MotherID;
  final String StatusMother;
  final String CheckWhere;

  @override
  State<MotherDeathDetailsScreen> createState() => _MotherDeathDetailsScreen();
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
String parseTODateFormat(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  // var outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  var outputFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
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



class _MotherDeathDetailsScreen extends State<MotherDeathDetailsScreen> {
  var _anmName="";
  var _topHeaderName="";
  late String dreasonId = "0";
  late String dsubreasonId = "0";
  late String aashaId = "0";
  late String tikaCode= "";
  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;


  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _get_death_details_url = AppConstants.app_base_url + "PostMotherDataforMaternalDeath";
  var _get_death_reason_list_url = AppConstants.app_base_url + "getMaternalDeathReason";
  var _get_death_sub_reason_list_url = AppConstants.app_base_url + "PostDeathOtherReason";
  var _add_new_tikakaran_api = AppConstants.app_base_url + "PostImmunizationDetail";

  var _add_mother_details_url = AppConstants.app_base_url + "PostMotherDeathDetails";
  var _edit_mother_details_url = AppConstants.app_base_url + "PutMotherDeathDetails";

  var _get_remaining_tikai_list_api = AppConstants.app_base_url + "uspManageImmunizationListForAdd";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postfillBlock";
  var _get_chchc_list = AppConstants.app_base_url + "postfillCHCPHC";
  var _get_upswasthya_list = AppConstants.app_base_url + "postfillSubcenter";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];


  late SharedPreferences preferences;
  List<CustomReasonList> custom_reason_list = [];
  List<CustomSubReasonList> custom_subreason_list = [];
  List<CustomAashaList> custom_aasha_list = [];
  List<CustomTikaiList> custom_tikai_list = [];
  List tikai_response_list = [];
  List response_list = [];
  List aasha_response_list = [];
  List dreason_response_list = [];
  List dsubreason_response_list = [];
  var UpdateUserNo="";
  var Media="";
  var PartImmu="1";
  var ANMVerify="";
  var IMMDate_post="";
  var finalIds="";
  var BFeed="";
  var BCGIMMU="";
  var _DeathUnitCode="0";
  var _DeathUnittype="";
  var dateReportPostDate="";
  var _prasavDate="";
  var _registerDate="";
  TextEditingController _tikaDDdateController = TextEditingController();
  TextEditingController _tikaMMdateController = TextEditingController();
  TextEditingController _tikaYYYYdateController = TextEditingController();

  TextEditingController _reportDDdateController = TextEditingController();
  TextEditingController _reportMMdateController = TextEditingController();
  TextEditingController _reportYYYYdateController = TextEditingController();

  TextEditingController _enterChildWeight = TextEditingController();

  TextEditingController _enterChildNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  TextEditingController _navjatshishuWeightController = TextEditingController();
  TextEditingController _mukhiyaNameController = TextEditingController();
  TextEditingController _mukhiyaMobNoController = TextEditingController();

 /* Future<String> getRemainingTikaiListAPI() async {

    preferences = await SharedPreferences.getInstance();

    print('LoginUnitID ${preferences.getString('UnitID')}');
    print('login-unit-code ${preferences.getString('UnitCode')}');

    var response = await post(Uri.parse(_get_remaining_tikai_list_api), body: {
      "LoginUnitcode": preferences.getString('UnitCode'),
      "SaveImmuCodeList": "[2],[3],[5],[1],[31],[32],[8],[11],[33],[13],[14],[15],[16],[17],[30],[29]",
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
  }*/

  bool isClickableEnableDisable=true;
  bool finalButtonView=true;
  bool deathPlaceView=false;
  bool referSansthaView=false;
  bool referJilaView=false;
  bool referBlockView=false;
  bool sapraView=false;
  bool upSwasthyaKendraView=false;
  var _deathPostDate="";
  var _reportdeathPostDate="";
  var Prasav_date="";
  var change_title=Strings.block;
  var change_title2=Strings.sa_pra_dispensary;
  bool _isItAsha=false;
  Future<String> getDeathDetailsAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_death_details_url), body: {
      "MotherID": widget.MotherID,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetDeathDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        print('res.len  ${response_list.length}');
        print('res.ashaautoid  ${response_list[0]['ashaautoid'].toString()}');
        aashaId=response_list[0]['ashaautoid'].toString();

        Prasav_date=response_list[0]['Prasav_date'].toString() == "null" ? "" :response_list[0]['Prasav_date'].toString();
        _VillageAutoID=response_list[0]['VillageAutoID'].toString();
        ANMVerify=response_list[0]['ANMVerify'].toString() == "null" ? "" :response_list[0]['ANMVerify'].toString();
        getAashaListAPI(response_list[0]['RegUnitid'].toString(),response_list[0]['VillageAutoID'].toString());
        getDistrictListAPI("3");

        _registerDate=response_list[0]['regdate'].toString();
        _prasavDate=response_list[0]['Prasav_date'].toString();
        print('_prasavDate_value $_prasavDate');
        print('_prasavDate_aashaId $aashaId');

        if(preferences.getString("AppRoleID").toString() == '33'){
          aashaId = preferences.getString('ANMAutoID').toString();
          _isItAsha=true;
        }else{
          aashaId = response_list[0]['ashaautoid'].toString();
          _isItAsha=false;
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getDeathReasonListAPI() async {

    preferences = await SharedPreferences.getInstance();

    var response = await get(Uri.parse(_get_death_reason_list_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetMotherDeathReasonListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_reason_list.clear();
        dreason_response_list = resBody['ResposeData'];
       // custom_reason_list
         //   .add(CustomReasonList(ReasonName:Strings.choose, ReasonID: "0",DeathType: "0"));

        for (int i = 0; i < dreason_response_list.length; i++) {
          custom_reason_list.add(CustomReasonList(
              ReasonName: dreason_response_list[i]['ReasonName'].toString(),
              ReasonID: dreason_response_list[i]['ReasonID'].toString(),
              DeathType: dreason_response_list[i]['DeathType'].toString()
          ));
        }
        dreasonId=response_list[0]['ParentReasonId'].toString() == "null" ? "0" : response_list[0]['ParentReasonId'].toString();
        print('dreasonId $dreasonId');
        //dreasonId = custom_reason_list[0].ReasonID.toString();
      } else {
        _showErrorPopup(apiResponse.message.toString(), ColorConstants.AppColorPrimary);
      }
      if(dreasonId != "0")
        getDeathSubReasonListAPI(dreasonId,"update");
    });
    print('responseee:${apiResponse.message}');
    return "Success";
  }

  var _Flag="0";//0 deafult, 1= for fave, 2= update

  Future<String> getDeathSubReasonListAPI(String _parentReasonId,String _type) async {

    preferences = await SharedPreferences.getInstance();

    var response = await post(Uri.parse(_get_death_sub_reason_list_url)
        //ParentReasonId:69
      // Flag:0
      // TokenNo:8fee200c-21ff-4f9f-8828-c02a7a56c63a
      // UserID:0101010020201
        , body: {
          "ParentReasonId": _parentReasonId,
          "Flag": _Flag,
          "TokenNo": preferences.getString('Token'),
          "UserID": preferences.getString('UserId')
        }
    );
    var resBody = json.decode(response.body);
    final apiResponse = GetMotherDeathReasonListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_subreason_list.clear();
        dsubreason_response_list = resBody['ResposeData'];
        custom_subreason_list
            .add(CustomSubReasonList(ReasonName:Strings.choose, ReasonID: "0",DeathType: "0"));

        for (int i = 0; i < dsubreason_response_list.length; i++) {
          custom_subreason_list.add(CustomSubReasonList(
              ReasonName: dsubreason_response_list[i]['ReasonName'].toString(),
              ReasonID: dsubreason_response_list[i]['ReasonID'].toString(),
              DeathType: dsubreason_response_list[i]['DeathType'].toString()
          ));
        }
        if(widget.CheckWhere == "post"){
          if(_parentReasonId == "0"){
            dsubreasonId = custom_subreason_list[0].ReasonID.toString();
          }else{
            dsubreasonId=response_list[0]['ReasonID'].toString() == "null" ? "0" : response_list[0]['ReasonID'].toString();
          }
        }else{
          if(_type == "post"){
            dsubreasonId =  custom_subreason_list[0].ReasonID.toString();
          }else{
            dsubreasonId = response_list[0]['ReasonID'].toString() == "null" ? "0" : response_list[0]['ReasonID'].toString();
          }

        }

      } else {
        _showErrorPopup(apiResponse.message.toString(), ColorConstants.AppColorPrimary);
      }
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getAashaListAPI(String _RegUnitid,String _villageautoid) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_aasha_list_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "DelplaceUnitid": "0",
      "RegUnitid": _RegUnitid,
      "VillageAutoid": _villageautoid,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_aasha_list.clear();
        aasha_response_list = resBody['ResposeData'];
        custom_aasha_list.add(CustomAashaList(ASHAName: Strings.choose, ASHAAutoid: "0"));
        for (int i = 0; i < aasha_response_list.length; i++) {
          custom_aasha_list.add(CustomAashaList(
              ASHAName: aasha_response_list[i]['ASHAName'].toString(),
              ASHAAutoid: aasha_response_list[i]['ASHAAutoid'].toString()));
        }
        //aashaId = custom_aasha_list[0].ASHAAutoid.toString();
      }
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  List response_district_list= [];
  List response_block_list= [];
  List response_chpch_list= [];

  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomBlockCodeList> custom_block_list = [];
  List<CustomCHCPHCList> custom_chcph_list = [];
  List<CustomUPSwasthyaList> custom_upswasthya_list = [];

  var _selectedDistrictUnitCode = "0000";
  var _selectedBlockUnitCode = "000000";
  var _selectedCHPhcCode = "0";
  var _selectedUpSwasthyaCode = "0";

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
  Future<GetDistrictListData> getDistrictListAPI(String refUnitType) async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_district_list_url), body: {
      //RefUnittype:3
      // TokenNo:730c8ec9-d70b-44a1-b68e-0f5cfe7e3957
      // UserID:0101010020201
      "RefUnittype": refUnitType,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = TreatmentListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_district_list = resBody['ResposeData'];
        custom_district_list.clear();
        custom_district_list.add(CustomDistrictCodeList(unitcode: "0000", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_district_list.length; i++) {
          custom_district_list.add(CustomDistrictCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedDistrictUnitCode = custom_district_list[0].unitcode.toString();
        print('API _selectedDistrictUnitCode ${_selectedDistrictUnitCode}');
        print('disctict.len ${custom_district_list.length}');
      } else {
        custom_district_list.clear();
        print('disctict.len ${custom_district_list.length}');
      }

      setPreviousData();
    //  EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }
  var _Action="";
  var blockValue=0;
  Future<String> getBlockListAPI(String refUnitType,String refUnitCode) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('refUnitType $refUnitType');
    print('referUnitCode $refUnitCode');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_block_list_url), body: {
      //TokenNo:8fee200c-21ff-4f9f-8828-c02a7a56c63a
      // UserID:0101010020201
      // DeathUnittype:4
      // DeathUnitCode:0101
      "DeathUnittype": refUnitType,
      "DeathUnitCode": refUnitCode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    //print('res.body ${response.body.toString()}');
    List<dynamic> x2 = jsonDecode(response.body.toString());
   // print(x2[0]);
    setState(() {
      custom_block_list.clear();
      custom_block_list.add(CustomBlockCodeList( UnitID:"0", UnitName:Strings.choose,UnitCode: "000000"));
      for (int i = 0; i < x2.length; i++) {
        custom_block_list.add(CustomBlockCodeList(UnitID:x2[i]['UnitID'].toString(),//{UnitID: 216, UnitName: अरॉई, UnitCode: 01010600000}
            UnitName:x2[i]['UnitName'].toString(),
            UnitCode:x2[i]['UnitCode'].toString()));
      }
      _selectedBlockUnitCode = custom_block_list[0].UnitCode.toString();
      print('_selectedBlockUnitCode ${_selectedBlockUnitCode}');
      print('block.len ${custom_block_list.length}');

      //Set Block Last Selected Item
      if(_DeathUnitCode != "0"){
        for (int i = 0; i < custom_block_list.length; i++) {
          if(custom_block_list[i].UnitCode.toString().substring(0,6) == _DeathUnitCode.substring(0, 6)){
            _selectedBlockUnitCode=custom_block_list[i].UnitCode.toString();
            _postDeathUnitID=_selectedBlockUnitCode;
          }
        }
        for (int pos = 0; pos < custom_block_list.length; pos++) {
          if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode.toString()){
            print('selected positions ${pos}');
            blockValue=pos;
            break;
          }
        }
        if(blockValue == 0){
          _Action="2";
          getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
        }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" ||_selectedReferSanstha == "16"){
          _Action="1";
          getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
        }else if(_selectedReferSanstha == "11"){
          if(blockValue == 0){
            _Action="2";
            getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);

          }else{
            _Action="3";
            getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
          }
        }else{
          _Action="1";
          getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
        }
      }
      //print('CheckValue blist.len ${custom_block_list.length}');
      /*print('CheckValue last ${_DeathUnitCode.substring(0, 6)}');


      for (int pos = 0; pos < custom_block_list.length; pos++) {
        if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode){
          //print('selected position ${pos}');
          blockValue=pos;
          break;
        }
      }
      print('prev_refer_sanstha $_selectedReferSanstha');
      if(blockValue == 0){
        _Action="2";
        getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
      }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" ||_selectedReferSanstha == "16"){
        _Action="1";
        getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
      }else if(_selectedReferSanstha == "11"){
        if(blockValue == 0){
          _Action="2";
          getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);

        }else{
          _Action="3";
          getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
        }
      }else{
        _Action="1";
        getCHPHCListAPI(_DeathUnitCode,_DeathUnittype, _Action);
      }*/

      EasyLoading.dismiss();
    });

    return "Success";
  }

  Future<String> getCHPHCListAPI(String _id,String _code,String _Action) async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    print('requestVal -dunicode ${_DeathUnitCode}');
    print('requestVal -dunittype ${_DeathUnittype}');
    print('requestVal -act ${_Action}');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_chchc_list), body: {
      //DeathUnitCode:01010100202
      // DeathUnittype:11
      // action:1
      // TokenNo:8fee200c-21ff-4f9f-8828-c02a7a56c63a
      // UserID:0101010020201
      "DeathUnitCode": _code,
      "DeathUnittype": _id,
      "action": _Action,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    //print('res.body ${response.body.toString()}');
    List<dynamic> x2 = jsonDecode(response.body.toString());
    // print(x2[0]);
    setState(() {
      if(x2.length > 0){
        custom_chcph_list.clear();
        custom_chcph_list.add(CustomCHCPHCList(UnitCode: "000000000", UnitName:Strings.choose,UnitID: "0"));
        for (int i = 0; i < x2.length; i++) {
          custom_chcph_list.add(CustomCHCPHCList(UnitCode: x2[i]['UnitCode'].toString(),UnitName: x2[i]['UnitName'].toString(),UnitID:x2[i]['UnitID'].toString()));
        }
        _selectedCHPhcCode = custom_chcph_list[0].UnitCode.toString();
        print('_selectedCHPhcCode ${_selectedCHPhcCode}');
        print('chphc.len ${custom_chcph_list.length}');




      }else{
        custom_chcph_list.clear();
        //print('chphc.len ${custom_chcph_list.length}');
      }
    //  EasyLoading.dismiss();
    });
    return "Success";
  }

  Future<String> getUpSwasthyaListAPI(String _id,String _code) async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    print('requestVal -dunicode ${_DeathUnitCode}');
    print('requestVal -dunittype ${_DeathUnittype}');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_upswasthya_list), body: {
      "DeathUnitCode": _code,
      "DeathUnittype": _id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
   // print('res.body ${response.body.toString()}');
    List<dynamic> x2 = jsonDecode(response.body.toString());
    // print(x2[0]);
    setState(() {
      if(x2.length > 0){
        custom_upswasthya_list.clear();
        custom_upswasthya_list.add(CustomUPSwasthyaList(UnitCode: "000000000", UnitName:Strings.choose,UnitID: "0"));
        for (int i = 0; i < x2.length; i++) {
          custom_upswasthya_list.add(CustomUPSwasthyaList(UnitCode: x2[i]['UnitCode'].toString(),UnitName: x2[i]['UnitName'].toString(),UnitID:x2[i]['UnitID'].toString()));
        }
        _selectedUpSwasthyaCode = custom_upswasthya_list[0].UnitCode.toString();
        //print('_selectedUpSwasthyaCode ${_selectedUpSwasthyaCode}');
        //print('upswasthya.len ${custom_upswasthya_list.length}');
        /*
        * Set Last UP Swasthaya Value
        * */
        /*for (int i = 0; i < custom_upswasthya_list.length; i++) {
          if(custom_upswasthya_list[i].UnitCode.toString() == _DeathUnitCode){
            _selectedUpSwasthyaCode=custom_upswasthya_list[i].UnitCode.toString();
          }
        }*/

      }else{
        custom_upswasthya_list.clear();
        //print('swasthya.len ${custom_upswasthya_list.length}');
      }
    //  EasyLoading.dismiss();
    });
    return "Success";
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



  @override
  void initState() {
    super.initState();
    ///_getLocation();
    getDeathDetailsAPI();
  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();


  var _selectedAgeCategory = "चुनें";
  List<CustomAgeCategoryList> age_categories_list = [
    CustomAgeCategoryList(
      title: "चुनें",
    ),
    CustomAgeCategoryList(
      title: "वर्ष",
    ),
    CustomAgeCategoryList(
      title: "माह",
    ),
    CustomAgeCategoryList(
      title: "सप्ताह",
    ),
    CustomAgeCategoryList(
      title: "दिन",
    ),
    CustomAgeCategoryList(
      title: "घंटे",
    )
  ];
  var _selectedBloodGroup= "चुनें";
  List<CustomBloodGroupList> blood_group_list = [
    CustomBloodGroupList(
      title: "चुनें",
    ),
    CustomBloodGroupList(
      title: "O+",
    ),
    CustomBloodGroupList(
      title: "O-",
    ),
    CustomBloodGroupList(
      title: "A+",
    ),
    CustomBloodGroupList(
      title: "A-",
    ),
    CustomBloodGroupList(
      title: "B+",
    ),
    CustomBloodGroupList(
      title: "B-",
    ),
    CustomBloodGroupList(
      title: "AB-",
    )
  ];
  var _selectedDeathPlace= "0";
  List<CustomDeathPlaceList> death_place_list = [
    CustomDeathPlaceList(
      title: "चुनें",
      code: "0"
    ),
    CustomDeathPlaceList(
      title: "घर पर",
      code: "1"
    ),
    CustomDeathPlaceList(
      title: "सरकारी / निजी चिकित्सा संस्थान पर",
      code: "2"
    ),
    CustomDeathPlaceList(
      title: "अन्य स्थान",
      code: "3"
    ),
    CustomDeathPlaceList(
      title: "अन्य राज्य",
      code: "4"
    )
  ];
  var _selectedReferSanstha= "0";
  List<CustomReferSansthaList> refer_sanstha_list = [
    CustomReferSansthaList(
      title: "चुनें",
      code: "0"
    ),
    CustomReferSansthaList(
      title: "जिला अस्पताल ",
      code: "6"
    ),
    CustomReferSansthaList(
      title: "मेडिकल कॉलेज",
      code: "7"
    ),
    CustomReferSansthaList(
      title: "सेटेलाईट अस्पताल",
      code: "5"
    ),
    CustomReferSansthaList(
      title: "उप जिला अस्पताल ",
      code: "8"
    ),
    CustomReferSansthaList(
      title: "सा.स्वा.केन्द्र ",
      code: "9"
    ),
    CustomReferSansthaList(
      title: "प्रा.स्वा.केन्द्र ",
      code: "10"
    ),
    CustomReferSansthaList(
      title: "डिस्पेंसरी",
      code: "13"
    ),
    CustomReferSansthaList(
      title: "अन्य सरकारी अस्पताल",
      code: "15"
    ),
    CustomReferSansthaList(
      title: "उपकेन्द्र",
      code: "11"
    ),
    CustomReferSansthaList(
      title: "Private Accre Hospital",
      code: "16"
    ),
    CustomReferSansthaList(
      title: "Private Non Accre Hospital",
      code: "17"
    )
  ];
  var wifeOfHusbandName="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
     // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(Strings.mother_kai_death_vivran_title,
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
      body: SingleChildScrollView(
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
                          Strings.pcts_id,
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
                          widget.pctsID,
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
                          Strings.village,
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
                          response_list.length == 0 ? "" :  response_list[0]['Address'].toString(),
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
                          Strings.mahila_ka_naam,
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
                          response_list.length == 0 ? "" :  response_list[0]['Name'].toString(),
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
                          Strings.patiKaName,
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
                          response_list.length == 0 ? "" :  response_list[0]['Husbname'].toString(),
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
                          Strings.MobileNumber,
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
                          response_list.length == 0 ? "" :  response_list[0]['Mobileno'].toString(),
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )),
                ],
              ),
            ),
            const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
            SizedBox(
              height: 20,
            ),
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
                                      child: Text(
                                        item.ASHAName.toString(),
                                        //Names that the api dropdown contains
                                        style: TextStyle(
                                          fontSize: 12.0,
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
                        value: aashaId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),


            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        color: Colors.white,
                        child: RichText(
                          text: TextSpan(
                              text: Strings.prasav_ki_tithi,
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
                      child:Container(
                        color: Colors.white,
                        child: RichText(
                          text: TextSpan(
                              text: '${response_list.length == 0 ? "" : getFormattedDate(response_list[0]['Prasav_date'].toString())}',
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
                      ))
                ],
              ),
            ),



            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child:  Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: RichText(
                            text: TextSpan(
                                text: Strings.owner_name,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10))
                                ]),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        margin: EdgeInsets.all(3),
                        height: 30,
                        child: Container(
                            height: 36,
                            child:TextField(

                              keyboardType: TextInputType.text,
                              maxLength: 20,
                              maxLines: 1,
                              controller: _mukhiyaNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                new EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                filled: true,
                                fillColor: ColorConstants.transparent,
                                hintText: Strings.owner_name,
                                counterText: ''
                              ),
                              onChanged: (text) {
                                //_hbCount=text.trim();
                                print('diastolic $text');
                              },
                            )),
                      ))
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child:  Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: RichText(
                            text: TextSpan(
                                text: Strings.owner_mo_num,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10))
                                ]),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        margin: EdgeInsets.all(3),
                        height: 30,
                        child: Container(
                            height: 36,
                            child:TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: _mukhiyaMobNoController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                new EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                filled: true,
                                fillColor: ColorConstants.transparent,
                                hintText: Strings.owner_mo_num,
                                counterText: ''
                              ),
                              onChanged: (text) {
                                //_hbCount=text.trim();
                                print('diastolic $text');
                              },
                            )),
                      ))
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              child: Row(
                children:<Widget> [
                  Expanded(child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        Strings.age,
                        style: TextStyle(
                            color: Colors.black, fontSize: 13),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Row(
                    children: [
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black)),
                          padding: EdgeInsets.all(1),
                          child: Form(
                            key: _formKey2,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              controller: ageController,
                              decoration: InputDecoration(
                                  hintText: Strings.age,
                                  contentPadding: EdgeInsets.zero,
                                  counterText: ''
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
                        )),
                        Expanded(child: Container())
                    ],
                  ),
                      )),
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
                            text: Strings.death_date,
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_tikaDDdateController.text.toString().length == 2 && _tikaMMdateController.text.toString().length == 2 && _tikaYYYYdateController.text.toString().length == 4){
                                    _selectANCDatePopupCustom(_tikaYYYYdateController.text.toString()+"-"+_tikaMMdateController.text.toString()+"-"+_tikaDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_tikaDDdateController.text.toString().length == 2 && _tikaMMdateController.text.toString().length == 2 && _tikaYYYYdateController.text.toString().length == 4){
                                    _selectANCDatePopupCustom(_tikaYYYYdateController.text.toString()+"-"+_tikaMMdateController.text.toString()+"-"+_tikaDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_tikaDDdateController.text.toString().length == 2 && _tikaMMdateController.text.toString().length == 2 && _tikaYYYYdateController.text.toString().length == 4){
                                    _selectANCDatePopupCustom(_tikaYYYYdateController.text.toString()+"-"+_tikaMMdateController.text.toString()+"-"+_tikaDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
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

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Strings.death_reason,
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
                        items: custom_reason_list.map((item) {
                          return DropdownMenuItem(

                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          item.ReasonName.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.ReasonID
                                  .toString() //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: _ReasonListEnableDisable ? (String? newVal) {
                          setState(() {
                            dreasonId = newVal!;
                            print('dreasonId:$dreasonId');
                            getDeathSubReasonListAPI(dreasonId,"post");
                          });
                        } : null,
                        value:
                        dreasonId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Strings.death_subreason,
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
                        items: custom_subreason_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          item.ReasonName.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.ReasonID
                                  .toString() //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: _SubReasonListEnableDisable ? (String? newVal) {
                          setState(() {
                            dsubreasonId = newVal!;
                            print('dsubreasonId:$dsubreasonId');
                          });
                        } : null,
                        value:
                        dsubreasonId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                      ),
                    ),
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
                            text: Strings.report_date,
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
                                controller: _reportDDdateController,
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_reportDDdateController.text.toString().length == 2 && _reportMMdateController.text.toString().length == 2 && _reportYYYYdateController.text.toString().length == 4){
                                    _selectReportDatePopupCustom(_reportYYYYdateController.text.toString()+"-"+_reportMMdateController.text.toString()+"-"+_reportDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
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
                                controller: _reportMMdateController,
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_reportDDdateController.text.toString().length == 2 && _reportMMdateController.text.toString().length == 2 && _reportYYYYdateController.text.toString().length == 4){
                                    _selectReportDatePopupCustom(_reportYYYYdateController.text.toString()+"-"+_reportMMdateController.text.toString()+"-"+_reportDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
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
                                controller: _reportYYYYdateController,
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
                                onChanged: (value){
                                  print('value $value');
                                  if(_reportDDdateController.text.toString().length == 2 && _reportMMdateController.text.toString().length == 2 && _reportYYYYdateController.text.toString().length == 4){
                                    _selectReportDatePopupCustom(_reportYYYYdateController.text.toString()+"-"+_reportMMdateController.text.toString()+"-"+_reportDDdateController.text.toString()+" 00:00:00.000");
                                  }
                                }
                              ),
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectReportDatePopup();
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
              height: 5,
            ),

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Strings.death_place,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: deathPlaceView,
                child: Container(
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
                        items: death_place_list.map((item) {
                          return DropdownMenuItem(

                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          item.title.toString(),
                                          //Names that the api dropdown contains
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.code
                                  .toString() //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedDeathPlace = newVal!;
                            print('_selectedDeathPlace:$_selectedDeathPlace');
                            if(_selectedDeathPlace == "0"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                            }else if(_selectedDeathPlace == "1"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              sapraView=false;
                              upSwasthyaKendraView=false;
                              _postDeathUnitID=preferences.getString("UnitCode").toString();
                            }else if(_selectedDeathPlace == "2"){
                              referSansthaView=true;
                              referJilaView=true;
                              referBlockView=true;
                            }else if(_selectedDeathPlace == "3"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              _postDeathUnitID=preferences.getString("UnitCode").toString();
                            }else if(_selectedDeathPlace == "4"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              _postDeathUnitID=preferences.getString("UnitCode").toString();
                            }
                          });
                        },
                        value: _selectedDeathPlace,
                      ),
                    ),
                  )
                ],
              ),
            )),

            Visibility(
                visible: referSansthaView,
                child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.sanstha_type,
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
                                      items: refer_sanstha_list.map((item) {
                                        return DropdownMenuItem(

                                            child: Row(
                                              children: [
                                                new Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(
                                                        item.title.toString(),
                                                        //Names that the api dropdown contains
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            value: item.code.toString() //Id that has to be passed that the dropdown has.....
                                        );
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          _selectedReferSanstha = newVal!;
                                          print('_selectedReferSanstha:$_selectedReferSanstha');

                                          if(_selectedReferSanstha == "0" || _selectedReferSanstha == "17"){
                                          referJilaView=false;
                                          referBlockView=false;
                                          sapraView=false;
                                          upSwasthyaKendraView=false;
                                          _postDeathUnitID=preferences.getString("UnitCode").toString();
                                          }else if(_selectedReferSanstha == "11"){
                                            change_title=Strings.block;
                                            change_title2=Strings.sa_pra_dispensary;
                                            referJilaView=true;
                                            referBlockView=true;
                                            sapraView=true;
                                            upSwasthyaKendraView=true;
                                          }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16"){
                                            for(int i=0 ;i<refer_sanstha_list.length; i++) {
                                              if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
                                                change_title2=refer_sanstha_list[i].title.toString();
                                              }
                                            }
                                            change_title=Strings.block;
                                            referJilaView=true;
                                            referBlockView=true;
                                            sapraView=true;
                                            upSwasthyaKendraView=false;
                                          }else{
                                            for(int i=0 ;i<refer_sanstha_list.length; i++) {
                                               if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
                                                 change_title=refer_sanstha_list[i].title.toString();
                                               }
                                            }
                                            referJilaView=true;
                                            referBlockView=true;
                                            sapraView=false;
                                            upSwasthyaKendraView=false;
                                          }
                                        });
                                      },
                                      value: _selectedReferSanstha,
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
              visible: referJilaView,
              child: Container(
              child: Column(
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          Strings.refer_jila,
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
                                                  fontSize: 12.0,
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
                                  _selectedDistrictUnitCode = newVal!;
                                  print('distrcode:$_selectedDistrictUnitCode');

                                  if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" ||
                                      _selectedReferSanstha == "10" ||_selectedReferSanstha == "11" ||
                                      _selectedReferSanstha == "16"){
                                    getBlockListAPI("4",_selectedDistrictUnitCode.substring(0, 4));
                                  }else{
                                    getBlockListAPI(_selectedReferSanstha,_selectedDistrictUnitCode.substring(0, 4));
                                  }
                                });
                              },
                              value: _selectedDistrictUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                visible:referBlockView ,
                child: Container(child: Column(
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '$change_title',
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
                          width:
                          (MediaQuery.of(context).size.width - 10),
                          // width: 411.42857142857144-10,
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
                                              child: Text(
                                                item.UnitName.toString(),
                                                //Names that the api dropdown contains
                                                style: TextStyle(
                                                  fontSize: 12.0,
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
                                  _selectedBlockUnitCode = newVal!;
                                  print('blockcode:$_selectedBlockUnitCode');
                                  _postDeathUnitID=_selectedBlockUnitCode;

                                  if(_selectedBlockUnitCode == "000000"){

                                  }else{

                                  }
                                  // _ReferUnitCode=_selectedBlockUnitCode;

                                  for (int pos = 0; pos < custom_block_list.length; pos++) {
                                    if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode){
                                      print('selected position ${pos}');
                                      blockValue=pos;
                                      break;
                                    }
                                  }
                                  for (int pos = 0; pos < custom_block_list.length; pos++) {
                                    if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode){
                                      //print('selected position ${pos}');
                                      blockValue=pos;
                                      break;
                                    }
                                  }
                                  print('prev_refer_sanstha $_selectedReferSanstha');
                                  if(blockValue == 0){
                                    _Action="2";
                                    getCHPHCListAPI(_selectedReferSanstha,_selectedBlockUnitCode.substring(0,4),_Action);
                                  }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" ||_selectedReferSanstha == "16"){
                                    _Action="1";
                                    getCHPHCListAPI(_selectedReferSanstha,_selectedBlockUnitCode.substring(0,4),_Action);
                                  }else if(_selectedReferSanstha == "11"){
                                    if(blockValue == 0){
                                      _Action="2";
                                      getCHPHCListAPI(_selectedReferSanstha,_selectedBlockUnitCode.substring(0,4), _Action);

                                    }else{
                                      _Action="3";
                                      getCHPHCListAPI(_selectedReferSanstha,_selectedBlockUnitCode.substring(0,4),_Action);
                                    }
                                  }else{
                                    _Action="1";
                                    getCHPHCListAPI(_selectedReferSanstha,_selectedBlockUnitCode.substring(0,4),_Action);
                                  }


                                });
                              },
                              value: _selectedBlockUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
            ),)),
            Visibility(
                visible:sapraView ,
                child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '$change_title2',
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
                            width:
                            (MediaQuery.of(context).size.width - 10),
                            // width: 411.42857142857144-10,
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
                                items: custom_chcph_list.map((item) {
                                  return DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          new Flexible(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(2.0),
                                                child: Text(
                                                  item.UnitName.toString(),
                                                  //Names that the api dropdown contains
                                                  style: TextStyle(
                                                    fontSize: 12.0,
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
                                    _selectedCHPhcCode = newVal!;
                                    print('_selectedCHPhcCode:$_selectedCHPhcCode');
                                    _postDeathUnitID=_selectedCHPhcCode;
                                    getUpSwasthyaListAPI(_selectedReferSanstha,_selectedCHPhcCode.substring(0,9));
                                  });
                                },
                                value: _selectedCHPhcCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                visible:upSwasthyaKendraView,
                child: Container(child: Column(children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          Strings.up_swasthya,
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
                          width:
                          (MediaQuery.of(context).size.width - 10),
                          // width: 411.42857142857144-10,
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
                              items: custom_upswasthya_list.map((item) {
                                return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Flexible(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(2.0),
                                              child: Text(
                                                item.UnitName.toString(),
                                                //Names that the api dropdown contains
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    value: item.UnitCode.toString() //Id that has to be passed that the dropdown has.....
                                  //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                );
                              }).toList(),
                              onChanged:(String? newVal) {
                                setState(() {
                                  _selectedUpSwasthyaCode = newVal!;
                                  print('_selectedUpSwasthyaCode:$_selectedUpSwasthyaCode');
                                  _postDeathUnitID=_selectedUpSwasthyaCode;
                                });
                              },
                              value: _selectedUpSwasthyaCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


            ]),)),
            SizedBox(
              height: 20,
            ),
            Visibility(
                visible: finalButtonView,
                child: GestureDetector(
              onTap: (){

                postValidateData();
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  color: ColorConstants.AppColorPrimary,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: finalButtonText,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
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

  var finalButtonText=Strings.vivran_save_krai;
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
                  thickness: 2,
                  color: Colors.black

              )
            ],
          ),
        ),
      ),
    );
  }
  var _postDeathUnitID="";

  void postValidateData() {

    if(_mukhiyaNameController.text.isEmpty){
      _showErrorPopup(Strings.owner_name,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaMobNoController.text.isEmpty){
      _showErrorPopup(Strings.owner_mo_num,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaMobNoController.text.isEmpty){
      _showErrorPopup(Strings.owner_mo_num,ColorConstants.AppColorPrimary);
    }else if(_tikaDDdateController.text.isEmpty){
      _showErrorPopup("कृप्या माता की मृत्यु की दिनांक डालें",ColorConstants.AppColorPrimary);
    }else if(_tikaMMdateController.text.isEmpty){
      _showErrorPopup("कृप्या माता की मृत्यु की दिनांक डालें",ColorConstants.AppColorPrimary);
    }else if(_tikaYYYYdateController.text.isEmpty){
      _showErrorPopup("कृप्या माता की मृत्यु की दिनांक डालें",ColorConstants.AppColorPrimary);
    }else if(dreasonId == "0" || dreasonId.isEmpty){
      _showErrorPopup(Strings.choose_death_reason,ColorConstants.AppColorPrimary);
    }else if(dsubreasonId == "0" || dsubreasonId.isEmpty){
      _showErrorPopup(Strings.choose_death_reason,ColorConstants.AppColorPrimary);
    }else if(_reportDDdateController.text.isEmpty){
      _showErrorPopup(Strings.choose_mother_death_date,ColorConstants.AppColorPrimary);
    }else if(_reportMMdateController.text.isEmpty){
      _showErrorPopup(Strings.choose_mother_death_date,ColorConstants.AppColorPrimary);
    }else if(_reportYYYYdateController.text.isEmpty){
      _showErrorPopup(Strings.choose_mother_death_date,ColorConstants.AppColorPrimary);
    }else if(_selectedDeathPlace == "0" || _selectedDeathPlace.isEmpty){
      _showErrorPopup(Strings.choose_death_place,ColorConstants.AppColorPrimary);
    }else if(_selectedDeathPlace == "2" && _selectedReferSanstha == "0"){
      _showErrorPopup("कृप्या संस्था का प्रकार चुनें !",ColorConstants.AppColorPrimary);
    }else if(_selectedReferSanstha != "17" && _selectedDeathPlace == "2" && _selectedDistrictUnitCode == "0000"){
      _showErrorPopup(Strings.choose_refer_jila,ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "5" || _selectedReferSanstha == "6" || _selectedReferSanstha == "7" || _selectedReferSanstha == "13" || _selectedReferSanstha == "15") && blockValue == 0){
      print('inside A');
      _showErrorPopup("कृप्या "+Strings.block+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "5") && blockValue == 0){
      print('inside B');
      _showErrorPopup("कृप्या "+Strings.block+" चुनें !",ColorConstants.AppColorPrimary);
    }else if(_postDeathUnitID == "0000000000"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16") && _selectedCHPhcCode == "0"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16") && _selectedCHPhcCode == "0"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && blockValue == 0){
      _showErrorPopup("कृप्या "+Strings.block+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && _selectedCHPhcCode == "0000000000"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && _selectedUpSwasthyaCode == "0"){
      _showErrorPopup("कृप्या "+Strings.up_swasthya+" चुनें !",ColorConstants.AppColorPrimary);
    }else{
      if(!_DeathDeath.isEmpty){
        putDataAPI();
      }else{
        postDataAPI();
      }
    }

  }

  var _UpdateUserNo="";// set value for api request
  var _ReasonListEnableDisable=true;
  var _SubReasonListEnableDisable=true;
  var _SaPraEnableDisable=true;
  var _ReasonID="";
  var _DeathReportDate="";
  var _IPAddress="";
  var _VillageAutoID="";

  void postDataAPI() {
    if(preferences.getString("AppRoleID") == "33"){
      Media="2";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isEmpty){
      Media ="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isNotEmpty){
        if(ANMVerify == "0"){
          Media ="3";
          _UpdateUserNo=preferences.getString("UserNo").toString();
        }else{
          Media ="1";
          _UpdateUserNo=preferences.getString("UserNo").toString();
        }
    }else{
      Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }

    if(_SubReasonListEnableDisable == true){
      _ReasonID=dsubreasonId;
    }else{
      _ReasonID=dreasonId;
    }

    if (_tikaDDdateController.text.isNotEmpty) {
      _DeathDeath=_tikaYYYYdateController.text.toString()+"/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
    }

    if (_reportDDdateController.text.isNotEmpty) {
      _DeathReportDate=_reportYYYYdateController.text.toString()+"/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
    }

    if(_selectedReferSanstha == "17"){
      _selectedDeathPlace="17";
    }
    print('UpdateRequest=>'
        'LoginUserID:${preferences.getString('UserId').toString()+
        "DeathUnitCode:"+_selectedDeathPlace == "2" ? _postDeathUnitID : "0"+
        "motherid:"+widget.MotherID+
        "Name:"+response_list[0]['Name'].toString()+
        "ReasonID:"+_ReasonID+
        "Age:"+ageController.text.toString().trim()+
        "DeathDate:"+_DeathDeath+
        "deathPlace:"+_selectedDeathPlace+
        "VillageAutoID:"+_VillageAutoID+
        "AgeType:"+"1"+
        "DeathReportDate:"+_DeathReportDate+
        "MasterMobile:"+_mukhiyaMobNoController.text.trim().trim()+
        "Relative_Name:"+_mukhiyaNameController.text.trim().trim()+
        "ashaautoid:"+aashaId+
        "EntryUnitID:"+preferences.getString('UnitID').toString()+
        "IPAddress:"+_IPAddress+
        "AppVersion:"+"5.5.5.22"+//5.5.5.22 for testing
        "UpdateUserNo:"+_UpdateUserNo+
        "Media:"+Media+
        "EntryUserNo:"+_UpdateUserNo+
        "DeliveryDate:"+Prasav_date+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');
    callPostAPI();

  }
  Future<SavedHBYCDetailsData> callPostAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        _IPAddress=addr.address;
        print(
            'my-ip-address ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }

    var response = await post(Uri.parse(_add_mother_details_url), body: {
      "LoginUserID":preferences.getString('UserId').toString(),
      "DeathUnitCode":_selectedDeathPlace == "2" ? _postDeathUnitID : "0",
      "motherid":widget.MotherID,
      "Name":response_list[0]['Name'].toString(),
      "ReasonID":dsubreasonId != "0" ? dsubreasonId : dreasonId,
      "Age": ageController.text.toString().trim(),
      "DeathDate": _DeathDeath,
      "deathPlace": _selectedDeathPlace,
      "VillageAutoID":_VillageAutoID,
      "AgeType": "1",
      "DeathReportDate": _DeathReportDate,
      "MasterMobile":_mukhiyaMobNoController.text.trim().trim(),
      "Relative_Name": _mukhiyaNameController.text.trim().trim(),
      "ashaautoid": aashaId,
      "EntryUnitID": preferences.getString('UnitID').toString(),
      "IPAddress": _IPAddress,
      "AppVersion":"5.5.5.22",
      "UpdateUserNo": _UpdateUserNo,
      "Media":Media,
      "EntryUserNo": _UpdateUserNo,
      "DeliveryDate":Prasav_date,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SavedHBYCDetailsData.fromJson(resBody);
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
    print('response-message:${apiResponse.message}');
    return SavedHBYCDetailsData.fromJson(resBody);
  }

  void putDataAPI() {
    if(preferences.getString("AppRoleID") == "33"){
      Media="2";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isEmpty){
      Media ="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isNotEmpty){
      if(ANMVerify == "0"){
        Media ="3";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else{
        Media ="1";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }
    }else{
      Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }

    if(_SubReasonListEnableDisable == true){
      _ReasonID=dsubreasonId;
    }else{
      _ReasonID=ParentReasonId;
    }

    if (_tikaDDdateController.text.isNotEmpty) {
      _DeathDeath=_tikaYYYYdateController.text.toString()+"/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
    }

    if (_reportDDdateController.text.isNotEmpty) {
      _DeathReportDate=_reportYYYYdateController.text.toString()+"/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
    }

    if(_selectedReferSanstha == "17"){
      _selectedDeathPlace="17";
    }
    callUpdateAPI();
  }
  Future<SavedHBYCDetailsData> callUpdateAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        _IPAddress=addr.address;
        print(
            'my-ip-address ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }

    print('UpdateRequest=>'
        'LoginUserID:${preferences.getString('UserId').toString()+
        "DeathUnitCode:"+_selectedDeathPlace == "2" ? _postDeathUnitID : "0"+
        "motherid:"+widget.MotherID+
        "Name:"+response_list[0]['Name'].toString()+
        "ReasonID:"+_ReasonID+
        "Age:"+ageController.text.toString().trim()+
        "DeathDate:"+_DeathDeath+
        "deathPlace:"+_selectedDeathPlace+
        "VillageAutoID:"+_VillageAutoID+
        "AgeType:"+"1"+
        "DeathReportDate:"+_DeathReportDate+
        "MasterMobile:"+_mukhiyaMobNoController.text.trim().trim()+
        "Relative_Name:"+_mukhiyaNameController.text.trim().trim()+
        "ashaautoid:"+aashaId+
        "EntryUnitID:"+preferences.getString('UnitID').toString()+
        "IPAddress:"+_IPAddress+
        "AppVersion:"+"5.5.5.22"+
        "UpdateUserNo:"+_UpdateUserNo+
        "Media:"+Media+
        "EntryUserNo:"+_UpdateUserNo+
        "DeliveryDate:"+Prasav_date+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');

    var response = await put(Uri.parse(_edit_mother_details_url), body: {
      "LoginUserID":preferences.getString('UserId').toString(),
      "DeathUnitCode":_selectedDeathPlace == "2" ? _postDeathUnitID : "0",
      "motherid":widget.MotherID,
      "Name":response_list[0]['Name'].toString(),
      //"ReasonID":dsubreasonId != "0" ? dsubreasonId : dreasonId,
      "ReasonID":_ReasonID,
      "Age": ageController.text.toString().trim(),
      "DeathDate": _DeathDeath,
      "deathPlace": _selectedDeathPlace,
      "VillageAutoID":_VillageAutoID,
      "AgeType": "1",
      "DeathReportDate": _DeathReportDate,
      "MasterMobile":_mukhiyaMobNoController.text.trim().trim(),
      "Relative_Name": _mukhiyaNameController.text.trim().trim(),
      "ashaautoid": aashaId,
      "EntryUnitID": preferences.getString('UnitID').toString(),
      "IPAddress": _IPAddress,
      "AppVersion":"5.5.5.22",
      "UpdateUserNo": _UpdateUserNo,
      "Media":Media,
      "EntryUserNo": _UpdateUserNo,
      "DeliveryDate":Prasav_date,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SavedHBYCDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        _showSuccessPopup(apiResponse.message.toString(),ColorConstants.AppColorPrimary);
      }else if (apiResponse.appVersion == 1){
        //Redirect to play store for update
        reLoginDialog();
      }else{
        _showErrorPopup(apiResponse.message.toString(), ColorConstants.AppColorPrimary);
      }
      EasyLoading.dismiss();
    });
    print('response-message:${apiResponse.message}');
    return SavedHBYCDetailsData.fromJson(resBody);
  }

  List<CustomSelectedTikaKaranList> custom_selected_tikakaran_cvslist = [];

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
  late DateTime _selectedDate2;

  var _selectedDeathDate="";
  var initalDay = 0;
  var initalMonth = 0;
  var initalYear = 0;
  var final_diff_dates=0;
  void _selectANCDatePopupCustom(String _customHBYCDate) {

      setState(() {
        var parseCustomANCDate = DateTime.parse(getConvertRegDateFormat(_customHBYCDate));
        print('parseCustomANCDate ${parseCustomANCDate}');


        _selectedDate = parseCustomANCDate;
        print('_selectedDate $_selectedDate');//2022-12-22 00:00:00.000
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if(_prasavDate == "null"){
            _tikaDDdateController.text = getDate(formattedDate4);
            _tikaMMdateController.text = getMonth(formattedDate4);
            _tikaYYYYdateController.text = getYear(formattedDate4);
            IMMDate_post=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
            print('IMMDate_post $IMMDate_post');
            var _parseDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDate.toString()));
            _selectedDeathDate=_parseDeathDate.toString();
            print('converted_death_date $_parseDeathDate');
            print('converted_death_date2 $_selectedDeathDate');
          }else{
            var prasavDate = DateTime.parse(getConvertRegDateFormat(_prasavDate));
            print('prasavDate ${prasavDate}');//2021-03-12 00:00:00.000

            var registerDate = DateTime.parse(getConvertRegDateFormat(_registerDate));
            print('registerDate ${registerDate}');//2021-03-12 00:00:00.000

            if(selectedParsedDate.compareTo(registerDate) >= 0){
              if (selectedParsedDate.compareTo(prasavDate) >= 0)
              {
                _tikaDDdateController.text = getDate(formattedDate4);
                _tikaMMdateController.text = getMonth(formattedDate4);
                _tikaYYYYdateController.text = getYear(formattedDate4);
                IMMDate_post=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
                print('IMMDate_post $IMMDate_post');
                var _parseDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDate.toString()));
                _selectedDeathDate=_parseDeathDate.toString();
                print('converted_death_date $_parseDeathDate');
                print('converted_death_date2 $_selectedDeathDate');
              }else{
                _showErrorPopup(Strings.death_date_after_prasav, ColorConstants.AppColorPrimary);
              }
            }else{
              _showErrorPopup(Strings.death_after_reg, ColorConstants.AppColorPrimary);
            }

          }
        }
      });
  }

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
        print('_selectedDate $_selectedDate');//2022-12-22 00:00:00.000
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if(_prasavDate == "null"){
            _tikaDDdateController.text = getDate(formattedDate4);
            _tikaMMdateController.text = getMonth(formattedDate4);
            _tikaYYYYdateController.text = getYear(formattedDate4);
            IMMDate_post=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
            print('IMMDate_post $IMMDate_post');
            var _parseDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDate.toString()));
            _selectedDeathDate=_parseDeathDate.toString();
            print('converted_death_date $_parseDeathDate');
            print('converted_death_date2 $_selectedDeathDate');
          }else{
            var prasavDate = DateTime.parse(getConvertRegDateFormat(_prasavDate));
            print('prasavDate ${prasavDate}');//2021-03-12 00:00:00.000

            var registerDate = DateTime.parse(getConvertRegDateFormat(_registerDate));
            print('registerDate ${registerDate}');//2021-03-12 00:00:00.000

            if(selectedParsedDate.compareTo(registerDate) >= 0){
              if (selectedParsedDate.compareTo(prasavDate) >= 0)
              {
                _tikaDDdateController.text = getDate(formattedDate4);
                _tikaMMdateController.text = getMonth(formattedDate4);
                _tikaYYYYdateController.text = getYear(formattedDate4);
                IMMDate_post=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
                print('IMMDate_post $IMMDate_post');
                var _parseDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDate.toString()));
                _selectedDeathDate=_parseDeathDate.toString();
                print('converted_death_date $_parseDeathDate');
                print('converted_death_date2 $_selectedDeathDate');
              }else{
                _showErrorPopup(Strings.death_date_after_prasav, ColorConstants.AppColorPrimary);
              }
            }else{
              _showErrorPopup(Strings.death_after_reg, ColorConstants.AppColorPrimary);
            }

          }
        }
      });
    });
  }


  void _selectReportDatePopupCustom(String _customReportDate) {

      setState(() {
        var parseCustomANCDate = DateTime.parse(getConvertRegDateFormat(_customReportDate));
        print('parseCustomANCDate ${parseCustomANCDate}');

        _selectedDate2 = parseCustomANCDate;
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate2);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate2);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var lastDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDeathDate));
          print('lastDeathDate ${lastDeathDate}');//2021-03-12 00:00:00.000

          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if (selectedParsedDate.compareTo(lastDeathDate) >= 0) //2021-04-22 00:00:00.000
          {
              _reportDDdateController.text = getDate(formattedDate4);
              _reportMMdateController.text = getMonth(formattedDate4);
              _reportYYYYdateController.text = getYear(formattedDate4);
              _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
              print('reportDeath $_reportdeathPostDate');
          }else{
            _showErrorPopup('Death Report date can not less than Death date.', ColorConstants.AppColorPrimary);
          }
        }
      });
  }

  void _selectReportDatePopup() {
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
        _selectedDate2 = pickedDate;
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate2);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate2);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var lastDeathDate = DateTime.parse(getConvertRegDateFormat(_selectedDeathDate));
          print('lastDeathDate ${lastDeathDate}');//2021-03-12 00:00:00.000

          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if (selectedParsedDate.compareTo(lastDeathDate) >= 0) //2021-04-22 00:00:00.000
          {
              _reportDDdateController.text = getDate(formattedDate4);
              _reportMMdateController.text = getMonth(formattedDate4);
              _reportYYYYdateController.text = getYear(formattedDate4);
              _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
              print('reportDeath $_reportdeathPostDate');
          }else{
            _showErrorPopup('Death Report date can not less than Death date.', ColorConstants.AppColorPrimary);
          }
        }
      });
    });
  }

  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }
  getCurrentDate2() {
     return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    //return DateFormat('yyyy/MM/dd').format(DateTime.now());
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

  void setLastSelectedData(String deathUnitCode, String deathUnittype) {
    print('deathUnitCode ${deathUnitCode}');
    print('deathUnittype ${deathUnittype}');
    setState(() {
      //Set Refer Sanstha Last Selected Item
      for (int i = 0; i < refer_sanstha_list.length; i++) {
        if(refer_sanstha_list[i].code.toString() == deathUnittype){
        _selectedReferSanstha=deathUnittype;
        }
      }


      //Set District Last Selected Item
      //print('CheckValue dis.len ${custom_district_list.length}');
      for (int i = 0; i < custom_district_list.length; i++) {
        if(custom_district_list[i].unitcode.toString().substring(0,4) == _DeathUnitCode.substring(0, 4)){
          _selectedDistrictUnitCode=custom_district_list[i].unitcode.toString();
          //print('CheckValue assign ${_selectedDistrictUnitCode}');//CheckValue assign 01010000000
        }
      }

      print('last _selectedReferSanstha ${_selectedReferSanstha}');
      //print('last _selectedDistrictUnitCode ${_selectedDistrictUnitCode.substring(0, 4)}');
      if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" ||
          _selectedReferSanstha == "10" ||_selectedReferSanstha == "11" ||
          _selectedReferSanstha == "16"){
        getBlockListAPI("4",_selectedDistrictUnitCode.substring(0, 4));
      }else{
        getBlockListAPI(_selectedReferSanstha,_selectedDistrictUnitCode.substring(0, 4));
      }

      /*
      * Set Last CHPCH Value
      * */
      for (int i = 0; i < custom_chcph_list.length; i++) {
          //print('unitcode ${custom_chcph_list[i].UnitCode.toString()}');
          if(custom_chcph_list[i].UnitCode.toString().substring(0,9) == _DeathUnitCode.substring(0, 9)){
            _selectedCHPhcCode=custom_chcph_list[i].UnitCode.toString();
          }
          print('_selectedCHPhcCode ${_selectedCHPhcCode}');
        }

    });



  }

  var ParentReasonId="";
  var _EntryDeath="";
  var _DeathDeath="";
  void setPreviousData() {

   setState(() {
     getDeathReasonListAPI();

     dreasonId=response_list[0]['ParentReasonId'].toString() == "null" ? "0" : response_list[0]['ParentReasonId'].toString();
     print('last_dreasonId $dreasonId');

     if(int.parse(dreasonId) >= 10 && int.parse(dreasonId) <= 14){
       _ReasonListEnableDisable=false;
       _SubReasonListEnableDisable=false;
     }




     if(response_list[0]['immucode'].toString() == "1"){
       _chooseimmu=colorsimmu.yes;
     }else if(response_list[0]['immucode'].toString() == "2"){
       _chooseimmu=colorsimmu.no;
     }else{
       _chooseimmu=colorsimmu.nill;
     }

     if(response_list[0]['deathPlace'].toString() == "2"){
       if(response_list[0]['deathPlaceUnittype'].toString() != "null"){
         _selectedReferSanstha=response_list[0]['deathPlaceUnittype'].toString();
         _DeathUnittype=response_list[0]['deathPlaceUnittype'].toString();
       }

       print('_selectedReferSanstha $_selectedReferSanstha');
     }



     ParentReasonId=response_list[0]['ParentReasonId'].toString() == "null" ? "0" : response_list[0]['ParentReasonId'].toString();


     _EntryDeath=response_list[0]['EntryDate'].toString();
     if(_EntryDeath == "null"){
       _Flag="1";
       finalButtonText=Strings.vivran_save_krai;
     }else{
       _Flag="2";
     }


     if(response_list[0]['DeathDate'].toString() != "null"){
       _DeathDeath=response_list[0]['DeathDate'].toString() == "null" ? "0" : response_list[0]['DeathDate'].toString();
       //print('checkDeathDate ${_DeathDeath}');
       var _hbycAPIDate= DateTime.parse(getConvertRegDateFormat(_DeathDeath));// "DeathDate": "2022-10-21T00:00:00",
       _DeathDeath=getYear(_hbycAPIDate.toString())+ "/"+getMonth(_hbycAPIDate.toString())+"/"+getDate(_hbycAPIDate.toString());
       print('_DeathDeath $_DeathDeath');
     }else{
       _DeathDeath=response_list[0]['DeathDate'].toString() == "null" ? "" : response_list[0]['DeathDate'].toString();
     }

      if(response_list[0]['EntryDate'].toString() != "null"){
        var expectedParsedDate = DateTime.parse(parseTODateFormat(_EntryDeath));
        var parseCalenderSelectedAncDate = DateTime.parse(getCurrentDate2().toString());
        final diff_lmp_ancdate =parseCalenderSelectedAncDate.difference(expectedParsedDate).inDays;
        if (diff_lmp_ancdate <= 30) {
          print('equal to current date');
          finalButtonView=true;
          finalButtonText=Strings.vivran_update_krai;
        }else{
          print('lesser');
          finalButtonView=false;
          _showErrorPopup(Strings.DaysMsg_30_mother, ColorConstants.AppColorPrimary);
        }
      }

     _selectedDeathPlace=response_list[0]['deathPlace'].toString() == "null" ? "0" :response_list[0]['deathPlace'].toString();

     setState(() {
       deathPlaceView=true;
       print('_selectedDeathPlace:$_selectedDeathPlace');
       if(_selectedDeathPlace == "0"){
         referSansthaView=false;
         referJilaView=false;
         referBlockView=false;
       }else if(_selectedDeathPlace == "1"){
         referSansthaView=false;
         referJilaView=false;
         referBlockView=false;
         sapraView=false;
         upSwasthyaKendraView=false;
         _postDeathUnitID=preferences.getString("UnitCode").toString();
       }else if(_selectedDeathPlace == "2"){
         referSansthaView=true;
         referJilaView=true;
         referBlockView=true;
         print('_selReferSanstha:$_selectedReferSanstha');
         _selectedReferSanstha=_DeathUnittype;
         print('_selRefSanstha:$_selectedReferSanstha');
         if(_selectedReferSanstha == "0" || _selectedReferSanstha == "17"){
           referJilaView=false;
           referBlockView=false;
           sapraView=false;
           upSwasthyaKendraView=false;
           _postDeathUnitID=preferences.getString("UnitCode").toString();
         }else if(_selectedReferSanstha == "11"){
           change_title=Strings.block;
           change_title2=Strings.sa_pra_dispensary;
           referJilaView=true;
           referBlockView=true;
           sapraView=true;
           upSwasthyaKendraView=true;

         }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16"){
           for(int i=0 ;i<refer_sanstha_list.length; i++) {
             if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
               change_title2=refer_sanstha_list[i].title.toString();
             }
           }
           change_title=Strings.block;
           referJilaView=true;
           referBlockView=true;
           sapraView=true;
           upSwasthyaKendraView=false;
         }else{
           for(int i=0 ;i<refer_sanstha_list.length; i++) {
             if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
               change_title=refer_sanstha_list[i].title.toString();
             }
           }
           referJilaView=true;
           referBlockView=true;
           sapraView=false;
           upSwasthyaKendraView=false;
         }

         /*setState(() {
             if(_selectedReferSanstha == "0" || _selectedReferSanstha == "17"){
               referSansthaView=false;
               referJilaView=false;
               referBlockView=false;
               sapraView=false;
               upSwasthyaKendraView=false;
             }else if(_selectedReferSanstha == "11"){
               referSansthaView=true;
               referJilaView=true;
               referBlockView=true;
               upSwasthyaKendraView=true;
               sapraView=true;
             }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16"){
               referSansthaView=true;
               referJilaView=true;
               referBlockView=true;
               sapraView=true;
               upSwasthyaKendraView=false;
             }else {
               referSansthaView=false;
               referJilaView=true;
               referBlockView=true;
               upSwasthyaKendraView=false;
               sapraView=false;
             }
           });*/
       }else if(_selectedDeathPlace == "3"){
         referSansthaView=false;
         referJilaView=false;
         referBlockView=false;
         _postDeathUnitID=preferences.getString("UnitCode").toString();
       }else if(_selectedDeathPlace == "4"){
         referSansthaView=false;
         referJilaView=false;
         referBlockView=false;
         _postDeathUnitID=preferences.getString("UnitCode").toString();
       }else{
         referSansthaView=false;
         referJilaView=false;
         referBlockView=false;
       }
     });

     _enterChildNameController.text=response_list[0]['ChildName'].toString() == "null" ? "" : response_list[0]['ChildName'].toString() ;

     ageController.text=response_list[0]['Age'].toString() == "null" ? "" : response_list[0]['Age'].toString() ;

     if(response_list[0]['AgeType'].toString() != "null"){
       if(response_list[0]['AgeType'].toString() == "1"){
         _selectedAgeCategory="वर्ष";
       }else if(response_list[0]['AgeType'].toString() == "2"){
         _selectedAgeCategory="माह";
       }else if(response_list[0]['AgeType'].toString() == "3"){
         _selectedAgeCategory="सप्ताह";
       }else if(response_list[0]['AgeType'].toString() == "4"){
         _selectedAgeCategory="दिन";
       }else if(response_list[0]['AgeType'].toString() == "5"){
         _selectedAgeCategory="घंटे";
       }
     }else{
       _selectedAgeCategory="चुनें";
     }

     if(response_list[0]['BloodGroup'].toString() != "null"){

       if(response_list[0]['BloodGroup'].toString() == "1"){
         _selectedBloodGroup="O+";
       }else if(response_list[0]['BloodGroup'].toString() == "2"){
         _selectedBloodGroup="O-";
       }else if(response_list[0]['BloodGroup'].toString() == "3"){
         _selectedBloodGroup="A+";
       }else if(response_list[0]['BloodGroup'].toString() == "4"){
         _selectedBloodGroup="A-";
       }else if(response_list[0]['BloodGroup'].toString() == "5"){
         _selectedBloodGroup="B+";
       }else if(response_list[0]['BloodGroup'].toString() == "6"){
         _selectedBloodGroup="B-";
       }else if(response_list[0]['BloodGroup'].toString() == "7"){
         _selectedBloodGroup="AB-";
       }
     }else{
       _selectedBloodGroup="चुनें";
     }


     if(response_list[0]['Bfeed'].toString() != "null"){

       if(response_list[0]['Bfeed'].toString() == "1"){
         _choose=colors.yes;
       }else{
         _choose=colors.no;
       }
     }

     if(response_list[0]['immucode'].toString() != "null"){

       if(response_list[0]['immucode'].toString() == "1"){
         _chooseimmu=colorsimmu.yes;
       }else{
         _chooseimmu=colorsimmu.no;
       }
     }

     if(response_list[0]['Weight'].toString() != "null"){
       _enterChildWeight.text=response_list[0]['Weight'].toString();
     }

     if(response_list[0]['DeathDate'].toString() != "null"){

       if(response_list[0]['Relative_Name'].toString() != "null"){
         _mukhiyaNameController.text=response_list[0]['Relative_Name'].toString();
       }else{
         _mukhiyaNameController.text="";
       }

       if(response_list[0]['MasterMobile'].toString() != "null"){
         _mukhiyaMobNoController.text=response_list[0]['MasterMobile'].toString();
       }else{
         _mukhiyaMobNoController.text="";
       }

       _navjatshishuWeightController.text=response_list[0]['Weight'].toString() == "null" ? "" : response_list[0]['Weight'].toString() ;


       var deathParsedDate = DateTime.parse(getConvertRegDateFormat(response_list[0]['DeathDate'].toString()));
       print('deathParsedDate ${deathParsedDate}');

       _tikaDDdateController.text = getDate(deathParsedDate.toString());
       _tikaMMdateController.text = getMonth(deathParsedDate.toString());
       _tikaYYYYdateController.text = getYear(deathParsedDate.toString());
       _deathPostDate=_tikaYYYYdateController.text.toString()+ "/"+_tikaMMdateController.text.toString()+"/"+_tikaDDdateController.text.toString();
       print('_deathPostDate $_deathPostDate');


       var dRportParsedDate = DateTime.parse(getConvertRegDateFormat(response_list[0]['DeathReportDate'].toString()));
       print('dRportParsedDate ${dRportParsedDate}');

       _reportDDdateController.text = getDate(dRportParsedDate.toString());
       _reportMMdateController.text = getMonth(dRportParsedDate.toString());
       _reportYYYYdateController.text = getYear(dRportParsedDate.toString());
       _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
       dateReportPostDate=response_list[0]['DeathReportDate'].toString();
       print('_reportdeathPostDate $_reportdeathPostDate');



      if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32"){
        finalButtonView=true;
        if(ANMVerify == "1"){
          finalButtonText="सत्यापित किये केस को अपडेट करें";
        }else{
          finalButtonText="सत्यापित / विवरण अपडेट करें";
        }
      }else if(preferences.getString("AppRoleID") == "33"){
        if(ANMVerify == "1"){
          finalButtonText="एएनएम द्वारा सत्यापित ";
          isClickableEnableDisable=false;//clickable false if logged in via Asha or ANMVerify == 1
        }else{
          if(response_list[0]['DeathDate'].toString() == "null"){
            finalButtonView=true;
          }else{
            if(int.parse(response_list[0]['ashaautoid'].toString()) > 0 && response_list[0]['ashaautoid'].toString() == preferences.getString("ANMAutoID")){
              finalButtonView=true;
            }else if(response_list[0]['ashaautoid'].toString() == "0"){
              finalButtonView=true;
            }else{
              _showErrorPopup(Strings.show_update_msg, ColorConstants.AppColorPrimary);
              finalButtonView=false;
            }
          }
        }
      }else{
        finalButtonView=false;
       }
       wifeOfHusbandName= response_list[0]['Name']+" W/o "+response_list[0]['Husbname'];
     }else{
       wifeOfHusbandName= response_list[0]['Name']+" W/o "+response_list[0]['Husbname'];
     }

   /*  if(response_list[0]['flag'].toString() == "0"){
       _showErrorPopup(Strings.show_if_after_30_days, ColorConstants.AppColorPrimary);
       finalButtonView=false;
     }else if(response_list[0]['Freeze'].toString() == "1"){
       _showErrorPopup(Strings.show_cannot_update, ColorConstants.AppColorPrimary);
       finalButtonView=false;
     }*/

     if(response_list[0]['deathPlaceUnitcode'].toString() != "null"){
       _DeathUnitCode=response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString();

       setLastSelectedData(_DeathUnitCode,_DeathUnittype);
     }
   });
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
                      fontWeight: FontWeight.normal),
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


enum colors { nill, yes, no }
enum colorsimmu { nill, yes, no }

colors _choose = colors.nill; //radio button 1
colorsimmu _chooseimmu = colorsimmu.nill; //radio button 1

class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}
class CustomReasonList {
  String? ReasonName;
  String? ReasonID;
  String? DeathType;

  CustomReasonList({this.ReasonName, this.ReasonID, this.DeathType});
}
class CustomSubReasonList {
  String? ReasonName;
  String? ReasonID;
  String? DeathType;

  CustomSubReasonList({this.ReasonName, this.ReasonID, this.DeathType});
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
class CustomAgeCategoryList {
  String? title;

  CustomAgeCategoryList({this.title});
}
class CustomBloodGroupList {
  String? title;

  CustomBloodGroupList({this.title});
}
class CustomDeathPlaceList {
  String? title;
  String? code;

  CustomDeathPlaceList({this.title,this.code});
}
class CustomReferSansthaList {
  String? title;
  String? code;

  CustomReferSansthaList({this.title,this.code});
}
class CustomDistrictCodeList {
  String? unitcode;
  String? unitNameHindi;

  CustomDistrictCodeList({this.unitcode,this.unitNameHindi});
}
class CustomBlockCodeList {
  String? UnitID;
  String? UnitName;
  String? UnitCode;

  CustomBlockCodeList({this.UnitID,this.UnitName,this.UnitCode});
}
class CustomCHCPHCList {
  String? UnitCode;
  String? UnitName;
  String? UnitID;

  CustomCHCPHCList({this.UnitCode,this.UnitName,this.UnitID});
}
class CustomUPSwasthyaList {
  String? UnitCode;
  String? UnitName;
  String? UnitID;

  CustomUPSwasthyaList({this.UnitCode,this.UnitName,this.UnitID});
}