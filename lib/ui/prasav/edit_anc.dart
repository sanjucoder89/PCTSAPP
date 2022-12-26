import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; //for date format
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import 'model/GetAanganBadiListData.dart';
import 'model/GetAashaListData.dart';
import 'model/GetBlockListData.dart';
import 'model/GetDistrictListData.dart';
import 'model/SavedANCDetailsData.dart';
import 'model/TreatmentListData.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

class EditANCScreen extends StatefulWidget {
  const EditANCScreen(
      {Key? key,
      required this.pctsID,
      required this.registered_date,
      required this.registered_date2,
      required this.expected_date,
      required this.anc_date,
      required this.weight,
      required this.AncFlag,
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
      required this.AshaAutoID,
      required this.AnganBadiNo,
      required this.HBCount,
      required this.IFA,
      required this.BPS,
      required this.BPD,
      required this.COMPL,
      required this.ALBE400,
      required this.CAL500,
      required this.RTI,
      required this.Media,
      required this.CovidCase,
      required this.CovidFromDate,
      required this.CovidForeignTrip,
      required this.CovidRelativePossibility,
      required this.CovidRelativePositive,
      required this.CovidQuarantine,
      required this.CovidIsolation,
      required this.IronSucrose1,
      required this.IronSucrose2,
      required this.IronSucrose3,
      required this.IronSucrose4,
      required this.NormalLodingIronSucrose1,
      required this.TreatmentCode,
      required this.ReferDistrictCode,
      required this.ReferUnitType,
      required this.ReferUniName,
      required this.headerName,
      required this.ANC1Date,
      required this.ANC2Date,
      required this.ANC3Date,
      required this.ANC4Date,
      required this.PreviousTT1Date,
      required this.PreviousTT2Date,
      required this.PreviousTTBDate
      })
      : super(key: key);
  final String pctsID;

  final String registered_date;
  final String registered_date2;
  final String expected_date;
  final String anc_date;
  final String weight;
  final String AncFlag;
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
  final String AshaAutoID;
  final String AnganBadiNo;
  final String HBCount;
  final String IFA;
  final String BPS;
  final String BPD;
  final String COMPL;
  final String ALBE400;
  final String CAL500;
  final String RTI;
  final String Media;
  final String CovidCase;
  final String CovidFromDate;
  final String CovidForeignTrip;
  final String CovidRelativePossibility;
  final String CovidRelativePositive;
  final String CovidQuarantine;
  final String CovidIsolation;
  final String IronSucrose1;
  final String IronSucrose2;
  final String IronSucrose3;
  final String IronSucrose4;
  final String NormalLodingIronSucrose1;
  final String TreatmentCode;
  final String ReferDistrictCode;
  final String ReferUnitType;
  final String ReferUniName;
  final String headerName;
  final String ANC1Date;
  final String ANC2Date;
  final String ANC3Date;
  final String ANC4Date;
  final String PreviousTT1Date;
  final String PreviousTT2Date;
  final String PreviousTTBDate;

  @override
  State<StatefulWidget> createState() => _EditANCScreen();
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

class _EditANCScreen extends State<EditANCScreen> {
  var option1 = Strings.logout;
  var option2 = Strings.sampark_sutr;
  var option3 = Strings.video_title;
  var option4 = Strings.app_ki_jankari;
  var option5 = Strings.help_desk;
  late String aashaId = "0";
  late String aanganBadiId = "0";
  late SharedPreferences preferences;
  var uuid = Uuid();
  var decodeLoginUnitId;

  /*
  * API BASE URL
  * */
  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _aanganbadi_list_url = AppConstants.app_base_url + "GetAanganwariByASHAAutoid";
  var _treatmentcode_list_url = AppConstants.app_base_url + "getTretmentCode";
  var _update_post_anc_api = AppConstants.app_base_url + "PutANCDetail";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postBlockData";



  List response_list = [];
  List response_list2 = [];
  List response_district_list= [];
  List response_block_list= [];

  List<CustomAashaList> custom_aasha_list = [];

  //List<TreatmentListData.Res> treatment_code_list = [];
  List<CustomAanganBadiList> custom_aanganbadi_list = [];
  List<CustomTreatmentCodeList> custom_treatment_list = [];
  List<CustomPlacesReferCodeList> custom_placesrefer_list = [];
  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomBlockCodeList> custom_block_list = [];
  var _selectedTreatmentCode = "0";
  var _selectedPlacesReferCode = "0";
  var _selectedDistrictUnitCode = "0";
  var _selectedBlockUnitCode = "0";
  TextEditingController _covidDDdateController = TextEditingController();
  TextEditingController _covidMMdateController = TextEditingController();
  TextEditingController _covidYYYYdateController = TextEditingController();

  TextEditingController _ancDDdateController = TextEditingController();
  TextEditingController _ancMMdateController = TextEditingController();
  TextEditingController _ancYYYYdateController = TextEditingController();

  /*
  * Sukroj Controller
  * */
  TextEditingController _sukroj1DDController = TextEditingController();
  TextEditingController _sukroj1MMController = TextEditingController();
  TextEditingController _sukroj1YYYYController = TextEditingController();

  TextEditingController _sukroj2DDController = TextEditingController();
  TextEditingController _sukroj2MMController = TextEditingController();
  TextEditingController _sukroj2YYYYController = TextEditingController();

  TextEditingController _sukroj3DDController = TextEditingController();
  TextEditingController _sukroj3MMController = TextEditingController();
  TextEditingController _sukroj3YYYYController = TextEditingController();

  TextEditingController _sukroj4DDController = TextEditingController();
  TextEditingController _sukroj4MMController = TextEditingController();
  TextEditingController _sukroj4YYYYController = TextEditingController();

  /*
  * tikai Controller
  * */

  TextEditingController _TT1DDController = TextEditingController();
  TextEditingController _TT1MMController = TextEditingController();
  TextEditingController _TT1YYYYController = TextEditingController();

  TextEditingController _TT2DDController = TextEditingController();
  TextEditingController _TT2MMController = TextEditingController();
  TextEditingController _TT2YYYYController = TextEditingController();

  TextEditingController _TTBDDController = TextEditingController();
  TextEditingController _TTBMMController = TextEditingController();
  TextEditingController _TTBYYYYController = TextEditingController();

  TextEditingController _IFA180DDController = TextEditingController();
  TextEditingController _IFA180MMController = TextEditingController();
  TextEditingController _IFA180YYYYController = TextEditingController();

  TextEditingController _IFA360DDController = TextEditingController();
  TextEditingController _IFA360MMController = TextEditingController();
  TextEditingController _IFA360YYYYController = TextEditingController();

  TextEditingController _AlbadoseDDController = TextEditingController();
  TextEditingController _AlbadoseMMController = TextEditingController();
  TextEditingController _AlbadoseYYYYController = TextEditingController();

  TextEditingController _CalciumVitaminD3DDController = TextEditingController();
  TextEditingController _CalciumVitaminD3MMController = TextEditingController();
  TextEditingController _CalciumVitaminD3YYYYController = TextEditingController();

  TextEditingController _mahilaHeightController = TextEditingController();
  TextEditingController _animyaHBCountController = TextEditingController();
  TextEditingController _weightKiloGramController = TextEditingController();
  TextEditingController _bloodpreshourSController = TextEditingController();
  TextEditingController _bloodpreshourDController = TextEditingController();

  var _hbCount="";

  /*
  * API REQUEST PARAMETER'S
  * */
  var _iscovidCase="";// set value for api request
  var _CovidForeignTrip="";// set value for api request
  var _CovidRelativePossibility="";// set value for api request
  var _CovidRelativePositive="";// set value for api request
  var _CovidQuarantine="";// set value for api request
  var _CovidIsolation="";// set value for api request
  var _covidDate="";// set value for api request
  var _UpdateUserNo="";// set value for api request
  var _Media="";// set value for api request
  var _TreatMentCode="";// set value for api request
  var _apiUrineCodeA="";
  var _apiUrineCodeS="";
  var _sukrojValue_Normal="";
  var _Iron_sukroj_Post1="";
  var _Iron_sukroj_Post2="";
  var _Iron_sukroj_Post3="";
  var _Iron_sukroj_Post4="";
  var _referData="0";
  var _ReferUnitCode="0";
  var _distUnitIdCode="0000";
  var _Tab_Alb_DatePost="";
  var _cal_DatePost="";
  var _RTI_YES_NO="";
  var _IFADatePost="";
  var _AncDatePost="";
  var _TT1DatePost="";
  var _TT2DatePost="";
  var _TTBDatePost="";


  bool _ShowHideEditVivranView=false;
  bool _isSukroj1Selected=false;
  bool _checkIfANCSelected=false;
  bool _showCovidDateView=false;
  bool? _mahilaHeightEnabledDisabled;
  bool? _covidDDEnabledDisabled;
  bool? _covidMMEnabledDisabled;//for enable disable covid date
  bool? _covidYYYYEnabledDisabled;//for enable disable covid date

  bool _isItAsha=false;
  Future<String> getAashaListAPI() async {
    preferences = await SharedPreferences.getInstance();


    //Reset all radio button for first time
    setState(() {
      _pet = Pet.none;
    });

    setState(() {
      _color = colors.blue;
    });

    setState(() {
      _choose=multiple_chooice.nill;
      _choose2=multiple_chooice.nill;
      _choose3=multiple_chooice.nill;
      _choose4=multiple_chooice.nill;
      _choose5=multiple_chooice.nill;
      _choose6=multiple_chooice.nill;

    });

    /*setState(() {
      _choose_covid_1=multiple_chooice.nill;
      _choose_covid_2=multiple_chooice.nill;
      _choose_covid_3=multiple_chooice.nill;
      _choose_covid_4=multiple_chooice.nill;
      _choose_covid_5=multiple_chooice.nill;
      _choose_covid_6=multiple_chooice.nill;
    });*/

    _HighAnaimiyaEnDisableCB=false;
    _HighbloodpresourEnDisableCB=false;
    _AgeEnDisableCB=false;
    _ChotakadEnDisableCB=false;
    //print('AppRoleID ${preferences.getString("AppRoleID")}');
    if(preferences.getString("AppRoleID") == "31" || preferences.getString("AppRoleID") == "32" || preferences.getString("AppRoleID") == "33"){
      _ShowHideEditVivranView = true;
    }else{
      _ShowHideEditVivranView=false;
    }

    // String subAncLastDate = "";
    //         if (TextUtils.isEmpty(getIntent().getStringExtra("AncLastDate"))) {
    //             AncLastDate = "";
    //         } else if (getIntent().getStringExtra("AncLastDate").equals("null")) {
    //             AncLastDate = "";
    //         } else {
    //             AncLastDate = getIntent().getStringExtra("AncLastDate");
    //
    //
    //             if (!AncLastDate.equals("")) {
    //                 subAncLastDate = AncLastDate.substring(0, 10);
    //                 try {
    //                     AncLastDateObj_41 = fastDateFormat1.parse(subAncLastDate);
    //                     AncLastDateObj_28 = fastDateFormat1.parse(subAncLastDate);
    //                     hb_lessThen112 = fastDateFormat1.parse(LMPD.substring(0, 10));
    //                     hb_lessThen112to210 = fastDateFormat1.parse(LMPD.substring(0, 10));
    //                     hb_graterThen210 = fastDateFormat1.parse(LMPD.substring(0, 10));
    //                     LMPD_Date = fastDateFormat1.parse(LMPD);
    //                     if (!AncLastDate.equals("")) {
    //                         AncLastDateObj_28 = AppUtils.addDays(AncLastDateObj_28, 28);
    //                         AncLastDateObj_41 = AppUtils.addDays(AncLastDateObj_41, 41);
    //
    //                         hb_lessThen112 = AppUtils.addDays(hb_lessThen112, 112);
    //                         hb_lessThen112to210 = AppUtils.addDays(hb_lessThen112to210, 210);
    //                         hb_graterThen210 = AppUtils.addDays(hb_graterThen210, 210);
    //
    //                     }
    //
    //                 } catch (Exception e) {
    //
    //                 }
    //             }
    //         }

    if(widget.anc_date.isNotEmpty){

    }


    if(widget.Height == "null"){
      setState(() {
        _mahilaHeightController.text="";
        _mahilaHeightEnabledDisabled=true;
      });
    }else{
      setState(() {
        _showHideMahilaHeightView=false;
        _mahilaHeightController.text=widget.Height.toString().trim();
        _mahilaHeightEnabledDisabled=false;
      });

      if(int.parse(widget.Height.toString()) <= 140 ){
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 3,rishValue: "9"));
        _showHideHighRiskView=true;
        _highRiskChecked=true;
        _chotakadCheckb=true;
        _highRiskEnDisableCB=false;

      }/*else{
        _highRiskChecked=false;
        _chotakadCheckb=false;
        _highRiskEnDisableCB=true;

      }*/

      if(widget.Age != "null"){
        if (int.parse(widget.Age) < 18 || int.parse(widget.Age) > 35) {
          _highRiskChecked=true;//checked highrisk chkbox
          _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
          _ageCheckb=true;//checked chota kad  chkbox
          _AgeEnDisableCB=false;//checked chota kad  chkbox
          custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 2,rishValue: "8"));
        }else{
          custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 2);
         // _highRiskChecked=false;
         // _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
        }
      }else{



      }
      if(widget.DeliveryComplication == "1"){
        _showHideHighRiskView=true;
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 4,rishValue: "10"));
        _highRiskChecked=true;//checked highrisk chkbox
        _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
        _purvJatilPrastutiCheckb=true;
        _PurvJatilEnDisableCB=false;
      }

    }
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
        response_list = resBody['ResposeData'];
        custom_aasha_list.add(CustomAashaList(ASHAName: Strings.choose, ASHAAutoid: "0"));
        for (int i = 0; i < response_list.length; i++) {
          custom_aasha_list.add(CustomAashaList(
              ASHAName: response_list[i]['ASHAName'].toString(),
              ASHAAutoid: response_list[i]['ASHAAutoid'].toString()));
        }
        if(preferences.getString("AppRoleID").toString() == '33'){
          _isItAsha=true;
          aashaId = preferences.getString('ANMAutoID').toString();
        }else{
          _isItAsha=false;
          aashaId = widget.AshaAutoID;
        }
        print('aashaId ${aashaId}');
      }
      if (aashaId != "0"){
        getAanganBadiListAPI(aashaId);
      }
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
            NameE: "",
            AnganwariNo: "0",
            LastUpdated: ""));
        for (int i = 0; i < response_list2.length; i++) {
          custom_aanganbadi_list.add(CustomAanganBadiList(
              NameH: response_list2[i]['NameH'].toString(),
              NameE: response_list2[i]['NameE'].toString(),
              AnganwariNo: response_list2[i]['AnganwariNo'].toString(),
              LastUpdated: response_list2[i]['LastUpdated'].toString()));
        }

        aanganBadiId = widget.AnganBadiNo;
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  var  edtBP_S=0;
  var  edtBP_D=0;
  void validatePostRequest() {

    if(_bloodpreshourSController.text.isNotEmpty){
      edtBP_S=int.parse(_bloodpreshourSController.text.toString());
    }

    if(_bloodpreshourDController.text.isNotEmpty){
      edtBP_D=int.parse(_bloodpreshourDController.text.toString());
    }

    if(aashaId == "0" && preferences.getString("AppRoleID").toString() == '32'){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }/*else if(aanganBadiId == "0"){
      _showErrorPopup(Strings.aanganbadi_chunai,ColorConstants.AppColorPrimary);
    }*/else if(_AncDatePost.isEmpty){
      _showErrorPopup(Strings.please_select_Anc_date,Colors.black);
    }else if(_animyaHBCountController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_hb,Colors.black);
    }else if(_weightKiloGramController.text.toString().isEmpty){
      _showErrorPopup(Strings.enter_weight,Colors.black);
    }else if(_sukroj1DDController.text.toString().isEmpty && _sukrojValue_Normal.isNotEmpty){
      _showErrorPopup(Strings.choose_sukroj_normal_loading,Colors.black);
    }else if(_sukroj1DDController.text.toString().isNotEmpty && _sukrojValue_Normal.isEmpty){
      _showErrorPopup(Strings.choose_sukroj_normal_loading,Colors.black);
    }else if(_RTI_YES_NO.isEmpty){
      _showErrorPopup(Strings.rti_sti_symtoms,Colors.black);
    }else if(_highRiskChecked == true){
        if(_bloodpreshourDController.text.isEmpty && _bloodpreshourSController.text.isEmpty){
          _showErrorPopup(Strings.please_write_blood_pressor,Colors.black);
        }else if(_bloodpreshourDController.text.isEmpty){
          _showErrorPopup(Strings.please_write_blood_pressor_diastolic,Colors.black);
        }else if(_bloodpreshourSController.text.isEmpty){
          _showErrorPopup(Strings.please_write_blood_pressor_systolic,Colors.black);
        }else if (edtBP_S < 60) {
          _showErrorPopup(Strings.enter_bp_s_range_under_60,Colors.black);
        }else if (edtBP_S > 300) {
          _showErrorPopup(Strings.enter_bp_s_range_greater_300,Colors.black);
        }else if (edtBP_D < 40) {
          _showErrorPopup(Strings.enter_bp_d_range_greater_60,Colors.black);
        }else if (edtBP_D > 150) {
          _showErrorPopup(Strings.enter_bp_d_range_greater_150,Colors.black);
        }else if (edtBP_S < edtBP_D) {
          _showErrorPopup(Strings.sys_dis_rance,Colors.black);
        }else if (_TreatMentCode.isEmpty) {
          _showErrorPopup(Strings.please_choose_upchar_code,Colors.black);
        }else if (_TreatMentCode == "0") {
          _showErrorPopup(Strings.please_choose_upchar_code,Colors.black);
        }else if(_ReferUnitCode == "0"){
          _showErrorPopup(Strings.choose_refer_sanstha, Colors.black);
        }/*else if(_referData == "0"){
          _showErrorPopup(Strings.choose_refer_type, Colors.black);
        }else if(_distUnitIdCode == "0000"){
          _showErrorPopup(Strings.choose_refer_district, Colors.black);
        }*/else{
          print('inside with risk');
          if(checkANCDatesWithHighRisk() == true){
            postRequestWithRisk();
          }
        }
    }else{
      print('inside without risk');
      if(checkANCDatesWithoutHighRisk() == true){
        postRequestWithoutRisk();
      }
    }
  }


  bool checkANCDatesWithoutHighRisk() {

    final finalANCDate=_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()+" 00:00:00.000";
    //print('finalANCDate $finalANCDate');

    var finalParseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(finalANCDate));
    //print('finalParseCustomANCDate ${finalParseCustomANCDate}');


    String formattedDate4 = DateFormat('yyyy-MM-dd').format(finalParseCustomANCDate);
    String formattedANCDate = DateFormat('yyyy/MM/dd').format(finalParseCustomANCDate);
    _selectedANCDate = formattedANCDate.toString();
    //print('Calendra selected date=>: ${formattedANCDate.toString()}');
    var selectedParsedDate = DateTime.parse(formattedDate4.toString());


    if(widget.AncFlag == "1"){//if ANC FLAG == 1 , CALL Direct API
      print('API WILL B CALLED>>>>>');
      return true;

    }else if(widget.AncFlag == "2"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC1Date));
      print('anc 2: ${parseLastANCDate}');


      final parseLastANCDate_41 = parseLastANCDate.add(const Duration(days: 41));
      print('parseLastANCDate_41: ${parseLastANCDate_41}');

      if(selectedParsedDate.compareTo(parseLastANCDate_41) < 0){
        _showErrorPopup(Strings.anc_41_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }

    }else if(widget.AncFlag == "3"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC2Date));
      print('anc 3: ${parseLastANCDate}');


      final parseLastANCDate_41 = parseLastANCDate.add(const Duration(days: 41));
      print('parseLastANCDate_41: ${parseLastANCDate_41}');

      if(selectedParsedDate.compareTo(parseLastANCDate_41) < 0){
        _showErrorPopup(Strings.anc_41_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }

    }else if(widget.AncFlag == "4"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC3Date));
      print('anc 4: ${parseLastANCDate}');


      final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
      print('parseLastANCDate_28: ${parseLastANCDate_28}');

      if(selectedParsedDate.compareTo(parseLastANCDate_28) < 0){
        _showErrorPopup(Strings.anc_28_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }
    }
    return false;
  }
  bool checkANCDatesWithHighRisk() {

    final finalANCDate=_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()+" 00:00:00.000";
    print('finalANCDate $finalANCDate');

    var finalParseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(finalANCDate));
    print('finalParseCustomANCDate ${finalParseCustomANCDate}');


    String formattedDate4 = DateFormat('yyyy-MM-dd').format(finalParseCustomANCDate);
    String formattedANCDate = DateFormat('yyyy/MM/dd').format(finalParseCustomANCDate);
    _selectedANCDate = formattedANCDate.toString();
    print('Calendra selected date=>: ${formattedANCDate.toString()}');
    var selectedParsedDate = DateTime.parse(formattedDate4.toString());


    if(widget.AncFlag == "1"){//if ANC FLAG == 1 , CALL Direct API
      print('API WILL B CALLED>>>>>');
      return true;

    }else if(widget.AncFlag == "2"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC1Date));
      print('last anc date: ${parseLastANCDate}');


      final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
      print('parseLastANCDate_28: ${parseLastANCDate_28}');

      if(selectedParsedDate.compareTo(parseLastANCDate_28) < 0){
        _showErrorPopup(Strings.anc_28_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }

    }else if(widget.AncFlag == "3"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC2Date));
      print('last anc date: ${parseLastANCDate}');


      final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
      print('parseLastANCDate_28: ${parseLastANCDate_28}');

      if(selectedParsedDate.compareTo(parseLastANCDate_28) < 0){
        _showErrorPopup(Strings.anc_28_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }

    }else if(widget.AncFlag == "4"){
      var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.ANC3Date));
      print('last anc date: ${parseLastANCDate}');


      final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
      print('parseLastANCDate_28: ${parseLastANCDate_28}');

      if(selectedParsedDate.compareTo(parseLastANCDate_28) < 0){
        _showErrorPopup(Strings.anc_28_days_validation,Colors.black);
      }else{
        print('API WILL B CALLED>>>>>');
        return true;
      }
    }
    return false;
  }

  /*
    * IF HIGH RISK CHECKED
  */
  Future<SavedANCDetailsData> postRequestWithRisk() async {//SavedANCDetailsData
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    if(preferences.getString("AppRoleID") == "33"){
      _Media="2";
      _UpdateUserNo=preferences.getString("ANMAutoID").toString();
    }else{
      _Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }

    if(_latitude == "0.0" || _longitude == "0.0"){
      _getLocation();
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('pkg_version: ${packageInfo.version}');


    if(_isTT1Selected == true){
      if (_TT1DDController.text.isNotEmpty) {
        _TT1DatePost=_TT1YYYYController.text.toString()+"/"+_TT1MMController.text.toString()+"/"+_TT1DDController.text.toString();
      }
    }

    if(_isTT2Selected == true){
      if (_TT2DDController.text.isNotEmpty) {
        _TT2DatePost=_TT2YYYYController.text.toString()+"/"+_TT2MMController.text.toString()+"/"+_TT2DDController.text.toString();
      }
    }

    if(_isTTBSelected == true){
      if (_TTBDDController.text.isNotEmpty) {
        _TTBDatePost=_TTBYYYYController.text.toString()+"/"+_TTBMMController.text.toString()+"/"+_TTBDDController.text.toString();
      }
    }


    if(_isIFA180View == true){
      if (_IFA180DDController.text.isNotEmpty) {
        _IFADatePost=_IFA180YYYYController.text.toString()+"/"+_IFA180MMController.text.toString()+"/"+_IFA180DDController.text.toString();
      }
    }

    if(_isIFA360View == true){
      if (_IFA360DDController.text.isNotEmpty) {
        _IFADatePost=_IFA360YYYYController.text.toString()+"/"+_IFA360MMController.text.toString()+"/"+_IFA360DDController.text.toString();
      }
    }

    if (_AlbadoseDDController.text.isNotEmpty) {
      _Tab_Alb_DatePost=_AlbadoseYYYYController.text.toString()+"/"+_AlbadoseMMController.text.toString()+"/"+_AlbadoseDDController.text.toString();
    }

    if (_CalciumVitaminD3DDController.text.isNotEmpty) {
      _cal_DatePost=_CalciumVitaminD3YYYYController.text.toString()+"/"+_CalciumVitaminD3MMController.text.toString()+"/"+_CalciumVitaminD3DDController.text.toString();
    }



    if(_isIronSukrojView == true){
      if(_sukroj1DDController.text.isNotEmpty){
        _Iron_sukroj_Post1=_sukroj1YYYYController.text.toString()+"/"+_sukroj1MMController.text.toString()+"/"+_sukroj1DDController.text.toString();
      }
      if(_sukroj2DDController.text.isNotEmpty){
        _Iron_sukroj_Post2=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
      }
      if(_sukroj3DDController.text.isNotEmpty){
        _Iron_sukroj_Post3=_sukroj3YYYYController.text.toString()+"/"+_sukroj3MMController.text.toString()+"/"+_sukroj3DDController.text.toString();
      }
      if(_sukroj4DDController.text.isNotEmpty){
        _Iron_sukroj_Post4=_sukroj4YYYYController.text.toString()+"/"+_sukroj4MMController.text.toString()+"/"+_sukroj4DDController.text.toString();
      }

    }
    if(_covidDDdateController.text.isNotEmpty){
      _covidDate=_covidYYYYdateController.text.toString()+"/"+_covidMMdateController.text.toString()+"/"+_covidDDdateController.text.toString();
    }

    String csv_value="";
    if(custom_high_pragnancy_cvslist.length > 0){
      for (int i = 0; i < custom_high_pragnancy_cvslist.length; i++) {
        csv_value=(csv_value.length>0? (csv_value+",") : csv_value) + (custom_high_pragnancy_cvslist[i].rishValue ?? " ");
      }
      print('final csv val ${csv_value}');
    }



    print('AddANCRequest=>'
        'ANCFlag:${widget.AncFlag+
        "ANCDate:"+_AncDatePost+
        "TT1:"+_TT1DatePost+
        "TT2:"+_TT2DatePost+
        "TTB:"+_TTBDatePost+
        "IFA:"+_IFADatePost+
        "HB:"+_animyaHBCountController.text.toString().trim()+
        "RTI:"+_RTI_YES_NO+
        "ashaAutoID:"+aashaId+
        "Weight:"+_weightKiloGramController.text.toString().trim()+
        "anganwariNo:"+aanganBadiId+
        "motherid:"+widget.motherIdIntent+
        "VillageAutoID:"+widget.VillageAutoID+
        "ALBE400:"+_Tab_Alb_DatePost+
        "CAL500:"+_cal_DatePost+
        "Media:"+_Media+
        "Height:"+_mahilaHeightController.text.toString().trim()+
        "LMPDate:"+widget.expected_date+
        "RegDate:"+widget.registered_date2+
        "LastANCDate:"+widget.anc_date+
        "ANCRegID:"+widget.AncRegId+
        "CompL="+","+csv_value+","+
        "ReferUnitCode="+_ReferUnitCode+
        "BloodPressureS="+_bloodpreshourSController.text.toString().trim()+
        "BloodPressureD="+_bloodpreshourDController.text.toString().trim()+
        "UrineA="+_apiUrineCodeA+
        "UrineS="+_apiUrineCodeS+
        "TreatmentCode="+_TreatMentCode+
        "Latitude:"+_latitude+
        "Longitude:"+_longitude+
        "AppVersion:"+"5.5.5.22"+//5.5.5.22 for testing
        "UpdateUserNo:"+_UpdateUserNo+
        "EntryUserNo:"+_UpdateUserNo+

        "NormalLodingIronSucrose1:"+_sukrojValue_Normal+
        "IronSucrose1:"+_Iron_sukroj_Post1+
        "IronSucrose2:"+_Iron_sukroj_Post2+
        "IronSucrose3:"+_Iron_sukroj_Post3+
        "IronSucrose4:"+_Iron_sukroj_Post4+

        "CovidCase:"+_iscovidCase+
        "CovidFromDate:"+_covidDate+
        "CovidForeignTrip:"+_CovidForeignTrip+
        "CovidRelativePossibility:"+_CovidRelativePossibility+
        "CovidRelativePositive:"+_CovidRelativePositive+
        "CovidQuarantine:"+_CovidQuarantine+
        "CovidIsolation:"+_CovidIsolation+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');
    var response = await put(Uri.parse(_update_post_anc_api), body: {
      "ANCFlag":widget.AncFlag,
      "ANCDate": _AncDatePost,
      "TT1": _TT1DatePost,
      "TT2": _TT2DatePost,
      "TTB": _TTBDatePost,
      "IFA": _IFADatePost,
      "HB": _animyaHBCountController.text.toString().trim(),
      "RTI": _RTI_YES_NO,// Done
      "ashaAutoID": aashaId,
      "Weight": _weightKiloGramController.text.toString().trim(),
      "anganwariNo": aanganBadiId,
      "motherid": widget.motherIdIntent,
      "VillageAutoID": widget.VillageAutoID,
      "ALBE400": _Tab_Alb_DatePost,
      "CAL500": _cal_DatePost,
      "Media": _Media,
      "Height":_mahilaHeightController.text.toString().trim(),
      "LMPDate": widget.expected_date,
      "RegDate":widget.registered_date2,
      "LastANCDate": widget.anc_date,
      "ANCRegID":widget.AncRegId,
      "CompL": ","+csv_value+",",//maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
      "ReferUnitCode": _ReferUnitCode,
      "BloodPressureS": _bloodpreshourSController.text.toString().trim(),
      "BloodPressureD": _bloodpreshourDController.text.toString().trim(),
      "UrineA": _apiUrineCodeA,
      "UrineS": _apiUrineCodeS,
      "TreatmentCode":_TreatMentCode,
      "NormalLodingIronSucrose1":_sukrojValue_Normal,
      "IronSucrose1": _Iron_sukroj_Post1,
      "IronSucrose2": _Iron_sukroj_Post2,
      "IronSucrose3": _Iron_sukroj_Post3,
      "IronSucrose4": _Iron_sukroj_Post4,
     // "Latitude": _latitude,
     // "Longitude":_longitude,
      //"AppVersion": packageInfo.version,
      "AppVersion":"5.5.5.22",
      "UpdateUserNo":_UpdateUserNo,
      "EntryUserNo": _UpdateUserNo,
      "CovidCase":_iscovidCase,
      "CovidFromDate": _covidDate,
      "CovidForeignTrip":_CovidForeignTrip,
      "CovidRelativePossibility": _CovidRelativePossibility,
      "CovidRelativePositive": _CovidRelativePositive,
      "CovidQuarantine": _CovidQuarantine,
      "CovidIsolation": _CovidIsolation,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SavedANCDetailsData.fromJson(resBody);
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
    print('response-status:${apiResponse.status}');
    print('response-message:${apiResponse.message}');
    print('response-appVersion:${apiResponse.appVersion}');
    return SavedANCDetailsData.fromJson(resBody);
  }
  /*
    * IF HIGH RISK UNCHECKED
  */
  Future<SavedANCDetailsData> postRequestWithoutRisk() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    if(preferences.getString("AppRoleID") == "33"){
      _Media="2";
      _UpdateUserNo=preferences.getString("ANMAutoID").toString();
    }else{
      _Media="1";
      _UpdateUserNo=preferences.getString("UserNo").toString();
    }

    if(_latitude == "0.0" || _longitude == "0.0"){
      _getLocation();
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('pkg_version: ${packageInfo.version}');


    if(_isTT1Selected == true){
      if (_TT1DDController.text.isNotEmpty) {
        _TT1DatePost=_TT1YYYYController.text.toString()+"/"+_TT1MMController.text.toString()+"/"+_TT1DDController.text.toString();
      }
    }

    if(_isTT2Selected == true){
      if (_TT2DDController.text.isNotEmpty) {
        _TT2DatePost=_TT2YYYYController.text.toString()+"/"+_TT2MMController.text.toString()+"/"+_TT2DDController.text.toString();
      }
    }

    if(_isTTBSelected == true){
      if (_TTBDDController.text.isNotEmpty) {
        _TTBDatePost=_TTBYYYYController.text.toString()+"/"+_TTBMMController.text.toString()+"/"+_TTBDDController.text.toString();
      }
    }


    if(_isIFA180View == true){
      if (_IFA180DDController.text.isNotEmpty) {
        _IFADatePost=_IFA180YYYYController.text.toString()+"/"+_IFA180MMController.text.toString()+"/"+_IFA180DDController.text.toString();
      }
    }

    if(_isIFA360View == true){
      if (_IFA360DDController.text.isNotEmpty) {
        _IFADatePost=_IFA360YYYYController.text.toString()+"/"+_IFA360MMController.text.toString()+"/"+_IFA360DDController.text.toString();
      }
    }

    if (_AlbadoseDDController.text.isNotEmpty) {
      _Tab_Alb_DatePost=_AlbadoseYYYYController.text.toString()+"/"+_AlbadoseMMController.text.toString()+"/"+_AlbadoseDDController.text.toString();
    }

    if (_CalciumVitaminD3DDController.text.isNotEmpty) {
      _cal_DatePost=_CalciumVitaminD3YYYYController.text.toString()+"/"+_CalciumVitaminD3MMController.text.toString()+"/"+_CalciumVitaminD3DDController.text.toString();
    }

    if(_isIronSukrojView == true){
      if(_sukroj1DDController.text.isNotEmpty){
        _Iron_sukroj_Post1=_sukroj1YYYYController.text.toString()+"/"+_sukroj1MMController.text.toString()+"/"+_sukroj1DDController.text.toString();
      }
      if(_sukroj2DDController.text.isNotEmpty){
        _Iron_sukroj_Post2=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
      }
      if(_sukroj3DDController.text.isNotEmpty){
        _Iron_sukroj_Post3=_sukroj3YYYYController.text.toString()+"/"+_sukroj3MMController.text.toString()+"/"+_sukroj3DDController.text.toString();
      }
      if(_sukroj4DDController.text.isNotEmpty){
        _Iron_sukroj_Post4=_sukroj4YYYYController.text.toString()+"/"+_sukroj4MMController.text.toString()+"/"+_sukroj4DDController.text.toString();
      }

    }
    if(_covidDDdateController.text.isNotEmpty){
      _covidDate=_covidYYYYdateController.text.toString()+"/"+_covidMMdateController.text.toString()+"/"+_covidDDdateController.text.toString();
    }
    if(_ancYYYYdateController.text.isNotEmpty && _ancMMdateController.text.isNotEmpty && _ancDDdateController.text.isNotEmpty){
      _AncDatePost=_ancYYYYdateController.text.toString()+"/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
    }

    print('AddANCRequest=>'
        'ANCFlag:${widget.AncFlag+
        "ANCDate:"+_AncDatePost+
        "TT1:"+_TT1DatePost+
        "TT2:"+_TT2DatePost+
        "TTB:"+_TTBDatePost+
        "IFA:"+_IFADatePost+
        "HB:"+_animyaHBCountController.text.toString().trim()+
        "RTI:"+_RTI_YES_NO+
        "ashaAutoID:"+aashaId+
        "Weight:"+_weightKiloGramController.text.toString().trim()+
        "anganwariNo:"+aanganBadiId+
        "motherid:"+widget.motherIdIntent+
        "VillageAutoID:"+widget.VillageAutoID+
        "ALBE400:"+_Tab_Alb_DatePost+
        "CAL500:"+_cal_DatePost+
        "Media:"+_Media+
        "Height:"+_mahilaHeightController.text.toString().trim()+
        "LMPDate:"+widget.expected_date+
        "RegDate:"+widget.registered_date2+
        "LastANCDate:"+widget.anc_date+
        "ANCRegID:"+widget.AncRegId+

        "Latitude:"+_latitude+
        "Longitude:"+_longitude+
       // "AppVersion:"+packageInfo.version+//uncomment for live
        "AppVersion:"+"5.5.5.22"+//5.5.5.22 for testing
        "UpdateUserNo:"+_UpdateUserNo+
        "EntryUserNo:"+_UpdateUserNo+
        "NormalLodingIronSucrose1:"+_sukrojValue_Normal+
        "IronSucrose1:"+_Iron_sukroj_Post1+
        "IronSucrose2:"+_Iron_sukroj_Post2+
        "IronSucrose3:"+_Iron_sukroj_Post3+
        "IronSucrose4:"+_Iron_sukroj_Post4+
        "CovidCase:"+_iscovidCase+
        "CovidFromDate:"+_covidDate+
        "CovidForeignTrip:"+_CovidForeignTrip+
        "CovidRelativePossibility:"+_CovidRelativePossibility+
        "CovidRelativePositive:"+_CovidRelativePositive+
        "CovidQuarantine:"+_CovidQuarantine+
        "CovidIsolation:"+_CovidIsolation+
        "TokenNo:"+preferences.getString('Token').toString()+
        "UserID:"+preferences.getString('UserId').toString()
    }');
    var response = await put(Uri.parse(_update_post_anc_api), body: {
      "ANCFlag": widget.AncFlag,
      "ANCDate": _AncDatePost,
      "TT1": _TT1DatePost,
      "TT2": _TT2DatePost,
      "TTB": _TTBDatePost,
      "IFA": _IFADatePost,
      "HB": _animyaHBCountController.text.toString().trim(),
      "RTI": _RTI_YES_NO,
      "ashaAutoID": aashaId,
      "Weight": _weightKiloGramController.text.toString().trim(),
      "anganwariNo": aanganBadiId,
      "motherid": widget.motherIdIntent,
      "VillageAutoID": widget.VillageAutoID,
      "ALBE400": _Tab_Alb_DatePost,
      "CAL500": _cal_DatePost,
      "Media": _Media,
      "Height":_mahilaHeightController.text.toString().trim(),
      "LMPDate": widget.expected_date,
      "RegDate":widget.registered_date2,
      "LastANCDate": widget.anc_date,
      "ANCRegID":widget.AncRegId,
      "NormalLodingIronSucrose1":_sukrojValue_Normal,
      "IronSucrose1": _Iron_sukroj_Post1,
      "IronSucrose2": _Iron_sukroj_Post2,
      "IronSucrose3": _Iron_sukroj_Post3,
      "IronSucrose4": _Iron_sukroj_Post4,
      "Latitude": _latitude,
      "Longitude":_longitude,
      "AppVersion":"5.5.5.22",
      "UpdateUserNo":_UpdateUserNo,
      "EntryUserNo": _UpdateUserNo,
      "CovidCase":_iscovidCase,
      "CovidFromDate": _covidDate,
      "CovidForeignTrip":_CovidForeignTrip,
      "CovidRelativePossibility": _CovidRelativePossibility,
      "CovidRelativePositive": _CovidRelativePositive,
      "CovidQuarantine": _CovidQuarantine,
      "CovidIsolation": _CovidIsolation,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SavedANCDetailsData.fromJson(resBody);
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
    print('response-status:${apiResponse.status}');
    print('response-message:${apiResponse.message}');
    print('response-appVersion:${apiResponse.appVersion}');
    return SavedANCDetailsData.fromJson(resBody);
  }

  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }

  Future<TreatmentListData> getTreatmentListAPI() async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    preferences = await SharedPreferences.getInstance();
    var response = await get(Uri.parse(_treatmentcode_list_url));
    var resBody = json.decode(response.body);
    final apiResponse = TreatmentListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        custom_treatment_list.clear();
        //treatment_code_list=apiResponse.resposeData!.cast<TreatmentListData>();
        //print('treat.len ${treatment_code_list.length}');
        custom_treatment_list
            .add(CustomTreatmentCodeList(code: Strings.choose));
        for (int i = 0; i < apiResponse.resposeData!.length; i++) {
          custom_treatment_list.add(CustomTreatmentCodeList(
              code: apiResponse.resposeData![i].name.toString()));
        }
        _selectedTreatmentCode = custom_treatment_list[0].code.toString();
        print('_selectedTreatmentCode ${_selectedTreatmentCode}');
        print('treat.len ${custom_treatment_list.length}');
        //_showHideHighRiskView = true;

        if(widget.TreatmentCode.isNotEmpty){
          setState(() {
            for (int i = 0; i < custom_treatment_list.length; i++){
              if(widget.TreatmentCode == "0"){
                _TreatMentCode="0";
                _selectedTreatmentCode = custom_treatment_list[0].code.toString();
                break;
              }else if(widget.TreatmentCode == "1"){
                _TreatMentCode="1";
                _selectedTreatmentCode = custom_treatment_list[1].code.toString();
                break;
              }else if(widget.TreatmentCode == "2"){
                _TreatMentCode="2";
                _selectedTreatmentCode = custom_treatment_list[2].code.toString();
                break;
              }else if(widget.TreatmentCode == "3"){
                _TreatMentCode="3";
                _selectedTreatmentCode = custom_treatment_list[3].code.toString();
                break;
              }else if(widget.TreatmentCode == "4"){
                _TreatMentCode="4";
                _selectedTreatmentCode = custom_treatment_list[4].code.toString();
                break;
              }else{
                _TreatMentCode="";
                break;
              }
            }
            print('last TreatMntCode pos: $_selectedTreatmentCode');
          });
        }
      } else {
        custom_treatment_list.clear();
        print('treat.len ${custom_treatment_list.length}');
        //_showHideHighRiskView = false;
      }
     // EasyLoading.dismiss();
    });
    print('treat_response:${apiResponse.message}');
    return TreatmentListData.fromJson(resBody);
  }

  Future<GetDistrictListData> getDistrictListAPI(String refUnitType) async {
    /*await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );*/
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_district_list_url), body: {
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
        custom_district_list.add(CustomDistrictCodeList(unitcode: "0", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_district_list.length; i++) {
          custom_district_list.add(CustomDistrictCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedDistrictUnitCode = custom_district_list[0].unitcode.toString();
        print('_selectedDistrictUnitCode ${_selectedDistrictUnitCode}');
        print('disctict.len ${custom_district_list.length}');
        if(widget.ReferDistrictCode.isNotEmpty){
          setState(() {
            for (int i = 0; i < response_district_list.length; i++) {
              if(widget.ReferDistrictCode == resBody['ResposeData'][i]['unitcode']){
                print('insideForLoop ${resBody['ResposeData'][i]['unitcode']}');
                _selectedDistrictUnitCode = resBody['ResposeData'][i]['unitcode'].toString();
                print('_selectedDistrictUnitCodeafter ${_selectedDistrictUnitCode}');
                getBlockListAPI(_selectedPlacesReferCode,_selectedDistrictUnitCode.substring(0, 4));
                break;
              }
            }
          });
        }
      } else {
        custom_district_list.clear();
        print('disctict.len ${custom_district_list.length}');
      }

   //   EasyLoading.dismiss();
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
        print('_selectedBlockUnitCode ${_selectedBlockUnitCode}');
        print('block.len ${custom_block_list.length}');
        if(widget.ReferUniName.isNotEmpty){
          setState(() {
            for (int i = 0; i < response_block_list.length; i++) {
              if(widget.ReferUniName == resBody['ResposeData'][i]['unitNameHindi']){
                print('insideForLoop ${resBody['ResposeData'][i]['unitNameHindi']}');
                _selectedBlockUnitCode = resBody['ResposeData'][i]['unitcode'].toString();
                print('_selectedBlockUnitCodeater ${_selectedBlockUnitCode}');
                _ReferUnitCode=_selectedBlockUnitCode;
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


  bool _showHideANCView = false;
  bool _showHideMahilaHeightView = false;
  bool _showHideCovidView = false;
  bool _showHideHighRiskView = false;
  bool _highRiskChecked = false;



  bool _highRiskEnDisableCB = true;
  bool _HighAnaimiyaEnDisableCB = true;
  bool _HighbloodpresourEnDisableCB = true;
  bool _ChotakadEnDisableCB = true;
  bool _AgeEnDisableCB = true;
  bool _PurvJatilEnDisableCB = true;
  bool _APHEnDisableCB = true;
  bool _TransverselieEnDisableCB = true;
  bool _MadhumayeEnDisableCB = true;
  bool _HeartRogEnDisableCB = true;
  bool _GurdaRogEnDisableCB = true;
  bool _OtherEnDisableCB = true;
  bool _MalairiyaEnDisableCB = true;

  //High Pragnancy Code checkbox listing
  List<CustomHighRiskPragnancyList> custom_high_pragnancy_cvslist = [];
  bool _highAnaimiyaCheckb = false;
  bool _highbloodpresourCheckb = false;
  bool _ageCheckb = false;
  bool _chotakadCheckb = false;
  bool _purvJatilPrastutiCheckb = false;
  bool _APHCheckb = false;
  bool _transverselieCheckb = false;
  bool _madhumayeCheckb = false;
  bool _heartRogCheckb = false;
  bool _gurdaRogCheckb = false;
  bool _otherCheckb = false;
  bool _malairiyaCheckb = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
    getAashaListAPI();
    addPlacesReferList();
    getDistrictListAPI("3");
    setPreviousData();
    getTreatmentListAPI();

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
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  var _selectedUrineRange_A = "चुनें";
  var _selectedUrineRange_S = "चुनें";
  List<CustomUrineRangeList> urine_range_list = [
    CustomUrineRangeList(
      range: "चुनें",
    ),
    CustomUrineRangeList(
      range: "+",
    ),
    CustomUrineRangeList(
      range: "+ +",
    ),
    CustomUrineRangeList(
      range: "+ + +",
    ),
    CustomUrineRangeList(
      range: "+ + + +",
    ),
    CustomUrineRangeList(
      range: "+ + + + +",
    )
  ];
  bool cbHightRiskFlag = false;
  var _customANCDate="";
  @override
  Widget build(BuildContext context) {
    print('ANCFlag ${widget.AncFlag}');
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
            Text(widget.headerName,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(widget.pctsID,
                style: TextStyle(color: Colors.white, fontSize: 12)),
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
        child: Stack(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
                                    if (aashaId != "0"){
                                      getAanganBadiListAPI(aashaId);
                                    }
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
                        Strings.aanganbadi_chunai,
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
                                items: custom_aanganbadi_list.map((item) {
                                  return DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          new Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              item.NameH.toString(),
                                              //Names that the api dropdown contains
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                      value: item.AnganwariNo
                                          .toString() //Id that has to be passed that the dropdown has.....
                                      //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                      );
                                }).toList(),
                                onChanged: (String? newVal) {
                                  setState(() {
                                    aanganBadiId = newVal!;
                                    print('aanganBadiId:$aanganBadiId');
                                  });
                                },
                                value:
                                    aanganBadiId, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Visibility(
                      visible: _showHideMahilaHeightView,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: RichText(
                                  text: TextSpan(
                                      text: Strings.mahila_ki_height_in_cm,
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
                                          enabled: _mahilaHeightEnabledDisabled,
                                          style: TextStyle(color: Colors.black),
                                          maxLength: 4,
                                          keyboardType: TextInputType.number,
                                          controller: _mahilaHeightController,
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
                                            getHBHeightCheck(_animyaHBCountController.text.toString().trim(),text);
                                          },
                                        ))))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: RichText(
                            text: TextSpan(
                                text: Strings.animiya,
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
                                          if(double.parse(_hbCount) <= 7.0){
                                            _showErrorPopup(Strings.hb_error,ColorConstants.error_color);
                                          }else if(double.parse(_hbCount) > 7.0 && double.parse(_hbCount) <= 11.0){
                                            _showErrorPopup(Strings.hb_error2,ColorConstants.warning_color);
                                          }else if(double.parse(_hbCount) > 11.0){
                                            _showErrorPopup(Strings.hb_error3,ColorConstants.success_color);
                                          }
                                        }
                                      },child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    controller: _animyaHBCountController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ColorConstants.transparent,
                                        counterText: ''
                                    ),
                                    onChanged: (text) {
                                      _hbCount=text.trim();
                                      print('_hbCount $text');
                                      getHBHeightCheck(text,_mahilaHeightController.text.toString().trim());
                                    },
                                  ))))
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
                                text: Strings.weight_kilograa,
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
                                          print('on focus');
                                        }else{
                                          print('out focus');
                                          final final_weight=double.parse(_weightKiloGramController.text.toString()) - double.parse(widget.weight);
                                          print('last weight : ${widget.weight}');//45
                                          print('final_weight ${final_weight}');//60-45=15
                                          if(double.parse(widget.weight).toString() != "0.0"){
                                            print('final_diff_dates ${final_diff_dates}');//60-45=15
                                            if(final_diff_dates <= 14){
                                              double grouthWeight = final_weight + double.parse("0.14");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.14) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 28){
                                              double grouthWeight = final_weight + double.parse("0.28");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.28) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 42){
                                              double grouthWeight = final_weight + double.parse("0.42");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.42) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 56){
                                              double grouthWeight = final_weight + double.parse("0.56");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.56) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 70){
                                              double grouthWeight = final_weight + double.parse("0.70");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.70) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 84){
                                              double grouthWeight = final_weight + double.parse("0.84");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.84) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 98){
                                              double grouthWeight = final_weight + double.parse("0.98");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 0.98) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 112){
                                              double grouthWeight = final_weight + double.parse("1.84");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 1.84) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 126){
                                              double grouthWeight = final_weight + double.parse("1.26");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 1.26) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 140){
                                              double grouthWeight = final_weight + double.parse("3.04");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 3.04) {
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 154){
                                              double grouthWeight = final_weight + double.parse("3.74");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 3.74) {
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 168){
                                              double grouthWeight = final_weight + double.parse("4.44");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 4.44) {
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 182){
                                              double grouthWeight = final_weight + double.parse("5.14");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 5.14) {
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 196){
                                              double grouthWeight = final_weight + double.parse("5.84");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 5.84) {
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 210){
                                              double grouthWeight = final_weight + double.parse("6.54");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 6.54) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 224) {
                                              double grouthWeight = final_weight +
                                                  double.parse("7.24");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 7.24) {
                                                _showWeightPopup(
                                                    Strings.weight_msg_green,
                                                    ColorConstants.error_color,
                                                    final_weight.toString(),
                                                    grouthWeight.toString());
                                              } else {
                                                _showWeightPopup(
                                                    Strings.weight_msg_green,
                                                    ColorConstants.success_color,
                                                    final_weight.toString(),
                                                    grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 238){
                                              double grouthWeight = final_weight + double.parse("7.94");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 7.94) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 252){
                                              double grouthWeight = final_weight + double.parse("8.64");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 8.64) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 266){
                                              double grouthWeight = final_weight + double.parse("9.34");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 9.34) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }else if(final_diff_dates <= 280){
                                              double grouthWeight = final_weight + double.parse("10.04");
                                              print('grouthWeight ${grouthWeight}');
                                              if (final_weight < 10.04) {

                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.error_color,final_weight.toString(),grouthWeight.toString());
                                              }else{
                                                _showWeightPopup(Strings.weight_msg_green,ColorConstants.success_color,final_weight.toString(),grouthWeight.toString());
                                              }
                                            }

                                          }else{
                                            //do nothing
                                          }
                                        }
                                      },
                                    child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    controller: _weightKiloGramController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ColorConstants.transparent,
                                        counterText: ''
                                    ),
                                    onChanged: (text) {

                                    },
                                  ))))
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.all(3),

                      /// height: 100,
                      child: Column(
                        children: <Widget>[
                          //ANC Layout (this layout will show only Edit time)
                          Visibility(
                            visible: _showHideANCView,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                            text: Strings.anc_ki_tithi,
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
                                    width: 136,
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
                                                controller: _ancDDdateController,
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
                                                    if(_ancDDdateController.text.toString().length == 2 && _ancMMdateController.text.toString().length == 2 && _ancYYYYdateController.text.toString().length == 4){
                                                      //2022-12-06 00:00:00.000
                                                      //_customANCDate=_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()+" 00:00:00.000";
                                                      //print('customANCDate $_customANCDate');
                                                      //_selectCustomANCDatePopup(_customANCDate);
                                                      if(checkCovidCase("2020-03-01")){
                                                        _showCovid19View(true);
                                                      }else{
                                                        _showCovid19View(false);
                                                      }
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
                                                controller: _ancMMdateController,
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
                                                    if(_ancDDdateController.text.toString().length == 2 && _ancMMdateController.text.toString().length == 2 && _ancYYYYdateController.text.toString().length == 4){
                                                      //2022-12-06 00:00:00.000
                                                      //_customANCDate=_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()+" 00:00:00.000";
                                                      //print('customANCDate $_customANCDate');
                                                      //_selectCustomANCDatePopup(_customANCDate);
                                                      if(checkCovidCase("2020-03-01")){
                                                        _showCovid19View(true);
                                                      }else{
                                                        _showCovid19View(false);
                                                      }
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
                                                controller: _ancYYYYdateController,
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
                                                    if(_ancDDdateController.text.toString().length == 2 && _ancMMdateController.text.toString().length == 2 && _ancYYYYdateController.text.toString().length == 4){
                                                      //2022-12-06 00:00:00.000
                                                      //_customANCDate=_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()+" 00:00:00.000";
                                                      //print('customANCDate $_customANCDate');
                                                      //_selectCustomANCDatePopup(_customANCDate);
                                                      if(checkCovidCase("2020-03-01")){
                                                        _showCovid19View(true);
                                                      }else{
                                                        _showCovid19View(false);
                                                      }
                                                    }
                                                  }
                                              ),

                                            ))
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _selectANCDatePopup(int.parse(_ancYYYYdateController.text.toString()),int.parse(_ancMMdateController.text.toString()) ,int.parse(_ancDDdateController.text.toString()));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/calendar_icon.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 15, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //TT1 layout
                          Visibility(
                              visible: _isTT1Selected,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            Strings.tt1_ki_tithi,
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 13),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.black)),
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
                                                    controller: _TT1DDController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
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
                                                    controller: _TT1MMController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor:Colors.transparent,
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
                                                    controller: _TT1YYYYController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
                                                        contentPadding: EdgeInsets.zero,
                                                        hintText: ' yyyy',
                                                        counterText: ''),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _selectTT1DatePopup(int.parse(_TT1YYYYController.text.toString()),int.parse(_TT1MMController.text.toString()) ,int.parse(_TT1DDController.text.toString()));
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/calendar_icon.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_TT1DDController.text.isNotEmpty) {
                                          _TT1DDController.text = "";
                                        } else if (_TT1MMController
                                            .text.isNotEmpty) {
                                          _TT1MMController.text = "";
                                        } else if (_TT1YYYYController
                                            .text.isNotEmpty) {
                                          _TT1YYYYController.text = "";
                                          if((_TT1DDController.text.isEmpty && _TT2DDController.text.isEmpty) && (_TT1MMController.text.isEmpty && _TT2MMController.text.isEmpty) && (_TT1YYYYController.text.isEmpty && _TT2YYYYController.text.isEmpty)){
                                            _isTTBSelectedToggle(true);
                                          }
                                        }
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/cancel_icon_dra.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                          ),
                          //TT2 layout
                          Visibility(
                              visible: _isTT2Selected,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            Strings.tt2_ki_tithi,
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 13),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.black)),
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
                                                    controller: _TT2DDController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
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
                                                    controller: _TT2MMController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor:Colors.transparent,
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
                                                    controller: _TT2YYYYController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
                                                        contentPadding: EdgeInsets.zero,
                                                        hintText: ' yyyy',
                                                        counterText: ''),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _selectTT2DatePopup(int.parse(_TT2YYYYController.text.toString()),int.parse(_TT2MMController.text.toString()) ,int.parse(_TT2DDController.text.toString()));
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/calendar_icon.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_TT2DDController.text.isNotEmpty) {
                                          _TT2DDController.text = "";
                                        } else if (_TT2MMController
                                            .text.isNotEmpty) {
                                          _TT2MMController.text = "";
                                        } else if (_TT2YYYYController
                                            .text.isNotEmpty) {
                                          _TT2YYYYController.text = "";
                                          if((_TT1DDController.text.isEmpty && _TT2DDController.text.isEmpty) && (_TT1MMController.text.isEmpty && _TT2MMController.text.isEmpty) && (_TT1YYYYController.text.isEmpty && _TT2YYYYController.text.isEmpty)){
                                            _isTTBSelectedToggle(true);
                                          }
                                        }
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/cancel_icon_dra.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                          ),
                          //TTB layout
                          Visibility(
                              visible: _isTTBSelected,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            Strings.ttb_ki_tithi,
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 13),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.black)),
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
                                                    controller: _TTBDDController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
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
                                                    controller: _TTBMMController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
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
                                                    controller: _TTBYYYYController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
                                                        contentPadding: EdgeInsets.zero,
                                                        hintText: ' yyyy',
                                                        counterText: ''),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        _selectTTBDatePopup(int.parse(_TTBYYYYController.text.toString()),int.parse(_TTBMMController.text.toString()) ,int.parse(_TTBDDController.text.toString()));
                                        },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/calendar_icon.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_TTBDDController.text.isNotEmpty) {
                                          _TTBDDController.text = "";
                                        } else if (_TTBMMController
                                            .text.isNotEmpty) {
                                          _TTBMMController.text = "";
                                        } else if (_TTBYYYYController
                                            .text.isNotEmpty) {
                                          _TTBYYYYController.text = "";

                                          if((_TTBDDController.text.isEmpty && _TTBMMController.text.isEmpty && _TTBYYYYController.text.isEmpty)){
                                            _isTT1SelectedToggle(true);
                                            _isTT2SelectedToggle(true);
                                          }
                                        }
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/cancel_icon_dra.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                          ),
                          //IFA180 layout
                          Visibility(
                              visible: _isIFA180View,
                              child: GestureDetector(
                              onTap: (){
                                _selectIFA180DatePopup(int.parse(_IFA180YYYYController.text.toString()),int.parse(_IFA180MMController.text.toString()) ,int.parse(_IFA180DDController.text.toString()));

                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            Strings.ifa180_ki_tithi,
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 13),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                            Border.all(color: Colors.black)),
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
                                                    controller: _IFA180DDController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
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
                                                    controller: _IFA180MMController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
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
                                                    controller: _IFA180YYYYController,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13),
                                                    textAlignVertical:
                                                    TextAlignVertical.center,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide.none,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    0))),
                                                        fillColor: Colors.transparent,
                                                        contentPadding: EdgeInsets.zero,
                                                        hintText: ' yyyy',
                                                        counterText: ''),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/calendar_icon.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        if (_IFA180DDController.text.isNotEmpty) {
                                          _IFA180DDController.text = "";
                                        } else if (_IFA180MMController
                                            .text.isNotEmpty) {
                                          _IFA180MMController.text = "";
                                        } else if (_IFA180YYYYController
                                            .text.isNotEmpty) {
                                          _IFA180YYYYController.text = "";
                                        }
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/cancel_icon_dra.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //IFA360 layout
                          Visibility(
                              visible: _isIFA360View,
                              child: GestureDetector(
                                onTap: (){
                                  _selectIFA360DatePopup(int.parse(_IFA360YYYYController.text.toString()),int.parse(_IFA360MMController.text.toString()) ,int.parse(_IFA360DDController.text.toString()));
                                },
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              Strings.ifa360_ki_tithi,
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 13),
                                            ),
                                          )),
                                      Expanded(
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border:
                                              Border.all(color: Colors.black)),
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
                                                      controller: _IFA360DDController,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 13),
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      0))),
                                                          fillColor: Colors.transparent,
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
                                                      controller: _IFA360MMController,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 13),
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      0))),
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
                                                      controller: _IFA360YYYYController,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 13),
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          border: OutlineInputBorder(
                                                              borderSide: BorderSide.none,
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      0))),
                                                          fillColor:Colors.transparent,
                                                          contentPadding: EdgeInsets.zero,
                                                          hintText: ' yyyy',
                                                          counterText: ''),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/calendar_icon.png",
                                            width: 20,
                                            height: 20,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (_IFA360DDController.text.isNotEmpty) {
                                            _IFA360DDController.text = "";
                                          } else if (_IFA360MMController
                                              .text.isNotEmpty) {
                                            _IFA360MMController.text = "";
                                          } else if (_IFA360YYYYController
                                              .text.isNotEmpty) {
                                            _IFA360YYYYController.text = "";
                                          }
                                        },
                                        child: Container(
                                            margin:
                                            EdgeInsets.only(right: 20, left: 10),
                                            child: Image.asset(
                                              "Images/cancel_icon_dra.png",
                                              width: 20,
                                              height: 20,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ),
                          //Albedose layout
                          GestureDetector(
                            onTap: (){
                              _selectAlbaDoseDatePopup(int.parse(_AlbadoseYYYYController.text.toString()),int.parse(_AlbadoseMMController.text.toString()) ,int.parse(_AlbadoseDDController.text.toString()));

                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.albadoja_ki_tithi,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller: _AlbadoseDDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
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
                                                  controller: _AlbadoseMMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
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
                                                  controller: _AlbadoseYYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin:
                                      EdgeInsets.only(right: 20, left: 10),
                                      child: Image.asset(
                                        "Images/calendar_icon.png",
                                        width: 20,
                                        height: 20,
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      if (_AlbadoseDDController.text.isNotEmpty) {
                                        _AlbadoseDDController.text = "";
                                      } else if (_AlbadoseMMController
                                          .text.isNotEmpty) {
                                        _AlbadoseMMController.text = "";
                                      } else if (_AlbadoseYYYYController
                                          .text.isNotEmpty) {
                                        _AlbadoseYYYYController.text = "";
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //Calcium Vitamin D layout
                          GestureDetector(
                            onTap: (){
                              _selectCalciumVitaminDDatePopup(int.parse(_CalciumVitaminD3YYYYController.text.toString()),int.parse(_CalciumVitaminD3MMController.text.toString()) ,int.parse(_CalciumVitaminD3DDController.text.toString()));

                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.calcium_or_vitaminD3_ki_tithi,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller:
                                                  _CalciumVitaminD3DDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
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
                                                  controller:
                                                  _CalciumVitaminD3MMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor:Colors.transparent,
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
                                                  controller:
                                                  _CalciumVitaminD3YYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin:
                                      EdgeInsets.only(right: 20, left: 10),
                                      child: Image.asset(
                                        "Images/calendar_icon.png",
                                        width: 20,
                                        height: 20,
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      if (_CalciumVitaminD3DDController
                                          .text.isNotEmpty) {
                                        _CalciumVitaminD3DDController.text = "";
                                      } else if (_CalciumVitaminD3MMController
                                          .text.isNotEmpty) {
                                        _CalciumVitaminD3MMController.text = "";
                                      } else if (_CalciumVitaminD3YYYYController
                                          .text.isNotEmpty) {
                                        _CalciumVitaminD3YYYYController.text = "";
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    /*
                      *  SUkROJ View
                    */
                    Visibility(
                      visible: _isIronSukrojView,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.all(3),
                        child: Column(
                          children: <Widget>[
                            //Sukroj 1 layout
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.iron_sukroj_1,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller: _sukroj1DDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor:Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' dd',
                                                      counterText: ''),
                                                  onChanged: (value){
                                                    print('value $value');
                                                    if(_sukroj1DDController.text.toString().length == 2 && _sukroj1MMController.text.toString().length == 2 && _sukroj1YYYYController.text.toString().length == 4){
                                                      _selectSukrojDatePopupCustom(_sukroj1YYYYController.text.toString()+"-"+_sukroj1MMController.text.toString()+"-"+_sukroj1DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj1MMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor:Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' mm',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj1DDController.text.toString().length == 2 && _sukroj1MMController.text.toString().length == 2 && _sukroj1YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopupCustom(_sukroj1YYYYController.text.toString()+"-"+_sukroj1MMController.text.toString()+"-"+_sukroj1DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj1YYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj1DDController.text.toString().length == 2 && _sukroj1MMController.text.toString().length == 2 && _sukroj1YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopupCustom(_sukroj1YYYYController.text.toString()+"-"+_sukroj1MMController.text.toString()+"-"+_sukroj1DDController.text.toString()+" 00:00:00.000");
                                                      }
                                                    }
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _selectSukrojDatePopup(int.parse(_sukroj1YYYYController.text.toString()),int.parse(_sukroj1MMController.text.toString()) ,int.parse(_sukroj1DDController.text.toString()));
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/calendar_icon.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_sukroj1DDController.text.isNotEmpty) {
                                        _sukroj1DDController.text = "";
                                      } else if (_sukroj1MMController
                                          .text.isNotEmpty) {
                                        _sukroj1MMController.text = "";
                                      } else if (_sukroj1YYYYController
                                          .text.isNotEmpty) {
                                        _sukroj1YYYYController.text = "";
                                        _Iron_sukroj_Post1="";
                                        _sukrojValue_Normal="";
                                        setState(() {
                                          _IronSukrojChoose = IronSukrojChoose.none;
                                        });
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
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
                                      child: Container(
                                        height: 36,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                    height: 20,
                                                    //Make it equal to height of radio button
                                                    width: 10,
                                                    //Make it equal to width of radio button
                                                    child: Row(
                                                      children: [
                                                        Radio<IronSukrojChoose>(
                                                          toggleable: true,
                                                          activeColor: Colors.black,
                                                          value: IronSukrojChoose.normal,
                                                          groupValue: _IronSukrojChoose,
                                                            onChanged: (IronSukrojChoose? value) {
                                                              setState(() {
                                                                _sukrojValue_Normal="1";
                                                                _IronSukrojChoose=value!;
                                                                print('select $_IronSukrojChoose');
                                                              });
                                                            },
                                                        ),
                                                        Text(
                                                          Strings.normal_mg,
                                                          style: TextStyle(fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Container(
                                                    height: 20,
                                                    //Make it equal to height of radio button
                                                    width: 10,
                                                    //Make it equal to width of radio button
                                                    child: Row(
                                                      children: [
                                                        Radio<IronSukrojChoose>(
                                                          toggleable: false,
                                                          activeColor: Colors.black,
                                                          value: IronSukrojChoose.loading,
                                                          groupValue: _IronSukrojChoose,
                                                          onChanged: (IronSukrojChoose? value) {
                                                            setState(() {
                                                              _sukrojValue_Normal="2";
                                                              _IronSukrojChoose=value!;
                                                              print('select $_IronSukrojChoose');
                                                            });
                                                          },
                                                        ),
                                                        Text(Strings.loading_mg,
                                                            style: TextStyle(fontSize: 13))
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

                            //Sukroj 2 layout
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.iron_sukroj_2,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller: _sukroj2DDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' dd',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj2DDController.text.toString().length == 2 && _sukroj2MMController.text.toString().length == 2 && _sukroj2YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup2Custom(_sukroj2YYYYController.text.toString()+"-"+_sukroj2MMController.text.toString()+"-"+_sukroj2DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj2MMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor:Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' mm',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj2DDController.text.toString().length == 2 && _sukroj2MMController.text.toString().length == 2 && _sukroj2YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup2Custom(_sukroj2YYYYController.text.toString()+"-"+_sukroj2MMController.text.toString()+"-"+_sukroj2DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj2YYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj2DDController.text.toString().length == 2 && _sukroj2MMController.text.toString().length == 2 && _sukroj2YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup2Custom(_sukroj2YYYYController.text.toString()+"-"+_sukroj2MMController.text.toString()+"-"+_sukroj2DDController.text.toString()+" 00:00:00.000");
                                                      }
                                                    }
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _selectSukrojDatePopup2(int.parse(_sukroj2YYYYController.text.toString()),int.parse(_sukroj2MMController.text.toString()) ,int.parse(_sukroj2DDController.text.toString()));
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/calendar_icon.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_sukroj2DDController.text.isNotEmpty) {
                                        _sukroj2DDController.text = "";
                                      } else if (_sukroj2MMController
                                          .text.isNotEmpty) {
                                        _sukroj2MMController.text = "";
                                      } else if (_sukroj2YYYYController
                                          .text.isNotEmpty) {
                                        _sukroj2YYYYController.text = "";
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            //Sukroj 3layout
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.iron_sukroj_3,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller: _sukroj3DDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' dd',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj3DDController.text.toString().length == 2 && _sukroj3MMController.text.toString().length == 2 && _sukroj3YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup3Custom(_sukroj3YYYYController.text.toString()+"-"+_sukroj3MMController.text.toString()+"-"+_sukroj3DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj3MMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' mm',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj3DDController.text.toString().length == 2 && _sukroj3MMController.text.toString().length == 2 && _sukroj3YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup3Custom(_sukroj3YYYYController.text.toString()+"-"+_sukroj3MMController.text.toString()+"-"+_sukroj3DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj3YYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj3DDController.text.toString().length == 2 && _sukroj3MMController.text.toString().length == 2 && _sukroj3YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup3Custom(_sukroj3YYYYController.text.toString()+"-"+_sukroj3MMController.text.toString()+"-"+_sukroj3DDController.text.toString()+" 00:00:00.000");
                                                      }
                                                    }
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _selectSukrojDatePopup3(int.parse(_sukroj3YYYYController.text.toString()),int.parse(_sukroj3MMController.text.toString()) ,int.parse(_sukroj3DDController.text.toString()));

                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/calendar_icon.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_sukroj3DDController.text.isNotEmpty) {
                                        _sukroj3DDController.text = "";
                                      } else if (_sukroj3MMController
                                          .text.isNotEmpty) {
                                        _sukroj3MMController.text = "";
                                      } else if (_sukroj3YYYYController
                                          .text.isNotEmpty) {
                                        _sukroj3YYYYController.text = "";
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            //Sukroj 4 layout
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Strings.iron_sukroj_4,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 13),
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                          Border.all(color: Colors.black)),
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
                                                  controller: _sukroj4DDController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' dd',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj4DDController.text.toString().length == 2 && _sukroj4MMController.text.toString().length == 2 && _sukroj4YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup4Custom(_sukroj4YYYYController.text.toString()+"-"+_sukroj4MMController.text.toString()+"-"+_sukroj4DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj4MMController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' mm',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj4DDController.text.toString().length == 2 && _sukroj4MMController.text.toString().length == 2 && _sukroj4YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup4Custom(_sukroj4YYYYController.text.toString()+"-"+_sukroj4MMController.text.toString()+"-"+_sukroj4DDController.text.toString()+" 00:00:00.000");
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
                                                  controller: _sukroj4YYYYController,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 13),
                                                  textAlignVertical:
                                                  TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none,
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                      fillColor: Colors.transparent,
                                                      contentPadding: EdgeInsets.zero,
                                                      hintText: ' yyyy',
                                                      counterText: ''),
                                                    onChanged: (value){
                                                      print('value $value');
                                                      if(_sukroj4DDController.text.toString().length == 2 && _sukroj4MMController.text.toString().length == 2 && _sukroj4YYYYController.text.toString().length == 4){
                                                        _selectSukrojDatePopup4Custom(_sukroj4YYYYController.text.toString()+"-"+_sukroj4MMController.text.toString()+"-"+_sukroj4DDController.text.toString()+" 00:00:00.000");
                                                      }
                                                    }
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        _selectSukrojDatePopup4(int.parse(_sukroj4YYYYController.text.toString()),int.parse(_sukroj4MMController.text.toString()) ,int.parse(_sukroj4DDController.text.toString()));
                                      },
                                      child: Container(
                                          margin:
                                          EdgeInsets.only(right: 20, left: 10),
                                          child: Image.asset(
                                            "Images/calendar_icon.png",
                                            width: 20,
                                            height: 20,
                                          ))
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_sukroj4DDController.text.isNotEmpty) {
                                        _sukroj4DDController.text = "";
                                      } else if (_sukroj4MMController
                                          .text.isNotEmpty) {
                                        _sukroj4MMController.text = "";
                                      } else if (_sukroj4YYYYController
                                          .text.isNotEmpty) {
                                        _sukroj4YYYYController.text = "";
                                      }
                                    },
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                        child: Image.asset(
                                          "Images/cancel_icon_dra.png",
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
                                  text: Strings.rtl_sti_grasit2,
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
                                        Radio<Rtl>(
                                          activeColor: Colors.black,
                                          value: Rtl.yes,
                                          groupValue: _rtl,
                                          onChanged: (Rtl? value) {
                                            setState(() {
                                              _rtl = value ?? _rtl;
                                              _RTI_YES_NO="0";
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
                                        Radio<Rtl>(
                                          activeColor: Colors.black,
                                          value: Rtl.no,
                                          groupValue: _rtl,
                                          onChanged: (Rtl? value) {
                                            setState(() {
                                              _rtl = value ?? _rtl;
                                              _RTI_YES_NO="1";
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
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              Strings.high_risk_tick,
                              style:
                                  TextStyle(color: _highRiskEnDisableCB == true ? Colors.black : Colors.grey, fontSize: 13),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: _highRiskEnDisableCB == true ? Colors.black : Colors.grey ,
                                  value: _highRiskChecked,
                                  onChanged: (bool? value) {
                                    if(_highRiskEnDisableCB == true){
                                      setState(() {
                                        _highRiskChecked = value ?? false;
                                        if (_highRiskChecked == true) {
                                          _showHideHighRiskView = true;
                                        } else {
                                          _showHideHighRiskView = false;
                                        }
                                      });
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),

                    /*
                    * *
                    * * * ############################## HIGH RISK WORK START
                    * *
                    */
                    Visibility(
                      visible: _showHideHighRiskView,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: Strings.blood_preshour,
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
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  padding: EdgeInsets.all(1),
                                  margin: EdgeInsets.all(3),
                                  height: 30,
                                  child: Container(
                                      height: 36,
                                      child: TextField(
                                        controller: _bloodpreshourSController,
                                        decoration: InputDecoration(
                                            //filled: true,
                                            fillColor:
                                                ColorConstants.transparent,
                                            hintText: ' systolic'),
                                        onChanged: (text) {
                                          //_hbCount=text.trim();
                                          print('systolic $text');
                                          getBloodPresourSystolicValue(text);
                                        },
                                      )),
                                )),
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    "/",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  padding: EdgeInsets.all(1),
                                  margin: EdgeInsets.all(3),
                                  height: 30,
                                  child: Container(
                                      height: 36,
                                      child: TextField(
                                        controller: _bloodpreshourDController,
                                        decoration: InputDecoration(
                                          ///filled: true,
                                          fillColor: ColorConstants.transparent,
                                          hintText: ' diastolic',
                                        ),
                                        onChanged: (text) {
                                          //_hbCount=text.trim();
                                          print('diastolic $text');
                                          getBloodPresourDiastolicValue(text);
                                        },
                                      )),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 30,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: Strings.urine_sugar_test,
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
                          Row(
                            children: <Widget>[
                              Expanded(
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
                                      style:
                                      Theme.of(context).textTheme.bodyText1,
                                      isExpanded: true,
                                      // hint: new Text("Select State"),
                                      items: urine_range_list.map((item) {
                                        return DropdownMenuItem(
                                            child: Row(
                                              children: [
                                                new Flexible(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(2.0),
                                                      child: Text(
                                                        item.range.toString(),
                                                        //Names that the api dropdown contains
                                                        style: TextStyle(
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            value: item.range
                                                .toString() //Id that has to be passed that the dropdown has.....
                                        );
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          _selectedUrineRange_A = newVal!;
                                          print('_selectedUrineRange_A:$_selectedUrineRange_A');
                                          if(_selectedUrineRange_A == "+"){
                                            _apiUrineCodeA="1";
                                          }else if(_selectedUrineRange_A == "+ +"){
                                            _apiUrineCodeA="2";
                                          }else if(_selectedUrineRange_A == "+ + +"){
                                            _apiUrineCodeA="3";
                                          }else if(_selectedUrineRange_A == "+ + + +"){
                                            _apiUrineCodeA="4";
                                          }else if(_selectedUrineRange_A == "+ + + + +"){
                                            _apiUrineCodeA="5";
                                          }else if(_selectedUrineRange_A == "चुनें"){
                                            _apiUrineCodeA="";
                                          }
                                        });
                                      },
                                      value:
                                      _selectedUrineRange_A, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                                child: Text(
                                  "/",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                              Expanded(
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      isExpanded: true,
                                      // hint: new Text("Select State"),
                                      items: urine_range_list.map((item) {
                                        return DropdownMenuItem(
                                            child: Row(
                                              children: [
                                                new Flexible(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    item.range.toString(),
                                                    //Names that the api dropdown contains
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                            value: item.range
                                                .toString() //Id that has to be passed that the dropdown has.....
                                            );
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          _apiUrineCodeS = newVal!;
                                          print('_apiUrineCodeS:$_apiUrineCodeS');
                                          /*if(_selectedUrineRange_S == "+"){
                                            _apiUrineCodeS="1";
                                          }else if(_selectedUrineRange_S == "+ +"){
                                            _apiUrineCodeS="2";
                                          }else if(_selectedUrineRange_S == "+ + +"){
                                            _apiUrineCodeS="3";
                                          }else if(_selectedUrineRange_S == "+ + + +"){
                                            _apiUrineCodeS="4";
                                          }else if(_selectedUrineRange_S == "+ + + + +"){
                                            _apiUrineCodeS="5";
                                          }else if(_selectedUrineRange_S == "चुनें"){
                                            _apiUrineCodeS="0";
                                          }*/
                                          _selectedUrineRange_S=_apiUrineCodeS;
                                          if(_selectedUrineRange_S == "+"){
                                            _apiUrineCodeS="1";
                                          }else if(_selectedUrineRange_S == "+ +"){
                                            _apiUrineCodeS="2";
                                          }else if(_selectedUrineRange_S == "+ + +"){
                                            _apiUrineCodeS="3";
                                          }else if(_selectedUrineRange_S == "+ + + +"){
                                            _apiUrineCodeS="4";
                                          }else if(_selectedUrineRange_S == "+ + + + +"){
                                            _apiUrineCodeS="5";
                                          }else if(_selectedUrineRange_S == "चुनें"){
                                            _apiUrineCodeS="";
                                          }
                                        });
                                      },
                                      value: _selectedUrineRange_S, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                      text: Strings.upchar_code,
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      isExpanded: true,
                                      // hint: new Text("Select State"),
                                      items: custom_treatment_list.map((item) {
                                        return DropdownMenuItem(
                                            child: Row(
                                              children: [
                                                new Flexible(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    item.code.toString(),
                                                    //Names that the api dropdown contains
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                            value: item.code
                                                .toString() //Id that has to be passed that the dropdown has.....
                                            //value: "चुनें"     //Id that has to be passed that the dropdown has.....
                                            );
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          _selectedTreatmentCode = newVal!;
                                          print('treatcode:$_selectedTreatmentCode');
                                          for (int i = 0; i < custom_treatment_list.length; i++){
                                            if(custom_treatment_list[i].code.toString() == _selectedTreatmentCode){
                                              print('trtCode pos: $i');
                                              if(i == 0){
                                                _TreatMentCode="0";
                                              }else if(i == 1){
                                                _TreatMentCode="1";
                                              }else if(i == 2){
                                                _TreatMentCode="2";
                                              }else if(i == 3){
                                                _TreatMentCode="3";
                                              }else if(i == 4){
                                                _TreatMentCode="4";
                                              }else{
                                                _TreatMentCode="";
                                              }
                                              break;
                                            }
                                          }
                                          print('final upchar code: $_TreatMentCode');
                                        });
                                      },
                                      value: _selectedTreatmentCode, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              color: Colors.white,
                              child: RichText(
                                text: TextSpan(
                                    text: Strings.high_risk_ka_code,
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
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.grey,
                                        ),
                                        child: Checkbox(
                                            activeColor: _HighAnaimiyaEnDisableCB == true ? Colors.black : Colors.grey,
                                            value: _highAnaimiyaCheckb,
                                            onChanged: (bool? value) {
                                              if(_HighAnaimiyaEnDisableCB == true){
                                                setState(() {
                                                  _highAnaimiyaCheckb = value ?? false;
                                                  //print("highAnaimiya $_highAnaimiyaCheckb");
                                                  if(_highAnaimiyaCheckb == true){
                                                    ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                    custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 0,rishValue: "7"));
                                                  }else{
                                                    custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 0);
                                                  }
                                                  print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                                });
                                              }
                                            }),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.animiya_symptoms,
                                              style: TextStyle(
                                                  color: _HighAnaimiyaEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _HighbloodpresourEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _highbloodpresourCheckb,
                                          onChanged: (bool? value) {
                                            if(_HighbloodpresourEnDisableCB == true){
                                              setState(() {
                                                _highbloodpresourCheckb = value ?? false;
                                                if (_highbloodpresourCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 1,rishValue: "1"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 1);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  Strings.high_blood_preshour_2,
                                              style: TextStyle(
                                                  color: _HighbloodpresourEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _AgeEnDisableCB == true ? Colors.black:Colors.grey,
                                          value: _ageCheckb,
                                          onChanged: (bool? value) {
                                            if(_AgeEnDisableCB == true){
                                              setState(() {
                                                _ageCheckb = value ?? false;
                                                if (_ageCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 2,rishValue: "8"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 2);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }

                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.check_age_,
                                              style: TextStyle(
                                                  color:_AgeEnDisableCB == true ? Colors.black:Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _ChotakadEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _chotakadCheckb,
                                          onChanged: (bool? value) {
                                            if(_ChotakadEnDisableCB == true){
                                              setState(() {
                                                _chotakadCheckb = value ?? false;
                                                if (_chotakadCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 3,rishValue: "9"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 3);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }

                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.chota_kad,
                                              style: TextStyle(
                                                  color:_ChotakadEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _PurvJatilEnDisableCB == true ? Colors.black:Colors.grey,
                                          value: _purvJatilPrastutiCheckb,
                                          onChanged: (bool? value) {
                                            if(_PurvJatilEnDisableCB == true){
                                              setState(() {
                                                _purvJatilPrastutiCheckb = value ?? false;
                                                if (_purvJatilPrastutiCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 4,rishValue: "10"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 4);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.purv_jatil_prasuti,
                                              style: TextStyle(
                                                  color: _PurvJatilEnDisableCB == true ? Colors.black:Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _APHEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _APHCheckb,
                                          onChanged: (bool? value) {
                                            if(_APHEnDisableCB == true){
                                              setState(() {
                                                _APHCheckb = value ?? false;
                                                if (_APHCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 5,rishValue: "3"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 5);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.aph_title,
                                              style: TextStyle(
                                                  color: _APHEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _TransverselieEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _transverselieCheckb,
                                          onChanged: (bool? value) {
                                            if(_TransverselieEnDisableCB == true){
                                              setState(() {
                                                _transverselieCheckb =
                                                    value ?? false;
                                                if (_transverselieCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 6,rishValue: "11"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 6);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.transveselie_title,
                                              style: TextStyle(
                                                  color: _TransverselieEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _MadhumayeEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _madhumayeCheckb,
                                          onChanged: (bool? value) {
                                            if(_MadhumayeEnDisableCB == true){
                                              setState(() {
                                                _madhumayeCheckb = value ?? false;
                                                if (_madhumayeCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 7,rishValue: "2"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 7);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.madhumaya,
                                              style: TextStyle(
                                                  color: _MadhumayeEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _HeartRogEnDisableCB == true ? Colors.black:Colors.grey,
                                          value: _heartRogCheckb,
                                          onChanged: (bool? value) {
                                            if(_HeartRogEnDisableCB == true){
                                              setState(() {
                                                _heartRogCheckb = value ?? false;
                                                if (_heartRogCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 8,rishValue: "12"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 8);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.heart_rog,
                                              style: TextStyle(
                                                  color: _HeartRogEnDisableCB == true ? Colors.black:Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _GurdaRogEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _gurdaRogCheckb,
                                          onChanged: (bool? value) {
                                            if(_GurdaRogEnDisableCB == true){

                                              setState(() {
                                                _gurdaRogCheckb = value ?? false;
                                                if (_gurdaRogCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 9,rishValue: "13"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 9);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.gurda_rog,
                                              style: TextStyle(
                                                  color: _GurdaRogEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor: _OtherEnDisableCB == true ? Colors.black : Colors.grey,
                                          value: _otherCheckb,
                                          onChanged: (bool? value) {
                                            if(_OtherEnDisableCB == true){
                                              setState(() {
                                                _otherCheckb = value ?? false;
                                                if (_otherCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 10,rishValue: "5"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 10);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");
                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.other,
                                              style: TextStyle(
                                                  color: _OtherEnDisableCB == true ? Colors.black : Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                          activeColor:_MalairiyaEnDisableCB == true ? Colors.black:Colors.grey,
                                          value: _malairiyaCheckb,
                                          onChanged: (bool? value) {
                                            if(_MalairiyaEnDisableCB == true){
                                              setState(() {
                                                _malairiyaCheckb = value ?? false;
                                                if (_malairiyaCheckb == true) {
                                                  ////maleriya=4,extra=5, gurdarog=13, heartprob=12, madhumeh=2 ,Transverselie =11 ,aph=3 , chotakud=9 , purv_jatil=10 , age =8, highbloodpres=1, serious_animya=7
                                                  custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 11,rishValue: "4"));
                                                }else{
                                                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 11);
                                                }
                                                print("cvslist.len ${custom_high_pragnancy_cvslist.length}");

                                              });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: RichText(
                                          text: TextSpan(
                                              text: Strings.malairiya,
                                              style: TextStyle(
                                                  color: _MalairiyaEnDisableCB == true ? Colors.black:Colors.grey,
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
                                      ),
                                    ),
                                  ],
                                ),
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                                      fontSize: 10.0,
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
                                                    item.unitNameHindi.toString(),
                                                    //Names that the api dropdown contains
                                                    style: TextStyle(
                                                      fontSize: 10.0,
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
                    * *
                    * * * ############################# HIGH RISK WORK END
                    * *
                    */

                    /*
                    * * covid-19 view
                    */
                    Visibility(
                      visible: _showHideCovidView,
                      child: Container(
                        //  height: 200,
                        color: ColorConstants.grey_bg_anc,
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: ColorConstants.grey_bg_anc,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: Strings.covid_19_ka_vivran,
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
                              // height: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black)),
                              padding: EdgeInsets.all(1),
                              margin: EdgeInsets.all(3),
                              child: Column(
                                children: <Widget>[
                                  /*
                                  * * COVID-19 RADIO BUTTON 1
                                  */
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
                                                      .ILI_jukam_bukhar_khasi,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:Colors.black,
                                                          value: multiple_chooice.yes,
                                                          groupValue: _choose_covid_1,
                                                          onChanged: (multiple_chooice? value) {
                                                            setState(() {
                                                              _choose_covid_1 = value ?? _choose_covid_1;
                                                              _iscovidCase="1";
                                                              _covidDDEnabledDisabled=true;
                                                              _covidMMEnabledDisabled=true;
                                                              _covidYYYYEnabledDisabled=true;
                                                              _showCovid19DateView(true);
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:Colors.black,
                                                          value: multiple_chooice.no,
                                                          groupValue: _choose_covid_1,
                                                          onChanged:(multiple_chooice? value) {
                                                            setState(() {
                                                              _choose_covid_1 = value ?? _choose_covid_1;
                                                              _iscovidCase="2";
                                                              _showCovid19DateView(false);
                                                              _covidDDEnabledDisabled=false;
                                                              _covidMMEnabledDisabled=false;
                                                              _covidYYYYEnabledDisabled=false;
                                                              _covidDDdateController.text="";
                                                              _covidMMdateController.text="";
                                                              _covidYYYYdateController.text="";
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

                                  /*
                                  * * COVID-19 Date
                                  */
                                  Visibility(
                                    visible: _showCovidDateView,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                    text: Strings.kab_sai,
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
                                                        autofocus: true,
                                                        enabled: _covidDDEnabledDisabled,
                                                        textAlign: TextAlign.center,
                                                        maxLength: 2,
                                                        keyboardType: TextInputType.number,
                                                        controller: _covidDDdateController,
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
                                                        enabled: _covidMMEnabledDisabled,
                                                        textAlign: TextAlign.center,
                                                        maxLength: 2,
                                                        keyboardType: TextInputType.number,
                                                        controller: _covidMMdateController,
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
                                                        enabled: _covidYYYYEnabledDisabled,
                                                        textAlign: TextAlign.center,
                                                        maxLength: 4,
                                                        keyboardType: TextInputType.number,
                                                        controller: _covidYYYYdateController,
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
                                              if(_iscovidCase == "1"){
                                                _selectCovidDatePopup();
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
                                  ),

                                  /*
                                  * * COVID-19 RADIO BUTTON 2
                                  */
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
                                                      .kya_mahila_mahila_videsh_yatra,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .yes,
                                                          groupValue:
                                                              _choose_covid_2,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_2 =
                                                                  value ??
                                                                      _choose_covid_2;
                                                              _CovidForeignTrip="1";
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .no,
                                                          groupValue:
                                                              _choose_covid_2,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_2 =
                                                                  value ??
                                                                      _choose_covid_2;
                                                              _CovidForeignTrip="2";
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

                                  /*
                                  * * COVID-19 RADIO BUTTON 3
                                  */
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
                                                      .kya_mahila_ka_parijan_sambhavit,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .yes,
                                                          groupValue:
                                                              _choose_covid_3,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_3 =
                                                                  value ??
                                                                      _choose_covid_3;
                                                              _CovidRelativePossibility="1";
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .no,
                                                          groupValue:
                                                              _choose_covid_3,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_3 =
                                                                  value ??
                                                                      _choose_covid_3;
                                                              _CovidRelativePossibility="2";
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

                                  /*
                                  * * COVID-19 RADIO BUTTON 4
                                  */
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
                                                      .kya_mahila_ka_parijan_positive_hai,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .yes,
                                                          groupValue:
                                                              _choose_covid_4,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_4 =
                                                                  value ??
                                                                      _choose_covid_4;
                                                              _CovidRelativePositive="1";
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .no,
                                                          groupValue:
                                                              _choose_covid_4,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_4 =
                                                                  value ??
                                                                      _choose_covid_4;
                                                              _CovidRelativePositive="2";
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

                                  /*
                                  * * COVID-19 RADIO BUTTON 5
                                  */
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
                                                      .kya_mahila_home_quarintine_hai,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .yes,
                                                          groupValue:
                                                              _choose_covid_5,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_5 =
                                                                  value ??
                                                                      _choose_covid_5;
                                                              _CovidQuarantine="1";
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .no,
                                                          groupValue:
                                                              _choose_covid_5,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_5 =
                                                                  value ??
                                                                      _choose_covid_5;
                                                              _CovidQuarantine="2";
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

                                  /*
                                  * * COVID-19 RADIO BUTTON 6
                                  */
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
                                                      .kya_mahila_isolation_hai,
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .yes,
                                                          groupValue:
                                                              _choose_covid_6,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_6 =
                                                                  value ??
                                                                      _choose_covid_6;
                                                              _CovidIsolation="1";
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
                                                        Radio<multiple_chooice>(
                                                          activeColor:
                                                              Colors.black,
                                                          value:
                                                              multiple_chooice
                                                                  .no,
                                                          groupValue:
                                                              _choose_covid_6,
                                                          onChanged:
                                                              (multiple_chooice?
                                                                  value) {
                                                            setState(() {
                                                              _choose_covid_6 =
                                                                  value ??
                                                                      _choose_covid_6;
                                                              _CovidIsolation="2";
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /*
                    * * radio button 1
                    */
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
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
                                              text: Strings.kya_pragnent_ko_sujan_hai,
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
                                                                  Strings.choose_1_title);
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
                                              text: Strings.kya_pragnent_ko_diabeties_hai,
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
                                                                  Strings.choose_2_title);
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
                                              text: Strings.kya_bukhar_hai,
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
                                                                  Strings.choose_3_title);
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
                                              text: Strings.kya_yoni_sai_badbo_ka_sasav,
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
                                                                  Strings.choose_4_title);
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
                                              text: Strings.kya_pragnent_ko_bukhar_hai,
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
                                                                  Strings.choose_5_title);
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
                                              text: Strings.raktchap_jada_ho,
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
                                                                  Strings.choose_6_title);
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

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),

            _ShowHideEditVivranView == true
                ? _isItAsha == true ?
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
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
                              text: Strings.update_pnc,
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

  Future<void> _showWeightPopup(String msg,Color _color,String diff_weight,String growth_weight) async {
    final convert_msg=msg.replaceAll("#.##1", diff_weight);
    final convert_msg2=convert_msg.replaceAll("#.##2", growth_weight);

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
                      convert_msg2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
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

  /*
  * * Custom Date Picker
  * */
  late DateTime _selectedDate;
  //teTime? diff_lmp_ancdate;
  var _selectedANCDate = "";
  var initalDay = 0;
  var initalMonth = 0;
  var initalYear = 0;
  var final_diff_dates=0;

  void _selectCustomANCDatePopup(String _customANCDate){
    var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customANCDate));
    print('parseCustomANCDate ${parseCustomANCDate}');

    setState(() {
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);


      _selectedANCDate = formattedDate2.toString();
      //print('Calendra selected date=>: ${formattedDate4.toString()}');
      //print('regiDate ${getConvertRegDateFormat(widget.registered_date)}');//regiDate 2021-03-12T00:00:00.000
      //print('regiDate ${widget.registered_date2}');//regiDate 2021-03-12T00:00:00.000
      var parsedDate1 = DateTime.parse(formattedDate4.toString());
      var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));

      //print('parsedDate1 ${parsedDate1}');//2021-03-12 00:00:00.000
      //print('parsedDate2 ${parsedDate2}');//2021-03-12 00:00:00.000
      if (formattedDate2.compareTo(getCurrentDate()) > 0) {
        _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
      }else{
        if (parsedDate2.compareTo(parsedDate1) > 0) {
          // print('greater date');
          _showErrorPopup(Strings.panjikaran_kai_baad_ka,Colors.black);

        } else {
          _showCovid19View(false);
          //print('less than date');
          if (formattedDate2.compareTo(getCurrentDate()) > 0) {
            //print('equal to current date#########');
            _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
          } else {
            //print('not equal date----------');
            //print('ANC selected date=>: ${_selectedANCDate}');
            // print('anc_dd: ${getDate(formattedDate4)}');
            // print('anc_year: ${getYear(formattedDate4)}');
            //print('anc_month: ${getMonth(formattedDate4)}');
            var selectedParsedDate = DateTime.parse(formattedDate4.toString());
            var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));

            print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
            final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
            print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000
            if (selectedParsedDate.compareTo(exptedDate_281) > 0) {
              // print('greater date');
              _showErrorPopup(Strings.please_select_before_date,Colors.black);
            }else if(widget.anc_date.toString().isNotEmpty){
              // print('lessthan date');
              print('checkANCDate ${widget.anc_date}');
              var selectedParsedDate = DateTime.parse(formattedDate4.toString());
              var ancParsedDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
              print('current anc date: ${ancParsedDate}');//2021-01-17 00:00:00.000
              final ancDate_41 = ancParsedDate.add(const Duration(days: 41));
              print('after anc date: ${ancDate_41}');//2021-10-25 00:00:00.000
              if (selectedParsedDate.compareTo(ancDate_41) > 0) //2021-04-22 00:00:00.000
                  {
                _checkIfANCSelected=true;
                var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
                var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
                //print('AncDate calendr ${parseCalenderSelectedAncDate}');
                //print('AncDate intentt ${intentAncDate}');
                final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
                //print('diff_lmp_ancdate ${diff_lmp_ancdate}');
                final_diff_dates=diff_lmp_ancdate;
                _ancDDdateController.text = getDate(formattedDate4);
                _ancMMdateController.text = getMonth(formattedDate4);
                _ancYYYYdateController.text = getYear(formattedDate4);
                _AncDatePost=_ancYYYYdateController.text.toString()+ "/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
                print('_AncDatePost $_AncDatePost');
                /*
                        * When COVID Start
                      */
                var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
                //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

                var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
                //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
                if (_ancAPIDate.compareTo(covidDate) > 0) {
                  //print('greater covid date');
                  _showCovid19View(true);
                }else{
                  //print('lssthan before date');
                  _showCovid19View(false);
                }
              } else {
                //print('lessthan date');
                _showErrorPopup(Strings.anc_41_days_validation,Colors.black);
              }
            }else {
              print('if first anc submited');
              _checkIfANCSelected=true;
              _ancDDdateController.text = getDate(formattedDate4);
              _ancMMdateController.text = getMonth(formattedDate4);
              _ancYYYYdateController.text = getYear(formattedDate4);
              _AncDatePost=_ancYYYYdateController.text.toString()+ "/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
              print('_AncDatePost $_AncDatePost');
              /*
                * When COVID Start
              */
              var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
              //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

              var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
              //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
              if (_ancAPIDate.compareTo(covidDate) > 0) {
                //print('greater covid date');
                _showCovid19View(true);
              }else{
                //print('lssthan before date');
                _showCovid19View(false);
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
        //print('Calendra selected date=>: ${formattedDate4.toString()}');
        //print('regiDate ${getConvertRegDateFormat(widget.registered_date)}');//regiDate 2021-03-12T00:00:00.000
        var parsedDate1 = DateTime.parse(formattedDate4.toString());
        var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));

        //print('parsedDate1 ${parsedDate1}');//2021-03-12 00:00:00.000
        //print('parsedDate2 ${parsedDate2}');//2021-03-12 00:00:00.000



        if (parsedDate2.compareTo(parsedDate1) > 0) {
          // print('greater date');
          _showErrorPopup(Strings.panjikaran_kai_baad_ka,Colors.black);

        } else {
          _showCovid19View(false);
          //print('less than date');
          if (formattedDate2.toString() == getCurrentDate()) {
            //print('equal to current date#########');
            _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
          } else {
            //print('not equal date----------');
            //print('ANC selected date=>: ${_selectedANCDate}');
            // print('anc_dd: ${getDate(formattedDate4)}');
            // print('anc_year: ${getYear(formattedDate4)}');
            //print('anc_month: ${getMonth(formattedDate4)}');
            var selectedParsedDate = DateTime.parse(formattedDate4.toString());
            var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));

            print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
            final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
            print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000
            if (selectedParsedDate.compareTo(exptedDate_281) > 0) {
              // print('greater date');
              _showErrorPopup(Strings.please_select_before_date,Colors.black);
            }else if(widget.anc_date.toString().isNotEmpty){
              // print('lessthan date');
              _checkIfANCSelected=true;
              var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());
              var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
              //print('AncDate calendr ${parseCalenderSelectedAncDate}');
              //print('AncDate intentt ${intentAncDate}');
              final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
              //print('diff_lmp_ancdate ${diff_lmp_ancdate}');
              final_diff_dates=diff_lmp_ancdate;
              _ancDDdateController.text = getDate(formattedDate4);
              _ancMMdateController.text = getMonth(formattedDate4);
              _ancYYYYdateController.text = getYear(formattedDate4);
              _AncDatePost=_ancYYYYdateController.text.toString()+ "/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
              print('_AncDatePost $_AncDatePost');
              /*
                        * When COVID Start
                      */
              var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
              //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

              var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
              //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
              if (_ancAPIDate.compareTo(covidDate) > 0) {
                //print('greater covid date');
                _showCovid19View(true);
              }else{
                //print('lssthan before date');
                _showCovid19View(false);
              }
            }else {
              print('if first anc submited');
              _checkIfANCSelected=true;
              _ancDDdateController.text = getDate(formattedDate4);
              _ancMMdateController.text = getMonth(formattedDate4);
              _ancYYYYdateController.text = getYear(formattedDate4);
              _AncDatePost=_ancYYYYdateController.text.toString()+ "/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
              print('_AncDatePost $_AncDatePost');
              /*
                * When COVID Start
              */
              var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
              //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

              var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
              //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
              if (_ancAPIDate.compareTo(covidDate) > 0) {
                //print('greater covid date');
                _showCovid19View(true);
              }else{
                //print('lssthan before date');
                _showCovid19View(false);
              }
            }
          }
        }
      });
    });
  }

  void _selectCovidDatePopup(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050))
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        print(
            "Hi bro, i came from cancel button or via click outside of datepicker");
        return;
      }
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        _covidDDdateController.text = getDate(formattedDate4);
        _covidMMdateController.text = getMonth(formattedDate4);
        _covidYYYYdateController.text = getYear(formattedDate4);
      }

    });
  }

  bool checkCovidCase(String _covidDate){
    var covidDate = DateTime.parse(getConvertRegDateFormat(_covidDate));
    //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000
    var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
    //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
    if (_ancAPIDate.compareTo(covidDate) > 0) {
      print('greater covid date');
      return true;
    }else{
      print('lssthan before date');
      return false;
    }
  }
  /*
    * VISIBILITY CONTROLLER
  */
  bool _isIFA180View = false;
  bool _isIFA360View = false;
  bool _isIronSukrojView = true;
  bool _isTT1Selected = true;
  bool _isTT2Selected = true;
  bool _isTTBSelected = true;

  void _showCovid19View(bool valu) {
    setState(() {
      _showHideCovidView = valu;
    });
  }

  void _showCovid19DateView(bool valu) {
    setState(() {
      _showCovidDateView = valu;
    });
  }

  void _isIronSukrojViewToggle(bool valu) {
    setState(() {
      _isIronSukrojView = valu;
    });
  }

  void _isTT1SelectedToggle(bool valu) {
    setState(() {
      _isTT1Selected = valu;
    });
  }

  void _isTT2SelectedToggle(bool valu) {
    setState(() {
      _isTT2Selected = valu;
    });
  }

  void _isTTBSelectedToggle(bool valu) {
    setState(() {
      _isTTBSelected = valu;
    });
  }
  var _ironSukroj1SelectDate="";
  var _ironSukroj2SelectDate="";
  var _ironSukroj3SelectDate="";
  var _checkDifference=0;
  void _selectSukrojDatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      _ironSukroj1SelectDate=_selectedDate.toString();
      print('_ironSukroj1SelectDate=>: ${_ironSukroj1SelectDate}');


      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      print('_checkIfANCSelected ${_checkIfANCSelected}');
      if(!_checkIfANCSelected){

        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());

        var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
        print('anc calendr ${parseCalenderSelectedAncDate}');
        print('anc intentt ${intentAncDate}');

        final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
        print('sukroj diff if ${diff_lmp_ancdate}');

      }else{
        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());

        var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
        print('anc calendr ${parseCalenderSelectedAncDate}');
        print('anc intentt ${intentAncDate}');

        final diff_lmp_ancdate = intentAncDate.difference(parseCalenderSelectedAncDate).inDays;
        print('sukroj diff else ${diff_lmp_ancdate}');
        _checkDifference=diff_lmp_ancdate;

        if(_checkDifference > 0){
          _showErrorPopup("Date cant be less than ANC date",Colors.black);
        }else{
          _sukroj1DDController.text = getDate(formattedDate4);
          _sukroj1MMController.text = getMonth(formattedDate4);
          _sukroj1YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj1YYYYController.text.toString()+"/"+_sukroj1MMController.text.toString()+"/"+_sukroj1DDController.text.toString();
          print('final sukroj 1 ${_Iron_sukroj_Post1}');
        }
      }


      /*if(!_checkIfANCSelected){
        var parseSukroj1Date = DateTime.parse(formattedDate4.toString());
        var parseLastANCDate = DateTime.parse(getAPIResponseFormattedDate2(widget.anc_date));

        print('parsedDate1 ${parseSukroj1Date}');
        print('parsedDate2 ${parseLastANCDate}');

        if (parseSukroj1Date.compareTo(parseLastANCDate) > 0) {
          print('greater date');
          _isSukroj1Selected=true;
          _sukroj1DDController.text = getDate(formattedDate4);
          _sukroj1MMController.text = getMonth(formattedDate4);
          _sukroj1YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj1YYYYController.text.toString()+"/"+_sukroj1MMController.text.toString()+"/"+_sukroj1DDController.text.toString();
          print('final sukroj 1 ${_Iron_sukroj_Post1}');
        }else{
          print('lessthan date');
          _showErrorPopup(Strings.date_cannot_less_anc_date, Colors.black);
        }
      }*/
    });
  }

  void _selectSukrojDatePopupCustom(String _customSukrojDate){
    setState(() {
      var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customSukrojDate));
      print('parseCustomANCDate ${parseCustomANCDate}');

      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);

      _ironSukroj1SelectDate=formattedDate4.toString();
      print('_ironSukroj1SelectDate=>: ${_ironSukroj1SelectDate}');

      print('_checkIfANCSelected ${_checkIfANCSelected}');
      if(!_checkIfANCSelected){

        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());

        var intentAncDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
        print('anc calendr ${parseCalenderSelectedAncDate}');
        print('anc intentt ${intentAncDate}');

        final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
        print('sukroj diff if ${diff_lmp_ancdate}');

      }else{
        var parseCalenderSelectedAncDate = DateTime.parse(formattedDate4.toString());

        var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
        print('anc calendr ${parseCalenderSelectedAncDate}');
        print('anc intentt ${intentAncDate}');

        final diff_lmp_ancdate = intentAncDate.difference(parseCalenderSelectedAncDate).inDays;
        print('sukroj diff else ${diff_lmp_ancdate}');
        _checkDifference=diff_lmp_ancdate;

        if(_checkDifference > 0){
          _showErrorPopup("Date cant be less than ANC date",Colors.black);
        }else{
          _sukroj1DDController.text = getDate(formattedDate4);
          _sukroj1MMController.text = getMonth(formattedDate4);
          _sukroj1YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj1YYYYController.text.toString()+"/"+_sukroj1MMController.text.toString()+"/"+_sukroj1DDController.text.toString();
          print('final sukroj 1 ${_Iron_sukroj_Post1}');
        }
      }
    });
  }

  var _check_btw_1_or_2_sukroj = 0 ;
  void _selectSukrojDatePopup2(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      _ironSukroj2SelectDate=_selectedDate.toString();
      print('_ironSukroj2SelectDate=>: ${_ironSukroj2SelectDate}');
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();


      if(_sukroj1DDController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
      }else if(_sukroj1MMController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
      }else if(_sukroj1YYYYController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
      }else{

        var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

        var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj1SelectDate));
        print('anc calendr ${parseCalenderSelectedISukroj1Date}');
        print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

        final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
        print('sukroj diff else ${diff_ironsukrj_date}');
        _check_btw_1_or_2_sukroj=diff_ironsukrj_date;

        if(_check_btw_1_or_2_sukroj >= 0){
          _showErrorPopup("Please Check Enter Date",Colors.black);
        }else{
          _sukroj2DDController.text = getDate(formattedDate4);
          _sukroj2MMController.text = getMonth(formattedDate4);
          _sukroj2YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post2=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post2}');
        }
      }



      /* if(!_checkIfANCSelected){
        var parseSukroj1Date = DateTime.parse(formattedDate4.toString());
        var parseLastANCDate = DateTime.parse(getAPIResponseFormattedDate2(widget.anc_date));

        print('parsedDate1 ${parseSukroj1Date}');
        print('parsedDate2 ${parseLastANCDate}');

        if (parseSukroj1Date.compareTo(parseLastANCDate) > 0) {
          print('greater date');

          _sukroj2DDController.text = getDate(formattedDate4);
          _sukroj2MMController.text = getMonth(formattedDate4);
          _sukroj2YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post1}');
        }else{
          print('lessthan date');
          _showErrorPopup(Strings.date_cannot_less_anc_date, Colors.black);
        }
      }*/
    });
  }

  void _selectSukrojDatePopup2Custom(String _customSukrojDate){


    var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customSukrojDate));
    print('parseCustomANCDate ${parseCustomANCDate}');

    String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
    String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);

    _ironSukroj2SelectDate=formattedDate4.toString();
    print('_ironSukroj2SelectDate=>: ${_ironSukroj2SelectDate}');

    if(_sukroj1DDController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
    }else if(_sukroj1MMController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
    }else if(_sukroj1YYYYController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj_date, Colors.black);
    }else{

      var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

      var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj1SelectDate));
      print('anc calendr ${parseCalenderSelectedISukroj1Date}');
      print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

      final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
      print('sukroj diff else ${diff_ironsukrj_date}');
      _check_btw_1_or_2_sukroj=diff_ironsukrj_date;


      if(_check_btw_1_or_2_sukroj >= 0){
        _showErrorPopup("Please Check Enter Date",Colors.black);
      }else{
        _sukroj2DDController.text = getDate(formattedDate4);
        _sukroj2MMController.text = getMonth(formattedDate4);
        _sukroj2YYYYController.text = getYear(formattedDate4);
        _Iron_sukroj_Post2=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
        print('final sukroj 2 ${_Iron_sukroj_Post2}');
      }

    }



    /* if(!_checkIfANCSelected){
        var parseSukroj1Date = DateTime.parse(formattedDate4.toString());
        var parseLastANCDate = DateTime.parse(getAPIResponseFormattedDate2(widget.anc_date));

        print('parsedDate1 ${parseSukroj1Date}');
        print('parsedDate2 ${parseLastANCDate}');

        if (parseSukroj1Date.compareTo(parseLastANCDate) > 0) {
          print('greater date');

          _sukroj2DDController.text = getDate(formattedDate4);
          _sukroj2MMController.text = getMonth(formattedDate4);
          _sukroj2YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post1}');
        }else{
          print('lessthan date');
          _showErrorPopup(Strings.date_cannot_less_anc_date, Colors.black);
        }
      }*/
  }

  var _check_btw_2_or_3_sukroj = 0 ;
  void _selectSukrojDatePopup3(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      _ironSukroj3SelectDate=_selectedDate.toString();
      print('_ironSukroj3SelectDate=>: ${_ironSukroj3SelectDate}');
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();


      if(_sukroj2DDController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
      }else if(_sukroj2MMController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
      }else if(_sukroj2YYYYController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
      }else{

        var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

        var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj2SelectDate));
        print('anc calendr ${parseCalenderSelectedISukroj1Date}');
        print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

        final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
        print('sukroj diff else ${diff_ironsukrj_date}');
        _check_btw_2_or_3_sukroj=diff_ironsukrj_date;

        if(_check_btw_2_or_3_sukroj >= 0){
          _showErrorPopup("Please Check Enter Date",Colors.black);
        }else{
          _sukroj3DDController.text = getDate(formattedDate4);
          _sukroj3MMController.text = getMonth(formattedDate4);
          _sukroj3YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post3=_sukroj3YYYYController.text.toString()+"/"+_sukroj3MMController.text.toString()+"/"+_sukroj3DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post3}');
        }

      }


      /* if(!_checkIfANCSelected){
        var parseSukroj1Date = DateTime.parse(formattedDate4.toString());
        var parseLastANCDate = DateTime.parse(getAPIResponseFormattedDate2(widget.anc_date));

        print('parsedDate1 ${parseSukroj1Date}');
        print('parsedDate2 ${parseLastANCDate}');

        if (parseSukroj1Date.compareTo(parseLastANCDate) > 0) {
          print('greater date');

          _sukroj2DDController.text = getDate(formattedDate4);
          _sukroj2MMController.text = getMonth(formattedDate4);
          _sukroj2YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post1}');
        }else{
          print('lessthan date');
          _showErrorPopup(Strings.date_cannot_less_anc_date, Colors.black);
        }
      }*/
    });
  }

  void _selectSukrojDatePopup3Custom(String _customSukrojDate){


    var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customSukrojDate));
    print('parseCustomANCDate ${parseCustomANCDate}');

    String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
    String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);

    _ironSukroj3SelectDate=formattedDate4.toString();
    print('_ironSukroj3SelectDate=>: ${_ironSukroj3SelectDate}');



    if(_sukroj2DDController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
    }else if(_sukroj2MMController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
    }else if(_sukroj2YYYYController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj2_date, Colors.black);
    }else{

      var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

      var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj2SelectDate));
      print('anc calendr ${parseCalenderSelectedISukroj1Date}');
      print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

      final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
      print('sukroj diff else ${diff_ironsukrj_date}');
      _check_btw_2_or_3_sukroj=diff_ironsukrj_date;

      if(_check_btw_2_or_3_sukroj >= 0){
        _showErrorPopup("Please Check Enter Date",Colors.black);
      }else{
        _sukroj3DDController.text = getDate(formattedDate4);
        _sukroj3MMController.text = getMonth(formattedDate4);
        _sukroj3YYYYController.text = getYear(formattedDate4);
        _Iron_sukroj_Post3=_sukroj3YYYYController.text.toString()+"/"+_sukroj3MMController.text.toString()+"/"+_sukroj3DDController.text.toString();
        print('final sukroj 2 ${_Iron_sukroj_Post3}');
      }
    }



    /* if(!_checkIfANCSelected){
        var parseSukroj1Date = DateTime.parse(formattedDate4.toString());
        var parseLastANCDate = DateTime.parse(getAPIResponseFormattedDate2(widget.anc_date));

        print('parsedDate1 ${parseSukroj1Date}');
        print('parsedDate2 ${parseLastANCDate}');

        if (parseSukroj1Date.compareTo(parseLastANCDate) > 0) {
          print('greater date');

          _sukroj2DDController.text = getDate(formattedDate4);
          _sukroj2MMController.text = getMonth(formattedDate4);
          _sukroj2YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post1=_sukroj2YYYYController.text.toString()+"/"+_sukroj2MMController.text.toString()+"/"+_sukroj2DDController.text.toString();
          print('final sukroj 2 ${_Iron_sukroj_Post1}');
        }else{
          print('lessthan date');
          _showErrorPopup(Strings.date_cannot_less_anc_date, Colors.black);
        }
      }*/

  }

  var _check_btw_3_or_4_sukroj = 0 ;
  void _selectSukrojDatePopup4(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();


      if(_sukroj3DDController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
      }else if(_sukroj3MMController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
      }else if(_sukroj3YYYYController.text.isEmpty){
        _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
      }else{

        var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

        var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj3SelectDate));
        print('anc calendr ${parseCalenderSelectedISukroj1Date}');
        print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

        final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
        print('sukroj diff else ${diff_ironsukrj_date}');
        _check_btw_3_or_4_sukroj=diff_ironsukrj_date;

        if(_check_btw_3_or_4_sukroj >= 0){
          _showErrorPopup("Please Check Enter Date",Colors.black);
        }else{
          _sukroj4DDController.text = getDate(formattedDate4);
          _sukroj4MMController.text = getMonth(formattedDate4);
          _sukroj4YYYYController.text = getYear(formattedDate4);
          _Iron_sukroj_Post4=_sukroj4YYYYController.text.toString()+"/"+_sukroj4MMController.text.toString()+"/"+_sukroj4DDController.text.toString();
          print('final sukroj 4 ${_Iron_sukroj_Post4}');
        }
      }


    });
  }

  void _selectSukrojDatePopup4Custom(String _customSukrojDate){

    var parseCustomANCDate = DateTime.parse(getAPIResponseFormattedDate2(_customSukrojDate));
    print('parseCustomANCDate ${parseCustomANCDate}');

    String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseCustomANCDate);
    String formattedDate2 = DateFormat('yyyy/MM/dd').format(parseCustomANCDate);

    if(_sukroj3DDController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
    }else if(_sukroj3MMController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
    }else if(_sukroj3YYYYController.text.isEmpty){
      _showErrorPopup(Strings.choose_sukroj3_date, Colors.black);
    }else{

      var parseCalenderSelectedISukroj1Date = DateTime.parse(formattedDate4.toString());

      var intent_ironSukroj1SelectDateDate = DateTime.parse(getConvertRegDateFormat(_ironSukroj3SelectDate));
      print('anc calendr ${parseCalenderSelectedISukroj1Date}');
      print('anc intent_ironSukroj1SelectDateDate ${intent_ironSukroj1SelectDateDate}');

      final diff_ironsukrj_date = intent_ironSukroj1SelectDateDate.difference(parseCalenderSelectedISukroj1Date).inDays;
      print('sukroj diff else ${diff_ironsukrj_date}');
      _check_btw_3_or_4_sukroj=diff_ironsukrj_date;

      if(_check_btw_3_or_4_sukroj >= 0){
        _showErrorPopup("Please Check Enter Date",Colors.black);
      }else{
        _sukroj4DDController.text = getDate(formattedDate4);
        _sukroj4MMController.text = getMonth(formattedDate4);
        _sukroj4YYYYController.text = getYear(formattedDate4);
        _Iron_sukroj_Post4=_sukroj4YYYYController.text.toString()+"/"+_sukroj4MMController.text.toString()+"/"+_sukroj4DDController.text.toString();
        print('final sukroj 4 ${_Iron_sukroj_Post4}');
      }
    }
  }

  var _yourSelectedANCDate="";
  void _selectTT1DatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
        initialDate: DateTime(yyyy, mm , dd ),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050))
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        print("Hi bro, i came from cancel button or via click outside of datepicker");
        return;
      }
      _selectedDate = pickedDate;
      print('_selectedTT1Date $_selectedDate');///2022-12-07 00:00:00.000
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        print('done');

        var selectedParsedDate = DateTime.parse(formattedDate4.toString());
        var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
        final diff_lmp_ancdate = selectedParsedDate.difference(intentAncDate).inDays;
        print('checkdifference ${diff_lmp_ancdate}');

        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{

          var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));
          print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
          final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
          print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000

          if(selectedParsedDate.compareTo(exptedDate_281) > 0){
            _showErrorPopup(Strings.please_select_before_date,Colors.black);
          }else{
            var registerDate = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
            print('registerDate ${registerDate}');//2021-03-12 00:00:00.000
            if(selectedParsedDate.compareTo(registerDate) >= 0){
              if(diff_lmp_ancdate > 0) {
                _showErrorPopup("TT date not grater then anc date", Colors.black);
              }else{
                /*
                  * when TT1 selected TT2 will be show but TTB will be hide
                */
                _isTTBSelectedToggle(false);
                _TT1DDController.text = getDate(formattedDate4);
                _TT1MMController.text = getMonth(formattedDate4);
                _TT1YYYYController.text = getYear(formattedDate4);
              }
            }else{
              _showErrorPopup(Strings.please_selectd_before_register,Colors.black);
            }

          }
        }
      }
    });
  }

  void _selectTT2DatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();


      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }/*else if(selectedParsedDate.compareTo(exptedDate_281) > 0){
        _showErrorPopup(Strings.please_select_before_date,Colors.black);
      }else if(diff_lmp_ancdate > 0) {
        _showErrorPopup("TT date not grater then anc date", Colors.black);
      }else if(lastANCDate_28.compareTo(selectedParsedDate) > 0){
        _showErrorPopup("TT date and Last Anc date should be greater than 28 days", Colors.black);
      }*/else{
        print('done');

        var selectedParsedDate = DateTime.parse(formattedDate4.toString());
        var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
        final diff_lmp_ancdate = selectedParsedDate.difference(intentAncDate).inDays;
        print('checkdifference ${diff_lmp_ancdate}');


        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{

          var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));
          print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
          final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
          print('after exptd date: ${exptedDate_281}');

          if(selectedParsedDate.compareTo(exptedDate_281) > 0){
            _showErrorPopup(Strings.please_select_before_date,Colors.black);
          }else{
            var registerDate = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
            print('registerDate ${registerDate}');//2021-03-12 00:00:00.000
            if(selectedParsedDate.compareTo(registerDate) >= 0){
              if(diff_lmp_ancdate > 0) {
                _showErrorPopup("TT date not grater then anc date", Colors.black);
              }else{
                if(widget.TT1.isNotEmpty){
                  var intentTT1Date = DateTime.parse(getConvertRegDateFormat(widget.TT1));
                  final checkTTDiff = selectedParsedDate.difference(intentTT1Date).inDays;
                  print('checkTTDiff ${checkTTDiff}');
                  if(checkTTDiff < 15){
                    _showErrorPopup("TT1 date and TT2 date should be Gap 15 days",Colors.black);
                  }else{
                    var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));

                    print('last anc date: ${parseLastANCDate}');
                    final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
                    print('parseLastANCDate_28: ${parseLastANCDate_28}');
                    if (selectedParsedDate.compareTo(parseLastANCDate_28) < 0) {
                      // print('greater date');
                      _showErrorPopup(Strings.tt_and_last_anc_date_greater_28days, Colors.black);
                    }else{
                      /*
                        * when TT2 selected TTB will be hide
                      */
                      _isTTBSelectedToggle(false);
                      _TT2DDController.text = getDate(formattedDate4);
                      _TT2MMController.text = getMonth(formattedDate4);
                      _TT2YYYYController.text = getYear(formattedDate4);
                    }
                  }
                }else{

                  /*
                    * when TT2 selected TTB will be hide
                  */
                  _isTTBSelectedToggle(false);
                  _TT2DDController.text = getDate(formattedDate4);
                  _TT2MMController.text = getMonth(formattedDate4);
                  _TT2YYYYController.text = getYear(formattedDate4);
                }

              }
            }else{
              _showErrorPopup(Strings.please_selectd_before_register,Colors.black);
            }
          }
        }
      }
    });
  }

  void _selectTTBDatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();
      var selectedParsedDate = DateTime.parse(formattedDate4.toString());

      var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
      final diff_lmp_ancdate = selectedParsedDate.difference(intentAncDate).inDays;
      print('checkdifference ${diff_lmp_ancdate}');

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        print('done');
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{

          var registerDate = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
          print('registerDate ${registerDate}');//2021-03-12 00:00:00.000
          if(selectedParsedDate.compareTo(registerDate) >= 0){

            var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));
            print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
            final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
            print('after exptd date: ${exptedDate_281}');

            if(selectedParsedDate.compareTo(exptedDate_281) > 0){
              _showErrorPopup(Strings.please_select_before_date,Colors.black);
            }else{
              if(diff_lmp_ancdate > 0) {
                _showErrorPopup("TT date not grater then anc date", Colors.black);
              }else{
                var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
                print('last anc date: ${parseLastANCDate}');
                final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
                print('parseLastANCDate_28: ${parseLastANCDate_28}');
                if (selectedParsedDate.compareTo(parseLastANCDate_28) < 0) {
                  // print('greater date');
                  _showErrorPopup(Strings.tt_and_last_anc_date_greater_28days, Colors.black);
                }else{
                  _isTT1SelectedToggle(false);
                  _isTT2SelectedToggle(false);
                  _isTTBSelectedToggle(true);
                  _TTBDDController.text = getDate(formattedDate4);
                  _TTBMMController.text = getMonth(formattedDate4);
                  _TTBYYYYController.text = getYear(formattedDate4);
                }
              }
            }
          }else{
            _showErrorPopup(Strings.please_selectd_before_register,Colors.black);
          }


        }
      }
    });
  }

  void _selectIFA180DatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();
      var selectedParsedDate = DateTime.parse(formattedDate4.toString());

      var intentAncDate = DateTime.parse(getConvertRegDateFormat(_yourSelectedANCDate));
      final diff_lmp_ancdate = selectedParsedDate.difference(intentAncDate).inDays;
      print('checkdifference ${diff_lmp_ancdate}');

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        print('done');
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{
          var parsedDate1 = DateTime.parse(formattedDate4.toString());
          var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
          if (parsedDate1.compareTo(parsedDate2) > 0) {

            print('greater date YYYYYYYYY');
            var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
            //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
            if (parsedDate1.compareTo(_ancAPIDate) > 0) {
              print('greater date SSSSSS');
              _showErrorPopup(Strings.ifa_cant_after_anc_date,Colors.black);
            }else{

              var registerDate = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
              print('registerDate ${registerDate}');//2021-03-12 00:00:00.000
              if(selectedParsedDate.compareTo(registerDate) >= 0){

                var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));
                print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
                final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
                print('after exptd date: ${exptedDate_281}');

                if(selectedParsedDate.compareTo(exptedDate_281) > 0){
                  _showErrorPopup(Strings.please_select_before_date,Colors.black);
                }else{
                  if(diff_lmp_ancdate > 0) {
                    _showErrorPopup("TT date not grater then anc date", Colors.black);
                  }else{
                    var parseLastANCDate = DateTime.parse(getConvertRegDateFormat(widget.anc_date));
                    print('last anc date: ${parseLastANCDate}');
                    final parseLastANCDate_28 = parseLastANCDate.add(const Duration(days: 28));
                    print('parseLastANCDate_28: ${parseLastANCDate_28}');
                    if (selectedParsedDate.compareTo(parseLastANCDate_28) < 0) {
                      // print('greater date');
                      _showErrorPopup(Strings.tt_and_last_anc_date_greater_28days, Colors.black);
                    }else{
                      _IFA180DDController.text = getDate(formattedDate4);
                      _IFA180MMController.text = getMonth(formattedDate4);
                      _IFA180YYYYController.text = getYear(formattedDate4);
                    }
                  }
                }
              }else{
                _showErrorPopup(Strings.please_selectd_before_register,Colors.black);
              }
            }
          }else{
            _showErrorPopup(Strings.ifa_cant_before_reg_date,Colors.black);
          }
        }
      }
    });
  }

  void _selectIFA360DatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        print('done');
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{
          var parsedDate1 = DateTime.parse(formattedDate4.toString());
          var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date));
          if (parsedDate2.compareTo(parsedDate1) > 0) {

            print('greater date YYYYYYYYY');
            var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
            //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
            if (parsedDate1.compareTo(_ancAPIDate) > 0) {
              print('greater date SSSSSS');
              _showErrorPopup(Strings.ifa_cant_after_anc_date,Colors.black);
            }else{

              _IFA360DDController.text = getDate(formattedDate4);
              _IFA360MMController.text = getMonth(formattedDate4);
              _IFA360YYYYController.text = getYear(formattedDate4);
            }
          }else{
            _showErrorPopup(Strings.ifa_cant_before_reg_date,Colors.black);
          }
        }

      }
    });
  }

  void _selectAlbaDoseDatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        print('done');
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,Colors.black);
        }else{
          var parsedDate1 = DateTime.parse(formattedDate4.toString());
          var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
          if (parsedDate1.compareTo(parsedDate2) > 0) {
             print('greater date YYYYYYYYY');
            var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
            //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
            if (parsedDate1.compareTo(_ancAPIDate) > 0) {
              print('greater date SSSSSS');
              _showErrorPopup(Strings.tab_albedazole_cant_after_anc_date,Colors.black);
            }else{
              print('lssthan dateFFFFFFFF');

              var selectedParsedDate = DateTime.parse(formattedDate4.toString());
              var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));

              print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
              final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
              print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000
              if (selectedParsedDate.compareTo(exptedDate_281) > 0) {
                // print('greater date');
                _showErrorPopup(Strings.please_select_before_date,Colors.black);
              }else{
                var ancParsedDate = DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));
                final ancDate_41 = ancParsedDate.add(const Duration(days: 41));
                print('after anc date: ${ancDate_41}');//2021-10-25 00:00:00.000
                var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
                if(widget.anc_date.isNotEmpty && ancDate_41.compareTo(_ancAPIDate) < 0){
                  _showErrorPopup(Strings.anc_41_days_validation,Colors.black);
                }else{
                  /*
                    * When COVID Start
                  */
                  var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
                  //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

                  var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
                  //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
                  if (_ancAPIDate.compareTo(covidDate) > 0) {
                    //print('greater covid date');
                    _showCovid19View(true);
                  }else{
                    //print('lssthan before date');
                    _showCovid19View(false);
                  }

                  _AlbadoseDDController.text = getDate(formattedDate4);
                  _AlbadoseMMController.text = getMonth(formattedDate4);
                  _AlbadoseYYYYController.text = getYear(formattedDate4);
                }
              }
            }
          } else {
            _showErrorPopup(Strings.tab_albedazole_cant_before_reg_date,Colors.black);
          }

        }
      }
    });
  }

  void _selectCalciumVitaminDDatePopup(int yyyy,int mm ,int dd){
    showDatePicker(
        context: context,
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      _selectedANCDate = formattedDate2.toString();

      if(_ancDDdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancMMdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else if(_ancYYYYdateController.text.isEmpty){
        _showErrorPopup(Strings.please_select_Anc_date, Colors.black);
      }else{
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          //print('equal to current date#########');
          _showErrorPopup(Strings.calciumvitamin_cant_after_current_date,Colors.black);
        }else{

          var parsedDate1 = DateTime.parse(formattedDate4.toString());
          var parsedDate2 = DateTime.parse(getConvertRegDateFormat(widget.registered_date2));
          if (parsedDate1.compareTo(parsedDate2) > 0) {
            print('greater date YYYYYYYYY');
            var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
            //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
            if (parsedDate1.compareTo(_ancAPIDate) > 0) {
              print('greater date SSSSSS');
              _showErrorPopup(Strings.calciumvitamin_cant_after_anc_date,Colors.black);
            }else{
              print('lssthan dateFFFFFFFF');

              var selectedParsedDate = DateTime.parse(formattedDate4.toString());
              var expectedParsedDate = DateTime.parse(getConvertRegDateFormat(widget.expected_date));

              print('current exptd date: ${expectedParsedDate}');//2021-01-17 00:00:00.000
              final exptedDate_281 = expectedParsedDate.add(const Duration(days: 281));
              print('after exptd date: ${exptedDate_281}');//2021-10-25 00:00:00.000
              if (selectedParsedDate.compareTo(exptedDate_281) > 0) {
                // print('greater date');
                _showErrorPopup(Strings.please_select_before_date,Colors.black);
              }else{
                var ancParsedDate = DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));
                final ancDate_41 = ancParsedDate.add(const Duration(days: 41));
                print('after anc date: ${ancDate_41}');//2021-10-25 00:00:00.000
                /*var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
                if(widget.anc_date.isNotEmpty && ancDate_41.compareTo(_ancAPIDate) < 0){
                  _showErrorPopup(Strings.do_anc_kai_bich,Colors.black);
                }else{*/
                  /*
                        * When COVID Start
                      */
                  var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
                  //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

                  var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(_ancYYYYdateController.text.toString()+"-"+_ancMMdateController.text.toString()+"-"+_ancDDdateController.text.toString()));;
                  //print('_ancAPIDate ${_ancAPIDate}');//2021-03-12 00:00:00.000
                  if (_ancAPIDate.compareTo(covidDate) > 0) {
                    //print('greater covid date');
                    _showCovid19View(true);
                  }else{
                    //print('lssthan before date');
                    _showCovid19View(false);
                  }
                  _CalciumVitaminD3DDController.text = getDate(formattedDate4);
                  _CalciumVitaminD3MMController.text = getMonth(formattedDate4);
                  _CalciumVitaminD3YYYYController.text = getYear(formattedDate4);
                //}
              }
            }
          } else {
            _showErrorPopup(Strings.calciumvitamin_cant_before_reg_date,Colors.black);
          }
        }
      }
    });
  }

  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  getCurrentDate2() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

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

    if(widget.ReferUnitType.isNotEmpty){
      for (int i = 0; i < custom_placesrefer_list.length; i++) {
        if (widget.ReferUnitType == custom_placesrefer_list[i].code.toString()) {
          _selectedPlacesReferCode = custom_placesrefer_list[i].code.toString();
          print('RegUnitTYpeafter ${_selectedPlacesReferCode}');
          getDistrictListAPI("3");
          break;
        }
      }
    }
  }

  void getHBHeightCheck(String _hb,String _height) {
    print('HB $_hb');
    print('Height $_height');
    setState(() {
      if(_hb.isEmpty){
        _isIronSukrojViewToggle(false);//hide sukroj view on empty
        _highAnaimiyaCheckb=false;
        custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 0);//remove 7 from csv ids
      }else if(double.parse(_hb) < 10.0){
              if(double.parse(_hb) <= 7.0){
                _highAnaimiyaCheckb=true;
                custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 0,rishValue: "7"));//add 7 in csv
                _isIFA180View=false;
                _isIFA360View=true;

                if(widget.Age != "null"){
                  if (int.parse(widget.Age) < 18 || int.parse(widget.Age) > 35) {
                    _highRiskChecked=true;//checked highrisk chkbox
                    _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
                  }else if (double.parse(_hb) <= 7.0) {
                    _highRiskChecked=true;//checked highrisk chkbox
                    _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
                  } else{
                    _highRiskChecked=false;
                    _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
                  }
                }else{
                  _highAnaimiyaCheckb=false;
                  custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 0);//remove 7 from csv ids
                  _isIFA180View=true;
                  _isIFA360View=false;
                  _isIronSukrojViewToggle(true);

                  if (int.parse(widget.Age) < 18 || int.parse(widget.Age) > 35) {
                    _highRiskChecked=true;//checked highrisk chkbox
                    _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
                  } else {
                    _highRiskChecked=false;
                    _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
                  }

                }
              }else{

              }
      }else{
        _isIFA180View=true;
        _isIFA360View=false;
        _isIronSukrojViewToggle(false);

        _sukroj1DDController.text="";
        _sukroj1MMController.text="";
        _sukroj1YYYYController.text="";

        _sukroj2DDController.text="";
        _sukroj2MMController.text="";
        _sukroj2YYYYController.text="";

        _sukroj3DDController.text="";
        _sukroj3MMController.text="";
        _sukroj3YYYYController.text="";

        _sukroj4DDController.text="";
        _sukroj4MMController.text="";
        _sukroj4YYYYController.text="";

        _sukrojValue_Normal="";
        _Iron_sukroj_Post1 = "";
        _Iron_sukroj_Post2 = "";
        _Iron_sukroj_Post3 = "";
        _Iron_sukroj_Post4 = "";
        _highAnaimiyaCheckb=false;
        custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 0);//remove 7 from csv ids
        if (int.parse(widget.Age) < 18 ||int.parse(widget.Age)> 35) {
          _highRiskChecked=true;//checked highrisk chkbox
          _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
        } else {
          _highRiskChecked=false;
          _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
        }
      }


      if(_height.isEmpty){
          _chotakadCheckb=false;
          custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 3);//remove 9 from csv ids
          _mahilaHeightEnabledDisabled=true;
      }else if(int.parse(_height) <= 140){
        _chotakadCheckb=true;
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 3,rishValue: "9"));//add 9 from csv ids
        if (!_highRiskChecked == true) {
          if ((int.parse(widget.Age) < 18) && int.parse(widget.Age) > 35) {
            _highRiskChecked=true;//checked highrisk chkbox
            _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
          }
        }
      }else{
        _chotakadCheckb=false;
        custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 3);//remove 9 from csv ids
      }
    });
  }

  void getBloodPresourSystolicValue(String _bloodPresS) {
    print('_bloodPresS $_bloodPresS');

      setState(() {
        if(_bloodPresS.isEmpty){
          _ChotakadEnDisableCB=true;
          _highbloodpresourCheckb=false;
          custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 1);//remove 1 from csv
        }else if(int.parse(_bloodPresS) > 140){
          _highRiskChecked=true;//checked highrisk chkbox
          _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
          _highbloodpresourCheckb=true;
          custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 1,rishValue: "1"));//add 1 in csv listing
        }else{
          _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
          _highbloodpresourCheckb=false;
          custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 1);//remove 1 from csv
        }
      });
  }

  void getBloodPresourDiastolicValue(String _bloodPresD) {
    print('_bloodPresD $_bloodPresD');
    setState(() {
      if(_bloodPresD.isEmpty){

        _highbloodpresourCheckb=false;
        _ChotakadEnDisableCB=true;
        custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 1);//remove 1 from csv

      }else if(int.parse(_bloodPresD) > 90){
        _highRiskChecked=true;//checked highrisk chkbox
        _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
        _highbloodpresourCheckb=true;
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 1,rishValue: "1"));//add 1 in csv listing
      }else{
        _highRiskEnDisableCB=true;//enable or disable highrisk checkbox
        _highbloodpresourCheckb=false;
        custom_high_pragnancy_cvslist.removeWhere((item) => item.rishId == 1);//remove 1 from csv
      }
    });
  }

  void setPreviousData() {
    // if (!TextUtils.isEmpty(hb)) {
    //             if (Float.parseFloat(hb) <= 7.0) {
    //                 edt_hbCount.setText(hb);
    //                 LL_sukroj_layout.setVisibility(View.VISIBLE);
    //                 chk_highrisk.setEnabled(false);
    //                 chk_highrisk.setChecked(true);
    //             } else {
    //                 edt_hbCount.setText(hb);
    //                 LL_sukroj_layout.setVisibility(View.GONE);
    //             }
    //         }

    if(widget.HBCount.isNotEmpty){
      if(double.parse(widget.HBCount) <= 7.0){
        _animyaHBCountController.text=widget.HBCount.toString().trim();
        _isIronSukrojViewToggle(true);
      }else{
        _animyaHBCountController.text=widget.HBCount.toString().trim();
        _isIronSukrojViewToggle(false);
      }
    }



    _weightKiloGramController.text=widget.weight.toString().trim();
    print('TT1Date ${widget.TT1}');
    print('PreviousTT1Date ${widget.PreviousTT1Date}');




    if(widget.TT1.isNotEmpty){
      _TT1DatePost=widget.TT1;
      _isTT1SelectedToggle(true);

      _isTTBSelectedToggle(false);
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.TT1));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _TT1DDController.text=getDate(formattedDate4);
      _TT1MMController.text=getMonth(formattedDate4);
      _TT1YYYYController.text=getYear(formattedDate4);
      _isTT2SelectedToggle(true);
    }else{
      _isTT1SelectedToggle(false);
      _isTT2SelectedToggle(false);
      _isTTBSelectedToggle(true);
    }

    if(widget.TT2.isNotEmpty){
      _TT2DatePost=widget.TT2;
      _isTT1SelectedToggle(true);
      _isTT2SelectedToggle(true);
      _isTTBSelectedToggle(false);
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.TT2));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _TT2DDController.text=getDate(formattedDate4);
      _TT2MMController.text=getMonth(formattedDate4);
      _TT2YYYYController.text=getYear(formattedDate4);
    }

    if(widget.TTB.isNotEmpty){
      _TTBDatePost=widget.TTB;
      _isTT1SelectedToggle(false);
      _isTT2SelectedToggle(false);
      _isTTBSelectedToggle(true);
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.TTB));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _TTBDDController.text=getDate(formattedDate4);
      _TTBMMController.text=getMonth(formattedDate4);
      _TTBYYYYController.text=getYear(formattedDate4);

    }else{
      _isTTBSelectedToggle(false);
    }


    print('PreviousTT1Date ${widget.PreviousTT1Date}');
    print('PreviousTT2Date ${widget.PreviousTT2Date}');
    print('PreviousTTBDate ${widget.PreviousTTBDate}');
    if(widget.PreviousTT1Date.isNotEmpty){
      _isTT1SelectedToggle(false);
    }
    if(widget.PreviousTT2Date.isNotEmpty){
      _isTT2SelectedToggle(false);
    }
    if(widget.PreviousTTBDate.isNotEmpty){
      _isTT1SelectedToggle(false);
      _isTT2SelectedToggle(false);
    }



    if(widget.IFA.isNotEmpty){
      _IFADatePost=widget.IFA;

      if(double.parse(_animyaHBCountController.text.toString().trim()) > 11.0){
        _isIFA180View=true;
        _isIFA360View=false;

        var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IFA));
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
        _IFA180DDController.text=getDate(formattedDate4);
        _IFA180MMController.text=getMonth(formattedDate4);
        _IFA180YYYYController.text=getYear(formattedDate4);

      }else{
        _isIFA180View=false;
        _isIFA360View=true;

        var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IFA));
        String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
        _IFA360DDController.text=getDate(formattedDate4);
        _IFA360MMController.text=getMonth(formattedDate4);
        _IFA360YYYYController.text=getYear(formattedDate4);

      }

    }else{
      _isTTBSelectedToggle(false);
    }


    if(widget.BPS.isEmpty){
      _bloodpreshourSController.text="";
      _bloodpreshourDController.text="";
    }else{
      _bloodpreshourSController.text=widget.BPS;
      _bloodpreshourDController.text=widget.BPD;
      if(int.parse(widget.BPS) > 140){
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 4,rishValue: "10"));
        _purvJatilPrastutiCheckb=true;
        _highRiskChecked=true;
        _highRiskEnDisableCB=true;
      }

      if(int.parse(widget.BPD) > 90){
        custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 4,rishValue: "10"));
        _purvJatilPrastutiCheckb=true;
        _purvJatilPrastutiCheckb=true;
        _highRiskChecked=true;
        _highRiskEnDisableCB=false;
      }
    }



    if(widget.Height.isEmpty){
      setState(() {
        _mahilaHeightController.text="";
        _mahilaHeightEnabledDisabled=true;
      });
    }else{
      setState(() {
        _showHideMahilaHeightView=false;
        _mahilaHeightController.text=widget.Height.toString().trim();
        _mahilaHeightEnabledDisabled=false;


        if(int.parse(widget.Height.toString()) <= 140 ){
          custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 3,rishValue: "9"));

          _showHideHighRiskView=true;
          _highRiskChecked=true;//checked highrisk chkbox
          _chotakadCheckb=true;//checked chota kad  chkbox
          _highRiskEnDisableCB=false;//false = disble click event,true=enable click event

        }
      });
    }

    if(_highAnaimiyaCheckb != true &&
        _highbloodpresourCheckb != true &&
        _ageCheckb != true &&
        _chotakadCheckb != true &&
        _purvJatilPrastutiCheckb != true &&
        _APHCheckb != true &&
        _transverselieCheckb != true &&
        _madhumayeCheckb != true &&
        _heartRogCheckb != true &&
        _gurdaRogCheckb != true &&
        _otherCheckb != true &&
        _malairiyaCheckb != true){

      _showHideHighRiskView=false;
      _highRiskChecked=false;
      _highRiskEnDisableCB=true;
    }else{
      _showHideHighRiskView=true;
      _highRiskChecked=true;
      _highRiskEnDisableCB=false;
    }


    if(widget.ALBE400.isNotEmpty){
      _Tab_Alb_DatePost=widget.ALBE400;

      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.ALBE400));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _AlbadoseDDController.text=getDate(formattedDate4);
      _AlbadoseMMController.text=getMonth(formattedDate4);
      _AlbadoseYYYYController.text=getYear(formattedDate4);

    }

    if(widget.CAL500.isNotEmpty){
      _cal_DatePost=widget.CAL500;

      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.CAL500));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _CalciumVitaminD3DDController.text=getDate(formattedDate4);
      _CalciumVitaminD3MMController.text=getMonth(formattedDate4);
      _CalciumVitaminD3YYYYController.text=getYear(formattedDate4);

    }

    if(widget.RTI.isNotEmpty){
      if(widget.RTI == "0"){
        setState(() {
          _rtl = Rtl.yes;
          _RTI_YES_NO="0";
        });
      }else{
        setState(() {
          _rtl = Rtl.no;
          _RTI_YES_NO="1";
        });
      }
    }

    if(widget.Media.isNotEmpty){
      _Media=widget.Media;
    }

    /*
      * When COVID Start
    */
    var covidDate = DateTime.parse(getConvertRegDateFormat("2020-03-01"));
    //print('covidDate ${covidDate}');//2021-03-12 00:00:00.000

    _showHideANCView=true;
    print('widget.anc_date ${widget.anc_date}');
    var _ancAPIDate= DateTime.parse(getConvertRegDateFormat(widget.anc_date));;
    _ancDDdateController.text = getDate(_ancAPIDate.toString());
    _ancMMdateController.text = getMonth(_ancAPIDate.toString());
    _ancYYYYdateController.text = getYear(_ancAPIDate.toString());
    _AncDatePost=_ancYYYYdateController.text.toString()+ "/"+_ancMMdateController.text.toString()+"/"+_ancDDdateController.text.toString();
    print('_AncDatePost $_AncDatePost');
    if (_ancAPIDate.compareTo(covidDate) > 0) {
      //print('greater covid date');
      _showCovid19View(true);
    }else{
      //print('lssthan before date');
      _showCovid19View(false);
    }


    print('widget.CovidCase ${widget.CovidCase}');
    if(widget.CovidCase.isNotEmpty){
      setState(() {
        if(widget.CovidCase == "1"){
          _iscovidCase="1";
          _covidDDEnabledDisabled=true;
          _covidMMEnabledDisabled=true;
          _covidYYYYEnabledDisabled=true;
          _showCovid19DateView(true);
          _choose_covid_1=multiple_chooice.yes;
        }else if(widget.CovidCase == "2"){
          _iscovidCase="2";
          _showCovid19DateView(false);
          _covidDDEnabledDisabled=false;
          _covidMMEnabledDisabled=false;
          _covidYYYYEnabledDisabled=false;
          _covidDDdateController.text="";
          _covidMMdateController.text="";
          _covidYYYYdateController.text="";
          _choose_covid_1=multiple_chooice.no;
        }else{
          _iscovidCase="";
          _choose_covid_1=multiple_chooice.nill;

        }
      });
    }
    if(widget.CovidForeignTrip.isNotEmpty){
      setState(() {
        if(widget.CovidForeignTrip == "1"){
          _CovidForeignTrip=widget.CovidForeignTrip;
          _choose_covid_2=multiple_chooice.yes;
        }else if(widget.CovidForeignTrip == "2"){
          _CovidForeignTrip=widget.CovidForeignTrip;
          _choose_covid_2=multiple_chooice.no;
        }else{
          _choose_covid_2=multiple_chooice.nill;
          _CovidForeignTrip="";
        }
      });
    }

    if(widget.CovidRelativePossibility.isNotEmpty){
      setState(() {
        if(widget.CovidRelativePossibility == "1"){
          _CovidRelativePossibility=widget.CovidRelativePossibility;
          _choose_covid_3=multiple_chooice.yes;
        }else if(widget.CovidForeignTrip == "2"){
          _CovidRelativePossibility=widget.CovidRelativePossibility;
          _choose_covid_3=multiple_chooice.no;
        }else{
          _choose_covid_3=multiple_chooice.nill;
          _CovidRelativePossibility="";
        }
      });
    }
    if(widget.CovidRelativePositive.isNotEmpty){
      setState(() {
        if(widget.CovidRelativePossibility == "1"){
          _CovidRelativePositive=widget.CovidRelativePositive;
          _choose_covid_4=multiple_chooice.yes;
        }else if(widget.CovidForeignTrip == "2"){
          _CovidRelativePositive=widget.CovidRelativePositive;
          _choose_covid_4=multiple_chooice.no;
        }else{
          _choose_covid_4=multiple_chooice.nill;
          _CovidRelativePositive="";
        }
      });
    }
    if(widget.CovidQuarantine.isNotEmpty){
      setState(() {
        if(widget.CovidRelativePossibility == "1"){
          _CovidQuarantine=widget.CovidQuarantine;
          _choose_covid_5=multiple_chooice.yes;
        }else if(widget.CovidForeignTrip == "2"){
          _CovidQuarantine=widget.CovidQuarantine;
          _choose_covid_5=multiple_chooice.no;
        }else{
          _choose_covid_5=multiple_chooice.nill;
          _CovidQuarantine="";
        }
      });
    }

    if(widget.CovidIsolation.isNotEmpty){
      setState(() {
        if(widget.CovidRelativePossibility == "1"){
          _CovidIsolation=widget.CovidIsolation;
          _choose_covid_6=multiple_chooice.yes;
        }else if(widget.CovidForeignTrip == "2"){
          _CovidIsolation=widget.CovidIsolation;
          _choose_covid_6=multiple_chooice.no;
        }else{
          _choose_covid_6=multiple_chooice.nill;
          _CovidIsolation="";
        }
      });
    }
    //   var _covidDate="";// set value for api request
    if(widget.CovidFromDate.isNotEmpty){
        setState(() {
          var _CovidFromDateDate= DateTime.parse(getConvertRegDateFormat(widget.CovidFromDate));;
          _covidDDdateController.text = getDate(_CovidFromDateDate.toString());
          _covidMMdateController.text = getMonth(_CovidFromDateDate.toString());
          _covidYYYYdateController.text = getYear(_CovidFromDateDate.toString());
          if(_covidDDdateController.text.isNotEmpty){
            _covidDate=_covidYYYYdateController.text.toString()+"/"+_covidMMdateController.text.toString()+"/"+_covidDDdateController.text.toString();
          }
        });
    }

    if(widget.IronSucrose1.isNotEmpty){
      _Iron_sukroj_Post1=widget.IronSucrose1;
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IronSucrose1));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _sukroj1DDController.text=getDate(formattedDate4);
      _sukroj1MMController.text=getMonth(formattedDate4);
      _sukroj1YYYYController.text=getYear(formattedDate4);
    }
    if(widget.IronSucrose2.isNotEmpty){
      _Iron_sukroj_Post2=widget.IronSucrose2;
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IronSucrose2));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _sukroj2DDController.text=getDate(formattedDate4);
      _sukroj2MMController.text=getMonth(formattedDate4);
      _sukroj2YYYYController.text=getYear(formattedDate4);
    }
    if(widget.IronSucrose3.isNotEmpty){
      _Iron_sukroj_Post3=widget.IronSucrose3;
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IronSucrose3));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _sukroj3DDController.text=getDate(formattedDate4);
      _sukroj3MMController.text=getMonth(formattedDate4);
      _sukroj3YYYYController.text=getYear(formattedDate4);
    }
    if(widget.IronSucrose4.isNotEmpty){
      _Iron_sukroj_Post4=widget.IronSucrose4;
      var parseToDate = DateTime.parse(getConvertRegDateFormat(widget.IronSucrose4));
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(parseToDate);
      _sukroj4DDController.text=getDate(formattedDate4);
      _sukroj4MMController.text=getMonth(formattedDate4);
      _sukroj4YYYYController.text=getYear(formattedDate4);
    }
    if(widget.NormalLodingIronSucrose1.isNotEmpty){
      _sukrojValue_Normal=widget.NormalLodingIronSucrose1;
      if(widget.NormalLodingIronSucrose1 == "1"){
        setState(() {
          _IronSukrojChoose = IronSukrojChoose.normal;
        });
      }else if(widget.NormalLodingIronSucrose1 == "2"){
        setState(() {
          _IronSukrojChoose = IronSukrojChoose.loading;
        });
      }else{
        _IronSukrojChoose = IronSukrojChoose.none;
      }
    }

    if(widget.UrineA.isNotEmpty){
      setState(() {
        _apiUrineCodeA=widget.UrineA;
        _selectedUrineRange_A = widget.UrineA;
        print('_selectedUrineRange_A:$_selectedUrineRange_A');
        if(widget.UrineA == "1"){
          _selectedUrineRange_A="+";
          _apiUrineCodeA="1";
        }else if(widget.UrineA == "2"){
          _selectedUrineRange_A="+ +";
          _apiUrineCodeA="2";
        }else if(widget.UrineA == "3"){
          _selectedUrineRange_A="+ + +";
          _apiUrineCodeA="3";
        }else if(widget.UrineA == "4"){
          _selectedUrineRange_A="+ + + +";
          _apiUrineCodeA="4";
        }else if(widget.UrineA == "5"){
          _selectedUrineRange_A="+ + + + +";
          _apiUrineCodeA="5";
        }else if(widget.UrineA == "0"){
          _selectedUrineRange_A="चुनें";
          _apiUrineCodeA="";
        }
      });

    }

    if(widget.UrineS.isNotEmpty){
      setState(() {
        _apiUrineCodeS=widget.UrineS;
        _selectedUrineRange_S = widget.UrineS;
        if(widget.UrineS == "1"){
          _selectedUrineRange_S="+";
          _apiUrineCodeS="1";
        }else if(widget.UrineS == "2"){
          _selectedUrineRange_S="+ +";
          _apiUrineCodeS="2";
        }else if(_selectedUrineRange_S == "3"){
          _selectedUrineRange_S="+ + +";
          _apiUrineCodeS="3";
        }else if(_selectedUrineRange_S == "4"){
          _selectedUrineRange_S="+ + + +";
          _apiUrineCodeS="4";
        }else if(_selectedUrineRange_S == "5"){
          _selectedUrineRange_S="+ + + + +";
          _apiUrineCodeS="5";
        }else if(_selectedUrineRange_S == "0"){
          _selectedUrineRange_S="चुनें";
          _apiUrineCodeS="";
        }
      });
    }

    //custom_high_pragnancy_cvslist
    if(widget.COMPL.isNotEmpty){
      setState(() {
        //final tagName = 'grubs, sheep';
        final tagName =widget.COMPL;
        final split = tagName.split(',');
        print('split.length ${split.length}');
        for (int i = 0; i < split.length; i++){
          if(split[i] == "7"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 0,rishValue: "7"));
            _highAnaimiyaCheckb=true;
          }else if(split[i] == "1"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 1,rishValue: "1"));
            _highbloodpresourCheckb = true;
          }else if(split[i] == "8"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 2,rishValue: "8"));
            _ageCheckb = true;
          }else if(split[i] == "9"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 3,rishValue: "9"));
            _chotakadCheckb = true;
          }else if(split[i] == "10"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 4,rishValue: "10"));
            _purvJatilPrastutiCheckb = true;
          }else if(split[i] == "3"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 5,rishValue: "3"));
            _APHCheckb = true;
          }else if(split[i] == "11"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 6,rishValue: "11"));
            _transverselieCheckb = true;
          }else if(split[i] == "2"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 7,rishValue: "2"));
            _madhumayeCheckb = true;
          }else if(split[i] == "12"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 8,rishValue: "12"));
            _heartRogCheckb = true;
          }else if(split[i] == "13"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 9,rishValue: "13"));
            _gurdaRogCheckb = true;
          }else if(split[i] == "5"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 10,rishValue: "5"));
            _otherCheckb = true;
          }else if(split[i] == "4"){
            custom_high_pragnancy_cvslist.add(CustomHighRiskPragnancyList(rishId: 11,rishValue: "4"));
            _malairiyaCheckb = true;
          }
        }
        _showHideHighRiskView=true;
        _highRiskChecked=true;//checked highrisk chkbox
        _highRiskEnDisableCB=false;//enable or disable highrisk checkbox
        print('PrevCOMPLen ${custom_high_pragnancy_cvslist.length}');
      });
    }

  }

  void closeOpenKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild!.unfocus();
    }
  }

}

colors _color = colors.blue;
Rtl _rtl = Rtl.none;
multiple_chooice _multiple_chooice = multiple_chooice.yes;

multiple_chooice _choose = multiple_chooice.nill; //radio button 1
multiple_chooice _choose2 = multiple_chooice.nill; //radio button 2
multiple_chooice _choose3 = multiple_chooice.nill; //radio button 3
multiple_chooice _choose4 = multiple_chooice.nill; //radio button 4
multiple_chooice _choose5 = multiple_chooice.nill; //radio button 5
multiple_chooice _choose6 = multiple_chooice.nill; //radio button 6

//Sukroj Radio Chooice
multiple_chooice _choose_sukroj_choice = multiple_chooice.nill; //radio button 1


//COVID-19 SYMTOMS VIEW
multiple_chooice _choose_covid_1 = multiple_chooice.nill; //radio button 1
multiple_chooice _choose_covid_2 = multiple_chooice.nill; //radio button 2
multiple_chooice _choose_covid_3 = multiple_chooice.nill; //radio button 3
multiple_chooice _choose_covid_4 = multiple_chooice.nill; //radio button 4
multiple_chooice _choose_covid_5 = multiple_chooice.nill; //radio button 5
multiple_chooice _choose_covid_6 = multiple_chooice.nill; //radio button 6

enum colors { red, green, blue }

enum multiple_chooice { nill, yes, no }
enum Rtl { yes,no,none}
enum Pet { none,normal,loading}
Pet _pet = Pet.none;

enum IronSukrojChoose { none,normal,loading}
IronSukrojChoose _IronSukrojChoose = IronSukrojChoose.none;

const TYPE_NONE = 0;
const TYPE_DOG = 1;
const TYPE_CAT = 2;


class CustomHighRiskPragnancyList {
  int? rishId;//unique id for array list
  String? rishValue;

  CustomHighRiskPragnancyList({this.rishId, this.rishValue});
}

class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
}

class CustomAanganBadiList {
  String? NameH;
  String? NameE;
  String? AnganwariNo;
  String? LastUpdated;

  CustomAanganBadiList(
      {this.NameH, this.NameE, this.AnganwariNo, this.LastUpdated});
}

class CustomUrineRangeList {
  String? range;

  CustomUrineRangeList({this.range});
}

class CustomTreatmentCodeList {
  String? code;

  CustomTreatmentCodeList({this.code});
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
