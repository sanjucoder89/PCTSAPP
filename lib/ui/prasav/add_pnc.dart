import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../../constant/ApiUrl.dart';
import '../../constant/IosVersion.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import 'add_anc.dart';
import 'after/GetPNCDetailsData.dart';
import 'model/GetANMListData.dart';
import 'model/GetAanganBadiListData.dart';
import 'model/GetAashaListData.dart';
import 'model/GetBlockListData.dart';
import 'model/GetChildComplListData.dart';
import 'model/GetChildDetailsData.dart';
import 'model/GetDistrictListData.dart';
import 'model/SavedANCDetailsData.dart';
import 'model/SavedPNDDetailsData.dart';

class AddPNCScreen extends StatefulWidget {
  const AddPNCScreen(
      {Key? key,
        required this.pctsID,
        required this.headerName,
        required this.registered_date,
        required this.expected_date,
        required this.pnc_date,
        required this.weight,
        required this.PNCFlag,
        required this.TTB,
        required this.TT1,
        required this.TT2,
        required this.UrineA,
        required this.UrineS,
        required this.motherIdIntent,
        required this.VillageAutoID,
        required this.DeliveryComplication,
        required this.RegUnitID,
        required this.Height,
        required this.AncRegId,
        required this.RegUnittype,
        required this.Age,
        required this.DischargeDT,
        required this.DelplaceCode,
        required this.DeliveryAbortionDate,
        required this.MotherDeathDate
      })
      : super(key: key);

  final String pctsID;
  final String headerName;
  final String registered_date;
  final String expected_date;
  final String pnc_date;
  final String weight;
  final String PNCFlag;
  final String TTB;
  final String TT1;
  final String TT2;
  final String UrineA;
  final String UrineS;
  final String motherIdIntent;
  final String VillageAutoID;
  final String DeliveryComplication;
  final String RegUnitID;
  final String Height;
  final String AncRegId;
  final String RegUnittype;
  final String Age;
  final String DischargeDT;
  final String DelplaceCode;
  final String DeliveryAbortionDate;
  final String MotherDeathDate;

  @override
  State<AddPNCScreen> createState() => _AddPNCScreenState();
}

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

String getFormattedDate(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getUpdateFormatedDate(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('yyyy/MM/dd');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getAPIResponseFormattedDate(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat =
  DateFormat('yyyy-MM-dd hh:mm:ss'); //"EntryDate": "2022-03-10T00:00:00",
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

String getAPIResponseFormattedDate2(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();
  var inputFormat =
  DateFormat('yyyy-MM-dd hh:mm:ss'); //"EntryDate": "2022-03-10T00:00:00",
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('yyyy-MM-dd');
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

class _AddPNCScreenState extends State<AddPNCScreen> {

  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;

  late SharedPreferences preferences;
  /*
  * API BASE URL
  * */
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _mothercompl_list_url = AppConstants.app_base_url + "getMotherComplication";
  var _aanganbadi_list_url = AppConstants.app_base_url + "GetAanganwariByASHAAutoid";
  var _get_detail = AppConstants.app_base_url + "uspDataforManagePNC";
  var _get_childname_list_url = AppConstants.app_base_url + "postchildrendetails";
  var _childcompl_list_url = AppConstants.app_base_url + "getchildcomplication";
  var _treatmentcode_list_url = AppConstants.app_base_url + "getTretmentCode";
  var _add_post_pnc_api = AppConstants.app_base_url + "PostPNCDetail";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postBlockData";
  var _get_anm_list = AppConstants.app_base_url + "uspANMList";

  //API REQUEST PARAMETER'S

  var _PncDatePost="";
  var _PncFlag_post="";
  var _UpdateUserNo="";// set value for api request
  var _Media="";// set value for api request
  var _motherid="";// set value for api request
  var _ancRegId="";// set value for api request

  List response_district_list= [];
  List response_block_list= [];

  Future<GetDistrictListData> getDistrictListAPI(String refUnitType) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
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
    final apiResponse = GetDistrictListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_district_list = resBody['ResposeData'];
        custom_district_list.clear();
        custom_district_list.add(CustomDistrictCodeList(unitcode: "0", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_district_list.length; i++) {
          custom_district_list.add(CustomDistrictCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedDistrictUnitCode = custom_district_list[0].unitcode.toString();
        print('_selectedDistrictUnitCode ${_selectedDistrictUnitCode}');
        print('disctict.len ${custom_district_list.length}');
      } else {
        custom_district_list.clear();
        print('disctict.len ${custom_district_list.length}');
      }

      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }

  Future<GetBlockListData> getBlockListAPI(String refUnitType,String refUnitCode) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('referUnitCode $refUnitCode');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_block_list_url), body: {
      //RefUnittype:9
      // RefUnitCode:0101
      // TokenNo:730c8ec9-d70b-44a1-b68e-0f5cfe7e3957
      // UserID:0101010020201
      "RefUnittype": refUnitType,
      "RefUnitCode": refUnitCode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetBlockListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_block_list = resBody['ResposeData'];
        custom_block_list.clear();
        custom_block_list.add(CustomBlockCodeList(unitcode: "0", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_block_list.length; i++) {
          custom_block_list.add(CustomBlockCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedBlockUnitCode = custom_block_list[0].unitcode.toString();
        print('_selectedDistrictUnitCode ${_selectedBlockUnitCode}');
        print('block.len ${custom_block_list.length}');
      } else {
        _selectedBlockUnitCode="0";
        custom_block_list.clear();
        print('block.len ${custom_block_list.length}');

      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetBlockListData.fromJson(resBody);
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
    //print('live loc lat $_latitude');
   // print('live loc lng $_longitude');
    if(mounted == true){
      setState(() {
        prefs.setString("latitude", _latitude);
        prefs.setString("longitude", _longitude);
      });
    }

  }
  List<CustomChildNameList> custom_childname_list = [];
  List<CustomAashaList> custom_aasha_list = [];
  List<CustomAanganBadiList> custom_aanganbadi_list = [];
  List<CustomANMList> custom_anm_list = [];
  List<CustomMotherComplList> custom_mothercomp_list = [];

  List<CustomChildComplList> custom_childcompl_list = [];
  List<CustomChildComplList> custom_childcompl_list2 = [];
  List<CustomChildComplList> custom_childcompl_list3 = [];
  List<CustomChildComplList> custom_childcompl_list4 = [];
  List<CustomChildComplList> custom_childcompl_list5 = [];

  List response_list = [];
  List response_list2 = [];
  List response_list6 = [];
  List response_list3 = [];
  List response_list4 = [];
  List response_list5 = [];
  late String aashaId = "0";
  late String aanganBadiId = "0";
  late String anmId = "0";
  late String motherComplId = "0";
  late String childComplId_1 = "0";
  late String childComplId_2 = "0";
  late String childComplId_3 = "0";
  late String childComplId_4 = "0";
  late String childComplId_5 = "0";

  var rdChildIsLive1="";
  var rdChildIsLive2="";
  var rdChildIsLive3="";
  var rdChildIsLive4="";
  var rdChildIsLive5="";

  var rdChildIsLiveEntry1=true;
  var rdChildIsLiveEntry2=true;
  var rdChildIsLiveEntry3=true;
  var rdChildIsLiveEntry4=true;
  var rdChildIsLiveEntry5=true;

  /*var child_comp1="";
  var child_comp2="";
  var child_comp3="";
  var child_comp4="";
  var child_comp5="";*/



  var _infantid1="0";
  var _infantid2="0";
  var _infantid3="0";
  var _infantid4="0";
  var _infantid5="0";


  TextEditingController _pncDDdateController = TextEditingController();
  TextEditingController _pncMMdateController = TextEditingController();
  TextEditingController _pncYYYYdateController = TextEditingController();


  bool _shishuEnDisable = true;
  bool _shishu2EnDisable = true;
  bool _shishu3EnDisable = true;
  bool _shishu4EnDisable = true;
  bool _shishu5EnDisable = true;

  bool _shishuWgtEnDisable = false;
  bool _shishuWgt2EnDisable = false;
  bool _shishuWgt3EnDisable = false;
  bool _shishuWgt4EnDisable = false;
  bool _shishuWgt5EnDisable = false;

  TextEditingController _shishuNameController = TextEditingController();
  TextEditingController _shishu2NameController = TextEditingController();
  TextEditingController _shishu3NameController = TextEditingController();
  TextEditingController _shishu4NameController = TextEditingController();
  TextEditingController _shishu5NameController = TextEditingController();

  TextEditingController _shishuWeightController = TextEditingController();
  TextEditingController _shishuWeight2Controller = TextEditingController();
  TextEditingController _shishuWeight3Controller = TextEditingController();
  TextEditingController _shishuWeight4Controller = TextEditingController();
  TextEditingController _shishuWeight5Controller = TextEditingController();


  bool _isFirstChildLive=true;//false= dead, true=live
  bool _isSecondChildLive=true;//false= dead, true=live
  bool _isThirdChildLive=true;//false= dead, true=live
  bool _isFourthChildLive=true;//false= dead, true=live
  bool _isFifthChildLive=true;//false= dead, true=live

  Future<String> getChildNameListAPI() async {
    preferences = await SharedPreferences.getInstance();
    print('req ancrgid=> ${widget.AncRegId}');
    print('req token=> ${preferences.getString('Token')}');
    print('req userid=> ${preferences.getString('UserId')}');

    var response = await post(Uri.parse(_get_childname_list_url)
        , body: {
        "ancregid": widget.AncRegId,
        "TokenNo": preferences.getString('Token'),
        "UserID": preferences.getString('UserId')
        }
    );
    var resBody = json.decode(response.body);
    final apiResponse = GetChildDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_childname_list.clear();
        response_list5 = resBody['ResposeData'];
        print('res5.len  ${response_list5.length}');

        for (int i = 0; i < response_list5.length; i++) {
          custom_childname_list.add(CustomChildNameList(
              ChildName:response_list5[i]['ChildName'].toString() == "null" ? "" : response_list5[i]['ChildName'].toString().trim(),
              InfantID:response_list5[i]['InfantID'].toString(),
          Status:response_list5[i]['Status'].toString()));
        }

    //first time reset all radio
        setState(() {
          _shishuislive = ShihuIsLive.none;
          _shishuislive2 = ShihuIsLive2.none;
          _shishuislive3 = ShihuIsLive3.none;
          _shishuislive4 = ShihuIsLive4.none;
          _shishuislive5 = ShihuIsLive5.none;
        });


        if(custom_childname_list.length == 1) {
          if(custom_childname_list[0].Status.toString() == "2"){
            _isFirstChildLive=false;
          }else{
            _isFifthChildLive=true;
          }
        }
        if(custom_childname_list.length == 2) {
          if(custom_childname_list[0].Status.toString() == "2"){
            _isFirstChildLive=false;
          }else{
            _isFifthChildLive=true;
          }

          if(custom_childname_list[1].Status.toString() == "2"){
            _isSecondChildLive=false;
          }else{
            _isSecondChildLive=true;
          }
        }
        if(custom_childname_list.length == 3) {

          if(custom_childname_list[0].Status.toString() == "2"){
            _isFirstChildLive=false;
          }else{
            _isFifthChildLive=true;
          }

          if(custom_childname_list[1].Status.toString() == "2"){
            _isSecondChildLive=false;
          }else{
            _isSecondChildLive=true;
          }

          if(custom_childname_list[2].Status.toString() == "2"){
            _isThirdChildLive=false;
          }else{
            _isThirdChildLive=true;
          }
        }
        if(custom_childname_list.length == 4) {

          if(custom_childname_list[0].Status.toString() == "2"){
            _isFirstChildLive=false;
          }else{
            _isFifthChildLive=true;
          }

          if(custom_childname_list[1].Status.toString() == "2"){
            _isSecondChildLive=false;
          }else{
            _isSecondChildLive=true;
          }

          if(custom_childname_list[2].Status.toString() == "2"){
            _isThirdChildLive=false;
          }else{
            _isThirdChildLive=true;
          }

          if(custom_childname_list[3].Status.toString() == "2"){
            _isFourthChildLive=false;
          }else{
            _isFourthChildLive=true;
          }
        }
        if(custom_childname_list.length == 5) {

          if(custom_childname_list[0].Status.toString() == "2"){
            _isFirstChildLive=false;
          }else{
            _isFifthChildLive=true;
          }

          if(custom_childname_list[1].Status.toString() == "2"){
            _isSecondChildLive=false;
          }else{
            _isSecondChildLive=true;
          }

          if(custom_childname_list[2].Status.toString() == "2"){
            _isThirdChildLive=false;
          }else{
            _isThirdChildLive=true;
          }

          if(custom_childname_list[3].Status.toString() == "2"){
            _isFourthChildLive=false;
          }else{
            _isFourthChildLive=true;
          }

          if(custom_childname_list[4].Status.toString() == "2"){
            _isFifthChildLive=false;
          }else{
            _isFifthChildLive=true;
          }
        }

        if(custom_childname_list.length > 5){
            if(custom_childname_list[0].Status.toString() == "2"){
              _isFirstChildLive=false;
            }else{
              _isFifthChildLive=true;
            }
            if(custom_childname_list[1].Status.toString() == "2"){
              _isSecondChildLive=false;
            }else{
              _isSecondChildLive=true;
            }

            if(custom_childname_list[2].Status.toString() == "2"){
              _isThirdChildLive=false;
            }else{
              _isThirdChildLive=true;
            }

            if(custom_childname_list[3].Status.toString() == "2"){
              _isFourthChildLive=false;
            }else{
              _isFourthChildLive=true;
            }

            if(custom_childname_list[4].Status.toString() == "2"){
              _isFifthChildLive=false;
            }else{
              _isFifthChildLive=true;
            }
        }


        print('custom_childnam.len ${custom_childname_list.length}');
        if(custom_childname_list.length > 0){

          if(custom_childname_list.length == 1) {
            if (custom_childname_list[0].ChildName.toString().isNotEmpty == "" || custom_childname_list[0].ChildName.toString() != "null") {
              _shishuNameController.text = custom_childname_list[0].ChildName.toString();
              _shishuEnDisable=false;
            }

          }
          if(custom_childname_list.length == 2) {
            if (custom_childname_list[0].ChildName.toString().isNotEmpty == "" || custom_childname_list[0].ChildName.toString() != "null") {
              _shishuNameController.text = custom_childname_list[0].ChildName.toString();
              _shishuEnDisable=false;
            }

            if(custom_childname_list[1].ChildName.toString().isNotEmpty == "" || custom_childname_list[1].ChildName.toString() != "null"){
              _shishu2NameController.text = custom_childname_list[1].ChildName.toString();
              _shishu2EnDisable=false;
            }
          }
          if(custom_childname_list.length == 3) {
            if (custom_childname_list[0].ChildName.toString().isNotEmpty == "" || custom_childname_list[0].ChildName.toString() != "null") {
              _shishuNameController.text = custom_childname_list[0].ChildName.toString();
              _shishuEnDisable=false;
            }

            if(custom_childname_list[1].ChildName.toString().isNotEmpty == "" || custom_childname_list[1].ChildName.toString() != "null"){
              _shishu2NameController.text = custom_childname_list[1].ChildName.toString();
              _shishu2EnDisable=false;
            }

            if(custom_childname_list[2].ChildName.toString().isNotEmpty == "" || custom_childname_list[2].ChildName.toString() != "null"){
              _shishu3NameController.text = custom_childname_list[2].ChildName.toString();
              _shishu3EnDisable=false;
            }
          }
          if(custom_childname_list.length == 4) {
            if (custom_childname_list[0].ChildName.toString().isNotEmpty == "" || custom_childname_list[0].ChildName.toString() != "null") {
              _shishuNameController.text = custom_childname_list[0].ChildName.toString();
              _shishuEnDisable=false;
            }

            if(custom_childname_list[1].ChildName.toString().isNotEmpty == "" || custom_childname_list[1].ChildName.toString() != "null"){
              _shishu2NameController.text = custom_childname_list[1].ChildName.toString();
              _shishu2EnDisable=false;
            }

            if(custom_childname_list[2].ChildName.toString().isNotEmpty == "" || custom_childname_list[2].ChildName.toString() != "null"){
              _shishu3NameController.text = custom_childname_list[2].ChildName.toString();
              _shishu3EnDisable=false;
            }

            if(custom_childname_list[3].ChildName.toString().isNotEmpty == "" || custom_childname_list[3].ChildName.toString() != "null"){
              _shishu4NameController.text = custom_childname_list[3].ChildName.toString();
              _shishu4EnDisable=false;
            }
          }
          if(custom_childname_list.length == 5) {
            if (custom_childname_list[0].ChildName.toString().isNotEmpty == "" || custom_childname_list[0].ChildName.toString() != "null") {
              _shishuNameController.text = custom_childname_list[0].ChildName.toString();
              _shishuEnDisable=false;
            }

            if(custom_childname_list[1].ChildName.toString().isNotEmpty == "" || custom_childname_list[1].ChildName.toString() != "null"){
              _shishu2NameController.text = custom_childname_list[1].ChildName.toString();
              _shishu2EnDisable=false;
            }

            if(custom_childname_list[2].ChildName.toString().isNotEmpty == "" || custom_childname_list[2].ChildName.toString() != "null"){
              _shishu3NameController.text = custom_childname_list[2].ChildName.toString();
              _shishu3EnDisable=false;
            }

            if(custom_childname_list[3].ChildName.toString().isNotEmpty == "" || custom_childname_list[3].ChildName.toString() != "null"){
              _shishu4NameController.text = custom_childname_list[3].ChildName.toString();
              _shishu4EnDisable=false;
            }

            if(custom_childname_list[4].ChildName.toString().isNotEmpty == "" || custom_childname_list[4].ChildName.toString() != "null"){
              _shishu5NameController.text = custom_childname_list[4].ChildName.toString();
              _shishu5EnDisable=false;
            }
          }

        }
        print('check_length ${custom_childname_list.length}');
        if(custom_childname_list.length == 1) {
          if (custom_childname_list[0].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[0].ChildName.toString() != "null") {
            _infantid1 = custom_childname_list[0].InfantID.toString();
          }
          print('last_infantid1 ${_infantid1}');

          //if child first is live or not
          if(custom_childname_list[0].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishuEnDisable=false;
            _shishuWgtEnDisable=false;
            _shishuislive = ShihuIsLive.no;
            rdChildIsLive1="0";
            rdChildIsLiveEntry1=false;
          }
        }//one child
        if(custom_childname_list.length == 2) {

          if (custom_childname_list[0].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[0].ChildName.toString() != "null") {
            _infantid1 = custom_childname_list[0].InfantID.toString();
          }
          print('last_infantid1 ${_infantid1}');

          if (custom_childname_list[1].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[1].ChildName.toString() != "null") {
            _infantid2 = custom_childname_list[1].InfantID.toString();
          }
          print('last_infantid2 ${_infantid2}');

          //if child first is live or not
          if(custom_childname_list[0].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishuEnDisable=false;
            _shishuWgtEnDisable=false;
            _shishuislive = ShihuIsLive.no;
            rdChildIsLive1="0";
            rdChildIsLiveEntry1=false;
          }
          //if child sec is live or not
          if(custom_childname_list[1].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu2EnDisable=false;
            _shishuWgt2EnDisable=false;
            _shishuislive2 = ShihuIsLive2.no;
            rdChildIsLive2="0";
            rdChildIsLiveEntry2=false;
          }
        }//two child
        if(custom_childname_list.length == 3) {

          if (custom_childname_list[0].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[0].ChildName.toString() != "null") {
            _infantid1 = custom_childname_list[0].InfantID.toString();
          }
          print('last_infantid1 ${_infantid1}');

          if (custom_childname_list[1].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[1].ChildName.toString() != "null") {
            _infantid2 = custom_childname_list[1].InfantID.toString();
          }
          print('last_infantid2 ${_infantid2}');

          if (custom_childname_list[2].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[2].ChildName.toString() != "null") {
            _infantid3 = custom_childname_list[2].InfantID.toString();
          }
          print('last_infantid3 ${_infantid3}');

          //if child first is live or not
          if(custom_childname_list[0].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishuEnDisable=false;
            _shishuWgtEnDisable=false;
            _shishuislive = ShihuIsLive.no;
            rdChildIsLive1="0";
            rdChildIsLiveEntry1=false;
          }
          //if child sec is live or not
          if(custom_childname_list[1].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu2EnDisable=false;
            _shishuWgt2EnDisable=false;
            _shishuislive2 = ShihuIsLive2.no;
            rdChildIsLive2="0";
            rdChildIsLiveEntry2=false;
          }
          //if child three is live or not
          if(custom_childname_list[2].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu3EnDisable=false;
            _shishuWgt3EnDisable=false;
            _shishuislive3 = ShihuIsLive3.no;
            rdChildIsLive3="0";
            rdChildIsLiveEntry3=false;
          }

        }//three child
        if(custom_childname_list.length == 4) {

          if (custom_childname_list[0].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[0].ChildName.toString() != "null") {
            _infantid1 = custom_childname_list[0].InfantID.toString();
          }
          print('last_infantid1 ${_infantid1}');

          if (custom_childname_list[1].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[1].ChildName.toString() != "null") {
            _infantid2 = custom_childname_list[1].InfantID.toString();
          }
          print('last_infantid2 ${_infantid2}');

          if (custom_childname_list[2].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[2].ChildName.toString() != "null") {
            _infantid3 = custom_childname_list[2].InfantID.toString();
          }
          print('last_infantid3 ${_infantid3}');

          if (custom_childname_list[3].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[3].ChildName.toString() != "null") {
            _infantid4 = custom_childname_list[3].InfantID.toString();
          }
          print('last_infantid4 ${_infantid4}');

          //if child first is live or not
          if(custom_childname_list[0].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishuEnDisable=false;
            _shishuWgtEnDisable=false;
            _shishuislive = ShihuIsLive.no;
            rdChildIsLive1="0";
            rdChildIsLiveEntry1=false;
          }
          //if child sec is live or not
          if(custom_childname_list[1].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu2EnDisable=false;
            _shishuWgt2EnDisable=false;
            _shishuislive2 = ShihuIsLive2.no;
            rdChildIsLive2="0";
            rdChildIsLiveEntry2=false;
          }
          //if child three is live or not
          if(custom_childname_list[2].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu3EnDisable=false;
            _shishuWgt3EnDisable=false;
            _shishuislive3 = ShihuIsLive3.no;
            rdChildIsLive3="0";
            rdChildIsLiveEntry3=false;
          }
          //if child four is live or not
          if(custom_childname_list[3].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu4EnDisable=false;
            _shishuWgt4EnDisable=false;
            _shishuislive4 = ShihuIsLive4.no;
            rdChildIsLive4="0";
            rdChildIsLiveEntry4=false;
          }

        }//four child
        if(custom_childname_list.length == 5) {

          if (custom_childname_list[0].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[0].ChildName.toString() != "null") {
            _infantid1 = custom_childname_list[0].InfantID.toString();
          }
          print('last_infantid1 ${_infantid1}');

          if (custom_childname_list[1].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[1].ChildName.toString() != "null") {
            _infantid2 = custom_childname_list[1].InfantID.toString();
          }
          print('last_infantid2 ${_infantid2}');

          if (custom_childname_list[2].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[2].ChildName.toString() != "null") {
            _infantid3 = custom_childname_list[2].InfantID.toString();
          }
          print('last_infantid3 ${_infantid3}');

          if (custom_childname_list[3].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[3].ChildName.toString() != "null") {
            _infantid4 = custom_childname_list[3].InfantID.toString();
          }
          print('last_infantid4 ${_infantid4}');

          if (custom_childname_list[4].InfantID
              .toString()
              .isNotEmpty == "" ||
              custom_childname_list[4].ChildName.toString() != "null") {
            _infantid5 = custom_childname_list[4].InfantID.toString();
          }
          print('last_infantid5 ${_infantid5}');

          //if child first is live or not
          if(custom_childname_list[0].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishuEnDisable=false;
            _shishuWgtEnDisable=false;
            _shishuislive = ShihuIsLive.no;
            rdChildIsLive1="0";
            rdChildIsLiveEntry1=false;
          }
          //if child sec is live or not
          if(custom_childname_list[1].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu2EnDisable=false;
            _shishuWgt2EnDisable=false;
            _shishuislive2 = ShihuIsLive2.no;
            rdChildIsLive2="0";
            rdChildIsLiveEntry2=false;
          }
          //if child three is live or not
          if(custom_childname_list[2].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu3EnDisable=false;
            _shishuWgt3EnDisable=false;
            _shishuislive3 = ShihuIsLive3.no;
            rdChildIsLive3="0";
            rdChildIsLiveEntry3=false;
          }
          //if child four is live or not
          if(custom_childname_list[3].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu4EnDisable=false;
            _shishuWgt4EnDisable=false;
            _shishuislive4 = ShihuIsLive4.no;
            rdChildIsLive4="0";
            rdChildIsLiveEntry4=false;
          }
          //if child fifth is live or not
          if(custom_childname_list[4].Status.toString() == "2"){
            //Lock First Child View Lock , if status is == 2 , else 0= live
            _shishu5EnDisable=false;
            _shishuWgt5EnDisable=false;
            _shishuislive5 = ShihuIsLive5.no;
            rdChildIsLive5="0";
            rdChildIsLiveEntry5=false;
          }
        }//five child


        if(custom_childname_list.length == 1) {
          _ShowHideShishuEntryView1=true;
        }else if(custom_childname_list.length == 2){
          _ShowHideShishuEntryView1=true;
          _ShowHideShishuEntryView2=true;
        }else if(custom_childname_list.length == 3){
          _ShowHideShishuEntryView1=true;
          _ShowHideShishuEntryView2=true;
          _ShowHideShishuEntryView3=true;
        }else if(custom_childname_list.length == 4){
          _ShowHideShishuEntryView1=true;
          _ShowHideShishuEntryView2=true;
          _ShowHideShishuEntryView3=true;
          _ShowHideShishuEntryView4=true;
        }else if(custom_childname_list.length == 5){
          _ShowHideShishuEntryView1=true;
          _ShowHideShishuEntryView2=true;
          _ShowHideShishuEntryView3=true;
          _ShowHideShishuEntryView4=true;
          _ShowHideShishuEntryView5=true;
        }

        if(custom_childname_list.length > 5){
          _ShowHideShishuEntryView1=true;
          _ShowHideShishuEntryView2=true;
          _ShowHideShishuEntryView3=true;
          _ShowHideShishuEntryView4=true;
          _ShowHideShishuEntryView5=true;
        }


      }
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getMotherComplAPI() async {
    preferences = await SharedPreferences.getInstance();
    var response = await get(Uri.parse(_mothercompl_list_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetAashaListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_mothercomp_list.clear();
        response_list3 = resBody['ResposeData'];
        custom_mothercomp_list
            .add(CustomMotherComplList(Name:Strings.choose, masterID:"0"));
        for (int i = 0; i < response_list3.length; i++) {
          custom_mothercomp_list.add(CustomMotherComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));
        }
        motherComplId = custom_mothercomp_list[0].masterID.toString();
        print('motherComplId ${motherComplId}');
        print('res3.len  ${response_list3.length}');
        print('custom_mthr_list.len ${custom_mothercomp_list.length}');
      }
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getChildComplAPI() async {
    preferences = await SharedPreferences.getInstance();
    var response = await get(Uri.parse(_childcompl_list_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetChildComplListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_childcompl_list.clear();
        custom_childcompl_list2.clear();
        custom_childcompl_list3.clear();
        custom_childcompl_list4.clear();
        custom_childcompl_list5.clear();
        response_list3 = resBody['ResposeData'];
        custom_childcompl_list.add(CustomChildComplList(Name:Strings.choose, masterID:"0"));
        custom_childcompl_list2.add(CustomChildComplList(Name:Strings.choose, masterID:"0"));
        custom_childcompl_list3.add(CustomChildComplList(Name:Strings.choose, masterID:"0"));
        custom_childcompl_list4.add(CustomChildComplList(Name:Strings.choose, masterID:"0"));
        custom_childcompl_list5.add(CustomChildComplList(Name:Strings.choose, masterID:"0"));

        for (int i = 0; i < response_list3.length; i++) {

          custom_childcompl_list.add(CustomChildComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));

          custom_childcompl_list2.add(CustomChildComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));

          custom_childcompl_list3.add(CustomChildComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));

          custom_childcompl_list4.add(CustomChildComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));


          custom_childcompl_list5.add(CustomChildComplList(
              Name: response_list3[i]['Name'].toString(),
              masterID: response_list3[i]['masterID'].toString()));


        }
        childComplId_1 = custom_childcompl_list[0].masterID.toString();
        childComplId_2 = custom_childcompl_list2[0].masterID.toString();
        childComplId_3 = custom_childcompl_list3[0].masterID.toString();
        childComplId_4 = custom_childcompl_list4[0].masterID.toString();
        childComplId_5 = custom_childcompl_list5[0].masterID.toString();
        print('childComplId_1 ${childComplId_1+" 2=>"+childComplId_2+" 3=>"+childComplId_3+" 4=>"+childComplId_4+" 5=>"+childComplId_5}');
        print('res4.len  ${response_list3.length}');
        print('custom_childc_list.len ${custom_childcompl_list.length}');
      }
    });
    print('response:${apiResponse.message}');
    return "Success";
  }
  bool _isItAsha=false;
  var _checkPlatform="0";
  Future<String> getAashaListAPI() async {
    preferences = await SharedPreferences.getInstance();
    print('AppROleD ${preferences.getString("AppRoleID")}');
    _checkPlatform=preferences.getString("CheckPlatform").toString();
    print('DischarDT ${widget.DischargeDT }');
    print('DelplaceCode ${widget.DelplaceCode }');
    if(widget.DischargeDT == "null"){
          if(int.parse(widget.DelplaceCode) > 0 || int.parse(widget.DelplaceCode) == -3){
            setState(() {
              _ShowHideADDNewVivranView=false;
            });
            _showgeneralMsgPopup(Strings.pnc_error_msg);
          }
    }


    if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
      setState(() {
        _ShowHideADDNewVivranView = true;
      });
    }else{
      setState(() {
        _ShowHideADDNewVivranView=false;
      });
    }
    //Reset ALl Radio button at first time
    setState(() {
      _choose = multiple_chooice.nill;
      _choose2 = multiple_chooice.nill;
      _choose3 = multiple_chooice.nill;
      _choose4 = multiple_chooice.nill;
      _choose5 = multiple_chooice.nill;
      _choose6 = multiple_chooice.nill;
      _choose7 = multiple_chooice.nill;
      _choose8 = multiple_chooice.nill;
      _choose9 = multiple_chooice.nill;

    });


    var response = await post(Uri.parse(_aasha_list_url), body: {
      /*"LoginUnitid":"18",
      "DelplaceUnitid":"0",
      "RegUnitid":"18",
      "VillageAutoid":"26",
      "TokenNo":"730c8ec9-d70b-44a1-b68e-0f5cfe7e3957",
      "UserID":"0101010020201"*/
      "LoginUnitid": preferences.getString('UnitID'),
      "DelplaceUnitid":widget.DelplaceCode,
      "RegUnitid": widget.RegUnitID,
      "VillageAutoid": widget.VillageAutoID,
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
       // print('aashaId ${aashaId}');
       // print('res.len  ${response_list.length}');
       // print('custom_aasha_list.len ${custom_aasha_list.length}');
      } else {}
      EasyLoading.dismiss();
      if (aashaId != "0") getANMListAPI(aashaId);
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getAanganBadiListAPI(String ashaAutoId) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_aanganbadi_list_url), body: {
      //ASHAAutoid:105121
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
      "ASHAAutoid": ashaAutoId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAanganBadiListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_aanganbadi_list.clear();
        response_list2 = resBody['ResposeData'];
        custom_aanganbadi_list.add(CustomAanganBadiList(
            NameH: Strings.choose,
            NameE: "0",
            AnganwariNo: "",
            LastUpdated: ""));
        for (int i = 0; i < response_list2.length; i++) {
          custom_aanganbadi_list.add(CustomAanganBadiList(
              NameH: response_list2[i]['NameH'].toString(),
              NameE: response_list2[i]['NameE'].toString(),
              AnganwariNo: response_list2[i]['AnganwariNo'].toString(),
              LastUpdated: response_list2[i]['LastUpdated'].toString()));
        }
        aanganBadiId = custom_aanganbadi_list[0].AnganwariNo.toString();
      //  print('aanganBadiId ${aanganBadiId}');
     //   print('res.len  ${response_list2.length}');
      //  print('custom_aasha_list.len ${custom_aanganbadi_list.length}');
      } else {}
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getANMListAPI(String ashaAutoId) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_anm_list), body: {
      //ASHAAutoid:105121
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
      "ASHAAutoid": ashaAutoId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetANMListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_anm_list.clear();
        response_list6 = resBody['ResposeData'];
        custom_anm_list.add(CustomANMList(
            AshaName: Strings.choose,
            ashaAutoID: "0"));
        for (int i = 0; i < response_list6.length; i++) {
          custom_anm_list.add(CustomANMList(
              AshaName: response_list6[i]['AshaName'].toString(),
              ashaAutoID: response_list6[i]['ashaAutoID'].toString()));
        }
        anmId = custom_anm_list[0].ashaAutoID.toString();
        print('anmId ${anmId}');
        print('res6.len  ${response_list6.length}');
        print('custom_anm_list.len ${custom_anm_list.length}');
      } else {}
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }
  List child_response = [];

  Future<String> getChildDetails() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_detail), body: {
      "ANCRegID": widget.AncRegId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetPNCDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        child_response = resBody['ResposeData'];
        print('pnc-resp-.len ${child_response.length}');
        _motherid=child_response[0]['Motherid'].toString();
        _ancRegId=child_response[0]['ancregid'].toString();


         /* if(child_response[0]['Child1_IsLive'].toString().isNotEmpty){
              if(child_response[0]['Child1_IsLive'].toString() == "1"){
                _shishuislive=ShihuIsLive.yes;
              }else if(child_response[0]['Child1_IsLive'].toString() == "2"){
                _shishuislive=ShihuIsLive.no;
              }else{
                _shishuislive=ShihuIsLive.none;
              }
          }else{
            _shishuislive=ShihuIsLive.none;
          }
          if(child_response[0]['Child2_IsLive'].toString().isNotEmpty){
            if(child_response[0]['Child2_IsLive'].toString() == "1"){
              _shishuislive2=ShihuIsLive2.yes;
            }else if(child_response[0]['Child2_IsLive'].toString() == "2"){
              _shishuislive2=ShihuIsLive2.no;
            }else{
              _shishuislive2=ShihuIsLive2.none;
            }
          }else{
            _shishuislive2=ShihuIsLive2.none;
          }

          if(child_response[0]['Child3_IsLive'].toString().isNotEmpty){
            if(child_response[0]['Child3_IsLive'].toString() == "1"){
              _shishuislive3=ShihuIsLive3.yes;
            }else if(child_response[0]['Child3_IsLive'].toString() == "2"){
              _shishuislive3=ShihuIsLive3.no;
            }else{
              _shishuislive3=ShihuIsLive3.none;
            }
          }else{
            _shishuislive3=ShihuIsLive3.none;
          }

          if(child_response[0]['Child4_IsLive'].toString().isNotEmpty){
            if(child_response[0]['Child4_IsLive'].toString() == "1"){
              _shishuislive4=ShihuIsLive4.yes;
            }else if(child_response[0]['Child4_IsLive'].toString() == "2"){
              _shishuislive4=ShihuIsLive4.no;
            }else{
              _shishuislive4=ShihuIsLive4.none;
            }
          }else{
            _shishuislive4=ShihuIsLive4.none;
          }

          if(child_response[0]['Child5_IsLive'].toString().isNotEmpty){
            if(child_response[0]['Child5_IsLive'].toString() == "1"){
              _shishuislive5=ShihuIsLive5.yes;
            }else if(child_response[0]['Child5_IsLive'].toString() == "2"){
              _shishuislive5=ShihuIsLive5.no;
            }else{
              _shishuislive5=ShihuIsLive5.none;
            }
          }else{
            _shishuislive5=ShihuIsLive5.none;
          }*/

      } else {

      }
      getAashaListAPI();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  bool _ShowHideADDNewVivranView=false;

  bool _ShowHideShishuEntryView1=true;
  bool _ShowHideShishuEntryView2=false;
  bool _ShowHideShishuEntryView3=false;
  bool _ShowHideShishuEntryView4=false;
  bool _ShowHideShishuEntryView5=false;

  bool _ShowHideErrorView=false;

  bool _isChanged=false;
  bool _ShowHideReferPlacesView=false;

  @override
  void initState() {
    super.initState();
    _getLocation();
    getChildDetails();
    getMotherComplAPI();
    getChildComplAPI();
    addPlacesReferList();
    getChildNameListAPI();
  }
  List<CustomPlacesReferCodeList> custom_placesrefer_list = [];
  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomBlockCodeList> custom_block_list = [];

  var _selectedPlacesReferCode = "0";
  var _selectedDistrictUnitCode = "0000";
  var _selectedBlockUnitCode = "0";
  var _ReferUnitCode="0";

  void addPlacesReferList() {
    print('RegUnitTYpe ${widget.RegUnittype}');
    custom_placesrefer_list.clear();
    custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.choose, code:"0"));

    if(widget.RegUnittype == "10" || widget.RegUnittype == "11"){
      if(widget.RegUnittype == "11"){
        custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.pra_sva_center, code:"10"));


      }
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.sa_sva_center, code:"9"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.up_jila_Hospital, code:"8"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));

    }else if(widget.RegUnittype == "9" || widget.RegUnittype == "13" || widget.RegUnittype == "14"){

      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.sa_sva_center, code:"9"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.up_jila_Hospital, code:"8"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));
    }else if(widget.RegUnittype == "8"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));

    }else if(widget.RegUnittype == "6" || widget.RegUnittype == "7"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
    }else if(widget.RegUnittype == "5"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));
    }
    print('custom_placesrefer_list.len ${custom_placesrefer_list.length}');
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
            Text(Strings.pncHeader,
                style: TextStyle(color: Colors.white, fontSize: 14)),
            Text(widget.pctsID,
                style: TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
        backgroundColor: ColorConstants.AppColorPrimary,
        actions: [
          Container(
            child: PopupMenuButton(
                color: Colors.white,
                elevation: 20,
                enabled: true,
                onSelected: (value) {
                  setState(() {
                    //_value = value;
                    print('selected $value');
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: option1,
                    child: ListTile(
                      leading: Image.asset("Images/logout_img.png"),
                      // your icon
                      title: Text(option1),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: option2,
                    child: ListTile(
                      leading: Image.asset("Images/sampark_sutra_img.png"),
                      // your icon
                      title: Text(option2),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: option3,
                    child: ListTile(
                      leading: Image.asset("Images/youtube.png"),
                      title: Text(option3),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: option4,
                    child: ListTile(
                      leading: Image.asset("Images/about.png"), // your icon
                      title: Text(option4),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: option5,
                    child: ListTile(
                      leading:
                      Image.asset("Images/help_desk.png"), // your icon
                      title: Text(option5),
                    ),
                  ),
                ]),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          Strings.aasha_chunai,
                          style: TextStyle(color: Colors.black, fontSize: 13),
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
                                 // style: Theme.of(context).textTheme.bodyText1,
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
                                      getANMListAPI(aashaId);
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          Strings.anm_chunai,
                          style: TextStyle(color: Colors.black, fontSize: 13),
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
                                 // style: Theme.of(context).textTheme.bodyText1,
                                  isExpanded: true,
                                  // hint: new Text("Select State"),
                                  items: custom_anm_list.map((item) {
                                    return DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            new Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    item.AshaName.toString(),
                                                    //Names that the api dropdown contains
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        value: item.ashaAutoID
                                            .toString() //Id that has to be passed that the dropdown has.....
                                      //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                    );
                                  }).toList(),
                                  onChanged: (String? newVal) {
                                    setState(() {
                                      anmId = newVal!;
                                      print('anmId:$anmId');
                                    });
                                  },
                                  value:
                                  anmId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RichText(
                          text: TextSpan(
                              text: Strings.PNCComp,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13),
                              children: [
                                TextSpan(
                                    text: ' *',
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
                                  items: custom_mothercomp_list.map((item) {
                                    return DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            new Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    item.Name.toString(),
                                                    //Names that the api dropdown contains
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        value: item.masterID
                                            .toString() //Id that has to be passed that the dropdown has.....
                                      //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                    );
                                  }).toList(),
                                  onChanged: (String? newVal) {
                                    setState(() {
                                      motherComplId = newVal!;
                                      print('motherComplId:$motherComplId');
                                      print('widget.MotherDeathDate:${widget.MotherDeathDate}');
                                      if(motherComplId == "3"){//if mother dead ,submit button & refer view will be hide
                                        if(widget.MotherDeathDate.isEmpty){
                                          _ShowHideReferPlacesView=false;
                                          _ShowHideErrorView=true;
                                          _ShowHideADDNewVivranView=false;
                                        }else{//if mother is dead and has been entry
                                          _ShowHideReferPlacesView=true;
                                          _ShowHideErrorView=false;
                                          _ShowHideADDNewVivranView=true;
                                        }

                                      }else{
                                          if(rdChildIsLive1 == "0" || rdChildIsLive2 == "0" || rdChildIsLive3 == "0" || rdChildIsLive4 == "0" || rdChildIsLive4 == "0"){
                                            _ShowHideReferPlacesView=false;
                                            _ShowHideErrorView=true;
                                            _ShowHideADDNewVivranView=false;
                                          }else{
                                            if(motherComplId == "5"){
                                              _ShowHideReferPlacesView=false;
                                              _ShowHideErrorView=false;
                                              _ShowHideADDNewVivranView=true;
                                            }else{
                                              _ShowHideReferPlacesView=true;
                                              _ShowHideErrorView=false;
                                              _ShowHideADDNewVivranView=true;
                                            }

                                          }
                                      }
                                      _pncDDdateController.text ="";
                                      _pncMMdateController.text = "";
                                      _pncYYYYdateController.text = "";
                                      /*if((motherComplId == "5" || motherComplId == "0") && (rdChildIsLive1 != "0" || rdChildIsLive2 != "0" || rdChildIsLive3 != "0" || rdChildIsLive4 != "0" || rdChildIsLive5 != "0")){
                                        _ShowHideReferPlacesView=false;
                                        _ShowHideErrorView=false;
                                        _ShowHideADDNewVivranView=true;
                                      }else if(motherComplId == "3"){
                                        _ShowHideReferPlacesView=false;
                                        _ShowHideErrorView=true;
                                        _ShowHideADDNewVivranView=false;
                                      }else{
                                        print('_isSecondChildLive $_isSecondChildLive');
                                        if(_isFirstChildLive == true || _isSecondChildLive == true || _isThirdChildLive == true ||_isFourthChildLive == true || _isFifthChildLive == true) { //false=dead, true=live
                                          _ShowHideReferPlacesView=true;
                                          _ShowHideErrorView=false;
                                          _ShowHideADDNewVivranView=true;

                                        }else{
                                          _ShowHideReferPlacesView=false;
                                          _ShowHideErrorView=true;
                                          _ShowHideADDNewVivranView=false;
                                        }
                                      }*/

                                      /*else if(rdChildIsLive1 != "0" || rdChildIsLive2 != "0" || rdChildIsLive3 != "0" || rdChildIsLive4 != "0" || rdChildIsLive5 != "0"){
                                        _ShowHideReferPlacesView=false;
                                        _ShowHideErrorView=true;
                                        _ShowHideADDNewVivranView=true;
                                      }*//*else{
                                        _ShowHideReferPlacesView=true;
                                        _ShowHideErrorView=false;
                                        _ShowHideADDNewVivranView=true;
                                      }*/

                                      /*if((motherComplId == "5" || motherComplId == "0") && (childComplId_1 == "12" || childComplId_2 == "12" || childComplId_3 == "12" || childComplId_4 == "12" || childComplId_5 == "12")){
                                        _ShowHideReferPlacesView=false;
                                        _ShowHideErrorView=false;
                                        _ShowHideADDNewVivranView=true;
                                      }else if(motherComplId == "3"){//dead
                                        _ShowHideReferPlacesView=false;
                                        _ShowHideErrorView=true;
                                        _ShowHideADDNewVivranView=false;
                                      }else{
                                        _ShowHideReferPlacesView=true;
                                        _ShowHideErrorView=false;
                                        _ShowHideADDNewVivranView=true;
                                      }*/
                                    });
                                  },
                                  value: motherComplId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                                      text: Strings.pncDate,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                      children: [
                                        TextSpan(
                                            text: '*',
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
                                          controller: _pncDDdateController,
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
                                              if(_pncDDdateController.text.toString().length == 2 && _pncMMdateController.text.toString().length == 2 && _pncYYYYdateController.text.toString().length == 4){
                                                _selectANCDatePopupCustom(_pncYYYYdateController.text.toString()+"-"+_pncMMdateController.text.toString()+"-"+_pncDDdateController.text.toString()+" 00:00:00.000");
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
                                          controller: _pncMMdateController,
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
                                            if(_pncDDdateController.text.toString().length == 2 && _pncMMdateController.text.toString().length == 2 && _pncYYYYdateController.text.toString().length == 4){
                                              _selectANCDatePopupCustom(_pncYYYYdateController.text.toString()+"-"+_pncMMdateController.text.toString()+"-"+_pncDDdateController.text.toString()+" 00:00:00.000");
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
                                          controller: _pncYYYYdateController,
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
                                            if(_pncDDdateController.text.toString().length == 2 && _pncMMdateController.text.toString().length == 2 && _pncYYYYdateController.text.toString().length == 4){
                                              _selectANCDatePopupCustom(_pncYYYYdateController.text.toString()+"-"+_pncMMdateController.text.toString()+"-"+_pncDDdateController.text.toString()+" 00:00:00.000");
                                            }
                                          }
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if(_pncYYYYdateController.text.toString().isEmpty && _pncMMdateController.text.toString().isEmpty && _pncDDdateController.text.toString().isEmpty){
                                  _selectANCDatePopup(0,0,0);
                                }else{
                                  _selectANCDatePopup(int.parse(_pncYYYYdateController.text.toString()),int.parse(_pncMMdateController.text.toString()) ,int.parse(_pncDDdateController.text.toString()));
                                }
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

                      /*
                    * * Shishu First View
                    */
                      Visibility(
                          visible: _ShowHideShishuEntryView1,
                          child: Container(
                            child: Column(
                              children:<Widget> [
                                Divider(height: 1,thickness: 2,color: Colors.black,),

                                Container(
                                  color: ColorConstants.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              color: ColorConstants.white,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings
                                                        .child_death_or_not,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                    children: [
                                                      TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10))
                                                    ]),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              height: 36,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive>(
                                                                activeColor:rdChildIsLiveEntry1 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive.yes,
                                                                groupValue: _shishuislive,
                                                                onChanged:rdChildIsLiveEntry1 == false ? null : (ShihuIsLive? value) {
                                                                  setState(() {
                                                                    _shishuislive = value ?? _shishuislive;
                                                                    rdChildIsLive1="1";

                                                                    _shishuEnDisable=true;
                                                                    _shishuWgtEnDisable=true;
                                                                    _ShowHideReferPlacesView=true;
                                                                    _ShowHideErrorView=false;

                                                                    /*
                                                                    * Check if any child is live , Save button will be show
                                                                    */
                                                                    checkShowHideSaveButton(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5
                                                                    );
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                Strings.yes,
                                                                style: TextStyle(
                                                                    fontSize: 11),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive>(
                                                                activeColor:rdChildIsLiveEntry1 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive.no,
                                                                groupValue: _shishuislive,
                                                                onChanged:rdChildIsLiveEntry1 == false ? null :(ShihuIsLive? value) {
                                                                  setState(() {
                                                                    _shishuislive = value ?? _shishuislive;
                                                                    rdChildIsLive1="0";

                                                                    _shishuEnDisable=false;
                                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.focusedChild!.unfocus();
                                                                    }
                                                                    _shishuNameController.text="";


                                                                    _shishuWgtEnDisable=false;
                                                                    _shishuWeightController.text="";
                                                                    childComplId_1="0";

                                                                    _ReferUnitCode="0";//set default value on child death
                                                                    print('final ReferUnitCode $_ReferUnitCode');

                                                                    /*
                                                                    * Check if any child is live refer listing will be show
                                                                    */
                                                                    checkifAnyChildLive(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5);
                                                                  });
                                                                },
                                                              ),
                                                              Text(Strings.no,
                                                                  style: TextStyle(
                                                                      fontSize: 11))
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

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_naam,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                         // enabled: _shishuEnDisable,//uncomment for active/inactive
                                                          enabled: false,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 10,
                                                          keyboardType: TextInputType.text,
                                                          controller: _shishuNameController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('mahilaheight $text');
                                                            print('_hbCount $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_weight,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          enabled: _shishuWgtEnDisable,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 4,
                                                          keyboardType: TextInputType.number,
                                                          controller: _shishuWeightController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('shishuWeight $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.child_comp,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
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
                                           // style: Theme.of(context).textTheme.bodyText1,
                                            isExpanded: true,
                                            // hint: new Text("Select State"),
                                            items: custom_childcompl_list.map((item) {
                                              return DropdownMenuItem(
                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.Name.toString(),
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.masterID
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: _shishuWgtEnDisable == true  ? (String? newVal) {
                                              setState(() {
                                                childComplId_1 = newVal!;
                                                print('childComplId_1:$childComplId_1');
                                                if((childComplId_1 == "12" || childComplId_1 == "0") && (motherComplId == "5" || motherComplId == "0")){
                                                  _ShowHideReferPlacesView=false;
                                                }else{
                                                  _ShowHideReferPlacesView=true;
                                                }
                                              });
                                            } : null,
                                            value: childComplId_1, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1,thickness: 2,color: Colors.black,),
                              ],
                            ),
                          )),

                      /*
                    * * Shishu Second View
                    */
                      Visibility(
                          visible: _ShowHideShishuEntryView2,
                          child: Container(
                            child: Column(
                              children:<Widget> [
                                Divider(height: 1,thickness: 2,color: Colors.black,),

                                Container(
                                  color: ColorConstants.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              color: ColorConstants.white,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings
                                                        .child_death_or_not,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                    children: [
                                                      TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10))
                                                    ]),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              height: 36,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive2>(
                                                                activeColor:rdChildIsLiveEntry2 == false ? Colors.grey :  Colors.black,
                                                                value: ShihuIsLive2.yes,
                                                                groupValue: _shishuislive2,
                                                                onChanged: rdChildIsLiveEntry2 == false ? null : (ShihuIsLive2? value) {
                                                                  setState(() {
                                                                    _shishuislive2 = value ?? _shishuislive2;
                                                                    rdChildIsLive2="1";
                                                                    _shishuWgt2EnDisable=true;
                                                                    _ShowHideReferPlacesView=true;
                                                                    _ShowHideErrorView=true;
                                                                    _shishu2EnDisable=true;
                                                                    /*
                                                                    * Check if any child is live , Save button will be show
                                                                    */
                                                                    checkShowHideSaveButton(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5
                                                                    );

                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                Strings.yes,
                                                                style: TextStyle(
                                                                    fontSize: 11),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive2>(
                                                                activeColor:rdChildIsLiveEntry2 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive2.no,
                                                                groupValue: _shishuislive2,
                                                                onChanged:rdChildIsLiveEntry2 == false ? null :(ShihuIsLive2? value) {
                                                                  setState(() {
                                                                    _shishuislive2 = value ?? _shishuislive2;
                                                                    rdChildIsLive2="0";
                                                                    _shishuWgt2EnDisable=false;
                                                                    _shishuWeight2Controller.text="";
                                                                    childComplId_2="0";
                                                                    //_ShowHideReferPlacesView=false;
                                                                    // _ShowHideErrorView=false;

                                                                    _shishu2NameController.text="";
                                                                    _shishu2EnDisable=false;
                                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.focusedChild!.unfocus();
                                                                    }

                                                                    _ReferUnitCode="0";//set default value on child death
                                                                    print('final ReferUnitCode $_ReferUnitCode');

                                                                    /*
                                                                    * Check if any child is live refer listing will be show
                                                                    */
                                                                    checkifAnyChildLive(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5);

                                                                  });
                                                                },
                                                              ),
                                                              Text(Strings.no,
                                                                  style: TextStyle(
                                                                      fontSize: 11))
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


                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_naam,
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 13),
                                                      children: [
                                                        TextSpan(
                                                            text: '*',
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14))
                                                      ]),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                         // enabled: _shishu2EnDisable,//uncomment for active/inactive
                                                          enabled: false,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 10,
                                                          keyboardType: TextInputType.text,
                                                          controller: _shishu2NameController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('mahilaheight $text');
                                                            print('_hbCount $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),


                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_weight,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          enabled: _shishuWgt2EnDisable,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 4,
                                                          keyboardType: TextInputType.number,
                                                          controller: _shishuWeight2Controller,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('shishuWeight $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.child_comp,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
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
                                           // style: Theme.of(context).textTheme.bodyText1,
                                            isExpanded: true,
                                            // hint: new Text("Select State"),
                                            items: custom_childcompl_list2.map((item) {
                                              return DropdownMenuItem(

                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.Name.toString(),
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.masterID
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: _shishuWgt2EnDisable == true ?(String? newVal) {
                                              setState(() {
                                                childComplId_2 = newVal!;
                                                print('childComplId_2:$childComplId_2');
                                                if((childComplId_1 == "12" || childComplId_1 == "0") && (motherComplId == "5" || motherComplId == "0")){
                                                  _ShowHideReferPlacesView=false;
                                                }else{
                                                  _ShowHideReferPlacesView=true;
                                                }
                                              });
                                            } : null,
                                            value:
                                            childComplId_2, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1,thickness: 2,color: Colors.black,),
                              ],
                            ),
                          )),

                      /*
                    * * Shishu Third View
                    */
                      Visibility(
                          visible: _ShowHideShishuEntryView3,
                          child: Container(
                            child: Column(
                              children:<Widget> [
                                Divider(height: 1,thickness: 2,color: Colors.black,),

                                Container(
                                  color: ColorConstants.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              color: ColorConstants.white,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings
                                                        .child_death_or_not,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                    children: [
                                                      TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10))
                                                    ]),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              height: 36,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive3>(
                                                                activeColor:rdChildIsLiveEntry3 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive3.yes,
                                                                groupValue: _shishuislive3,
                                                                onChanged:rdChildIsLiveEntry3 == false ? null : (ShihuIsLive3? value) {
                                                                  setState(() {
                                                                    _shishuislive3 = value ?? _shishuislive3;
                                                                    rdChildIsLive3="1";
                                                                    _shishuWgt3EnDisable=true;
                                                                    _ShowHideReferPlacesView=true;
                                                                    _ShowHideErrorView=true;

                                                                    _shishu3EnDisable=true;


                                                                    /*
                                                                    * Check if any child is live , Save button will be show
                                                                    */
                                                                    checkShowHideSaveButton(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5
                                                                    );
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                Strings.yes,
                                                                style: TextStyle(
                                                                    fontSize: 11),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive3>(
                                                                activeColor:rdChildIsLiveEntry3 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive3.no,
                                                                groupValue: _shishuislive3,
                                                                onChanged:rdChildIsLiveEntry3 == false ? null : (ShihuIsLive3? value) {
                                                                  setState(() {
                                                                    _shishuislive3 = value ?? _shishuislive3;
                                                                    rdChildIsLive3="0";
                                                                    _shishuWgt3EnDisable=false;
                                                                    _shishuWeight3Controller.text="";
                                                                    childComplId_3="0";
                                                                    // _ShowHideReferPlacesView=false;
                                                                    // _ShowHideErrorView=false;


                                                                    _shishu3NameController.text="";
                                                                    _shishu3EnDisable=false;
                                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.focusedChild!.unfocus();
                                                                    }


                                                                    _ReferUnitCode="0";//set default value on child death
                                                                    print('final ReferUnitCode $_ReferUnitCode');

                                                                    /*
                                                                    * Check if any child is live refer listing will be show
                                                                    */
                                                                    checkifAnyChildLive(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5);
                                                                  });
                                                                },
                                                              ),
                                                              Text(Strings.no,
                                                                  style: TextStyle(
                                                                      fontSize: 11))
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

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_naam,
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 13),
                                                      children: [
                                                        TextSpan(
                                                            text: '*',
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14))
                                                      ]),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          //enabled: _shishu3EnDisable,//uncomment for active/inactive
                                                          enabled: false,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 10,
                                                          keyboardType: TextInputType.text,
                                                          controller: _shishu3NameController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('mahilaheight $text');
                                                            print('_hbCount $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_weight,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          enabled: _shishuWgt3EnDisable,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 4,
                                                          keyboardType: TextInputType.number,
                                                          controller: _shishuWeight3Controller,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('shishuWeight $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.child_comp,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
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
                                           // style: Theme.of(context).textTheme.bodyText1,
                                            isExpanded: true,
                                            // hint: new Text("Select State"),
                                            items: custom_childcompl_list3.map((item) {
                                              return DropdownMenuItem(

                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.Name.toString(),
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.masterID
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: _shishuWgt3EnDisable == true ? (String? newVal) {
                                              setState(() {
                                                childComplId_3 = newVal!;
                                                print('childComplId_3:$childComplId_3');
                                                if((childComplId_1 == "12" || childComplId_1 == "0") && (motherComplId == "5" || motherComplId == "0")){
                                                  _ShowHideReferPlacesView=false;
                                                }else{
                                                  _ShowHideReferPlacesView=true;
                                                }
                                              });
                                            } : null,
                                            value:
                                            childComplId_3, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1,thickness: 2,color: Colors.black,),
                              ],
                            ),
                          )),

                      /*
                    * * Shishu Four View
                    */
                      Visibility(
                          visible: _ShowHideShishuEntryView4,
                          child: Container(
                            child: Column(
                              children:<Widget> [
                                Divider(height: 1,thickness: 2,color: Colors.black,),

                                Container(
                                  color: ColorConstants.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              color: ColorConstants.white,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings
                                                        .child_death_or_not,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                    children: [
                                                      TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10))
                                                    ]),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              height: 36,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive4>(
                                                                activeColor:rdChildIsLiveEntry4 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive4.yes,
                                                                groupValue: _shishuislive4,
                                                                onChanged:rdChildIsLiveEntry4 == false ? null : (ShihuIsLive4? value) {
                                                                  setState(() {
                                                                    _shishuislive4 = value ?? _shishuislive4;
                                                                    rdChildIsLive4="1";
                                                                    _shishuWgt4EnDisable=true;
                                                                    _ShowHideReferPlacesView=true;
                                                                    _ShowHideErrorView=true;

                                                                    _shishu4EnDisable=true;

                                                                    /*
                                                                    * Check if any child is live , Save button will be show
                                                                    */
                                                                    checkShowHideSaveButton(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5
                                                                    );
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                Strings.yes,
                                                                style: TextStyle(
                                                                    fontSize: 11),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive4>(
                                                                activeColor:rdChildIsLiveEntry4 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive4.no,
                                                                groupValue: _shishuislive4,
                                                                onChanged:rdChildIsLiveEntry4 == false ? null :(ShihuIsLive4? value) {
                                                                  setState(() {
                                                                    _shishuislive4 = value ?? _shishuislive4;
                                                                    rdChildIsLive4="0";
                                                                    _shishuWgt4EnDisable=false;
                                                                    _shishuWeight4Controller.text="";
                                                                    childComplId_4="0";
                                                                    // _ShowHideReferPlacesView=false;
                                                                    //_ShowHideErrorView=false;


                                                                    _shishu4NameController.text="";
                                                                    _shishu4EnDisable=false;
                                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.focusedChild!.unfocus();
                                                                    }

                                                                    _ReferUnitCode="0";//set default value on child death
                                                                    print('final ReferUnitCode $_ReferUnitCode');

                                                                    /*
                                                                    * Check if any child is live refer listing will be show
                                                                    */
                                                                    checkifAnyChildLive(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5);
                                                                  });
                                                                },
                                                              ),
                                                              Text(Strings.no,
                                                                  style: TextStyle(
                                                                      fontSize: 11))
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

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_naam,
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 13),
                                                      children: [
                                                        TextSpan(
                                                            text: '*',
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14))
                                                      ]),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          //enabled: _shishu4EnDisable,//uncomment for active/inactive
                                                          enabled: false,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 10,
                                                          keyboardType: TextInputType.text,
                                                          controller: _shishu4NameController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('mahilaheight $text');
                                                            print('_hbCount $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_weight,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          enabled: _shishuWgt4EnDisable,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 4,
                                                          keyboardType: TextInputType.number,
                                                          controller: _shishuWeight4Controller,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('shishuWeight $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.child_comp,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
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
                                            items: custom_childcompl_list4.map((item) {
                                              return DropdownMenuItem(

                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.Name.toString(),
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.masterID
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: _shishuWgt4EnDisable == true ? (String? newVal) {
                                              setState(() {
                                                childComplId_4 = newVal!;
                                                print('childComplId_4:$childComplId_4');
                                                if((childComplId_1 == "12" || childComplId_1 == "0") && (motherComplId == "5" || motherComplId == "0")){
                                                  _ShowHideReferPlacesView=false;
                                                }else{
                                                  _ShowHideReferPlacesView=true;
                                                }
                                              });
                                            }:null,
                                            value:
                                            childComplId_4, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1,thickness: 2,color: Colors.black,),
                              ],
                            ),
                          )),

                      /*
                    * * Shishu Five View
                    */
                      Visibility(
                          visible: _ShowHideShishuEntryView5,
                          child: Container(
                            child: Column(
                              children:<Widget> [
                                Divider(height: 1,thickness: 2,color: Colors.black,),

                                Container(
                                  color: ColorConstants.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              color: ColorConstants.white,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings
                                                        .child_death_or_not,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                    children: [
                                                      TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 10))
                                                    ]),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                              height: 36,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive5>(
                                                                activeColor:rdChildIsLiveEntry5 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive5.yes,
                                                                groupValue: _shishuislive5,
                                                                onChanged:rdChildIsLiveEntry5 == false ? null :  (ShihuIsLive5? value) {
                                                                  setState(() {
                                                                    _shishuislive5 = value ?? _shishuislive5;
                                                                    rdChildIsLive5="1";
                                                                    _shishuWgt5EnDisable=true;
                                                                    _ShowHideReferPlacesView=true;
                                                                    _ShowHideErrorView=true;

                                                                    _shishu5EnDisable=true;

                                                                    /*
                                                                    * Check if any child is live , Save button will be show
                                                                    */
                                                                    checkShowHideSaveButton(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5
                                                                    );
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                Strings.yes,
                                                                style: TextStyle(
                                                                    fontSize: 11),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 20),
                                                          height: 20,
                                                          //Make it equal to height of radio button
                                                          width: 10,
                                                          //Make it equal to width of radio button
                                                          child: Row(
                                                            children: [
                                                              Radio<ShihuIsLive5>(
                                                                activeColor:rdChildIsLiveEntry5 == false ? Colors.grey : Colors.black,
                                                                value: ShihuIsLive5.no,
                                                                groupValue: _shishuislive5,
                                                                onChanged:rdChildIsLiveEntry5 == false ? null : (ShihuIsLive5? value) {
                                                                  setState(() {
                                                                    _shishuislive5 = value ?? _shishuislive5;
                                                                    rdChildIsLive5="0";
                                                                    _shishuWgt5EnDisable=false;
                                                                    _shishuWeight5Controller.text="";
                                                                    childComplId_5="0";
                                                                    // _ShowHideReferPlacesView=false;
                                                                    // _ShowHideErrorView=false;

                                                                    _ReferUnitCode="0";//set default value on child death
                                                                    print('final ReferUnitCode $_ReferUnitCode');

                                                                    _shishu5NameController.text="";
                                                                    _shishu5EnDisable=false;
                                                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.focusedChild!.unfocus();
                                                                    }
                                                                    /*
                                                                    * Check if any child is live refer listing will be show
                                                                    */
                                                                    checkifAnyChildLive(
                                                                        rdChildIsLive1,
                                                                        rdChildIsLive2,
                                                                        rdChildIsLive3,
                                                                        rdChildIsLive4,
                                                                        rdChildIsLive5);
                                                                  });
                                                                },
                                                              ),
                                                              Text(Strings.no,
                                                                  style: TextStyle(
                                                                      fontSize: 11))
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

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_naam,
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 13),
                                                      children: [
                                                        TextSpan(
                                                            text: '*',
                                                            style: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14))
                                                      ]),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                        //  enabled: _shishu5EnDisable,//uncomment for active/inactive
                                                          enabled: false,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 10,
                                                          keyboardType: TextInputType.text,
                                                          controller: _shishu5NameController,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('mahilaheight $text');
                                                            print('_hbCount $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    children:<Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: Strings.shishu_ka_weight,
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
                                                  textAlign: TextAlign.left,
                                                )),
                                            Expanded(
                                                child: Container(
                                                    height: 36,
                                                    child: Focus(
                                                        onFocusChange: (hasFocus) {
                                                          if(hasFocus) {
                                                            // do stuff
                                                          }else{
                                                            //print('enter value: $text');

                                                          }
                                                        },
                                                        child: TextField(
                                                          enabled: _shishuWgt5EnDisable,
                                                          style: TextStyle(color: Colors.black),
                                                          maxLength: 4,
                                                          keyboardType: TextInputType.number,
                                                          controller: _shishuWeight5Controller,
                                                          decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: ColorConstants.transparent,
                                                            counterText: '',
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            disabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                          onChanged: (text) {
                                                            //_hbCount=text.trim();
                                                            print('shishuWeight $text');
                                                            //getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                                          },
                                                        ))))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.child_comp,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
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
                                            ///style: Theme.of(context).textTheme.bodyText1,
                                            isExpanded: true,
                                            // hint: new Text("Select State"),
                                            items: custom_childcompl_list5.map((item) {
                                              return DropdownMenuItem(

                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.Name.toString(),
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.masterID
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged:_shishuWgt5EnDisable == true ? (String? newVal) {
                                              setState(() {
                                                childComplId_5 = newVal!;
                                                print('childComplId_5:$childComplId_5');
                                                if((childComplId_1 == "12" || childComplId_1 == "0") && (motherComplId == "5" || motherComplId == "0")){
                                                  _ShowHideReferPlacesView=false;
                                                }else{
                                                  _ShowHideReferPlacesView=true;
                                                }
                                              });
                                            } : null,
                                            value:
                                            childComplId_5, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1,thickness: 2,color: Colors.black,),
                              ],
                            ),
                          )),


                      Visibility(
                        visible: _ShowHideErrorView,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              Strings.pncDetailUpdate,
                              style: TextStyle(color: ColorConstants.redTextColor, fontSize: 13),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: _ShowHideReferPlacesView,
                        child: Column(
                          children:<Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  color: Colors.white,
                                  child: RichText(
                                    text: TextSpan(
                                        text: Strings.refer_karnai,
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
                                        //style: Theme.of(context).textTheme.bodyText1,
                                        isExpanded: true,
                                        // hint: new Text("Select State"),
                                        items: custom_placesrefer_list.map((item) {
                                          return DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  new Flexible(
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(2.0),
                                                        child: Text(
                                                          item.title.toString(),
                                                          //Names that the api dropdown contains
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              value: item.code.toString() //Id that has to be passed that the dropdown has.....
                                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                          );
                                        }).toList(),
                                        onChanged: (String? newVal) {
                                          setState(() {
                                            _selectedPlacesReferCode = newVal!;
                                            print('refercode:$_selectedPlacesReferCode');
                                            getDistrictListAPI("3");

                                            if(_isChanged == true){
                                              _isChanged=false;
                                              _selectedBlockUnitCode = custom_block_list[0].unitcode.toString();
                                              print('_selectedDistrictUnitCode ${_selectedBlockUnitCode}');
                                            }
                                          });
                                        },
                                        value: _selectedPlacesReferCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                                  color: Colors.white,
                                  child: RichText(
                                    text: TextSpan(
                                        text: Strings.refer_jila,
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
                                        //style: Theme.of(context).textTheme.bodyText1,
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
                                                            fontSize: 14.0,
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
                                            getBlockListAPI(_selectedPlacesReferCode,_selectedDistrictUnitCode.substring(0, 4));
                                          });
                                        },
                                        value: _selectedDistrictUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),//
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  color: Colors.white,
                                  child: RichText(
                                    text: TextSpan(
                                        text: Strings.refer_sanstha,
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
                                       // style: Theme.of(context).textTheme.bodyText1,
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
                                                          item.unitNameHindi.toString(),
                                                          //Names that the api dropdown contains
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              value: item.unitcode
                                                  .toString() //Id that has to be passed that the dropdown has.....
                                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                          );
                                        }).toList(),
                                        onChanged: (String? newVal) {
                                          setState(() {
                                            _selectedBlockUnitCode = newVal!;
                                            print('blockcode:$_selectedBlockUnitCode');
                                            _ReferUnitCode=_selectedBlockUnitCode;
                                            _isChanged=true;
                                          });
                                        },
                                        value:
                                        _selectedBlockUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                          text: Strings.kya_mahila_ko_fever,
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
                                                          /*strType="0";*/
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_1);
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
                                          text: Strings.kya_pet_k_nichle_dard,
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
                                                          _choose2 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_2);
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
                                                          _choose2 = value! ;
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
                                          text: Strings.kya_pair_main_sujan,
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
                                                          _choose3 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_3);
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
                                                          _choose3 = value! ;
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
                                          text: Strings.kya_paishab_main_jalan,
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
                                                          _choose4 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_4);
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
                                                          _choose4 = value! ;
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
                                          text: Strings.kya_yoni_main_badbodar_rasav,
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
                                                          _choose5 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_5);
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
                                                          _choose5 = value! ;
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
                                          text: Strings.kya_mata_postic_bhojan,
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
                                                          _choose6 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_6);
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
                                                          _choose6 = value! ;
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
                                          text: Strings.kya_gath_kya_koe_dard,
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
                                                          _choose7 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_7);
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
                                                          _choose7 = value! ;
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
                                          text: Strings.kya_mother_is_normal,
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
                                                          _choose8 = value! ;
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
                                                          _choose8 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_8);
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
                                          text: Strings.kya_pad_change_morethan_five_time,
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
                                                          _choose9 = value! ;
                                                          _showgeneralMsgPopup(
                                                              Strings.choice_pnc_9);
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
                                                          _choose9 = value! ;
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


                    ],
                  ),
                ),
              ),
            ),
            _ShowHideADDNewVivranView == true
                ?
            GestureDetector(
              onTap: (){
                validatePostRequest();
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
            )
                :
            Container()
          ],
        ),
      ),
    );
  }
  /*
  * * Custom Date Picker
  * */
  late DateTime _selectedDate;
  var _selectedANCDate = "";
  void _selectANCDatePopupCustom(String _customHBNCDate) {
      setState(() {

        var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customHBNCDate));
        print('parseCustomANCDate ${parseCustomANCDate}');

        String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);

        _selectedANCDate = formattedDate2.toString();
        _selectedDate = parseCustomANCDate;
        //var parsedCurrentDate = DateTime.parse(getCurrentDate());
        var parsedDate1 = DateTime.parse(formattedDate4.toString());
        //var parsedDate2 = DateTime.parse(getConvertRegDateFormat(getCurrentDate()));

      //  print('DateCondition ${formattedDate2.toString()}');
        //print('DateCondition currDt : ${getCurrentDate()}');
     //   print('DateCondition currDt : ${parsedDate2}');
        //print('DateCondition _selectedDate : ${_selectedDate}');

        //DateTime dt1 = DateTime.parse("2021-12-23 11:47:00");
        DateTime dt2 = DateTime.parse(getCurrentDate());

        if (formattedDate2.toString() == getCurrentDate2()) {
          _showErrorPopup(Strings.PncDate_sahi_kare_msg,ColorConstants.AppColorPrimary);
          _pncDDdateController.text ="";
          _pncMMdateController.text = "";
          _pncYYYYdateController.text = "";
        } else {
         // print('not equal to current date#########');
          //print('DateCondition dt1 : ${_selectedDate}');
          //print('DateCondition dt2 : ${dt2}');
          if(_selectedDate.compareTo(dt2) > 0){
         //   print("DT2 is after DT1");
            _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
          }else{

            //first check if mother death is exist or not
            if(widget.MotherDeathDate.isEmpty){

              var deliveryAbortionDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
              print("deliveryAbortionDate ${deliveryAbortionDate}");
              if (_selectedDate.compareTo(deliveryAbortionDate) > 0) {
                print('after pnc date');
                var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
                var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
                print('AncDate calendr ${parseCalenderSelectedAncDate}');
                print('AncDate intentt ${intentAncDate}');
                final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays+1;
                print('AncDate diff ${diff_lmp_ancdate}');
                if(diff_lmp_ancdate == 0 || diff_lmp_ancdate == 1){
                  if(widget.DelplaceCode == "-1" || widget.DelplaceCode == "-2" ){
                    _PncFlag_post="1";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');

                  }else{
                    _showErrorPopup(Strings.difference_btw_png_deli,ColorConstants.AppColorPrimary);
                  }
                }else if(diff_lmp_ancdate >= 2 && diff_lmp_ancdate <= 4){
                  _PncFlag_post="2";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');

                }else if(diff_lmp_ancdate >= 6 && diff_lmp_ancdate <= 8){
                  _PncFlag_post="3";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');

                }else if(diff_lmp_ancdate >= 13 && diff_lmp_ancdate <= 15){
                  _PncFlag_post="4";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');

                }else if(diff_lmp_ancdate >= 19 && diff_lmp_ancdate <= 23){
                  _PncFlag_post="5";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');
                }else if(diff_lmp_ancdate >= 26 && diff_lmp_ancdate <= 30){
                  _PncFlag_post="6";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');
                }else if(diff_lmp_ancdate >= 40 && diff_lmp_ancdate <= 44){
                  _PncFlag_post="7";

                  _pncDDdateController.text = getDate(formattedDate4);
                  _pncMMdateController.text = getMonth(formattedDate4);
                  _pncYYYYdateController.text = getYear(formattedDate4);
                  _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                  print('_PncDatePost $_PncDatePost');
                }else {
                  _showErrorPopup(Strings.please_correct_pnc_date,ColorConstants.AppColorPrimary);
                }
              }else{
                print('before pnc date');
                _showErrorPopup(Strings.check_png_date,ColorConstants.AppColorPrimary);
                _pncDDdateController.text ="";
                _pncMMdateController.text = "";
                _pncYYYYdateController.text = "";
              }
            }else{

              if(motherComplId == "3"){
                var motherDeathDate = DateTime.parse(getConvertRegDateFormat(widget.MotherDeathDate));
                print("motherDeathDate ${motherDeathDate}");

                var _selecteHBNCDate= DateTime.parse(getConvertRegDateFormat(_pncYYYYdateController.text.toString()+"-"+_pncMMdateController.text.toString()+"-"+_pncDDdateController.text.toString()));;
                if (_selecteHBNCDate.compareTo(motherDeathDate) != 0) {
                  _showErrorPopup('माता की मृत्यु की तिथि '+getFormattedDate(widget.MotherDeathDate)+' होनी चाहिए',ColorConstants.AppColorPrimary);
                  _pncDDdateController.text ="";
                  _pncMMdateController.text = "";
                  _pncYYYYdateController.text = "";
                }else{
                  var deliveryAbortionDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
                  print("deliveryAbortionDate ${deliveryAbortionDate}");
                  if (_selectedDate.compareTo(deliveryAbortionDate) > 0) {
                    print('after pnc date');


                    var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
                    var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
                    print('AncDate calendr ${parseCalenderSelectedAncDate}');
                    print('AncDate intentt ${intentAncDate}');
                    final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays+1;
                    print('AncDate diff ${diff_lmp_ancdate}');
                    if(diff_lmp_ancdate == 0 || diff_lmp_ancdate == 1){
                      if(widget.DelplaceCode == "-1" || widget.DelplaceCode == "-2" ){
                        _PncFlag_post="1";

                        _pncDDdateController.text = getDate(formattedDate4);
                        _pncMMdateController.text = getMonth(formattedDate4);
                        _pncYYYYdateController.text = getYear(formattedDate4);
                        _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                        print('_PncDatePost $_PncDatePost');

                      }else{
                        _showErrorPopup(Strings.difference_btw_png_deli,ColorConstants.AppColorPrimary);
                      }
                    }else if(diff_lmp_ancdate >= 2 && diff_lmp_ancdate <= 4){
                      _PncFlag_post="2";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');

                    }else if(diff_lmp_ancdate >= 6 && diff_lmp_ancdate <= 8){
                      _PncFlag_post="3";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');

                    }else if(diff_lmp_ancdate >= 13 && diff_lmp_ancdate <= 15){
                      _PncFlag_post="4";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');

                    }else if(diff_lmp_ancdate >= 19 && diff_lmp_ancdate <= 23){
                      _PncFlag_post="5";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');
                    }else if(diff_lmp_ancdate >= 26 && diff_lmp_ancdate <= 30){
                      _PncFlag_post="6";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');
                    }else if(diff_lmp_ancdate >= 40 && diff_lmp_ancdate <= 44){
                      _PncFlag_post="7";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');
                    }else {
                      _showErrorPopup(Strings.please_correct_pnc_date,ColorConstants.AppColorPrimary);
                      _pncDDdateController.text ="";
                      _pncMMdateController.text = "";
                      _pncYYYYdateController.text = "";
                    }
                  }else{
                    print('before pnc date');
                    _showErrorPopup(Strings.check_png_date,ColorConstants.AppColorPrimary);
                    _pncDDdateController.text ="";
                    _pncMMdateController.text = "";
                    _pncYYYYdateController.text = "";
                  }
                }
              }else{
                var deliveryAbortionDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
                print("deliveryAbortionDate ${deliveryAbortionDate}");
                if (_selectedDate.compareTo(deliveryAbortionDate) > 0) {
                  print('after pnc date');


                  var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
                  var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
                  print('AncDate calendr ${parseCalenderSelectedAncDate}');
                  print('AncDate intentt ${intentAncDate}');
                  final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays+1;
                  print('AncDate diff ${diff_lmp_ancdate}');
                  if(diff_lmp_ancdate == 0 || diff_lmp_ancdate == 1){
                    if(widget.DelplaceCode == "-1" || widget.DelplaceCode == "-2" ){
                      _PncFlag_post="1";

                      _pncDDdateController.text = getDate(formattedDate4);
                      _pncMMdateController.text = getMonth(formattedDate4);
                      _pncYYYYdateController.text = getYear(formattedDate4);
                      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                      print('_PncDatePost $_PncDatePost');

                    }else{
                      _showErrorPopup(Strings.difference_btw_png_deli,ColorConstants.AppColorPrimary);
                    }
                  }else if(diff_lmp_ancdate >= 2 && diff_lmp_ancdate <= 4){
                    _PncFlag_post="2";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');

                  }else if(diff_lmp_ancdate >= 6 && diff_lmp_ancdate <= 8){
                    _PncFlag_post="3";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');

                  }else if(diff_lmp_ancdate >= 13 && diff_lmp_ancdate <= 15){
                    _PncFlag_post="4";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');

                  }else if(diff_lmp_ancdate >= 19 && diff_lmp_ancdate <= 23){
                    _PncFlag_post="5";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');
                  }else if(diff_lmp_ancdate >= 26 && diff_lmp_ancdate <= 30){
                    _PncFlag_post="6";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');
                  }else if(diff_lmp_ancdate >= 40 && diff_lmp_ancdate <= 44){
                    _PncFlag_post="7";

                    _pncDDdateController.text = getDate(formattedDate4);
                    _pncMMdateController.text = getMonth(formattedDate4);
                    _pncYYYYdateController.text = getYear(formattedDate4);
                    _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                    print('_PncDatePost $_PncDatePost');
                  }else {
                    _showErrorPopup(Strings.please_correct_pnc_date,ColorConstants.AppColorPrimary);
                    _pncDDdateController.text ="";
                    _pncMMdateController.text = "";
                    _pncYYYYdateController.text = "";
                  }
                }else{
                  print('before pnc date');
                  _showErrorPopup(Strings.check_png_date,ColorConstants.AppColorPrimary);
                  _pncDDdateController.text ="";
                  _pncMMdateController.text = "";
                  _pncYYYYdateController.text = "";
                }
              }
            }
          }
        }
      });
  }

  void _selectANCDatePopup(int yyyy,int mm ,int dd) {
    showDatePicker(
        context: context,
        //initialDate: DateTime.now(),
        initialDate: (yyyy == 0 && mm == 0 && dd == 0) ? DateTime.now() : DateTime(yyyy, mm , dd ),
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

        _selectedANCDate = formattedDate2.toString();

        //var parsedCurrentDate = DateTime.parse(getCurrentDate());
        var parsedDate1 = DateTime.parse(formattedDate4.toString());
        //var parsedDate2 = DateTime.parse(getConvertRegDateFormat(getCurrentDate()));

      //  print('DateCondition ${formattedDate2.toString()}');
        //print('DateCondition currDt : ${getCurrentDate()}');
     //   print('DateCondition currDt : ${parsedDate2}');
        //print('DateCondition _selectedDate : ${_selectedDate}');

        //DateTime dt1 = DateTime.parse("2021-12-23 11:47:00");
        DateTime dt2 = DateTime.parse(getCurrentDate());

        if (formattedDate2.toString() == getCurrentDate2()) {
         // print('equal to current date#########');
          _showErrorPopup(Strings.PncDate_sahi_kare_msg,ColorConstants.AppColorPrimary);
        } else {
         // print('not equal to current date#########');
          //print('DateCondition dt1 : ${_selectedDate}');
          //print('DateCondition dt2 : ${dt2}');
          if(_selectedDate.compareTo(dt2) > 0){
         //   print("DT2 is after DT1");
            _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
          }else{
            var deliveryAbortionDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
            print("deliveryAbortionDate ${deliveryAbortionDate}");
            if (_selectedDate.compareTo(deliveryAbortionDate) > 0) {
               print('after pnc date');


               var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
               var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.DeliveryAbortionDate));
               print('AncDate calendr ${parseCalenderSelectedAncDate}');
               print('AncDate intentt ${intentAncDate}');
               final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays+1;
               print('AncDate diff ${diff_lmp_ancdate}');
               if(diff_lmp_ancdate == 0 || diff_lmp_ancdate == 1){
                 if(widget.DelplaceCode == "-1" || widget.DelplaceCode == "-2" ){
                   _PncFlag_post="1";

                   _pncDDdateController.text = getDate(formattedDate4);
                   _pncMMdateController.text = getMonth(formattedDate4);
                   _pncYYYYdateController.text = getYear(formattedDate4);
                   _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                   print('_PncDatePost $_PncDatePost');

                 }else{
                   _showErrorPopup(Strings.difference_btw_png_deli,ColorConstants.AppColorPrimary);
                 }
               }else if(diff_lmp_ancdate >= 2 && diff_lmp_ancdate <= 4){
                 _PncFlag_post="2";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');

               }else if(diff_lmp_ancdate >= 6 && diff_lmp_ancdate <= 8){
                 _PncFlag_post="3";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');

               }else if(diff_lmp_ancdate >= 13 && diff_lmp_ancdate <= 15){
                 _PncFlag_post="4";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');

               }else if(diff_lmp_ancdate >= 19 && diff_lmp_ancdate <= 23){
                 _PncFlag_post="5";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');
               }else if(diff_lmp_ancdate >= 26 && diff_lmp_ancdate <= 30){
                 _PncFlag_post="6";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');
               }else if(diff_lmp_ancdate >= 40 && diff_lmp_ancdate <= 44){
                 _PncFlag_post="7";

                 _pncDDdateController.text = getDate(formattedDate4);
                 _pncMMdateController.text = getMonth(formattedDate4);
                 _pncYYYYdateController.text = getYear(formattedDate4);
                 _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
                 print('_PncDatePost $_PncDatePost');
               }else {
                 _showErrorPopup(Strings.please_correct_pnc_date,ColorConstants.AppColorPrimary);
               }
            }else{
              print('before pnc date');
              _showErrorPopup(Strings.check_png_date,ColorConstants.AppColorPrimary);
            }
          }
        }
      });
    });
  }

  getCurrentDate() {
     return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    //return DateFormat('yyyy/MM/dd hh:mm:ss').format(DateTime.now());
  }
  getCurrentDate2() {
    // return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
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
                          color: ColorConstants.AppColorPrimary,
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

  void validatePostRequest() {
    if(aashaId == "0"){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }else if(anmId == "0"){
      _showErrorPopup(Strings.anm_chunai,ColorConstants.AppColorPrimary);
    }else if(motherComplId.isEmpty){
        _showErrorPopup(Strings.choose_mata_prasav_prob, ColorConstants.AppColorPrimary);
    }else if(motherComplId == "0"){
      _showErrorPopup(Strings.choose_mata_prasav_prob, ColorConstants.AppColorPrimary);
    }else if(motherComplId == "0"){
      _showErrorPopup(Strings.choose_mata_prasav_prob, ColorConstants.AppColorPrimary);
    }else if(_pncDDdateController.text.toString().isEmpty){
      _showErrorPopup(Strings.choosepncDate,Colors.black);
    }else if(_pncMMdateController.text.toString().isEmpty){
      _showErrorPopup(Strings.choosepncDate,Colors.black);
    }else if(_pncYYYYdateController.text.toString().isEmpty){
      _showErrorPopup(Strings.choosepncDate,Colors.black);
    }

    //child 1 validation conditions
    else if(rdChildIsLive1.isEmpty && _ShowHideShishuEntryView1 == true){
      _showErrorPopup(Strings.kya_shishu_is_live,Colors.black);
    }else if(_shishuWeightController.text.toString().isEmpty && _shishuWgtEnDisable == true){
      _showErrorPopup(Strings.enter_shishu_weight,Colors.black);
    }else if(_shishuWeightController.text.toString() == "0" && _shishuWgtEnDisable == true){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }else if(_shishuWeightController.text.toString().isNotEmpty && (double.parse(_shishuWeightController.text.toString()) > 9 && _shishuWgtEnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight_child,Colors.black);
    }else if(_shishuWeightController.text.toString().isNotEmpty && (double.parse(_shishuWeightController.text.toString()) < 0 && _shishuWgtEnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }
    //child 2 validation conditions
    else if(rdChildIsLive2.isEmpty && _ShowHideShishuEntryView2 == true){
      _showErrorPopup(Strings.kya_shishu_is_live,Colors.black);
    }else if(_shishuWeight2Controller.text.toString().isEmpty && _shishuWgt2EnDisable == true){
      _showErrorPopup(Strings.enter_shishu_weight,Colors.black);
    }else if((_shishuWeight2Controller.text.toString() == "0" && _shishuWgt2EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }else if(_shishuWeight2Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight2Controller.text.toString()) > 9 && _shishuWgt2EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight_child,Colors.black);
    }else if(_shishuWeight2Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight2Controller.text.toString()) < 0 && _shishuWgt2EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }
    //child 3 validation conditions
    else if(rdChildIsLive3.isEmpty && _ShowHideShishuEntryView3 == true){
      _showErrorPopup(Strings.kya_shishu_is_live,Colors.black);
    }else if(_shishuWeight3Controller.text.toString().isEmpty && _shishuWgt3EnDisable == true){
      _showErrorPopup(Strings.enter_shishu_weight,Colors.black);
    }else if(_shishuWeight3Controller.text.toString() == "0" && _shishuWgt3EnDisable == true){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }else if(_shishuWeight3Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight3Controller.text.toString()) > 9 && _shishuWgt3EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight_child,Colors.black);
    }else if(_shishuWeight3Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight3Controller.text.toString()) < 0 && _shishuWgt3EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }
    //child 4 validation conditions
    else if(rdChildIsLive4.isEmpty && _ShowHideShishuEntryView4 == true){
      _showErrorPopup(Strings.kya_shishu_is_live,Colors.black);
    }else if(_shishuWeight4Controller.text.toString().isEmpty && _shishuWgt4EnDisable == true){
      _showErrorPopup(Strings.enter_shishu_weight,Colors.black);
    }else if(_shishuWeight4Controller.text.toString() == "0" && _shishuWgt4EnDisable == true){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }else if(_shishuWeight4Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight4Controller.text.toString()) > 9 && _shishuWgt4EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight_child,Colors.black);
    }else if(_shishuWeight4Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight4Controller.text.toString()) < 0 && _shishuWgt4EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }

    //child 5 validation conditions
    else if(rdChildIsLive5.isEmpty && _ShowHideShishuEntryView5 == true){
      _showErrorPopup(Strings.kya_shishu_is_live,Colors.black);
    }else if(_shishuWeight5Controller.text.toString().isEmpty && _shishuWgt5EnDisable == true){
      _showErrorPopup(Strings.enter_shishu_weight,Colors.black);
    }else if(_shishuWeight5Controller.text.toString() == "0" && _shishuWgt5EnDisable == true){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }else if(_shishuWeight5Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight5Controller.text.toString()) > 9 && _shishuWgt5EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight_child,Colors.black);
    }else if(_shishuWeight5Controller.text.toString().isNotEmpty && (double.parse(_shishuWeight5Controller.text.toString()) < 0 && _shishuWgt5EnDisable == true)){
      _showErrorPopup(Strings.enter_correct_shishu_weight,Colors.black);
    }





    else if(_ShowHideShishuEntryView1 == true && rdChildIsLive1 == "0" && rdChildIsLiveEntry1 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(_ShowHideShishuEntryView2 == true && rdChildIsLive2 == "0" && rdChildIsLiveEntry2 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(_ShowHideShishuEntryView3 == true && childComplId_3 == "0" && rdChildIsLiveEntry3 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(_ShowHideShishuEntryView4 == true && childComplId_4 == "0" && rdChildIsLiveEntry4 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(_ShowHideShishuEntryView5 == true && childComplId_5 == "0" && rdChildIsLiveEntry5 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }

    /*else if(_ShowHideShishuEntryView1== true && childComplId_1 == "0"){
      _showErrorPopup(Strings.choose_danger_symp_in_shishu,Colors.black);
    }else if(_ShowHideShishuEntryView2== true && childComplId_2 == "0"){
      _showErrorPopup(Strings.choose_danger_symp_in_shishu,Colors.black);
    }else if(_ShowHideShishuEntryView3== true && childComplId_3 == "0"){
      _showErrorPopup(Strings.choose_danger_symp_in_shishu,Colors.black);
    }else if(_ShowHideShishuEntryView4== true && childComplId_4 == "0"){
      _showErrorPopup(Strings.choose_danger_symp_in_shishu,Colors.black);
    }else if(_ShowHideShishuEntryView5 == true && childComplId_5 == "0"){
      _showErrorPopup(Strings.choose_danger_symp_in_shishu,Colors.black);
    }else if(motherComplId == "3"){
      _showErrorPopup(Strings.pncDetailUpdate, ColorConstants.AppColorPrimary);
    }else if(rdChildIsLive1 == "0" && _ShowHideShishuEntryView1 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(rdChildIsLive2 == "0" && _ShowHideShishuEntryView2 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(rdChildIsLive3 == "0" && _ShowHideShishuEntryView3 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(rdChildIsLive4 == "0" && _ShowHideShishuEntryView4 == true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }else if(rdChildIsLive5 == "0" && _ShowHideShishuEntryView5== true){
      _showErrorPopup(Strings.pncDetailUpdate,Colors.black);
    }*/
    else if(_selectedPlacesReferCode == "0" && _ShowHideReferPlacesView == true){
      _showErrorPopup(Strings.refer_sanstha_type,Colors.black);
    }else if(_selectedDistrictUnitCode == "0000" && _ShowHideReferPlacesView == true){
      _showErrorPopup(Strings.choose_refer_jila,Colors.black);
    }else if(_selectedBlockUnitCode == "0" && _ShowHideReferPlacesView == true){
      _showErrorPopup(Strings.refer_block_choose,Colors.black);
    }else if(_latitude == "0.0" ){
      _getLocation();
    }else if(_longitude == "0.0" ){
      _getLocation();
    }else{
      postPNCRequest();
    }

  }

  var _Child1_Weight="";
  var _Child2_Weight="";
  var _Child3_Weight="";
  var _Child4_Weight="";
  var _Child5_Weight="";
  /*
    *
  */

  String sub_heading="";


  void postPNCRequest() async {
    preferences = await SharedPreferences.getInstance();

    if(preferences.getString("AppRoleID") == "33"){
      _Media="2";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else{
      _Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }


    if(_latitude == "0.0" || _longitude == "0.0"){
      _getLocation();
    }

    if(_shishuWeightController.text.toString().isEmpty){
      _Child1_Weight="0";
    }else{
      _Child1_Weight=_shishuWeightController.text.toString().trim();
    }
    if(_shishuWeight2Controller.text.toString().isEmpty){
      _Child2_Weight="0";
    }else{
      _Child2_Weight=_shishuWeight2Controller.text.toString().trim();
    }
    if(_shishuWeight3Controller.text.toString().isEmpty){
      _Child3_Weight="0";
    }else{
      _Child3_Weight=_shishuWeight3Controller.text.toString().trim();
    }
    if(_shishuWeight4Controller.text.toString().isEmpty){
      _Child4_Weight="0";
    }else{
      _Child4_Weight=_shishuWeight4Controller.text.toString().trim();
    }
    if(_shishuWeight5Controller.text.toString().isEmpty){
      _Child5_Weight="0";
    }else{
      _Child5_Weight=_shishuWeight5Controller.text.toString().trim();
    }

    if(_pncYYYYdateController.text.toString().isNotEmpty &&_pncMMdateController.text.toString().isNotEmpty &&_pncDDdateController.text.toString().isNotEmpty){
      _PncDatePost=_pncYYYYdateController.text.toString()+ "/"+_pncMMdateController.text.toString()+"/"+_pncDDdateController.text.toString();
      print('_PncDatePost $_PncDatePost');
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('pkg_version: ${packageInfo.version}');

    print('Motherid:${_motherid+
        "ANCRegID:"+_ancRegId+
        "PNCFlag:"+_PncFlag_post+
        "PNCComp:"+motherComplId+
        "PPCM:"+"0"+
        "PNCDate:"+_PncDatePost+
        "Ashaautoid:"+aashaId+
        "ReferUnitCode:"+_ReferUnitCode+
        "Child1_InfantID:"+_infantid1+
        "Child1_Comp:"+childComplId_1+
        "Child1_Weight:"+_Child1_Weight+
        "Child2_InfantID:"+_infantid2+
        "Child2_Comp:"+childComplId_2+
        "Child2_Weight:"+_Child2_Weight+
        "Child3_InfantID:"+_infantid3+
        "Child3_Comp:"+childComplId_3+
        "Child3_Weight:"+_Child3_Weight+
        "Child4_InfantID:"+_infantid4+
        "Child4_Comp:"+childComplId_4+
        "Child4_Weight:"+_Child4_Weight+
        "Child5_InfantID:"+_infantid5+
        "Child5_Comp:"+childComplId_5+
        "Child5_Weight:"+_Child5_Weight+
        "Freeze:"+"0"+
        "S_mthyr:"+"0"+
        "VillageAutoID:"+widget.VillageAutoID+
        "ANMautoid:"+anmId+
        "Child1_isLive:"+rdChildIsLive1+
        "Child2_isLive:"+rdChildIsLive2+
        "Child3_isLive:"+rdChildIsLive3+
        "Child4_isLive:"+rdChildIsLive4+
        "Child5_isLive:"+rdChildIsLive5+
        "media:"+_Media+
        "DeliveryDate:"+widget.DeliveryAbortionDate+
        "DelplaceCode:"+widget.DelplaceCode+
        "Latitude:"+_latitude+
        "Longitude:"+_longitude+
        "AppVersion:"+"5.5.5.22"+
        "UpdateUserNo:"+_UpdateUserNo+
        "EntryUserNo:"+_UpdateUserNo+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');
    callapi();
  }
  Future<SavedPNDDetailsData> callapi() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var response = await post(Uri.parse(_add_post_pnc_api), body: {
      "Motherid":_motherid,
      "ANCRegID":_ancRegId,
      "PNCFlag":_PncFlag_post,
      "PNCComp":motherComplId,
      "PPCM":"0",
      "PNCDate": _PncDatePost,
      "Ashaautoid": aashaId,
      "ReferUnitCode": _ReferUnitCode,
      "Child1_InfantID":_infantid1,
      "Child1_Comp": childComplId_1,
      "Child1_Weight": _Child1_Weight,
      "Child2_InfantID":_infantid2,
      "Child2_Comp": childComplId_2,
      "Child2_Weight": _Child2_Weight,
      "Child3_InfantID": _infantid3,
      "Child3_Comp":childComplId_3,
      "Child3_Weight": _Child3_Weight,
      "Child4_InfantID":_infantid4,
      "Child4_Comp": childComplId_4,
      "Child4_Weight":_Child4_Weight,
      "Child5_InfantID": _infantid5,
      "Child5_Comp": childComplId_5,
      "Child5_Weight": _Child5_Weight,
      "Freeze":"0",
      "S_mthyr":"0",
      "VillageAutoID": widget.VillageAutoID,
      "ANMautoid":anmId,
      "Child1_isLive":rdChildIsLive1,
      "Child2_isLive":rdChildIsLive2,
      "Child3_isLive":rdChildIsLive3,
      "Child4_isLive":rdChildIsLive4,
      "Child5_isLive":rdChildIsLive5,
      "media":_Media,
      "DeliveryDate":widget.DeliveryAbortionDate,
      "DelplaceCode":widget.DelplaceCode,
      "Latitude":_latitude,
      "Longitude":_longitude,
      "AppVersion": _checkPlatform == "0" ? preferences.getString("Appversion") : "",
      "IOSAppVersion": _checkPlatform == "1" ? IosVersion.ios_version : "",
      "UpdateUserNo":_UpdateUserNo,
      "EntryUserNo": _UpdateUserNo,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SavedPNDDetailsData.fromJson(resBody);
    setState(() {
      //{
      //     "AppVersion": 0,
      //     "Message": "धन्यवाद, एएनसी का विवरण सेव हो चुका हैं।",
      //     "Status": true,
      //     "ResposeData": null
      // }
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
    return SavedPNDDetailsData.fromJson(resBody);
  }
  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
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

  void checkifAnyChildLive(String rdChildIsLive1, String rdChildIsLive2, String rdChildIsLive3, String rdChildIsLive4, String rdChildIsLive5) {
    if(motherComplId == "3"){//if mother dead ,submit button & refer view will be hide
      _ShowHideReferPlacesView=false;
      _ShowHideErrorView=true;
      _ShowHideADDNewVivranView=false;
    }else{
      if(rdChildIsLive1 == "0" || rdChildIsLive2 == "0" || rdChildIsLive3 == "0" || rdChildIsLive4 == "0" || rdChildIsLive4 == "0"){
        _ShowHideReferPlacesView=false;
        _ShowHideErrorView=true;
        _ShowHideADDNewVivranView=false;
      }else{
        if(motherComplId == "5"){
          _ShowHideReferPlacesView=false;
          _ShowHideErrorView=false;
          _ShowHideADDNewVivranView=false;
        }else{
          _ShowHideReferPlacesView=true;
          _ShowHideErrorView=false;
          _ShowHideADDNewVivranView=true;
        }
       /* _ShowHideReferPlacesView=true;
        _ShowHideErrorView=false;
        _ShowHideADDNewVivranView=true;*/
      }
    }
    /*if(_ShowHideShishuEntryView1 == true && rdChildIsLive1 == "1"  ||
        _ShowHideShishuEntryView2 == true && rdChildIsLive2 == "1"  ||
        _ShowHideShishuEntryView3 == true && rdChildIsLive3 == "1"  ||
        _ShowHideShishuEntryView4 == true && rdChildIsLive4 == "1"  ||
        _ShowHideShishuEntryView5 == true && rdChildIsLive5 == "1"){//1=live,0=dead
      _ShowHideReferPlacesView=true;
      _ShowHideErrorView=false;
      _ShowHideADDNewVivranView=true;
    }else{
      if(motherComplId == "3" && (rdChildIsLive1 == "0" || rdChildIsLive2 == "0" || rdChildIsLive3 == "0" || rdChildIsLive4 == "0" || rdChildIsLive5 == "0" )){
        _ShowHideErrorView=true;
        _ShowHideReferPlacesView=false;
        _ShowHideADDNewVivranView=false;
      }else{
        if((motherComplId != "3" || motherComplId != "0" || motherComplId != "5") && (rdChildIsLive1 == "0" || rdChildIsLive2 == "0" || rdChildIsLive3 == "0" || rdChildIsLive4 == "0" || rdChildIsLive5 == "0" )){
          _ShowHideErrorView=true;
          _ShowHideReferPlacesView=false;
          _ShowHideADDNewVivranView=false;
        }else{
          _ShowHideReferPlacesView=true;
          _ShowHideErrorView=false;
          _ShowHideADDNewVivranView=true;
        }
      }
    }*/
    /*if(rdChildIsLive1 == "1" || rdChildIsLive2 == "1" || rdChildIsLive3 == "1" ||rdChildIsLive4 == "1" ||rdChildIsLive5 == "1"){//show
      _ShowHideReferPlacesView=true;
      _ShowHideErrorView=false;
      _ShowHideADDNewVivranView=false;
      _ShowHideADDNewVivranView=true;
    }else{//hide
      _ShowHideErrorView=true;
      _ShowHideReferPlacesView=false;
      _ShowHideADDNewVivranView=false;
    }*/
    /*if( _ShowHideShishuEntryView1 == true && rdChildIsLive1 == "0"  ||
        _ShowHideShishuEntryView2 == true && rdChildIsLive2 == "0"  ||
        _ShowHideShishuEntryView3 == true && rdChildIsLive3 == "0"  ||
        _ShowHideShishuEntryView4 == true && rdChildIsLive4 == "0"  ||
        _ShowHideShishuEntryView5 == true && rdChildIsLive5 == "0"){
        setState(() {

        });
    }else{
        setState(() {

        });
    }*/
  }
  void checkShowHideSaveButton(String rdChildIsLive1, String rdChildIsLive2, String rdChildIsLive3, String rdChildIsLive4, String rdChildIsLive5) {
    if( _ShowHideShishuEntryView1 == true && rdChildIsLive1 == "0"  ||
        _ShowHideShishuEntryView2 == true && rdChildIsLive2 == "0"  ||
        _ShowHideShishuEntryView3 == true && rdChildIsLive3 == "0"  ||
        _ShowHideShishuEntryView4 == true && rdChildIsLive4 == "0"  ||
        _ShowHideShishuEntryView5 == true && rdChildIsLive5 == "0"){
        setState(() {
          if(_isFirstChildLive == true || _isSecondChildLive == true || _isThirdChildLive == true ||_isFourthChildLive == true || _isFifthChildLive == true){ //false=dead, true=live
            _ShowHideReferPlacesView=true;
            _ShowHideErrorView=false;
            _ShowHideADDNewVivranView=true;
          }else{
            _ShowHideADDNewVivranView=false;
            _ShowHideErrorView=true;
            _ShowHideReferPlacesView=false;
          }
        });
    }else{
        setState(() {
          if(motherComplId == "3"){//check if mother is not selected as Dead
            if(widget.MotherDeathDate.isEmpty){
              _ShowHideADDNewVivranView=false;
              _ShowHideErrorView=true;
              _ShowHideReferPlacesView=false;
            }else{
              _ShowHideADDNewVivranView=true;
              _ShowHideErrorView=false;
              _ShowHideReferPlacesView=true;
            }
          }else{
            if(motherComplId == "5"){
              _ShowHideReferPlacesView=false;
              _ShowHideErrorView=false;
              _ShowHideADDNewVivranView=true;
            }else{
              _ShowHideReferPlacesView=true;
              _ShowHideErrorView=false;
              _ShowHideADDNewVivranView=true;
            }
            /*_ShowHideReferPlacesView=true;
            _ShowHideErrorView=false;
            _ShowHideADDNewVivranView=true;*/
          }
        });
    }
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

enum ShihuIsLive { none,yes,no}
enum ShihuIsLive2 { none,yes,no}
enum ShihuIsLive3 { none,yes,no}
enum ShihuIsLive4 { none,yes,no}
enum ShihuIsLive5 { none,yes,no}

ShihuIsLive _shishuislive = ShihuIsLive.none;
ShihuIsLive2 _shishuislive2 = ShihuIsLive2.none;
ShihuIsLive3 _shishuislive3 = ShihuIsLive3.none;
ShihuIsLive4 _shishuislive4 = ShihuIsLive4.none;
ShihuIsLive5 _shishuislive5 = ShihuIsLive5.none;

class CustomChildNameList {
  String? ChildName;
  String? InfantID;
  String? Status;

  CustomChildNameList({this.ChildName,this.InfantID,this.Status});
}
class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}
class CustomMotherComplList {
  String? Name;
  String? masterID;

  CustomMotherComplList({this.Name, this.masterID});
}
class CustomChildComplList {
  String? Name;
  String? masterID;

  CustomChildComplList({this.Name, this.masterID});
}
class CustomAanganBadiList {
  String? NameH;
  String? NameE;
  String? AnganwariNo;
  String? LastUpdated;

  CustomAanganBadiList(
      {this.NameH, this.NameE, this.AnganwariNo, this.LastUpdated});
}

class CustomANMList {
  String? AshaName;
  String? ashaAutoID;

  CustomANMList({this.AshaName,this.ashaAutoID});
}
class CustomPlacesReferCodeList {
  String? code;
  String? title;

  CustomPlacesReferCodeList({this.code,this.title});
}
class CustomDistrictCodeList {
  String? unitcode;
  String? unitNameHindi;

  CustomDistrictCodeList({this.unitcode,this.unitNameHindi});
}
class CustomBlockCodeList {
  String? unitcode;
  String? unitNameHindi;

  CustomBlockCodeList({this.unitcode,this.unitNameHindi});
}