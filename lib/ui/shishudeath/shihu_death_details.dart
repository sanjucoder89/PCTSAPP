import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcts/ui/hbyc/model/SavedHBYCDetailsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/model/GetAashaListData.dart';
import '../prasav/model/GetDistrictListData.dart';
import '../prasav/model/TreatmentListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/GetChildDeathDetailsData.dart';
import 'model/GetDeathDetailsData.dart';
import 'model/GetDeathReasonListData.dart'; //for date format

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


class ShishuDeathDetails extends StatefulWidget {
  const ShishuDeathDetails({Key? key,
    required this.pctsID,
    required this.infantId,
    required this.birthdate,
    required this.DeathReportDate,
  }) : super(key: key);

  final String pctsID;
  final String infantId;
  final String birthdate;
  final String DeathReportDate;

  @override
  State<ShishuDeathDetails> createState() => _ShishuDeathDetailsState();
}

class _ShishuDeathDetailsState extends State<ShishuDeathDetails> {

  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _get_child_death_details_url = AppConstants.app_base_url + "uspInfantDataforInfantDeathByInfantID";
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _get_death_reason_list_url = AppConstants.app_base_url + "PostInfantDeathReason";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postfillBlock";
  var _get_chchc_list = AppConstants.app_base_url + "postfillCHCPHC";
  var _get_upswasthya_list = AppConstants.app_base_url + "postfillSubcenter";
  var _edit_child_details_url = AppConstants.app_base_url + "PutInfantDeathDetails";
  var _add_child_details_url = AppConstants.app_base_url + "PostInfantDeathDetails";

  TextEditingController _enterChildNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController _enterChildWeight = TextEditingController();
  TextEditingController _mukhiyaNameController = TextEditingController();
  TextEditingController _mukhiyaMobNoController = TextEditingController();


  TextEditingController _deathDDdateController = TextEditingController();
  TextEditingController _deathMMdateController = TextEditingController();
  TextEditingController _deathYYYYdateController = TextEditingController();

  TextEditingController _reportDDdateController = TextEditingController();
  TextEditingController _reportMMdateController = TextEditingController();
  TextEditingController _reportYYYYdateController = TextEditingController();

  var wifeOfHusbandName="";
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  List help_response_listing = [];
  late SharedPreferences preferences;
  ScrollController? _controller;

  var BFeed="";
  var BCGIMMU="";
  var _DeathDeath="";
  var _reportdeathPostDate="";
  var postDeathUnitID="";
  var _AgeType="";
  var _BloodGroup="";
  var  submit_title="";
  var  change_title=Strings.sa_pra_dispensary;
  var  change_title_block=Strings.block;

  bool isClickableEnableDisable=true;
  bool finalButtonView=false;



  bool referSansthaView=false;
  bool referJilaView=false;
  bool referBlockView=false;
  bool sapraView=false;
  bool upSwasthyaKendraView=false;
  bool distView=false;

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


  List response_list = [];
  late String aashaId = "";
  late String AnmVerify = "";

  Future<String> getDeathDetailsAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('infantID ${widget.infantId}');
    var response = await post(Uri.parse(_get_child_death_details_url), body: {
      "InfantID": widget.infantId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChildDeathDetailsData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        print('res.len  ${response_list.length}');

        if(preferences.getString("AppRoleID").toString() == '33' ){
          aashaId = preferences.getString('ANMAutoID').toString();
            if(response_list[0]['ashaautoid'].toString() == aashaId){
              _isItAsha=true;
            }else{
              _isItAsha=false;
            }
        }else{
          aashaId=response_list[0]['ashaautoid'].toString();
          _isItAsha=true;
        }
        AnmVerify=response_list[0]['ANMVerify'].toString() == "null" ? "0" : response_list[0]['ANMVerify'].toString();
        getAashaListAPI(response_list[0]['RegUnitid'].toString(),response_list[0]['VillageAutoID'].toString());
        getDistrictListAPI("3");
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
  List<CustomAashaList> custom_aasha_list = [];
  List aasha_response_list = [];
  bool _isItAsha=true;
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
        custom_aasha_list
            .add(CustomAashaList(ASHAName: Strings.choose, ASHAAutoid: "0"));
        for (int i = 0; i < aasha_response_list.length; i++) {
          custom_aasha_list.add(CustomAashaList(
              ASHAName: aasha_response_list[i]['ASHAName'].toString(),
              ASHAAutoid: aasha_response_list[i]['ASHAAutoid'].toString()));
        }
        //aashaId = custom_aasha_list[0].ASHAAutoid.toString();
      }
      //getRemainingTikaiListAPI();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  List response_district_list= [];
  List<CustomDistrictCodeList> custom_district_list = [];
  var _selectedDistrictUnitCode = "0";
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
      } else {
        custom_district_list.clear();
      }
      setPreviousData();
    });
    print('response:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }
  Future<GetDistrictListData> getDistrictListAPIReset(String refUnitType) async {
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
      } else {
        custom_district_list.clear();
      }
    });
    print('Didresponse:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }

  var _selectedBlockUnitCode = "000000";
  var _selectedCHPhcCode = "000000000";
  var _selectedUpSwasthyaCode = "0";
  List<CustomBlockCodeList> custom_block_list = [];
  var _Action="";
  Future<String> getBlockListAPI(String refUnitType,String refUnitCode) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('DeathUnittype $refUnitType');
    print('DeathUnitCode $refUnitCode');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_block_list_url), body: {
      "DeathUnittype": refUnitType,
      "DeathUnitCode": refUnitCode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    print('res.body ${response.body.toString()}');
    List<dynamic> x2 = jsonDecode(response.body.toString());
    // print(x2[0]);
    setState(() {
      custom_block_list.clear();
      custom_block_list.add(CustomBlockCodeList(UnitID:"0", UnitName:Strings.choose,UnitCode: "000000"));
      for (int i = 0; i < x2.length; i++) {
        custom_block_list.add(CustomBlockCodeList(UnitID:x2[i]['UnitID'].toString(),//{UnitID: 216, UnitName: अरॉई, UnitCode: 01010600000}
            UnitName:x2[i]['UnitName'].toString(),
            UnitCode:x2[i]['UnitCode'].toString()));
      }
      print('testblockcode len ${custom_block_list.length}');
      //print('testblockcode old ${custom_block_list[0].UnitCode.toString()}');
    //  print('testblockcode _selectedBlockUnitCode ${_selectedBlockUnitCode}');
      _selectedBlockUnitCode = custom_block_list[0].UnitCode.toString();

      if(_selectedReferSanstha == "16"){
        getCHPHCListAPI(refUnitCode+"00", _selectedReferSanstha, "1");
        postDeathUnitID=response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString();
        print('selected postDeathUnitID ${postDeathUnitID}');
      }else{
        if(response_list[0]['deathPlaceUnitcode'].toString() != "null"){
          for (int i = 0; i < custom_block_list.length; i++) {
            if(custom_block_list[i].UnitCode.toString().substring(0,6) == response_list[0]['deathPlaceUnitcode'].toString().substring(0, 6)){
              _selectedBlockUnitCode=custom_block_list[i].UnitCode.toString();
              postDeathUnitID=response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString();
              print('selected postDeathUnitID ${postDeathUnitID}');
            }
          }
          var blockValue=0;
          for (int pos = 0; pos < custom_block_list.length; pos++) {
            if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode){
              print('selected position ${pos}');
              blockValue=pos;
              break;
            }
          }
          print('prev_refer_sanstha $_selectedReferSanstha');
          if(blockValue == 0){
            _Action="2";
            getCHPHCListAPI(response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString(),
                response_list[0]['deathPlaceUnittype'].toString(), _Action);
          }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" ||_selectedReferSanstha == "16"){
            _Action="1";
            getCHPHCListAPI(response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString(),
                response_list[0]['deathPlaceUnittype'].toString(), _Action);
          }else if(_selectedReferSanstha == "11"){
            if(blockValue == 0){
              _Action="2";
              getCHPHCListAPI(response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString(),
                  response_list[0]['deathPlaceUnittype'].toString(), _Action);

            }else{
              _Action="3";
              getCHPHCListAPI(response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString(),
                  response_list[0]['deathPlaceUnittype'].toString(), _Action);
            }
          }else{
            _Action="1";
            getCHPHCListAPI(response_list[0]['deathPlaceUnitcode'].toString() == "null" ? "" : response_list[0]['deathPlaceUnitcode'].toString() == null ? "" : response_list[0]['deathPlaceUnitcode'].toString(),
                response_list[0]['deathPlaceUnittype'].toString(), _Action);
          }
        }
      }
      EasyLoading.dismiss();
    });

    return "Success";
  }
  List<CustomCHCPHCList> custom_chcph_list = [];
  List<CustomUPSwasthyaList> custom_upswasthya_list = [];
  Future<String> getCHPHCListAPI(String _DeathUnitCode,String _DeathUnittype,String _Action) async {
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
      "DeathUnitCode": _DeathUnitCode.substring(0,6),
      "DeathUnittype": _DeathUnittype,
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


        /*
        * Set Last CHPCH Value
        * */
        for (int i = 0; i < custom_chcph_list.length; i++) {
          //print('unitcode ${custom_chcph_list[i].UnitCode.toString()}');
          //print('unitcode du ${_DeathUnitCode}');
          if(_DeathUnitCode.length > 6) {
            if (custom_chcph_list[i].UnitCode.toString().substring(0, 9) == _DeathUnitCode.substring(0, 9)) {
              _selectedCHPhcCode = custom_chcph_list[i].UnitCode.toString();
            }
          }else{
            if(postDeathUnitID == custom_chcph_list[i].UnitCode.toString()){
              _selectedCHPhcCode = custom_chcph_list[i].UnitCode.toString();
              print('postDeathUnitID_last. ${postDeathUnitID}');
              print('private_acre_hosp. ${_selectedCHPhcCode}');
            }
          }
        }

      }else{
        custom_chcph_list.clear();
        print('chphc.len ${custom_chcph_list.length}');
      }
      if(_selectedReferSanstha != "16"){
        getUpSwasthyaListAPI(_DeathUnitCode,_DeathUnittype);
      }

      //  EasyLoading.dismiss();
    });
    return "Success";
  }

  Future<String> getUpSwasthyaListAPI(String _DeathUnitCode,String _DeathUnittype) async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    print('requestVal -dunicode ${_DeathUnitCode}');
    print('requestVal -dunittype ${_DeathUnittype}');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_upswasthya_list), body: {
      "DeathUnitCode": _DeathUnitCode.substring(0,9),
      "DeathUnittype": _DeathUnittype,
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
        print('_selectedUpSwasthyaCode ${_selectedUpSwasthyaCode}');
        print('upswasthya.len ${custom_upswasthya_list.length}');


        /*
        * Set Last UP Swasthaya Value
        * */
        for (int i = 0; i < custom_upswasthya_list.length; i++) {
          if(custom_upswasthya_list[i].UnitCode.toString() == _DeathUnitCode){
            _selectedUpSwasthyaCode=custom_upswasthya_list[i].UnitCode.toString();
          }
        }

      }else{
        custom_upswasthya_list.clear();
        print('swasthya.len ${custom_upswasthya_list.length}');
      }
      //  EasyLoading.dismiss();
    });
    return "Success";
  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void setPreviousData() {

    setState(() {
      if(response_list[0]['Status'].toString() != "null"){
        if(response_list[0]['Status'].toString() == "2"){
          if(response_list[0]['flag'].toString() == "0"){
            _showErrorPopup(Strings.show_if_after_30_days, ColorConstants.AppColorPrimary);
            finalButtonView=false;
          }else if(response_list[0]['Freeze'].toString() == "1"){
            _showErrorPopup(Strings.show_cannot_update, ColorConstants.AppColorPrimary);
            finalButtonView=false;
          }
        }else{
          submit_title=Strings.vivran_save_krai;
          finalButtonView=true;
        }
      }

      if(response_list[0]['Weight'].toString() != "null"){
        _enterChildWeight.text=response_list[0]['Weight'].toString();
      }

      if(response_list[0]['DeathDate'].toString() != "null"){
        wifeOfHusbandName= response_list[0]['Name']+" W/o "+response_list[0]['Husbname'];
        _enterChildNameController.text=response_list[0]['ChildName'].toString() == "null" ? "" : response_list[0]['ChildName'].toString() ;

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
      }else{
        wifeOfHusbandName= response_list[0]['Name']+" W/o "+response_list[0]['Husbname'];
      }


      ageController.text=response_list[0]['Age'].toString() == "null" ? "" : response_list[0]['Age'].toString() ;

      if(response_list[0]['AgeType'].toString() != "null"){
        if(response_list[0]['AgeType'].toString() == "1"){
          _selectedAgeCategory="वर्ष";
          _AgeType="1";
        }else if(response_list[0]['AgeType'].toString() == "2"){
          _selectedAgeCategory="माह";
          _AgeType="2";
        }else if(response_list[0]['AgeType'].toString() == "3"){
          _selectedAgeCategory="सप्ताह";
          _AgeType="3";
        }else if(response_list[0]['AgeType'].toString() == "4"){
          _selectedAgeCategory="दिन";
          _AgeType="4";
        }else if(response_list[0]['AgeType'].toString() == "5"){
          _selectedAgeCategory="घंटे";
          _AgeType="5";
        }
      }else{
        _selectedAgeCategory="चुनें";
        _AgeType="0";
      }


      if(response_list[0]['BloodGroup'].toString() != "null"){
        if(response_list[0]['BloodGroup'].toString() == "1"){
          _selectedBloodGroup="O+";
          _BloodGroup="1";
        }else if(response_list[0]['BloodGroup'].toString() == "2"){
          _selectedBloodGroup="O-";
          _BloodGroup="2";
        }else if(response_list[0]['BloodGroup'].toString() == "3"){
          _selectedBloodGroup="A+";
          _BloodGroup="3";
        }else if(response_list[0]['BloodGroup'].toString() == "4"){
          _selectedBloodGroup="A-";
          _BloodGroup="4";
        }else if(response_list[0]['BloodGroup'].toString() == "5"){
          _selectedBloodGroup="B+";
          _BloodGroup="5";
        }else if(response_list[0]['BloodGroup'].toString() == "6"){
          _selectedBloodGroup="B-";
          _BloodGroup="6";
        }else if(response_list[0]['BloodGroup'].toString() == "7"){
          _selectedBloodGroup="AB-";
          _BloodGroup="7";
        }else{
          _selectedBloodGroup="चुनें";
          _BloodGroup="0";
        }
      }else{
        _selectedBloodGroup="चुनें";
        _BloodGroup="0";
      }


      if(response_list[0]['Bfeed'].toString() != "null"){
        if(response_list[0]['Bfeed'].toString() == "1"){
          BFeed="1";
          _choose=colors.yes;
        }else{
          BFeed="0";
          _choose=colors.no;
        }
      }

      if(response_list[0]['immucode'].toString() != "null"){
        if(response_list[0]['immucode'].toString() == "1"){
          _chooseimmu=colorsimmu.yes;
          BCGIMMU="1";
        }else{
          _chooseimmu=colorsimmu.no;
          BCGIMMU="0";
        }
      }
      print('BCGIMMU $BCGIMMU');

      if(response_list[0]['DeathDate'].toString() != "null"){
        var deathParsedDate = DateTime.parse(getConvertRegDateFormat(response_list[0]['DeathDate'].toString()));
        print('deathParsedDate ${deathParsedDate}');

        _deathDDdateController.text = getDate(deathParsedDate.toString());
        _deathMMdateController.text = getMonth(deathParsedDate.toString());
        _deathYYYYdateController.text = getYear(deathParsedDate.toString());
        _DeathDeath=_deathYYYYdateController.text.toString()+ "/"+_deathMMdateController.text.toString()+"/"+_deathDDdateController.text.toString();
        print('_DeathDeath $_DeathDeath');
      }


      dreasonId=response_list[0]['ReasonID'].toString();
      ANMVerify=response_list[0]['ANMVerify'].toString() == "null" ? "0" : response_list[0]['ANMVerify'].toString();

      if(response_list[0]['AgeType'].toString() != "0"){
        print('inside dfdfdfd');
        getDeathReasonListAPI(response_list[0]['AgeType'].toString());
      }

      if(response_list[0]['DeathReportDate'].toString() != "null"){
        var dRportParsedDate = DateTime.parse(getConvertRegDateFormat(response_list[0]['DeathReportDate'].toString()));
        print('dRportParsedDate ${dRportParsedDate}');

        _reportDDdateController.text = getDate(dRportParsedDate.toString());
        _reportMMdateController.text = getMonth(dRportParsedDate.toString());
        _reportYYYYdateController.text = getYear(dRportParsedDate.toString());
        _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
        print('_reportdeathPostDate $_reportdeathPostDate');
      }



      if(response_list[0]['deathPlace'].toString() != "null"){
        if(response_list[0]['deathPlace'].toString() != "0"){
          if(response_list[0]['deathPlace'].toString() != ""){
            if(response_list[0]['deathPlace'].toString() == "17"){
              _selectedDeathPlace="2";
              _selectedReferSanstha="17";
              referSansthaView=false;
              referBlockView=false;
            }else{
              _selectedDeathPlace=response_list[0]['deathPlace'].toString();
              referSansthaView=false;
            }
          }
        }
      }
      print('_selectedDeathPlace ${_selectedDeathPlace}');




      //Set Refer Sanstha Last Selected Item

        for (int i = 0; i < refer_sanstha_list.length; i++) {
          if(refer_sanstha_list[i].code.toString() == response_list[0]['deathPlaceUnittype'].toString()){
            _selectedReferSanstha=response_list[0]['deathPlaceUnittype'].toString();
            change_title=refer_sanstha_list[i].title.toString();
          }
        }
        print('refer_santha ${_selectedReferSanstha}');


      //before
      setState(() {
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
          change_title=Strings.sa_pra_dispensary;
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
      });

      //set Last Refer Jila/District Selected Item
      for (int i = 0; i < custom_district_list.length; i++) {
        if(custom_district_list[i].unitcode.toString().substring(0,4) == response_list[0]['deathPlaceUnitcode'].toString().substring(0, 4)){
          _selectedDistrictUnitCode=custom_district_list[i].unitcode.toString();
         // print('CheckValue assign ${_selectedDistrictUnitCode}');//CheckValue assign 01010000000
          print('postvalidate ${custom_district_list[i].unitcode.toString().substring(0,4)}');//CheckValue assign 01010000000
        }
      }



      if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" ||
          _selectedReferSanstha == "10" ||_selectedReferSanstha == "11" ||
          _selectedReferSanstha == "16"){
        getBlockListAPI("4",_selectedDistrictUnitCode.substring(0, 4));
      }else{
        getBlockListAPI(_selectedReferSanstha,_selectedDistrictUnitCode.substring(0, 4));
      }

      //before
      if(_selectedDeathPlace =="2"){
        if(_selectedReferSanstha == "17"){
          referSansthaView=true;
          referJilaView=false;
          referBlockView=false;
        }else{
          referSansthaView=true;
          referJilaView=true;
          referBlockView=true;
        }
      }else if(_selectedDeathPlace == "1"){
        referSansthaView=false;
        referJilaView=false;
        referBlockView=false;
        sapraView=false;
        upSwasthyaKendraView=false;
      }else if(_selectedDeathPlace == "3"){
        referSansthaView=false;
        referJilaView=false;
        referBlockView=false;
      }else if(_selectedDeathPlace == "4"){
        referSansthaView=false;
      }else{
        referSansthaView=false;
        referJilaView=false;
        referBlockView=false;
      }

      if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32"){
          if(response_list[0]['DeathDate'].toString() == "null"){
            finalButtonView=true;
            submit_title=Strings.vivran_save_krai;
          }else{
            finalButtonView=true;
            if(AnmVerify == "1"){
              submit_title="एएनएम द्वारा सत्यापित ";
              isClickableEnableDisable=false;
            }else{
              submit_title="सत्यापित / विवरण अपडेट करें";
              isClickableEnableDisable=true;
            }
          }
      }else if(preferences.getString("AppRoleID") == "33"){
        if(response_list[0]['ANMVerify'].toString() == "1"){
          submit_title="एएनएम द्वारा सत्यापित ";
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


    });
  }

  @override
  void initState() {
    super.initState();
    getDeathDetailsAPI();
    getHelpDesk();
  }
  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

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
  List<CustomReasonList> custom_reason_list = [];
  List dreason_response_list = [];
  late String dreasonId = "";
  Future<String> getDeathReasonListAPI(String _AgeType) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_death_reason_list_url), body: {
      "AgeType": _AgeType,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetDeathReasonListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_reason_list.clear();
        dreason_response_list = resBody['ResposeData'];
        custom_reason_list.add(CustomReasonList(ReasonName:Strings.choose, ReasonID: "0",DeathType: "0"));

        for (int i = 0; i < dreason_response_list.length; i++) {
          custom_reason_list.add(CustomReasonList(
              ReasonName: dreason_response_list[i]['ReasonName'].toString(),
              ReasonID: dreason_response_list[i]['ReasonID'].toString(),
              DeathType: dreason_response_list[i]['DeathType'].toString()
          ));
        }
        if(response_list[0]['ReasonID'].toString() != "null"){
          dreasonId=response_list[0]['ReasonID'].toString() == "null" ? "" : response_list[0]['ReasonID'].toString();
        }else{
          dreasonId = custom_reason_list[0].ReasonID.toString();
        }
        print('dreasonId $dreasonId');

      } else {}
      //EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
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
        title: Column(
          children: [
            Text(Strings.shishu_kai_death_vivran_title,
                style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.normal)),
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              height: 25,
              color: ColorConstants.lifebgColor,
              child: Align(
                alignment: Alignment.center,
                child: Text('$wifeOfHusbandName',textAlign:TextAlign.center,style: TextStyle(color:Colors.black,fontSize: 14),),
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
                        onChanged:_isItAsha == false ? null : (String? newVal) {
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
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
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
                      //textScaleFactor: labelTextScale,
                      //maxLines: labelMaxLines,
                      // overflow: overflow,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(1),
                    height: 40,
                    child: Form(
                      key: _formKey1,
                      child: TextFormField(
                        maxLength: 10,
                        controller: _enterChildNameController,
                        decoration: InputDecoration(
                            hintText: Strings.name_of_child,
                            contentPadding: EdgeInsets.zero,
                          counterText: "",

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
                                  text: Strings.death_date,
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
                                      controller: _deathDDdateController,
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
                                        if(_deathDDdateController.text.toString().length == 2 && _deathMMdateController.text.toString().length == 2 && _deathYYYYdateController.text.toString().length == 4){
                                          _selectANCDatePopupCustom(_deathYYYYdateController.text.toString()+"-"+_deathMMdateController.text.toString()+"-"+_deathDDdateController.text.toString()+" 00:00:00.000");
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
                                      controller: _deathMMdateController,
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
                                        if(_deathDDdateController.text.toString().length == 2 && _deathMMdateController.text.toString().length == 2 && _deathYYYYdateController.text.toString().length == 4){
                                          _selectANCDatePopupCustom(_deathYYYYdateController.text.toString()+"-"+_deathMMdateController.text.toString()+"-"+_deathDDdateController.text.toString()+" 00:00:00.000");
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
                                      controller: _deathYYYYdateController,
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
                                        if(_deathDDdateController.text.toString().length == 2 && _deathMMdateController.text.toString().length == 2 && _deathYYYYdateController.text.toString().length == 4){
                                          _selectANCDatePopupCustom(_deathYYYYdateController.text.toString()+"-"+_deathMMdateController.text.toString()+"-"+_deathDDdateController.text.toString()+" 00:00:00.000");
                                        }
                                      }
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(response_list[0]['DeathDate'].toString() != "null"){
                              _selectANCDatePopup(int.parse(_deathYYYYdateController.text.toString()),int.parse(_deathMMdateController.text.toString()) ,int.parse(_deathDDdateController.text.toString()));
                            }else{
                              _selectANCDatePopup(0,0,0);
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

                ],
              ),
            ),

            Container(
              height: 40,
              child: Row(
                children:<Widget> [
                  Expanded(child: Container(child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        Strings.blood_group,
                        style: TextStyle(
                            color: Colors.black, fontSize: 13),
                      ),
                    ),
                  ),)),
                  Expanded(child: Container(color: Colors.white,
                    margin: EdgeInsets.only(right: 5),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.all(3),
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
                          items: blood_group_list.map((item) {
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
                                value: item.title.toString() //Id that has to be passed that the dropdown has.....
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState(() {
                              _selectedBloodGroup = newVal!;
                              if(_selectedBloodGroup == "O+"){
                                _BloodGroup="1";
                              }else if(_selectedBloodGroup == "O-"){
                                _BloodGroup="2";
                              }else if(_selectedBloodGroup == "A+"){
                                _BloodGroup="3";
                              }else if(_selectedBloodGroup == "A-"){
                                _BloodGroup="4";
                              }else if(_selectedBloodGroup == "B+"){
                                _BloodGroup="5";
                              }else if(_selectedBloodGroup == "B-"){
                                _BloodGroup="6";
                              }else if(_selectedBloodGroup == "AB-"){
                                _BloodGroup="7";
                              }else{
                                _BloodGroup="0";
                              }
                            });
                          },
                          value: _selectedBloodGroup, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                        ),
                      ),
                    ),))
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
                      child: Container(
                        color: Colors.white,
                        child: RichText(
                          text: TextSpan(
                              text: Strings.child_feeding_in_1Hour,
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
                                        Radio<colors>(
                                          activeColor: Colors.black,
                                          value: colors.yes,
                                          groupValue: _choose,
                                          onChanged: (colors? value) {
                                            setState(() {
                                              _choose = value ?? _choose;
                                              BFeed="1";
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
                                        Radio<colors>(
                                          activeColor: Colors.black,
                                          value: colors.no,
                                          groupValue: _choose,
                                          onChanged: (colors? value) {
                                            setState(() {
                                              _choose = value ?? _choose;
                                              BFeed="0";
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        color: Colors.white,
                        child: RichText(
                          text: TextSpan(
                              text: Strings.child_BCG_yes_no,
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
                                        Radio<colorsimmu>(
                                          activeColor: Colors.black,
                                          value: colorsimmu.yes,
                                          groupValue: _chooseimmu,
                                          onChanged: (colorsimmu? value) {
                                            setState(() {
                                              _chooseimmu = value ?? _chooseimmu;
                                              BCGIMMU="1";
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
                                        Radio<colorsimmu>(
                                          activeColor: Colors.black,
                                          value: colorsimmu.no,
                                          groupValue: _chooseimmu,
                                          onChanged: (colorsimmu? value) {
                                            setState(() {
                                              _chooseimmu = value ?? _chooseimmu;
                                              BCGIMMU="0";
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
                                text: Strings.child_weight,
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
                              maxLength: 5,
                              controller: _enterChildWeight,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                  new EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                  filled: true,
                                  fillColor: ColorConstants.transparent,
                                  hintText: ' शिशु का वजन (कि. ग्रा)',
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
                              maxLength: 5,
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
                              maxLength: 10,
                              keyboardType: TextInputType.number,
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

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RichText(
                    text: TextSpan(
                        text: Strings.death_reason,
                        style: TextStyle(
                            color: Colors.black, fontSize: 13),
                        children: [
                          TextSpan(
                              text: ' *',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13))
                        ]),
                    //textScaleFactor: labelTextScale,
                    //maxLines: labelMaxLines,
                    // overflow: overflow,
                    textAlign: TextAlign.left,
                  )/*Text(
                    Strings.death_reason,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  )*/,
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
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              value: item.ReasonID
                                  .toString() //Id that has to be passed that the dropdown has.....
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            dreasonId = newVal!;
                            print('dreasonId:$dreasonId');
                          });
                        },
                        value: dreasonId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                              ),
                            ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectReportDatePopup(int.parse(_reportYYYYdateController.text.toString()),int.parse(_reportMMdateController.text.toString()) ,int.parse(_reportDDdateController.text.toString()));
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
              height: 40,
              child: Row(
                children:<Widget> [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: Row(
                        children: [
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
                          Container(
                            width: 80,
                            margin: EdgeInsets.only(right: 10,left: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            padding: EdgeInsets.all(1),
                            child: Form(
                              key: _formKey2,
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                controller: ageController,
                               // textAlignVertical:TextAlignVertical.center,
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
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.all(3),
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
                            items: age_categories_list.map((item) {
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
                                  value: item.title.toString() //Id that has to be passed that the dropdown has.....
                              );
                            }).toList(),
                            /*onChanged: (String? newVal) {
                                    setState(() {
                                      _selectedAgeCategory = newVal!;
                                      if(_selectedAgeCategory == "वर्ष"){
                                        _AgeType="1";
                                      }else if(_selectedAgeCategory == "माह"){
                                        _AgeType="2";
                                      }else if(_selectedAgeCategory == "सप्ताह"){
                                        _AgeType="3";
                                      }else if(_selectedAgeCategory == "दिन"){
                                        _AgeType="4";
                                      }else if(_selectedAgeCategory == "घंटे"){
                                        _AgeType="5";
                                      }else if(_selectedAgeCategory == "चुनें"){
                                        _AgeType="0";
                                      }

                                      if(_AgeType != "0"){
                                        getDeathReasonListAPI(_AgeType);
                                      }
                                    });
                                  },*/
                            onChanged: null,
                            value: _selectedAgeCategory, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                          ),
                        ),
                      ),
                    ),
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
                  child: RichText(
                    text: TextSpan(
                        text: Strings.death_place,
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
                                            fontSize: 14.0,
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
                            _selectedDeathPlace = newVal!;
                            print('_selectedDeathPlace:$_selectedDeathPlace');
                            if(_selectedDeathPlace == "0"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              _selectedReferSanstha="0";
                            }else if(_selectedDeathPlace == "1"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              sapraView=false;
                              upSwasthyaKendraView=false;
                              postDeathUnitID=preferences.getString('UnitCode').toString();
                              _selectedReferSanstha="0";
                            }else if(_selectedDeathPlace == "2"){
                              referSansthaView=true;
                              referJilaView=true;
                              referBlockView=true;
                            }else if(_selectedDeathPlace == "3"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              postDeathUnitID=preferences.getString('UnitCode').toString();
                              _selectedReferSanstha="0";
                            }else if(_selectedDeathPlace == "4"){
                              referSansthaView=false;
                              referJilaView=false;
                              referBlockView=false;
                              postDeathUnitID=preferences.getString('UnitCode').toString();
                              _selectedReferSanstha="0";
                            }
                          });
                        },
                        value: _selectedDeathPlace,
                      ),
                    ),
                  )
                ],
              ),
            ),

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
                            child:  RichText(
                              text: TextSpan(
                                  text: Strings.refer_karnai,
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
                                                      fontSize: 14.0,
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
                                      _selectedReferSanstha = newVal!;
                                      print('_selectedReferSanstha:$_selectedReferSanstha');
                                      //_selectedBlockUnitCode="0";
                                      if(_selectedReferSanstha == "0" || _selectedReferSanstha == "17"){
                                      //  referSansthaView=false;
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
                                        getDistrictListAPIReset("3");
                                        _selectedBlockUnitCode = "000000";
                                        _selectedCHPhcCode="000000000";
                                        change_title=Strings.sa_pra_dispensary;
                                      }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16"){
                                        referSansthaView=true;
                                        referJilaView=true;
                                        referBlockView=true;
                                        sapraView=true;
                                        upSwasthyaKendraView=false;
                                        getDistrictListAPIReset("3");
                                        _selectedBlockUnitCode = "000000";
                                        for(int i=0 ;i<refer_sanstha_list.length; i++) {
                                          if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
                                            change_title=refer_sanstha_list[i].title.toString();
                                          }
                                        }
                                       change_title_block=Strings.block;

                                      }else if(_selectedReferSanstha == "6" ||_selectedReferSanstha == "7" ||_selectedReferSanstha == "5" ||_selectedReferSanstha == "13" ||_selectedReferSanstha == "15"){
                                        referSansthaView=true;
                                        referJilaView=true;
                                        referBlockView=true;
                                        upSwasthyaKendraView=false;
                                        sapraView=false;
                                        getDistrictListAPIReset("3");
                                        _selectedBlockUnitCode = "000000";
                                        _selectedCHPhcCode="000000000";
                                        for(int i=0 ;i<refer_sanstha_list.length; i++) {
                                          if(_selectedReferSanstha == refer_sanstha_list[i].code.toString()){
                                            change_title_block=refer_sanstha_list[i].title.toString();
                                          }
                                        }
                                      }else {
                                        //referSansthaView=false;
                                        referJilaView=true;
                                        referBlockView=true;
                                        upSwasthyaKendraView=false;
                                        sapraView=false;
                                        getDistrictListAPIReset("3");
                                        _selectedBlockUnitCode = "000000";
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
                  child:Column(
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
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "$change_title_block",
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
                                //style: Theme.of(context).textTheme.bodyText1,
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
                                                    fontSize: 14.0,
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
                                    //postDeathUnitID=_selectedBlockUnitCode;
                                    // _ReferUnitCode=_selectedBlockUnitCode;

                                    //before
                                    var blockValue=0;
                                    for (int pos = 0; pos < custom_block_list.length; pos++) {
                                      if(_selectedBlockUnitCode == custom_block_list[pos].UnitCode){
                                        print('selected position ${pos}');
                                        blockValue=pos;
                                        break;
                                      }
                                    }
                                      if(blockValue == 0){
                                        _Action="2";
                                        getCHPHCListAPI(_selectedBlockUnitCode,_selectedReferSanstha, _Action);
                                      }else if(_selectedReferSanstha == "8" || _selectedReferSanstha == "9" || _selectedReferSanstha == "10" ||_selectedReferSanstha == "16"){
                                        _Action="1";
                                        getCHPHCListAPI(_selectedBlockUnitCode,_selectedReferSanstha, _Action);
                                      }else if(_selectedReferSanstha == "11"){
                                        if(blockValue == 0){
                                          _Action="2";
                                          getCHPHCListAPI(_selectedBlockUnitCode,_selectedReferSanstha, _Action);
                                        }else{
                                          _Action="3";
                                          getCHPHCListAPI(_selectedBlockUnitCode,_selectedReferSanstha, _Action);
                                        }
                                      }else{
                                        _Action="1";
                                        getCHPHCListAPI(_selectedBlockUnitCode,_selectedReferSanstha, _Action);
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
                ),
              ),
            ),

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
                              '$change_title',//Strings.sa_pra_dispensary,
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
                               // style: Theme.of(context).textTheme.bodyText1,
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
                                                    fontSize: 14.0,
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
                                    getUpSwasthyaListAPI(_selectedCHPhcCode, _selectedReferSanstha);
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
              ),
            ),

            Visibility(
              visible:upSwasthyaKendraView,
              child: Container(
                child: Column(
                  children: [
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
                                //style: Theme.of(context).textTheme.bodyText1,
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
                                                    fontSize: 14.0,
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
                                    _selectedUpSwasthyaCode = newVal!;
                                    print('_selectedUpSwasthyaCode:$_selectedUpSwasthyaCode');
                                    postDeathUnitID=_selectedUpSwasthyaCode;
                                    print('postDeathUnitID:$postDeathUnitID');
                                  });
                                },
                                value: _selectedUpSwasthyaCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(
              height: 30,
            ),


            _isItAsha == true
                ?
            Visibility(
                visible: finalButtonView,
                child: GestureDetector(
                  onTap: (){
                    if(isClickableEnableDisable == true){
                      postValidateData();
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      color: isClickableEnableDisable == false ? ColorConstants.hbyc_bg_green  : ColorConstants.AppColorPrimary,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: submit_title,
                                style: TextStyle(color: Colors.white, fontSize: 14),
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
                ))
                :
            Container(),
          ],
        ),
      ),
    );
  }


  /*
  * * Custom Date Picker
  * */
  late DateTime _selectedDate;
  late DateTime _selectedDate2;

  var initalDay = 0;
  var initalMonth = 0;
  var initalYear = 0;
  var final_diff_dates=0;

  void _selectANCDatePopupCustom(String _customDate) {
      setState(() {
        var parseCustomANCDate = DateTime.parse(getConvertRegDateFormat(_customDate));
        print('parseCustomANCDate ${parseCustomANCDate}');


        _selectedDate = parseCustomANCDate;
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          var birthDate = DateTime.parse(getConvertRegDateFormat(widget.birthdate));
          print('birthDate ${birthDate}');//2021-01-23 00:00:00.000

          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if (selectedParsedDate.compareTo(birthDate) > 0) //2021-04-22 00:00:00.000
            {
              final diff_in_days = selectedParsedDate.difference(birthDate).inDays;
              //print('diff_in_days ${diff_in_days}');
              var _calculatedAge = 0.0;
              if(diff_in_days >= 365){
                _calculatedAge=diff_in_days/365;
                //print('calcualted Age_A : ${_calculatedAge}');
                ageController.text=_calculatedAge.floor().toString();

                setState(() {
                  _selectedAgeCategory="वर्ष";
                  _AgeType="1";
                });

              }else if(diff_in_days > 27){
                _calculatedAge=diff_in_days/30;
                //print('calcualted Age_B : ${_calculatedAge}');
                if(_calculatedAge == 0 || _calculatedAge == 0.0){
                    setState(() {
                      _selectedAgeCategory="माह";
                      _AgeType="2";
                    });
                    ageController.text="1";
                }

                if(_calculatedAge == 12 || _calculatedAge == 12.0){
                    setState(() {
                      _selectedAgeCategory="वर्ष";
                    });
                    ageController.text="1";
                }else{
                  ageController.text=_calculatedAge.floor().toString();
                }

              }else if(diff_in_days > 6){
                _calculatedAge=diff_in_days/7;
               // print('calcualted Age_C : ${_calculatedAge}');
                setState(() {
                  _selectedAgeCategory="सप्ताह";
                  _AgeType="3";
                });
                ageController.text=_calculatedAge.floor().toString();
              }else if(diff_in_days > 0){
                //print('calcualted Age_D : ${diff_in_days}');
                setState(() {
                  _selectedAgeCategory="दिन";
                  _AgeType="4";
                });
                ageController.text=_calculatedAge.floor().toString();
              }else{
                //print('calcualted Age_E : ${diff_in_days}');
                setState(() {
                  _selectedAgeCategory="घंटे";
                  _AgeType="5";
                });
                ageController.text=_calculatedAge.floor().toString();
              }

              if(_AgeType != "0"){
                getDeathReasonListAPI(_AgeType);
              }

              _deathDDdateController.text = getDate(formattedDate4);
              _deathMMdateController.text = getMonth(formattedDate4);
              _deathYYYYdateController.text = getYear(formattedDate4);
              _DeathDeath=_deathYYYYdateController.text.toString()+ "/"+_deathMMdateController.text.toString()+"/"+_deathDDdateController.text.toString();
              print('_DeathDeath $_DeathDeath');//2022/12/11

          }else{
            _showErrorPopup(Strings.choose_after_birth_date, ColorConstants.AppColorPrimary);
          }
        }
      });
  }

  void _selectANCDatePopup(int yyyy,int mm ,int dd) {
    showDatePicker(
        context: context,
        initialDate: (yyyy == 0 && mm == 0 && dd == 0) ? DateTime.now() : DateTime(yyyy, mm , dd ),
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
          print('birthDate ${birthDate}');//2021-01-23 00:00:00.000

          var selectedParsedDate = DateTime.parse(formattedDate4.toString());

          if (selectedParsedDate.compareTo(birthDate) > 0) //2021-04-22 00:00:00.000
            {
              final diff_in_days = selectedParsedDate.difference(birthDate).inDays;
              //print('diff_in_days ${diff_in_days}');
              var _calculatedAge = 0.0;
              if(diff_in_days >= 365){
                _calculatedAge=diff_in_days/365;
                //print('calcualted Age_A : ${_calculatedAge}');
                ageController.text=_calculatedAge.floor().toString();

                setState(() {
                  _selectedAgeCategory="वर्ष";
                  _AgeType="1";
                });

              }else if(diff_in_days > 27){
                _calculatedAge=diff_in_days/30;
                //print('calcualted Age_B : ${_calculatedAge}');
                if(_calculatedAge == 0 || _calculatedAge == 0.0){
                    setState(() {
                      _selectedAgeCategory="माह";
                      _AgeType="2";
                    });
                    ageController.text="1";
                }

                if(_calculatedAge == 12 || _calculatedAge == 12.0){
                    setState(() {
                      _selectedAgeCategory="वर्ष";
                    });
                    ageController.text="1";
                }else{
                  ageController.text=_calculatedAge.floor().toString();
                }

              }else if(diff_in_days > 6){
                _calculatedAge=diff_in_days/7;
               // print('calcualted Age_C : ${_calculatedAge}');
                setState(() {
                  _selectedAgeCategory="सप्ताह";
                  _AgeType="3";
                });
                ageController.text=_calculatedAge.floor().toString();
              }else if(diff_in_days > 0){
                //print('calcualted Age_D : ${diff_in_days}');
                setState(() {
                  _selectedAgeCategory="दिन";
                  _AgeType="4";
                });
                ageController.text=_calculatedAge.floor().toString();
              }else{
                //print('calcualted Age_E : ${diff_in_days}');
                setState(() {
                  _selectedAgeCategory="घंटे";
                  _AgeType="5";
                });
                ageController.text=_calculatedAge.floor().toString();
              }

              if(_AgeType != "0"){
                getDeathReasonListAPI(_AgeType);
              }

              _deathDDdateController.text = getDate(formattedDate4);
              _deathMMdateController.text = getMonth(formattedDate4);
              _deathYYYYdateController.text = getYear(formattedDate4);
              _DeathDeath=_deathYYYYdateController.text.toString()+ "/"+_deathMMdateController.text.toString()+"/"+_deathDDdateController.text.toString();
              print('_DeathDeath $_DeathDeath');//2022/12/11

          }else{
            _showErrorPopup(Strings.choose_after_birth_date, ColorConstants.AppColorPrimary);
          }
        }
      });
    });
  }



  void _selectReportDatePopup(int yyyy,int mm ,int dd) {
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
        _selectedDate2 = pickedDate;
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate2);
        String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate2);

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          if(widget.DeathReportDate != "null"){
            var reportDate = DateTime.parse(getConvertRegDateFormat(widget.DeathReportDate));
            print('reportDate ${reportDate}');//2021-03-12 00:00:00.000

            var selectedParsedDate = DateTime.parse(formattedDate4.toString());

            if (selectedParsedDate.compareTo(reportDate) > 0) //2021-04-22 00:00:00.000
                {
              _reportDDdateController.text = getDate(formattedDate4);
              _reportMMdateController.text = getMonth(formattedDate4);
              _reportYYYYdateController.text = getYear(formattedDate4);
              _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
              print('reportDeath $_reportdeathPostDate');
            }else{
              _showErrorPopup('शिशु की मृत्यु की दिनांक चुने', ColorConstants.AppColorPrimary);
            }
          }else{
            _reportDDdateController.text = getDate(formattedDate4);
            _reportMMdateController.text = getMonth(formattedDate4);
            _reportYYYYdateController.text = getYear(formattedDate4);
            _reportdeathPostDate=_reportYYYYdateController.text.toString()+ "/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
            print('reportDeath $_reportdeathPostDate');
          }

        }
      });
    });
  }
  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
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

 // String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
  String pattern = r"^[6-9]\\d{9}$";
  //MobilePattern = "^[6-9]\\d{9}$";

  void postValidateData() {
    if(_enterChildNameController.text.isEmpty){
      _showErrorPopup(Strings.enter_name,ColorConstants.AppColorPrimary);
    }else if(_enterChildNameController.text.toString().contains(new RegExp(r'[0-9]'))){
      _showErrorPopup(Strings.enter_correct_format_name,ColorConstants.AppColorPrimary);
    }else if(_enterChildNameController.text.length > 25){
      _showErrorPopup(Strings.name_no_more_thn25,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaMobNoController.text.isEmpty){
      _showErrorPopup(Strings.owner_mo_num,ColorConstants.AppColorPrimary);
    }else if(ageController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_child_age,ColorConstants.AppColorPrimary);
    }else if(_selectedAgeCategory == ""){
      _showErrorPopup(Strings.enter_child_age,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "0"){
      _showErrorPopup(Strings.select_age_type,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "1" && int.parse(ageController.text.toString()) > 5){
      _showErrorPopup(Strings.select_age_lessthn_5yr_type,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "2" && int.parse(ageController.text.toString()) > 11){
      _showErrorPopup(Strings.select_age_lessthn_11yr_type,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "3" && int.parse(ageController.text.toString()) > 3){
      _showErrorPopup(Strings.select_age_lessthn_3wek_type,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "4" && int.parse(ageController.text.toString()) > 6){
      _showErrorPopup(Strings.select_age_lessthn_6days_type,ColorConstants.AppColorPrimary);
    }else if(_AgeType == "5" && int.parse(ageController.text.toString()) > 23){
      _showErrorPopup(Strings.select_age_lessthn_23hours_type,ColorConstants.AppColorPrimary);
    }else if(BCGIMMU == ""){
      _showErrorPopup(Strings.is_bcg_apply,ColorConstants.AppColorPrimary);
    }else if(_enterChildWeight.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_weight_child2,ColorConstants.AppColorPrimary);
    }else if(double.parse(_enterChildWeight.text.toString()) > 9.0 ){
      _showErrorPopup(Strings.child_weight_notmorethn_9kg,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaNameController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_owner_name,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaNameController.text.toString().contains(new RegExp(r'[0-9]'))){//8.40 per  min...
      _showErrorPopup(Strings.enter_correct_owner_name,ColorConstants.AppColorPrimary);
    }else if(_mukhiyaMobNoController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_owner_mo_num,ColorConstants.AppColorPrimary);
    }/*else if(!_mukhiyaMobNoController.text.toString().contains(new RegExp(pattern))){
      _showErrorPopup(Strings.enter_correct_mob_num,ColorConstants.AppColorPrimary);
    }*/else if(_deathDDdateController.text.isEmpty){
      _showErrorPopup(Strings.enter_child_date,ColorConstants.AppColorPrimary);
    }else if(_deathMMdateController.text.isEmpty){
      _showErrorPopup(Strings.enter_child_date,ColorConstants.AppColorPrimary);
    }else if(_deathYYYYdateController.text.isEmpty){
      _showErrorPopup(Strings.enter_child_date,ColorConstants.AppColorPrimary);
    }else if(dreasonId.isEmpty){
      _showErrorPopup(Strings.child_death_reason,ColorConstants.AppColorPrimary);
    }else if(dreasonId == "0"){
      _showErrorPopup(Strings.child_death_reason,ColorConstants.AppColorPrimary);
    }else if(_reportDDdateController.text.isEmpty){
      _showErrorPopup(Strings.child_report_date,ColorConstants.AppColorPrimary);
    }else if(_reportMMdateController.text.isEmpty){
      _showErrorPopup(Strings.child_report_date,ColorConstants.AppColorPrimary);
    }else if(_reportYYYYdateController.text.isEmpty){
      _showErrorPopup(Strings.child_report_date,ColorConstants.AppColorPrimary);
    }else if(_selectedDeathPlace == "0" || _selectedDeathPlace.isEmpty){
      _showErrorPopup(Strings.choose_death_place,ColorConstants.AppColorPrimary);
    }else if(_selectedDeathPlace == "2" && _selectedReferSanstha == "0"){
      _showErrorPopup("कृप्या संस्था का प्रकार चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "5" || _selectedReferSanstha == "6" || _selectedReferSanstha == "7"|| _selectedReferSanstha == "13"|| _selectedReferSanstha == "15") && _selectedBlockUnitCode == "0"){
      _showErrorPopup("कृप्या "+change_title+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "8") && _selectedBlockUnitCode == "0"){
      _showErrorPopup("कृप्या "+change_title+" चुनें !",ColorConstants.AppColorPrimary);
    }else if(postDeathUnitID == "0000000000"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "8") && _selectedCHPhcCode == "0"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "9" || _selectedReferSanstha == "10" || _selectedReferSanstha == "16") && _selectedCHPhcCode == "0"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && _selectedBlockUnitCode == "0"){
      _showErrorPopup("कृप्या "+Strings.block+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && _selectedCHPhcCode == "0000000000"){
      _showErrorPopup("कृप्या "+Strings.sa_pra_dispensary+" चुनें !",ColorConstants.AppColorPrimary);
    }else if((_selectedDeathPlace == "2") && (_selectedReferSanstha == "11") && _selectedUpSwasthyaCode == "0"){
      _showErrorPopup("कृप्या "+Strings.up_swasthya+" चुनें !",ColorConstants.AppColorPrimary);
    }else{
      if(response_list[0]['DeathDate'].toString() != "null"){
        putDataAPI();
      }else{
        postDataAPI();
      }
    }
  }
  var _UpdateUserNo="";// set value for api request
  var Media="";
  var ANMVerify="";
  var _IPAddress="";
  void putDataAPI() {

    if(preferences.getString("AppRoleID") == "33"){
      Media="2";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isNotEmpty){
      if(ANMVerify == "0"){
        Media ="3";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else{
        Media ="3";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }
    }else{
      Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }
    printIps();
    if (_deathDDdateController.text.isNotEmpty) {
      _DeathDeath=_deathYYYYdateController.text.toString()+"/"+_deathMMdateController.text.toString()+"/"+_deathDDdateController.text.toString();
    }

    if (_reportDDdateController.text.isNotEmpty) {
      _reportdeathPostDate=_reportYYYYdateController.text.toString()+"/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
    }

    //don't uncomment this condition i have set condition at api request as conditional oprator
    /*if(_selectedReferSanstha == "17"){
      _selectedDeathPlace="17";
    }*/
    print('UpdateChildDeath request');
    print("Motherid:${response_list[0]['Motherid'].toString()}");
    print("infantid:${response_list[0]['InfantID'].toString()}");
    print("Name:${_enterChildNameController.text.toString().trim()}");
    print("ReasonID:${dreasonId}");
    print("Age:${ageController.text.toString().trim()}");
    print("DeathDate:${_DeathDeath}");
    print("deathPlace:${_selectedReferSanstha == "17" ? "17" : _selectedDeathPlace}");
    print("VillageAutoID:${response_list[0]['VillageAutoID'].toString()}");
    print("AgeType:${_AgeType}");
    print("Weight:${_enterChildWeight.text.toString().trim()}");
    print("Bfeed:${BFeed}");
    print("BloodType:${_BloodGroup}");
    print("IsImmun:${BCGIMMU}");
    print("DeathReportDate:${_reportdeathPostDate}");
    print("MasterMobile:${_mukhiyaMobNoController.text.trim().trim()}");
    print("Relative_Name:${_mukhiyaNameController.text.trim().trim()}");
    print("DeathUnitCode:${_selectedReferSanstha == "2" ? postDeathUnitID : "0"}");
    print("IPAddress:IPAddress");
    print("AppVersion:5.5.5.22");
    print("ashaautoid:${aashaId}");
    print("BirthDate:${response_list[0]['Birth_date'].toString()}");
    print("EntryUnitID:${preferences.getString('UnitID').toString()}");
    print("LoginUserID:${preferences.getString('UserId').toString()}");
    print("UpdateUserNo:${_UpdateUserNo}");
    print("Media:${Media}");
    print("EntryUserNo:${_UpdateUserNo}");
    print("TokenNo:${preferences.getString('Token').toString()}");
    print("UserID:${preferences.getString('UserId').toString()}");
    updatePostDataAPI();
  }

  void postDataAPI() {

    if(preferences.getString("AppRoleID") == "33"){
      Media="2";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }else if(ANMVerify.isNotEmpty){
      if(ANMVerify == "0"){
        Media ="3";
       // _UpdateUserNo=preferences.getString("UserNo").toString();
      }else if(ANMVerify == "1" && Media == "3"){
        Media ="3";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else if(ANMVerify == "1" && Media == "2"){
        Media ="3";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else if(ANMVerify == "1" && Media == "1"){
        Media ="1";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }
    }else{
      Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }

    if (_deathDDdateController.text.isNotEmpty) {
      _DeathDeath=_deathYYYYdateController.text.toString()+"/"+_deathMMdateController.text.toString()+"/"+_deathDDdateController.text.toString();
    }

    if (_reportDDdateController.text.isNotEmpty) {
      _reportdeathPostDate=_reportYYYYdateController.text.toString()+"/"+_reportMMdateController.text.toString()+"/"+_reportDDdateController.text.toString();
    }

    /*if(_selectedReferSanstha == "17"){
      _selectedDeathPlace="17";
    }*/

    print("Motherid:${response_list[0]['Motherid'].toString()}");
    print("infantid:${response_list[0]['InfantID'].toString()}");
    print("Name:${_enterChildNameController.text.toString().trim()}");
    print("ReasonID:${dreasonId}");
    print("Age:${ageController.text.toString().trim()}");
    print("DeathDate:${_DeathDeath}");
    print("deathPlace:${_selectedReferSanstha == "17" ? "17" : _selectedDeathPlace}");
    print("VillageAutoID:${response_list[0]['VillageAutoID'].toString()}");
    print("AgeType:${_AgeType}");
    print("Weight:${_enterChildWeight.text.toString().trim()}");
    print("Bfeed:${BFeed}");
    print("BloodType:${_BloodGroup}");
    print("IsImmun:${BCGIMMU}");
    print("DeathReportDate:${_reportdeathPostDate}");
    print("MasterMobile:${_mukhiyaMobNoController.text.trim().trim()}");
    print("Relative_Name:${_mukhiyaNameController.text.trim().trim()}");
    print("DeathUnitCode:${_selectedReferSanstha == "2" ? postDeathUnitID : "0"}");
    print("IPAddress:IPAddress");
    print("AppVersion:5.5.5.22");
    print("ashaautoid:${aashaId}");
    print("BirthDate:${response_list[0]['Birth_date'].toString()}");
    print("EntryUnitID:${preferences.getString('UnitID').toString()}");
    print("LoginUserID:${preferences.getString('UserId').toString()}");
    print("UpdateUserNo:${_UpdateUserNo}");
    print("Media:${Media}");
    print("EntryUserNo:${_UpdateUserNo}");
    print("TokenNo:${preferences.getString('Token').toString()}");
    print("UserID:${preferences.getString('UserId').toString()}");

    submitPostDataAPI();
  }

  Future<SavedHBYCDetailsData> updatePostDataAPI() async {


    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        _IPAddress=addr.address;
        print('my-ip-address ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }

    var response = await put(Uri.parse(_edit_child_details_url), body: {
      "Motherid":response_list[0]['Motherid'].toString(),
      "infantid":response_list[0]['InfantID'].toString(),
      "Name":_enterChildNameController.text.toString().trim(),
      "ReasonID":dreasonId,
      "Age": ageController.text.toString().trim(),
      "DeathDate": _DeathDeath,
      "deathPlace": _selectedReferSanstha == "17" ? "17" : _selectedDeathPlace,
      "VillageAutoID":response_list[0]['VillageAutoID'].toString(),
      "AgeType": _AgeType,
      "Weight": _enterChildWeight.text.toString().trim(),
      "Bfeed": BFeed,
      "BloodGroup": _BloodGroup,
      "IsImmun": BCGIMMU,
      "DeathReportDate": _reportdeathPostDate,
      "MasterMobile":_mukhiyaMobNoController.text.trim().trim(),
      "Relative_Name": _mukhiyaNameController.text.trim().trim(),
      "DeathUnitCode": _selectedDeathPlace == "2" ? postDeathUnitID : "0",
      "DeathUnitID": "0",
      "IPAddress": _IPAddress,
      "ashaautoid": aashaId,
      "BirthDate": response_list[0]['Birth_date'].toString(),
      "EntryUnitID": preferences.getString('UnitID').toString(),
      "LoginUserID": preferences.getString('UserId').toString(),
      "AppVersion":"5.5.5.22",
      "UpdateUserNo": _UpdateUserNo,
      "EntryUserNo": _UpdateUserNo,
      "Media":Media,
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

  Future<SavedHBYCDetailsData> submitPostDataAPI() async {


    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        _IPAddress=addr.address;
        print('my-ip-address ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
    var response = await post(Uri.parse(_add_child_details_url), body: {
      "Motherid":response_list[0]['Motherid'].toString(),
      "infantid":response_list[0]['InfantID'].toString(),
      "Name":_enterChildNameController.text.toString().trim(),
      "ReasonID":dreasonId,
      "Age": ageController.text.toString().trim(),
      "DeathDate": _DeathDeath,
      "deathPlace": _selectedReferSanstha == "17" ? "17" : _selectedDeathPlace,
      "VillageAutoID":response_list[0]['VillageAutoID'].toString(),
      "AgeType": _AgeType,
      "Weight": _enterChildWeight.text.toString().trim(),
      "Bfeed": BFeed,
      "BloodGroup": _BloodGroup,
      "IsImmun": BCGIMMU,
      "DeathReportDate": _reportdeathPostDate,
      "MasterMobile":_mukhiyaMobNoController.text.trim().trim(),
      "Relative_Name": _mukhiyaNameController.text.trim().trim(),
      //"DeathUnitCode": _selectedUpSwasthyaCode != "0" ? _selectedUpSwasthyaCode : postDeathUnitID,
      "DeathUnitCode":_selectedDeathPlace == "2" ? postDeathUnitID : "0",
      "DeathUnitID": "0",
      "IPAddress": _IPAddress,
      "ashaautoid": aashaId,
      "BirthDate": response_list[0]['Birth_date'].toString(),
      "EntryUnitID": preferences.getString('UnitID').toString(),
      "LoginUserID": preferences.getString('UserId').toString(),
      "AppVersion":"5.5.5.22",
      "UpdateUserNo": _UpdateUserNo,
      "EntryUserNo": _UpdateUserNo,
      "Media":Media,
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

  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }

  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        _IPAddress=addr.address;
        print('my-ip-address ${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
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