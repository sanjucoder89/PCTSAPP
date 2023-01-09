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

class EditHBYCForm extends StatefulWidget {
  const EditHBYCForm(
      {Key? key,
        required this.RegUnitID,
        required this.VillageAutoID,
        required this.RegUnittype,
        required this.HBYCFlag,
        required this.Birth_date,
        required this.motherid,
        required this.ancregid,
        required this.infantid,
        required this.ashaAutoID,
        required this.VisitDate,
        required this.HBYCWeight,
        required this.Height,
        required this.ORSPacket,
        required this.IFASirap,
        required this.GrowthChart,
        required this.Color,
        required this.FoodAccordingAge,
        required this.GrowthLate,
        required this.Refer,
        required this.ReferUnittype,
        required this.ReferUnitcode,
        required this.ReferUnitID,
        required this.ANMVerify,
        required this.Media
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
  final String ashaAutoID;
  final String VisitDate;
  final String HBYCWeight;
  final String Height;
  final String ORSPacket;
  final String IFASirap;
  final String GrowthChart;
  final String Color;
  final String FoodAccordingAge;
  final String GrowthLate;
  final String Refer;
  final String ReferUnittype;
  final String ReferUnitcode;
  final String ReferUnitID;
  final String ANMVerify;
  final String Media;
  @override
  State<EditHBYCForm> createState() => _EditHBYCFormState();
}

class _EditHBYCFormState extends State<EditHBYCForm> {
  late SharedPreferences preferences;
  late String aashaId = "";
  late String hbycDateId = "0";
  bool _shishuEnDisable = true;
  String sub_heading="";
  var HBYCFlag="";

  //API REQUEST PARAM
  var _hbycPostDate="";
  var _weightPostData="0";
  var _orsPostData="0";
  var _ifaPostData="0";
  var _mamtaPostData="0";
  var _dietPostData="0";
  var _diabiliyPostData="0";
  var _childColorPostData="0";
  var _riskPostData="0";
  var _Media="";
  var _UpdateUserNo="";

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
  var _selectedDistrictUnitCode = "0";
  var _selectedBlockUnitCode = "0";
  var _selectedSubUnitCode = "0";
  var _ReferUnitCode="0";

  var _customHBYCDate="";
  /*
  * API BASE URL
  * */
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postBlockData";
  var _get_subdata_url = AppConstants.app_base_url + "postfillPHCCHCHBYC";
  var _add_hbyc_form_url = AppConstants.app_base_url + "PutHBYCDetail";

  List<CustomAashaList> custom_aasha_list = [];
  List aasha_response_list = [];
  List response_district_list= [];
  List response_block_list= [];
  List response_subdata_list= [];
  bool _ShowHideEditableView=false;
  Future<String> getAashaListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
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
          _isItAsha=true;
          aashaId = preferences.getString('ANMAutoID').toString();
        }else{
         // _isItAsha=false;
          //aashaId = widget.ashaAutoID;
          if(preferences.getString("AppRoleID").toString() == '32') {
            if(widget.Media == "1"){
              _isAshaEntryORANMEntry=false;
              _isItAsha=false;
              aashaId = widget.ashaAutoID;
            }else{
              if(preferences.getString('ANMAutoID').toString() == widget.ashaAutoID){
                _isAshaEntryORANMEntry=false;//update btn will show
              }else{
                if(preferences.getString("AppRoleID").toString() == '32') {//if last is anm btn will show for all asha
                  _isAshaEntryORANMEntry=false;//update btn will show
                }
              }
              _isItAsha=true;//not editable
              aashaId = widget.ashaAutoID;//set to last asha
            }
          }
        }
        print('aashaId ${aashaId}');

        if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
          _ShowHideEditableView = true;
        }else{
          _ShowHideEditableView=false;
        }

        //set hbyc
        if(widget.HBYCFlag == "0"){
          hbycDateId="0";
        }else if(widget.HBYCFlag == "3"){
          hbycDateId="1";
        }else if(widget.HBYCFlag == "6"){
          hbycDateId="2";
        }else if(widget.HBYCFlag == "9"){
          hbycDateId="3";
        }else if(widget.HBYCFlag == "12"){
          hbycDateId="4";
        }else if(widget.HBYCFlag == "15"){
          hbycDateId="5";
        }

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

        var _hbycAPIDate= DateTime.parse(getConvertRegDateFormat(widget.VisitDate));// "VisitDate": "2019-02-28T00:00:00",
        _hbycDDdateController.text = getDate(_hbycAPIDate.toString());
        _hbycMMdateController.text = getMonth(_hbycAPIDate.toString());
        _hbycYYYYdateController.text = getYear(_hbycAPIDate.toString());
        _hbycPostDate=_hbycYYYYdateController.text.toString()+ "-"+_hbycMMdateController.text.toString()+"-"+_hbycDDdateController.text.toString();
        print('_hbycPostDate $_hbycPostDate');

        //Set Last
        setState(() {
          print('ORSPacket ${widget.ORSPacket}');
          if(widget.ORSPacket == "1"){
            _orsPostData="1";
            _shishukoors=ShihuKoORS.yes;
          }else if(widget.ORSPacket == "2"){
            _orsPostData="2";
            _shishukoors=ShihuKoORS.no;
          }else{
            _orsPostData="0";
            _shishukoors=ShihuKoORS.none;
          }
          if(widget.IFASirap == "1"){
            _ifaPostData="1";
            _shishukosirp=ShihuKoSirp.yes;
          }else if(widget.IFASirap == "2"){
            _ifaPostData="2";
            _shishukosirp=ShihuKoSirp.no;
          }else{
            _ifaPostData="0";
            _shishukosirp=ShihuKoSirp.none;
          }
          if(widget.GrowthChart == "1"){
            _mamtaPostData="1";
            _mamtaCard=MamtaCard.yes;
            _chooseMamtaCard=true;
          }else if(widget.GrowthChart == "2"){
            _mamtaPostData="2";
            _mamtaCard=MamtaCard.no;
            _chooseMamtaCard=false;
          }else{
            _mamtaPostData="0";
            _mamtaCard=MamtaCard.none;
            _chooseMamtaCard=true;
          }
          if(widget.Color == "1"){
            _childColorPostData="1";
            _childColor=ChildColor.green;
          }else if(widget.Color == "2"){
            _childColorPostData="2";
            _childColor=ChildColor.yellow;
          }else if(widget.Color == "3"){
            _childColorPostData="3";
            _childColor=ChildColor.red;
          }else{
            _childColorPostData="0";
            _childColor=ChildColor.none;

          }

          if(widget.FoodAccordingAge == "1"){
            _dietPostData="1";
            _childahar=ChildAhar.yes;
          }else if(widget.FoodAccordingAge == "2"){
            _dietPostData="2";
            _childahar=ChildAhar.no;
          }else{
            _dietPostData="0";
            _childahar=ChildAhar.none;
          }
          if(widget.GrowthLate == "1"){
            _diabiliyPostData="1";
            _childfounddisese=ChildFoundDisease.yes;
            _referView=true;
            _isChildGrowthDiseaseFound=true;
            if(_isChildGrowthDiseaseFound == true){
              setState(() {
                _referView=true;
              });
            }
          }else if(widget.GrowthLate == "2"){
            _diabiliyPostData="2";
            _childfounddisese=ChildFoundDisease.no;
            _referView=false;
            _chooseAharCard=false;
            _isChildGrowthDiseaseFound=false;
            if(_isChildGrowthDiseaseFound == true){
              setState(() {
                _referView=true;
              });
            }
          }else{
            _diabiliyPostData="0";
            _childfounddisese=ChildFoundDisease.none;
          }
          if(widget.Refer == "1"){
            _riskPostData="1";
            _childrefer=ChildRefer.yes;
            _referView=true;
          }else if(widget.Refer == "2"){
            _riskPostData="2";
            _childrefer=ChildRefer.no;
            _referView=false;
          }else{
            _riskPostData="0";
            _childrefer=ChildRefer.none;
          }
        });

        setState(() {
          _shishuWeightController.text=widget.HBYCWeight;
          _shishuKadController.text=widget.Height;
        });

        if(widget.ReferUnittype.isNotEmpty){
          for (int i = 0; i < custom_placesrefer_list.length; i++) {
            if (widget.ReferUnittype == custom_placesrefer_list[i].code.toString()) {
              _selectedPlacesReferCode = custom_placesrefer_list[i].code.toString();
              print('RegUnitTYpeafter ${_selectedPlacesReferCode}');
              getDistrictListAPI("3");
              break;
            }
          }
        }


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
        //_selectedDistrictUnitCode = custom_district_list[0].unitcode.toString();
        //print('_selectedDistrictUnitCode ${_selectedDistrictUnitCode}');
        //print('disctict.len ${custom_district_list.length}');

        if(widget.ReferUnitcode.isNotEmpty){
          setState(() {
            print('widget.ReferUnitcode ${widget.ReferUnitcode}');
            print('widget.ReferUnitcode.substring ${widget.ReferUnitcode.substring(0, 4)}');
            for (int i = 0; i < response_district_list.length; i++) {
              if(widget.ReferUnitcode.substring(0, 4) == resBody['ResposeData'][i]['unitcode'].substring(0, 4)){
                print('insideForLoop ${resBody['ResposeData'][i]['unitcode']}');
                _selectedDistrictUnitCode = resBody['ResposeData'][i]['unitcode'].toString();
                print('_selectedDistrictUnitCodeafter ${_selectedDistrictUnitCode}');
                if(_selectedPlacesReferCode == "8" ||_selectedPlacesReferCode == "9" ||_selectedPlacesReferCode == "10" ||_selectedPlacesReferCode == "16"){
                  getBlockListAPI("4",_selectedDistrictUnitCode.substring(0, 4));
                }else{
                  getBlockListAPI(_selectedPlacesReferCode,_selectedDistrictUnitCode.substring(0, 4));
                }
                break;
              }
            }
          });
        }

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
        print('runicode ${widget.ReferUnitcode}');
        if(widget.ReferUnitcode != "null"){
          setState(() {
            for (int i = 0; i < response_block_list.length; i++) {
              if(widget.ReferUnitcode.substring(0, 6) == resBody['ResposeData'][i]['unitcode'].substring(0, 6)){
                print('insideForLoop ${resBody['ResposeData'][i]['unitNameHindi']}');
                _selectedBlockUnitCode = resBody['ResposeData'][i]['unitcode'].toString();
                print('_selectedBlockUnitCodeater ${_selectedBlockUnitCode}');
                _ReferUnitCode=_selectedBlockUnitCode;
                getSubDataListAPI(_selectedPlacesReferCode,_ReferUnitCode);
                break;
              }
            }
          });
        }

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

      custom_sub_list.clear();
      custom_sub_list.add(CustomSubCodeList(UnitID: "", UnitName:Strings.choose,UnitCode: "0"));
      for (int i = 0; i < resBody.length; i++) {
        custom_sub_list.add(CustomSubCodeList(UnitID: resBody[i]['UnitID'].toString(),
            UnitName: resBody[i]['UnitName'].toString(),
            UnitCode:resBody[i]['UnitCode'].toString()));
      }
      print('custom_sub_list.len ${custom_sub_list.length}');
      print('sdffffffffffffffffff ${widget.ReferUnitcode}');
      ///_ReferUnitCode=widget.ReferUnitcode;
      _selectedSubUnitCode=custom_sub_list[0].UnitCode.toString();


      //set Last selected value
      if(_selectedPlacesReferCode == "8" || _selectedPlacesReferCode == "8" || _selectedPlacesReferCode == "10"){
        for (int i = 0; i < custom_sub_list.length; i++) {
          if (widget.ReferUnitcode == custom_sub_list[i].UnitCode.toString()) {
            _selectedSubUnitCode = custom_sub_list[i].UnitCode.toString();
            print('_selectedSubUnitCode ${_selectedSubUnitCode}');
            break;
          }
        }
      }

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
  void postHbycRequest() async {

    preferences = await SharedPreferences.getInstance();

    if(aashaId == "0"){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }/*else if(widget.motherid){
      _showErrorPopup(Strings.try_again,ColorConstants.AppColorPrimary);
    }*/else if(HBYCFlag.isEmpty){
      _showErrorPopup(Strings.hbyc_choose_date,ColorConstants.AppColorPrimary);
    }else if(HBYCFlag == "0"){
      _showErrorPopup(Strings.choose_visit_schedule,ColorConstants.AppColorPrimary);
    }/*else if(widget.HBYCFlag == HBYCFlag){
      _showErrorPopup(Strings.choose_correct_visit_schedule,ColorConstants.AppColorPrimary);
    }*/else if(_hbycPostDate.isEmpty){
      _showErrorPopup(Strings.choose_visit_date,ColorConstants.AppColorPrimary);
    }else if(_shishuKadController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_height_incm,ColorConstants.AppColorPrimary);
    }else if(_orsPostData.isEmpty){
      _showErrorPopup(Strings.choose_ors_packet,ColorConstants.AppColorPrimary);
    }else if(_mamtaPostData.isEmpty){
      _showErrorPopup(Strings.choose_mamta_packet,ColorConstants.AppColorPrimary);
    }else if(_dietPostData.isEmpty){
      _showErrorPopup(Strings.choose_child_ahar,ColorConstants.AppColorPrimary);
    }else if(_diabiliyPostData.isEmpty){
      _showErrorPopup(Strings.choose_child_dieses,ColorConstants.AppColorPrimary);
    }else if(_referView == true && _ReferUnitCode == "0"){
      _showErrorPopup(Strings.choose_refer_type,ColorConstants.AppColorPrimary);
    }else if((_selectedPlacesReferCode == "10" ||_selectedPlacesReferCode == "9" ||_selectedPlacesReferCode == "8") && _selectedSubUnitCode == "0"){
      _showErrorPopup("कृपया "+sub_heading +" चुनें!",ColorConstants.AppColorPrimary);
    }else{

      if(_shishuWeightController.text.toString().trim().isEmpty){
        _weightPostData="0";
      }else{
        _weightPostData=_shishuWeightController.text.toString().trim();
      }
     // print('AppRoleID: ${preferences.getString("AppRoleID")}');
      if(preferences.getString("AppRoleID") == "33"){
        _Media="2";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else if (widget.ANMVerify.isNotEmpty) {
        if(widget.ANMVerify == "1" && widget.Media == "1"){
          _Media="1";
          _UpdateUserNo=preferences.getString("UserNo").toString();
        }else if(widget.ANMVerify == "1" && widget.Media == "3"){
          _Media = "3";
          _UpdateUserNo = preferences.getString("UserNo").toString();
        }else if(widget.ANMVerify == "1" && widget.Media == "2"){
          _Media = "3";
          _UpdateUserNo =preferences.getString("UserNo").toString();
        }else if(widget.ANMVerify == "0" && widget.Media == "1"){
          _Media = "1";
          _UpdateUserNo =preferences.getString("UserNo").toString();
        }
      }else{
        _Media="1";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }

      var _tempReferCode="";
      if(_referView == true){
        _tempReferCode=_ReferUnitCode;
      }else{
        _tempReferCode="0";
      }
      print('_Media_req $_Media');
      print('__UpdateUserNo_req $_UpdateUserNo');


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
  bool _chooseMamtaCard = true;
  bool _chooseAharCard = true;
  bool _referView = false;
  bool _isChildGrowthDiseaseFound = true;
  bool _isItAsha=false;
  bool _isAshaEntryORANMEntry=false;//false= anm , true =asha
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
                    child: Text(
                      Strings.hbyc_choose_date,
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
                            _selectHBYCDatePopup(int.parse(_hbycYYYYdateController.text.toString()),int.parse(_hbycMMdateController.text.toString()) ,int.parse(_hbycDDdateController.text.toString()));
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
                                                           });
                                                           setState(() {
                                                             if(widget.Refer == "1"){
                                                               _riskPostData="1";
                                                               _childrefer=ChildRefer.yes;
                                                             }else if(widget.Refer == "2"){
                                                               _riskPostData="2";
                                                               _childrefer=ChildRefer.no;
                                                             }else{
                                                               _riskPostData="0";
                                                               _childrefer=ChildRefer.none;
                                                             }
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
                                                           });
                                                           setState(() {
                                                             _childrefer=ChildRefer.none;
                                                             _riskPostData="0";
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
                             children: <Widget>[
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
                                           text: Strings.block,
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
                                             value: _selectedSubUnitCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
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
            _ShowHideEditableView == true ?
            _isAshaEntryORANMEntry  == false
                ?
            GestureDetector(
              onTap: (){
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
            )
                :
            Container()
                :
            Container()
          ],
        ),
      ),

    );
  }

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
      var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.VisitDate));
      print('hbycDate calendr ${parseCalenderSelectedAncDate}');
      print('hbycDate intentt ${intentAncDate}');
      final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
      print('hbycDate diff ${diff_lmp_ancdate}');


      if (formattedDate2.toString() == getCurrentDate()) {
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
  }




  void _selectHBYCDatePopup(int yyyy,int mm ,int dd) {
    showDatePicker(
        context: context,
        // initialDate: DateTime.now(),
        initialDate: DateTime(yyyy, mm , dd ),
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


        if (formattedDate2.toString() == getCurrentDate()) {
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
  //my code
  /*void _selectHBYCDatePopup() {
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


        _selectedANCDate = formattedDate2.toString();
        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
        var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.VisitDate));
        print('hbycDate calendr ${parseCalenderSelectedAncDate}');
        print('hbycDate intentt ${intentAncDate}');
        final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
        print('hbycDate diff ${diff_lmp_ancdate}');


        if (formattedDate2.toString() == getCurrentDate()) {
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
  }*/

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

  Future<SavedHBYCDetailsData> callapi() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //print('pkg_version: ${packageInfo.version}');
    var response = await put(Uri.parse(_add_hbyc_form_url), body: {
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
      "AppVersion": "5.5.5.22",
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