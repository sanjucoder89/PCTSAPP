import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcts/ui/prasav/model/GetAashaListData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/IosVersion.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import '../prasav/model/GetBlockListData.dart';
import '../prasav/model/GetDistrictListData.dart';
import 'model/GetHBYCSUBListData.dart';
import 'model/SavedHBYCDetailsData.dart';


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

class AddHBYCForm extends StatefulWidget {
  const AddHBYCForm(
      {Key? key,
        required this.RegUnitID,
        required this.VillageAutoID,
        required this.RegUnittype,
        required this.HBYCFlag,
        required this.Birth_date,
        required this.motherid,
        required this.ancregid,
        required this.infantid
      })
      : super(key: key);


  final String RegUnitID;
  final String VillageAutoID;
  final String RegUnittype;
  final String HBYCFlag;
  final String Birth_date;
  final String motherid;
  final String ancregid;
  final String infantid;
  @override
  State<AddHBYCForm> createState() => _AddHBYCFormState();
}

class _AddHBYCFormState extends State<AddHBYCForm> {
  late SharedPreferences preferences;
  late String aashaId = "0";
  late String hbycDateId = "0";
  bool _shishuEnDisable = true;
  String sub_heading="";
  var HBYCFlag="";

  //API REQUEST PARAM
  var _hbycPostDate="";
  var _weightPostData="0";
  var _heightPostData="";
  var _orsPostData="0";//none=0,yes=,no=
  var _ifaPostData="0";
  var _mamtaPostData="0";
  var _dietPostData="0";
  var _diabiliyPostData="0";
  var _childColorPostData="0";
  var _riskPostData="0";
  var _chooseRbskPostData="";
  var _Media="";
  var _UpdateUserNo="";
  var _changeBlockTitle=Strings.block;
  TextEditingController _shishuWeightController = TextEditingController();
  TextEditingController _shishuKadController = TextEditingController();


  TextEditingController _hbycDDdateController = TextEditingController();
  TextEditingController _hbycMMdateController = TextEditingController();
  TextEditingController _hbycYYYYdateController = TextEditingController();


  List<CustomPlacesReferCodeList> custom_placesrefer_list = [];
  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomBlockCodeList> custom_block_list = [];
  List<CustomSubCodeList> custom_sub_list = [];

  var _selectedPlacesReferCode = "0";
  var _selectedDistrictUnitCode = "0000";
  var _selectedBlockUnitCode = "0";
  var _selectedSubUnitCode = "0";
  var _ReferUnitCode="0";


  /*
  * API BASE URL
  * */
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postBlockData";
  var _get_subdata_url = AppConstants.app_base_url + "postfillPHCCHCHBYC";
  var _add_hbyc_form_url = AppConstants.app_base_url + "PostHBYCDetail";

  List<CustomAashaList> custom_aasha_list = [];
  List aasha_response_list = [];
  List response_district_list= [];
  List response_block_list= [];
  List response_subdata_list= [];
  var _customHBYCDate="";
  bool _isItAsha=false;
  var _checkPlatform="0";
  Future<String> getAashaListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _checkPlatform=preferences.getString("CheckPlatform").toString();
    var response = await post(Uri.parse(_aasha_list_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "DelplaceUnitid": "0",
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
        aasha_response_list = resBody['ResposeData'];
        custom_aasha_list
            .add(CustomAashaList(ASHAName: Strings.choose, ASHAAutoid: "0"));
        for (int i = 0; i < aasha_response_list.length; i++) {
          custom_aasha_list.add(CustomAashaList(
              ASHAName: aasha_response_list[i]['ASHAName'].toString(),
              ASHAAutoid: aasha_response_list[i]['ASHAAutoid'].toString()));
        }
        if(preferences.getString("AppRoleID").toString() == '33'){
          aashaId = preferences.getString('ANMAutoID').toString();
          _isItAsha=true;
        }else{
          aashaId = custom_aasha_list[0].ASHAAutoid.toString();
          _isItAsha=false;
        }
        print('aashaId ${aashaId}');

        //Reset ALl Radio button at first time
        setState(() {
          _shishukoors=ShihuKoORS.none;
          _shishukosirp=ShihuKoSirp.none;
          _mamtaCard=MamtaCard.none;
          _childColor=ChildColor.none;
          _childahar=ChildAhar.none;
          _childfounddisese=ChildFoundDisease.none;
          _childrefer=ChildRefer.none;

          if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
            _ShowHideADDNewVivranView = true;
          }else{
            _ShowHideADDNewVivranView=false;
          }

        });
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

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
    print('refUnitType $refUnitType');
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
        custom_block_list.clear();
        print('block.len ${custom_block_list.length}');

      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetBlockListData.fromJson(resBody);
  }

  Future<String> getSubDataListAPI(String refUnitType,String refUnitCode) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('PHCCHCHBYC unittype $refUnitType');
    print('PHCCHCHBYC unitcode $refUnitCode');
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_subdata_url), body: {
      //Unitcode:01010100000
      // UnitType:10
      // TokenNo:4efa9239-19fb-40f0-bb84-ef1dc4beb21e
      // UserID:0101065030203
      "Unitcode": refUnitCode,
      "UnitType": refUnitType,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
   // final apiResponse = GetHBYCSUBListData.fromJson(resBody);
    setState(() {
      print('UnitID ${resBody[0]['UnitID'].toString()}');
      custom_sub_list.clear();
      custom_sub_list.add(CustomSubCodeList(UnitID: "", UnitName:Strings.choose,UnitCode: "0"));
      for (int i = 0; i < resBody.length; i++) {
        custom_sub_list.add(CustomSubCodeList(UnitID: resBody[i]['UnitID'].toString(),
            UnitName: resBody[i]['UnitName'].toString(),
            UnitCode:resBody[i]['UnitCode'].toString()));
      }
      _selectedSubUnitCode=custom_sub_list[0].UnitCode.toString();
      print('custom_sub_list.len ${custom_sub_list.length}');
      EasyLoading.dismiss();
    });
    return "Success";
  }

  List<MonthList> month_list = [
    MonthList(
      index: "0",
      month: "चुनें",
    ),
    MonthList(
      index: "1",
      month: "3 माह",
    ),
    MonthList(
      index: "2",
      month: "6 माह",
    ),
    MonthList(
      index: "3",
      month: "9 माह",
    ),
    MonthList(
      index: "4",
      month: "12 माह",
    ),
    MonthList(
      index: "5",
      month: "15 माह",
    )
  ];

  /*
    *
  */
  postHbycRequest() async {

    preferences = await SharedPreferences.getInstance();
    if(aashaId == "0"){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }/*else if(widget.motherid){
      _showErrorPopup(Strings.try_again,ColorConstants.AppColorPrimary);
    }*/else if(HBYCFlag == "0"){
      _showErrorPopup(Strings.choose_visit_schedule,ColorConstants.AppColorPrimary);
    }else if(HBYCFlag.isEmpty){
      _showErrorPopup(Strings.choose_visit_schedule,ColorConstants.AppColorPrimary);
    }else if(widget.HBYCFlag == HBYCFlag){
      _showErrorPopup(Strings.choose_correct_visit_schedule,ColorConstants.AppColorPrimary);
    }else if(_hbycPostDate.isEmpty){
      _showErrorPopup(Strings.choose_visit_date,ColorConstants.AppColorPrimary);
    }else if(_shishuWeightController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_correct_weight,ColorConstants.AppColorPrimary);
    }else if(_shishuWeightController.text.toString() == "0" ||  double.parse(_shishuWeightController.text.toString()) < 0){
      _showErrorPopup(Strings.enter_correct_weight,ColorConstants.AppColorPrimary);
    }else if(_shishuKadController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_height_incm,ColorConstants.AppColorPrimary);
    }else if(int.parse(_shishuKadController.text.toString()) < 30){
      _showErrorPopup(Strings.enter_height_more_than_30_semi,ColorConstants.AppColorPrimary);
    }else if(int.parse(_shishuKadController.text.toString()) > 90 ){
      _showErrorPopup(Strings.enter_height_less_than_90_semi,ColorConstants.AppColorPrimary);
    }else if(_shishuKadController.text.toString() == "0" ||  double.parse(_shishuKadController.text.toString()) < 0){
      _showErrorPopup(Strings.enter_height_incm,ColorConstants.AppColorPrimary);
    }else if(_orsPostData == "0"){
      _showErrorPopup(Strings.choose_ors_packet,ColorConstants.AppColorPrimary);
    }else if(_ifaPostData == "0"){
      _showErrorPopup(Strings.ifa_srip_choose,ColorConstants.AppColorPrimary);
    }else if(_mamtaPostData == "0"){
      _showErrorPopup(Strings.choose_mamta_packet,ColorConstants.AppColorPrimary);
    }else if(_chooseMamtaCard == true && _childColorPostData == "0"){
      _showErrorPopup(Strings.choose_child_color_packet,ColorConstants.AppColorPrimary);
    }else if(_dietPostData == "0"){
      _showErrorPopup(Strings.choose_child_ahar,ColorConstants.AppColorPrimary);
    }else if(_diabiliyPostData == "0"){
      _showErrorPopup(Strings.choose_child_dieses,ColorConstants.AppColorPrimary);
    }else if(_riskPostData == "0" && _diabiliyPostData == "1"){
      _showErrorPopup(Strings.child_any_rbsk_refer_choose,ColorConstants.AppColorPrimary);
    }else if(_referView == true && _selectedPlacesReferCode == "0"){
      _showErrorPopup(Strings.choose_refer_type,ColorConstants.AppColorPrimary);
    //}else if( (_selectedDistrictUnitCode == "0000" || _selectedDistrictUnitCode == "0") && _diabiliyPostData == "2" ){
    }else if((_referView == true && _selectedPlacesReferCode != "0") && (_selectedDistrictUnitCode == "0000" || _selectedDistrictUnitCode == "0")){
      _showErrorPopup(Strings.choose_refer_jila,ColorConstants.AppColorPrimary);
    }else if(_showSubDropDown == true && _selectedBlockUnitCode == "0"){
      _showErrorPopup(Strings.choose_block,ColorConstants.AppColorPrimary);
    }else if((_selectedPlacesReferCode == "10" || _selectedPlacesReferCode == "9" || _selectedPlacesReferCode == "8") && (sub_heading == "" || sub_heading =="चुनें" || _selectedSubUnitCode == "0")){
      _showErrorPopup("कृपया "+sub_heading +" चुनें!",ColorConstants.AppColorPrimary);
    }else if(_referView == true && _ReferUnitCode == "0"){
      _showErrorPopup(Strings.choose_refer_type_sub,ColorConstants.AppColorPrimary);
    }else{
      if(_shishuWeightController.text.toString().trim().isEmpty){
        _weightPostData="0";
      }else{
        _weightPostData=_shishuWeightController.text.toString().trim();
      }

      if(preferences.getString("AppRoleID") == "33"){
        _Media="2";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else{
        _Media="1";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print('pkg_version: ${packageInfo.version}');
      var _tempReferCode="";
      if(_referView == true){
        _tempReferCode=_ReferUnitCode;
      }else{
        _tempReferCode="0";
      }


      print('Motherid:${widget.motherid+
          "ANCRegID:"+widget.ancregid+
          "InfantId:"+widget.infantid+
          "HBYCFlag:"+HBYCFlag+
          "VillageAutoID:"+widget.VillageAutoID+
          "VisitDate:"+_hbycPostDate+
          "ORSPacket:"+_orsPostData+
          "IFASirap:"+_ifaPostData+
          "GrowthChart:"+_mamtaPostData+
          "Color:"+_childColorPostData+
          "FoodAccordingAge:"+_dietPostData+
          "GrowthLate:"+_diabiliyPostData+
          "Refer:"+_riskPostData+
          "EntryUserNo:"+_UpdateUserNo+
          "UpdateUserNo:"+_UpdateUserNo+
          "Weight:"+_weightPostData+
          "Height:"+_shishuKadController.text.toString().trim()+
          "ReferUnitcode:"+_tempReferCode+
          "BirthDate:"+widget.Birth_date+
          "Media:"+_Media+
          "ashaautoid:"+aashaId+
          "TokenNo:"+preferences.getString('Token').toString()+
          "UserID:"+preferences.getString('UserId').toString()
      }');
      callapi();
    }


  }

  Future<SavedHBYCDetailsData> callapi() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();




    var response = await post(Uri.parse(_add_hbyc_form_url), body: {
      "MotherId":widget.motherid,
      "ASHAAutoID":aashaId,
      "AncRegId":widget.ancregid,
      "InfantId":widget.infantid,
      "HBYCFlag":HBYCFlag,
      "VillageAutoID": widget.VillageAutoID,
      "VisitDate": _hbycPostDate,
      "ORSPacket": _orsPostData,
      "IFASirap":_ifaPostData,
      "GrowthChart": _mamtaPostData,
      "Color": _childColorPostData,
      "FoodAccordingAge":_dietPostData,
      "GrowthLate": _diabiliyPostData,
      "Refer": _riskPostData,
      "EntryUserNo": _UpdateUserNo,
      "UpdateUserNo":_UpdateUserNo,
      "Weight": _weightPostData,
      "Height":_shishuKadController.text.toString().trim(),
      "ReferUnitcode": _referView == true ? _ReferUnitCode : "0",
      "BirthDate":widget.Birth_date,
      "Media": _Media,
      "AppVersion": _checkPlatform == "0" ? preferences.getString("Appversion") : "",
      "IOSAppVersion": _checkPlatform == "1" ? IosVersion.ios_version : "",
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
  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }

  @override
  void initState() {
    super.initState();
    getAashaListAPI();
    addPlacesReferList();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void addPlacesReferList() {
    print('RegUnitTYpe ${widget.RegUnittype}');
    custom_placesrefer_list.clear();
    custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.choose, code:"0"));

    if(widget.RegUnittype == "10" || widget.RegUnittype == "11"){
      if(widget.RegUnittype == "11"){
        custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.city_dispancry, code:"13"));
        custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.pra_sva_center, code:"10"));


      }
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.sa_sva_center, code:"9"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.up_jila_Hospital, code:"8"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.other_hospital, code:"15"));
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

  var _showSubDropDown=false;
  bool _chooseMamtaCard = false;
  bool _chooseAharCard = false;
  bool _referView = false;
  bool _isChildGrowthDiseaseFound = false;
  bool _isDropDownRefresh=false;
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
            Text(Strings.hbyc_vivran,
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(child: Container(child: SingleChildScrollView(
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
                                  //getANMListAPI(aashaId);
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
                    child: RichText(
                      text: TextSpan(
                          text: Strings.select_visit_schedule,
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
                              items: month_list.map((item) {
                                return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(
                                                item.month.toString(),
                                                //Names that the api dropdown contains
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    value: item.index.toString() //Id that has to be passed that the dropdown has.....
                                  //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                );
                              }).toList(),
                              onChanged: (String? newVal) {
                                setState(() {
                                  hbycDateId = newVal!;
                                  print('hbycDateId:$hbycDateId');
                                  if(hbycDateId == "0"){
                                    HBYCFlag="0";
                                  }else if(hbycDateId == "1"){
                                    HBYCFlag="3";
                                  }else if(hbycDateId == "2"){
                                    HBYCFlag="6";
                                  }else if(hbycDateId == "3"){
                                    HBYCFlag="9";
                                  }else if(hbycDateId == "4"){
                                    HBYCFlag="12";
                                  }else if(hbycDateId == "5"){
                                    HBYCFlag="15";
                                  }
                                });
                              },
                              value: hbycDateId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
                                  text: Strings.hbyc_visit_date,
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
                                      controller: _hbycDDdateController,
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
                                        if(_hbycDDdateController.text.toString().length == 2 && _hbycMMdateController.text.toString().length == 2 && _hbycYYYYdateController.text.toString().length == 4){
                                          //2022-12-06 00:00:00.000
                                          _customHBYCDate=_hbycYYYYdateController.text.toString()+"-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString()+" 00:00:00.000";
                                          print('_customHBYCDate $_customHBYCDate');
                                          _selectCustomHBYCDatePopup(_customHBYCDate);
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
                                      controller: _hbycMMdateController,
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
                                        if(_hbycDDdateController.text.toString().length == 2 && _hbycMMdateController.text.toString().length == 2 && _hbycYYYYdateController.text.toString().length == 4){
                                          //2022-12-06 00:00:00.000
                                          _customHBYCDate=_hbycYYYYdateController.text.toString()+"-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString()+" 00:00:00.000";
                                          print('_customHBYCDate $_customHBYCDate');
                                          _selectCustomHBYCDatePopup(_customHBYCDate);
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
                                      controller: _hbycYYYYdateController,
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
                                        if(_hbycDDdateController.text.toString().length == 2 && _hbycMMdateController.text.toString().length == 2 && _hbycYYYYdateController.text.toString().length == 4){
                                     //2022-12-06 00:00:00.000
                                          _customHBYCDate=_hbycYYYYdateController.text.toString()+"-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString()+" 00:00:00.000";
                                         print('_customHBYCDate $_customHBYCDate');
                                         _selectCustomHBYCDatePopup(_customHBYCDate);
                                       }
                                      }
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(_hbycYYYYdateController.text.toString().isEmpty && _hbycMMdateController.text.toString().isEmpty && _hbycDDdateController.text.toString().isEmpty){
                              _selectHBYCDatePopup(0,0,0);
                            }else{
                              _selectHBYCDatePopup(int.parse(_hbycYYYYdateController.text.toString()),int.parse(_hbycMMdateController.text.toString()) ,int.parse(_hbycDDdateController.text.toString()));
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
                  Container(
                    child: Column(
                       children:<Widget> [
                         Divider(height: 1,thickness: 2,color: Colors.black,),

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
                                                   enabled: _shishuEnDisable,
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
                                               text: Strings.child_kad_in_cm,
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
                                                   enabled: _shishuEnDisable,
                                                   style: TextStyle(color: Colors.black),
                                                   maxLength: 4,
                                                   keyboardType: TextInputType.number,
                                                   controller: _shishuKadController,
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
                                                 .ors_packet,
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
                                                       Radio<ShihuKoORS>(
                                                         activeColor:Colors.black,
                                                         value: ShihuKoORS.yes,
                                                         groupValue: _shishukoors,
                                                         onChanged: (ShihuKoORS? value) {
                                                           setState(() {
                                                             _shishukoors = value ?? _shishukoors;
                                                             _orsPostData="1";
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
                                                       Radio<ShihuKoORS>(
                                                         activeColor:Colors.black,
                                                         value: ShihuKoORS.no,
                                                         groupValue: _shishukoors,
                                                         onChanged:(ShihuKoORS? value) {
                                                           setState(() {
                                                             _shishukoors = value ?? _shishukoors;
                                                             _orsPostData="2";
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
                                                 .ifa_srip,
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
                                                       Radio<ShihuKoSirp>(
                                                         activeColor:Colors.black,
                                                         value: ShihuKoSirp.yes,
                                                         groupValue: _shishukosirp,
                                                         onChanged: (ShihuKoSirp? value) {
                                                           setState(() {
                                                             _shishukosirp = value ?? _shishukosirp;
                                                            _ifaPostData="1";
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
                                                       Radio<ShihuKoSirp>(
                                                         activeColor:Colors.black,
                                                         value: ShihuKoSirp.no,
                                                         groupValue: _shishukosirp,
                                                         onChanged:(ShihuKoSirp? value) {
                                                           setState(() {
                                                             _shishukosirp = value ?? _shishukosirp;
                                                             _ifaPostData="2";
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
                                                 .fill_mamta_card,
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
                                                       Radio<MamtaCard>(
                                                         activeColor:Colors.black,
                                                         value: MamtaCard.yes,
                                                         groupValue: _mamtaCard,
                                                         onChanged: (MamtaCard? value) {
                                                           setState(() {
                                                             _mamtaCard = value ?? _mamtaCard;
                                                             _mamtaPostData="1";
                                                             _chooseMamtaCard=true;

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
                                                       Radio<MamtaCard>(
                                                         activeColor:Colors.black,
                                                         value: MamtaCard.no,
                                                         groupValue: _mamtaCard,
                                                         onChanged:(MamtaCard? value) {
                                                           setState(() {
                                                             _mamtaCard = value ?? _mamtaCard;
                                                             _mamtaPostData="2";
                                                             _chooseMamtaCard=false;
                                                             setState(() {
                                                               _childColor = ChildColor.none;
                                                               _childColorPostData="0";
                                                             });
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
                           color: ColorConstants.white,
                           child: Padding(
                             padding: const EdgeInsets.all(5.0),
                             child: Row(
                               children: [
                                 Container(
                                   width: 100,
                                   color: ColorConstants.white,
                                   child: RichText(
                                     text: TextSpan(
                                         text: Strings
                                             .child_color,
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
                                 ),
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
                                                       Radio<ChildColor>(
                                                         activeColor: _chooseMamtaCard == true ? Colors.black : Colors.grey,
                                                         value: ChildColor.green,
                                                         groupValue: _childColor,
                                                         onChanged: (ChildColor? value) {
                                                          if(_chooseMamtaCard == true){
                                                            setState(() {
                                                              _childColor = value ?? _childColor;
                                                              _childColorPostData="1";
                                                            });
                                                          }else{
                                                            setState(() {
                                                              _childColor = ChildColor.none;
                                                              _childColorPostData="0";
                                                            });
                                                          }
                                                         },
                                                       ),
                                                       Text(
                                                         Strings.green_title,
                                                         style: TextStyle(
                                                             fontSize: 11,
                                                             color: _chooseMamtaCard == true ? Colors.black : Colors.grey),
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
                                                       Radio<ChildColor>(
                                                         activeColor: _chooseMamtaCard == true ? Colors.black : Colors.grey,
                                                         value: ChildColor.yellow,
                                                         groupValue: _childColor,
                                                         onChanged:(ChildColor? value) {
                                                          if(_chooseMamtaCard == true){
                                                            setState(() {
                                                              _childColor = value ?? _childColor;
                                                              _childColorPostData="2";
                                                            });
                                                          }else{
                                                            setState(() {
                                                              _childColor = ChildColor.none;
                                                              _childColorPostData="0";
                                                            });
                                                          }
                                                         },
                                                       ),
                                                       Text(Strings.yellow_title,
                                                           style: TextStyle(
                                                               fontSize: 11,
                                                               color: _chooseMamtaCard == true ? Colors.black : Colors.grey))
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
                                                       Radio<ChildColor>(
                                                         activeColor: _chooseMamtaCard == true ? Colors.black : Colors.grey,
                                                         value: ChildColor.red,
                                                         groupValue: _childColor,
                                                         onChanged:(ChildColor? value) {
                                                           if(_chooseMamtaCard == true){
                                                             setState(() {
                                                               _childColor = value ?? _childColor;
                                                               _childColorPostData="3";
                                                             });
                                                           }else{
                                                             setState(() {
                                                               _childColor = ChildColor.none;
                                                               _childColorPostData="0";
                                                             });
                                                           }
                                                         },
                                                       ),
                                                       Text(Strings.red_title,
                                                           style: TextStyle(
                                                               fontSize: 11,
                                                               color: _chooseMamtaCard == true ? Colors.black : Colors.grey))
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
                                                 .child_age_ahar,
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
                                                       Radio<ChildAhar>(
                                                         activeColor:Colors.black,
                                                         value: ChildAhar.yes,
                                                         groupValue: _childahar,
                                                         onChanged: (ChildAhar? value) {
                                                           setState(() {
                                                             _childahar = value ?? _childahar;
                                                             _dietPostData="1";

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
                                                       Radio<ChildAhar>(
                                                         activeColor:Colors.black,
                                                         value: ChildAhar.no,
                                                         groupValue: _childahar,
                                                         onChanged:(ChildAhar? value) {
                                                           setState(() {
                                                             _childahar = value ?? _childahar;
                                                             _dietPostData="2";


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
                                                 .child_any_disease,
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
                                                       Radio<ChildFoundDisease>(
                                                         activeColor:Colors.black,
                                                         value: ChildFoundDisease.yes,
                                                         groupValue: _childfounddisese,
                                                         onChanged: (ChildFoundDisease? value) {
                                                           setState(() {
                                                             _isChildGrowthDiseaseFound=true;
                                                           });
                                                           setState(() {
                                                             _childfounddisese = value ?? _childfounddisese;
                                                             _diabiliyPostData="1";
                                                             _chooseAharCard=true;
                                                             _chooseRbskPostData="yes";
                                                             print('_diabiliyPostData $_diabiliyPostData');
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
                                                       Radio<ChildFoundDisease>(
                                                         activeColor:Colors.black,
                                                         value: ChildFoundDisease.no,
                                                         groupValue: _childfounddisese,
                                                         onChanged:(ChildFoundDisease? value) {
                                                           setState(() {
                                                             _referView=false;
                                                             _isChildGrowthDiseaseFound=false;
                                                           });
                                                           setState(() {
                                                             _childfounddisese = value ?? _childfounddisese;
                                                             _diabiliyPostData="2";
                                                             _chooseAharCard=false;
                                                             print('_diabiliyPostData $_diabiliyPostData');
                                                           });
                                                           setState(() {
                                                             _childrefer=ChildRefer.none;
                                                             _riskPostData="0";
                                                             _chooseRbskPostData="no";
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
                                                 .child_any_rbsk_refer,
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
                                                       Radio<ChildRefer>(
                                                         activeColor: _chooseAharCard == true ? Colors.black : Colors.grey,
                                                         value: ChildRefer.yes,
                                                         groupValue: _childrefer,
                                                         onChanged: (ChildRefer? value) {
                                                           if(_isChildGrowthDiseaseFound == true){
                                                             setState(() {
                                                               _referView=true;
                                                             });
                                                           }
                                                           if(_chooseAharCard == true){
                                                             setState(() {
                                                               _childrefer = value ?? _childrefer;
                                                               _riskPostData="1";
                                                             });
                                                           }else{
                                                             setState(() {
                                                               _childrefer=ChildRefer.none;
                                                               _riskPostData="0";
                                                             });
                                                           }
                                                           print('_riskPostData $_riskPostData');
                                                         },
                                                       ),
                                                       Text(
                                                         Strings.yes,
                                                         style: TextStyle(
                                                             fontSize: 11,
                                                             color: _chooseAharCard == true ? Colors.black : Colors.grey),
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
                                                       Radio<ChildRefer>(
                                                         activeColor: _chooseAharCard == true ? Colors.black : Colors.grey,
                                                         value: ChildRefer.no,
                                                         groupValue: _childrefer,
                                                         onChanged:(ChildRefer? value) {
                                                           setState(() {
                                                             _referView=false;
                                                           });
                                                          if(_chooseAharCard == true){
                                                            setState(() {
                                                              _childrefer = value ?? _childrefer;
                                                              _riskPostData="2";
                                                            });
                                                          }else{
                                                            setState(() {
                                                              _childrefer=ChildRefer.none;
                                                              _riskPostData="0";
                                                            });
                                                          }
                                                          print('_riskPostData $_riskPostData');
                                                         },
                                                       ),
                                                       Text(Strings.no,
                                                           style: TextStyle(
                                                               fontSize: 11,
                                                           color: _chooseAharCard == true ? Colors.black : Colors.grey))
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
                         //Refer UI Functionality
                         Visibility(
                           visible: _referView,
                             child: Column(
                             children:<Widget> [
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

                                               if(_selectedPlacesReferCode == "13" ||_selectedPlacesReferCode == "6" ||_selectedPlacesReferCode == "15" ||_selectedPlacesReferCode == "7" || _selectedPlacesReferCode == "5"){
                                                 _changeBlockTitle=Strings.sanstha_type;
                                               }else{
                                                 _changeBlockTitle=Strings.block;
                                               }
                                               for(int i=0 ;i<custom_placesrefer_list.length; i++){
                                                 if(_selectedPlacesReferCode == "10" || _selectedPlacesReferCode == "9" || _selectedPlacesReferCode == "8"){
                                                   if(_selectedPlacesReferCode == custom_placesrefer_list[i].code.toString()){
                                                     sub_heading=custom_placesrefer_list[i].title.toString();
                                                   }
                                                   _showSubDropDown=true;
                                                 }else{
                                                   sub_heading="";
                                                   _showSubDropDown=false;
                                                 }
                                               }
                                               getDistrictListAPI("3");

                                               if(_isDropDownRefresh == true){
                                                 _isDropDownRefresh=false;
                                                 _selectedBlockUnitCode = custom_block_list[0].unitcode.toString();
                                                 _selectedDistrictUnitCode = custom_district_list[0].unitcode.toString();
                                                 _selectedSubUnitCode=custom_sub_list[0].UnitCode.toString();
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
                                           // style: Theme.of(context).textTheme.bodyText1,
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
                                               print('ReferCode:$_selectedPlacesReferCode');

                                               if(_selectedPlacesReferCode == "8" ||_selectedPlacesReferCode == "9" ||_selectedPlacesReferCode == "10" ||_selectedPlacesReferCode == "16"){
                                                 getBlockListAPI("4",_selectedDistrictUnitCode.substring(0, 4));
                                               }else{
                                                 getBlockListAPI(_selectedPlacesReferCode,_selectedDistrictUnitCode.substring(0, 4));
                                               }
                                               //
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
                                           text: _changeBlockTitle,
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
                                               _isDropDownRefresh=true;//that mean first time block value selected,now value will be reset if refer jila value changed
                                               _ReferUnitCode=_selectedBlockUnitCode;
                                               getSubDataListAPI(_selectedPlacesReferCode,_ReferUnitCode);
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

                               Padding(
                                 padding: const EdgeInsets.all(5.0),//
                                 child: Align(
                                   alignment: Alignment.centerLeft,
                                   child: Container(
                                     color: Colors.white,
                                     child: RichText(
                                       text: TextSpan(
                                           text: '${sub_heading}',
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
                               Visibility(
                                 visible: _showSubDropDown,
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
                                             items: custom_sub_list.map((item) {
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
                                                   value: item.UnitCode
                                                       .toString() //Id that has to be passed that the dropdown has.....
                                                 //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                               );
                                             }).toList(),
                                             onChanged: (String? newVal) {
                                               setState(() {
                                                 _selectedSubUnitCode = newVal!;
                                                 _ReferUnitCode=_selectedSubUnitCode;
                                                 print('_selectedSubUnitCode:$_selectedSubUnitCode');

                                               });
                                             },
                                             value:
                                             _selectedSubUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               )
                             ],
                         ))
                       ],
                    ),
                  )

                ],
              ),
            ),)),
            _ShowHideADDNewVivranView == true
                ? GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild!.unfocus();
                }
                postHbycRequest();
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
  bool _ShowHideADDNewVivranView=false; //show button for sa or anm/asha login
  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  late DateTime _selectedDate;
  var _selectedANCDate = "";

  void _selectCustomHBYCDatePopup(String _customHBYCDate) {

    var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customHBYCDate));
    print('parseCustomANCDate ${parseCustomANCDate}');


    setState(() {
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);


        _selectedANCDate = formattedDate2.toString();
        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
        var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.Birth_date));
        print('hbycDate calendr ${parseCalenderSelectedAncDate}');
        print('hbycDate intentt ${intentAncDate}');
        final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
        print('hbycDate diff ${diff_lmp_ancdate}');
        print('HBYCFlag ${HBYCFlag}');


        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
          if(HBYCFlag == "3"){
            if(!(diff_lmp_ancdate >= 90 && diff_lmp_ancdate <= 105)){
              _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              _hbycDDdateController.text = "";
              _hbycMMdateController.text = "";
              _hbycYYYYdateController.text = "";
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
          }else if(HBYCFlag == "6"){
            if(!(diff_lmp_ancdate >= 180 && diff_lmp_ancdate <= 195)){
              _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              _hbycDDdateController.text = "";
              _hbycMMdateController.text = "";
              _hbycYYYYdateController.text = "";
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
          }else if(HBYCFlag == "9"){
            if(!(diff_lmp_ancdate >= 270 && diff_lmp_ancdate <= 285)){
              _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              _hbycDDdateController.text = "";
              _hbycMMdateController.text = "";
              _hbycYYYYdateController.text = "";
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
          }else if(HBYCFlag == "12"){
            if(!(diff_lmp_ancdate >= 360 && diff_lmp_ancdate <= 375)){
              _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              _hbycDDdateController.text = "";
              _hbycMMdateController.text = "";
              _hbycYYYYdateController.text = "";
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
          }else if(HBYCFlag == "15"){
            if(!(diff_lmp_ancdate >= 450 && diff_lmp_ancdate <= 465)){
              _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              _hbycDDdateController.text = "";
              _hbycMMdateController.text = "";
              _hbycYYYYdateController.text = "";
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
          }else{
            _hbycDDdateController.text = getDate(formattedDate4);
            _hbycMMdateController.text = getMonth(formattedDate4);
            _hbycYYYYdateController.text = getYear(formattedDate4);
            _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
            print('_hbycPostDate $_hbycPostDate');
          }
        }
      });
  }

  void _selectHBYCDatePopup(int yyyy,int mm ,int dd) {
    showDatePicker(
        context: context,
       // initialDate: DateTime.now(),
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


        _selectedANCDate = formattedDate2.toString();
        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
        var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.Birth_date));
        print('hbycDate calendr ${parseCalenderSelectedAncDate}');
        print('hbycDate intentt ${intentAncDate}');
        final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
        print('hbycDate diff ${diff_lmp_ancdate}');


        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        } else {
            if(HBYCFlag == "3"){
              if(!(diff_lmp_ancdate >= 90 && diff_lmp_ancdate <= 105)){
                _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              }else{
                _hbycDDdateController.text = getDate(formattedDate4);
                _hbycMMdateController.text = getMonth(formattedDate4);
                _hbycYYYYdateController.text = getYear(formattedDate4);
                _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
                print('_hbycPostDate $_hbycPostDate');
              }
            }else if(HBYCFlag == "6"){
              if(!(diff_lmp_ancdate >= 180 && diff_lmp_ancdate <= 195)){
                _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              }else{
                _hbycDDdateController.text = getDate(formattedDate4);
                _hbycMMdateController.text = getMonth(formattedDate4);
                _hbycYYYYdateController.text = getYear(formattedDate4);
                _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
                print('_hbycPostDate $_hbycPostDate');
              }
            }else if(HBYCFlag == "9"){
              if(!(diff_lmp_ancdate >= 270 && diff_lmp_ancdate <= 285)){
                _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              }else{
                _hbycDDdateController.text = getDate(formattedDate4);
                _hbycMMdateController.text = getMonth(formattedDate4);
                _hbycYYYYdateController.text = getYear(formattedDate4);
                _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
                print('_hbycPostDate $_hbycPostDate');
              }
            }else if(HBYCFlag == "12"){
              if(!(diff_lmp_ancdate >= 360 && diff_lmp_ancdate <= 375)){
                _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              }else{
                _hbycDDdateController.text = getDate(formattedDate4);
                _hbycMMdateController.text = getMonth(formattedDate4);
                _hbycYYYYdateController.text = getYear(formattedDate4);
                _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
                print('_hbycPostDate $_hbycPostDate');
              }
            }else if(HBYCFlag == "15"){
              if(!(diff_lmp_ancdate >= 450 && diff_lmp_ancdate <= 465)){
                _showErrorPopup(Strings.choose_correct_hbyc_date,ColorConstants.AppColorPrimary);
              }else{
                _hbycDDdateController.text = getDate(formattedDate4);
                _hbycMMdateController.text = getMonth(formattedDate4);
                _hbycYYYYdateController.text = getYear(formattedDate4);
                _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
                print('_hbycPostDate $_hbycPostDate');
              }
            }else{
              _hbycDDdateController.text = getDate(formattedDate4);
              _hbycMMdateController.text = getMonth(formattedDate4);
              _hbycYYYYdateController.text = getYear(formattedDate4);
              _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
              print('_hbycPostDate $_hbycPostDate');
            }
        }
      });
    });
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

}

enum ShihuKoORS { none,yes,no}
enum ShihuKoSirp { none,yes,no}
enum MamtaCard { none,yes,no}
enum ChildColor { none,green,yellow,red}
enum ChildAhar { none,yes,no}
enum ChildFoundDisease { none,yes,no}
enum ChildRefer { none,yes,no}

ShihuKoORS _shishukoors = ShihuKoORS.none;
ShihuKoSirp _shishukosirp = ShihuKoSirp.none;
MamtaCard _mamtaCard = MamtaCard.none;
ChildColor _childColor = ChildColor.none;
ChildAhar _childahar = ChildAhar.none;
ChildFoundDisease _childfounddisese = ChildFoundDisease.none;
ChildRefer _childrefer = ChildRefer.none;

class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}
class MonthList {
  String month;
  String  index;
  MonthList({required this.month, required this.index});
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
class CustomSubCodeList {
  String? UnitID;
  String? UnitName;
  String? UnitCode;

  CustomSubCodeList({this.UnitID,this.UnitName,this.UnitCode});
}