import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart'; //for date format
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/before/model/GetVillageListData.dart';
import '../samparksutra/samparksutra.dart';
import '../shishudeath/model/GetCHCPHCData.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'carts/model/ChartBlockListData.dart';
import 'model/GetChartCHCPHCData.dart';
import 'model/GetChartSubCenterData.dart';
import 'model/SaChartDashboardData.dart';
import 'model/StatePieBarChartData.dart';
import 'model/SubCenterChartDataList.dart';

class RCHChartDashboard extends StatefulWidget {
  const RCHChartDashboard({Key? key}) : super(key: key);

  @override
  State<RCHChartDashboard> createState() => _RCHChartDashboardState();
}

class _RCHChartDashboardState extends State<RCHChartDashboard> {
  var incr_next_year = "";
  var fin_next_year = "0";
  var parse_year = 0;
  var curr_parse_yr=0;
  var head_financl_yr="";
  List help_response_listing = [];
  var _districtHeading=Strings.top_7_district_performer;
  var _blockHeading=Strings.top_7_block_performer;

  var _get_village_list = AppConstants.app_base_url+"DashboardUnitDDL";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _get_anm_chart_details_url = AppConstants.app_base_url + "CreateDashboard";
  var _chart_click_detail_api = AppConstants.app_base_url + "CreateDashboardafterclickForSterliandSexRatio";
  var _chart_subcenter_detail_api = AppConstants.app_base_url + "CreateDashboardafterclickForSterliandSexRatio";
  var _state_pie_chart_api = AppConstants.app_base_url + "CreateDashboardafterclick";
  late SharedPreferences preferences;
  var _selected=false;
  var _selectedTab=true;
  var _selected2Tab=false;
  var count=1;
  var ifTabOne=false;
  var isResultShow=false;
  List villages_list = [];
  late String DistrictId="0";
  var post_unit_type="1";
  var post_unit_code="0";
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
    getVillageListAPI();
    return "Success";
  }



  /*
  * API FOR Village  LISTING
  * */
  Future<String> getVillageListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitcode ${preferences.getString("UnitCode")}');//00000000000
    print('LoginUnitType ${preferences.getString("UnitID")}');//1
    print('TokenNo ${preferences.getString("Token")}');
    print('UserID ${preferences.getString("UserId")}');
    var response = await post(Uri.parse(_get_village_list), body: {
      //LoginUnitcode:00000000000
      // LoginUnitType:1
      // TokenNo:284a1b3e-12d7-485c-8d2c-7d5da2e887fa
      // UserID:sa
      "LoginUnitcode":preferences.getString("UnitCode"),
      "LoginUnitType":preferences.getString("UnitID"),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetVillageListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        villages_list = resBody['ResposeData'];
        DistrictId = resBody['ResposeData'][0]['Unitcode'].toString();
        print('villages_list.len ${villages_list.length}');
        print('DistrictId ${DistrictId}');




      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    getCurrentYear();
    print('vilage.len:${apiResponse.message}');
    return "Success";
  }

  var _totalANCReg=0;
  var _ANCRegTrimister=0;
  var _AfterANCRegTrimister=0;

  var _liveMaleBirth=0;
  var _liveFeMaleBirth=0;
  var _stillBirth=0;

  var _delPublic=0;
  var _delPrivate=0;
  var _delHome=0;

  var _fullyImmunized=0;
  var _partImmunized=0;
  var _notImmunized=0;

  //Chart View Boolean
  bool _loadChart = false;
  bool _loadInfantChart = false;
  bool _loadDeliveryChart = false;
  bool _loadBirthChart = false;
  bool _loadFirstChart = false;
  bool _load7BlockChart = false;
  bool _loadMaternalDeathChart = false;
  bool _loadInafntDeathDeathChart = false;
  bool _loadIndicatorPerformanceChart = false;
  bool _loadSexRatioAtBirthChart = false;
  bool _loadVaccineReqChart = false;
  bool _loadSterlizationChart = false;
  bool _loadReasonWiseChart = false;



  List response_anc_dashboard = [];
  List response_anm_dashboard = [];
  List response_block_dashboard = [];
  List response_birth_dashboard = [];
  List response_delivery_dashboard = [];
  List response_infant_dashboard = [];

  List response_infantdeath_dashboard = [];
  List response_maternaldeath_dashboard = [];
  List response_indicatorperformace_dashboard = [];

  List response_sexratioatbirth_dashboard = [];
  List response_vaccinereq_dashboard = [];
  List response_sterlization_dashboard = [];
  List response_reasonwise_dashboard = [];

  List<AncRegisterData>? ancChartData;
  List<BirthTotalData>? birthChartData;
  List<DeliveryData>? deliveryChartData;
  List<InfantData>? infantChartData;
  List<TopSevenDistrictData> topSevenDistrictData=[];
  List<TopSevenBlockData> top7BlockPerformance=[];

  List<MaternalData> maternalDeathData=[];
  List<InfantDeathData> infantDeathData=[];
  List<IndicatorwiseData> indicatorPerformData=[];

  List<SexRatioAtBirthData> sexRatioAtBirthData=[];
  List<VaccineRequireData> vaccineRequiremntData=[];
  List<SterlizationData> sterlizationData=[];
  List<ReasonWiseHighRiskData> reasonWiseData=[];

  var _ancRegisterCount="";
  var _totalBirthCount="";
  var _totalDeliveryCount="";
  var _totalChilderenRegCount="";

  //popup chart array's
  List<ClickDistrictData> clickDistrictData=[];
  List<ClickDistrictChildData> clickDistrictChildData=[];
  List<ClickDistrictSubCenterData> clickDistrictSubCenterData=[];
  List<ClickBlockChildData> clickBlockPopupData=[];
  List<ClickBlockChildSubCntrData> clickBlockPopupSubCenterData=[];
  List<StatePieChartData> statePieChartData=[];
  List<SterlizeStateChartData> sterlizeStateChartData=[];
  List<ClickBlockChildData> stateBlockPieChartData=[];
  List<ClickBlockChildData> stateCHCPHCPieChartData=[];
  List<ClickBlockChildData> stateCHCPHCSubCentrPieChartData=[];
  List response_district_ = [];
  List response_district_child = [];
  List response_district_subcenter = [];
  List response_block_popup_data = [];
  List response_block_popup_subcntr_data = [];


  List response_state_sterlize_popup_data = [];
  List response_state_pie_popup_data = [];
  List response_state_block_popup_data = [];
  List response_state_block_chcphc_popup_data = [];
  List response_state_block_chcphc_subcntr_popup_data = [];

  Future<String> getChartDashboard(int parse_year) async {
    preferences = await SharedPreferences.getInstance();

    //change Heading according loggin session
    if(preferences.getString("UnitType").toString() == "1"){ //On Click show Block Data
      _districtHeading=Strings.top_7_district_performer;
      _blockHeading=Strings.top_7_block_performer;
    }else if(preferences.getString("UnitType").toString() == "3"){
      _districtHeading=Strings.top_7_block_performer;
      _blockHeading=Strings.top_7_chc_performer;
    }else if(preferences.getString("UnitType").toString() == "4"){

    }else if(preferences.getString("UnitType").toString() == "9"){

    }
    print('LoginUnitcode ${preferences.getString("UnitCode")}');//00000000000,01010000000
    print('LoginUnitType ${preferences.getString("UnitID")}');//1 , 3
    if(preferences.getString("UnitID").toString() == "3"){
      post_unit_type=preferences.getString("UnitID").toString();
      post_unit_code=preferences.getString("UnitCode").toString().substring(0, 4);
    }
    /*print('UnitType:....> ${post_unit_type}');
    print('UnitCode:....> ${post_unit_code}');
    print('Token:....> ${preferences.getString("Token")}');
    print('UserId:....> ${preferences.getString("UserId")}');*/
    var response = await post(Uri.parse(_get_anm_chart_details_url), body: {
      "LoginUnitType":post_unit_type,
      "LoginUnitCode": post_unit_code,
      "finyear": parse_year.toString(),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = SaChartDashboardData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_anm_dashboard.clear();
        response_block_dashboard.clear();
        response_anc_dashboard.clear();
        response_birth_dashboard.clear();
        response_delivery_dashboard.clear();
        response_infant_dashboard.clear();
        response_infantdeath_dashboard.clear();
        response_maternaldeath_dashboard.clear();
        response_indicatorperformace_dashboard.clear();
        EasyLoading.dismiss();
        response_anm_dashboard = resBody['ResposeData']['top7DistrictPerformance'];
        response_block_dashboard = resBody['ResposeData']['top7BlockPerformance'];
        response_anc_dashboard = resBody['ResposeData']['ancRegDashboard'];
        response_birth_dashboard = resBody['ResposeData']['birthDetails'];
        response_delivery_dashboard = resBody['ResposeData']['deliveryDetails'];
        response_infant_dashboard = resBody['ResposeData']['immunizationDetails'];
        response_maternaldeath_dashboard = resBody['ResposeData']['maternalDeaths'];
        response_infantdeath_dashboard = resBody['ResposeData']['infantDeaths'];
        response_indicatorperformace_dashboard = resBody['ResposeData']['indicatorWisePerformance'];
        response_sexratioatbirth_dashboard = resBody['ResposeData']['sexRatio'];
        response_vaccinereq_dashboard = resBody['ResposeData']['vaccineRequirement'];
        response_sterlization_dashboard = resBody['ResposeData']['sterlization'];
        response_reasonwise_dashboard = resBody['ResposeData']['highRisk'];
        /*
        * assign value after length
        * */
        if(response_anc_dashboard.length >0){
          _ancRegisterCount = resBody['ResposeData']['ancRegDashboard'][0]['TotalANCReg'].toString();
        }
        if(response_birth_dashboard.length > 0){
          _totalBirthCount = resBody['ResposeData']['birthDetails'][0]['totalBirth'].toString();
        }
        if(response_delivery_dashboard.length > 0){
          _totalDeliveryCount = resBody['ResposeData']['deliveryDetails'][0]['totalDelivery'].toString();
        }
        if(response_infant_dashboard.length > 0){
          _totalChilderenRegCount = resBody['ResposeData']['immunizationDetails'][0]['totalChilderenReg'].toString();
        }
        //print('top7D.len ${response_anm_dashboard.length}');
        //print('top7B.len ${response_block_dashboard.length}');
        //print('_ancRegisterCount ${_ancRegisterCount}');
        //print('top7.unitname ${response_anm_dashboard[5]['unitname'].toString()}');
        if(response_anm_dashboard.length > 0){
          _loadFirstChart=true;

          if(topSevenDistrictData != null)topSevenDistrictData.clear();
            for (int i = 0; i < response_anm_dashboard.length; i++) {
              topSevenDistrictData.add(TopSevenDistrictData(response_anm_dashboard[i]['unitname'].toString(),
                  response_anm_dashboard[i]['unitcode'].toString(),
                  response_anm_dashboard[i]['unittype'].toString(),
                  double.parse(response_anm_dashboard[i]['performacePer'].toString()),
                  Color.fromRGBO(_random.nextInt(256),
                      _random.nextInt(256),
                      _random.nextInt(256),
                      10)));
            }
        }else{
          _loadFirstChart=false;
        }

        if(response_block_dashboard.length > 0){
          _load7BlockChart=true;

          if(top7BlockPerformance != null)top7BlockPerformance.clear();
            for (int i = 0; i < response_block_dashboard.length; i++) {
              top7BlockPerformance.add(TopSevenBlockData(response_block_dashboard[i]['unitname'].toString(),
                  response_block_dashboard[i]['unitcode'].toString(),
                  response_block_dashboard[i]['unittype'].toString(),
                  double.parse(response_block_dashboard[i]['performacePer'].toString()),
                  Color.fromRGBO(_random.nextInt(256),
                      _random.nextInt(256),
                      _random.nextInt(256),
                      10)));
            }
        }else{
          _load7BlockChart=false;
        }

        if(response_anc_dashboard.length > 0){
          _loadChart=true;
          _totalANCReg=response_anc_dashboard[0]['TotalANCReg'];
          _ANCRegTrimister=response_anc_dashboard[0]['ANCRegTrimister'];
          _AfterANCRegTrimister=_totalANCReg-_ANCRegTrimister;

          var total=0.0;

          total=total+response_anc_dashboard[0]['TotalANCReg'];

          if(ancChartData != null)ancChartData!.clear();
          ancChartData = [
            AncRegisterData('${((response_anc_dashboard[0]['ANCRegTrimister'] / total) * 100).toStringAsFixed(2)}%',
                response_anc_dashboard[0]['TotalANCReg'],
                const Color.fromRGBO(255, 255, 0,0)
            ),

            AncRegisterData('${(((response_anc_dashboard[0]['TotalANCReg']-response_anc_dashboard[0]['ANCRegTrimister']) / total) * 100).toStringAsFixed(2)}%',
                (response_anc_dashboard[0]['TotalANCReg']-response_anc_dashboard[0]['ANCRegTrimister']),
                const Color.fromRGBO(255, 0, 0,0)
            ),
          ];

        }else{
          _loadChart=false;
        }

        if(response_birth_dashboard.length > 0){
          _loadBirthChart=true;
          _liveMaleBirth=response_birth_dashboard[0]['liveMaleBirth'];
          _liveFeMaleBirth=response_birth_dashboard[0]['liveFeMaleBirth'];
          _stillBirth=response_birth_dashboard[0]['stillBirth'];

          var total=0.0;

          total=total+response_birth_dashboard[0]['totalBirth'];

          if(birthChartData != null)birthChartData!.clear();
          birthChartData = [
            BirthTotalData('${((response_birth_dashboard[0]['liveMaleBirth'] / total) * 100).toStringAsFixed(2)}%',
                response_birth_dashboard[0]['liveMaleBirth'],
                const Color.fromRGBO(255, 255, 0,0)
            ),

            BirthTotalData('${((response_birth_dashboard[0]['liveFeMaleBirth'] / total) * 100).toStringAsFixed(2)}%',
                response_birth_dashboard[0]['liveFeMaleBirth'],
                const Color.fromRGBO(255, 0, 0,0)
            ),

            BirthTotalData('${((response_birth_dashboard[0]['stillBirth'] / total) * 100).toStringAsFixed(2)}%',
                response_birth_dashboard[0]['stillBirth'],
                const Color.fromRGBO(51, 102, 255,0)
            ),

          ];

        }else{
          _loadBirthChart=false;
        }

        if(response_delivery_dashboard.length > 0){
          _loadDeliveryChart=true;
          _delPublic=response_delivery_dashboard[0]['delPublic'];
          _delPrivate=response_delivery_dashboard[0]['delPrivate'];
          _delHome=response_delivery_dashboard[0]['delHome'];

          var total=0.0;

          total=total+response_delivery_dashboard[0]['totalDelivery'];

          if(deliveryChartData != null)deliveryChartData!.clear();
          deliveryChartData = [
            DeliveryData('${((response_delivery_dashboard[0]['delPublic'] / total) * 100).toStringAsFixed(2)}%',
                response_delivery_dashboard[0]['delPublic'],
                const Color.fromRGBO(255, 255, 0,0)
            ),

            DeliveryData('${((response_delivery_dashboard[0]['delPrivate'] / total) * 100).toStringAsFixed(2)}%',
                response_delivery_dashboard[0]['delPrivate'],
                const Color.fromRGBO(255, 0, 0,0)
            ),

            DeliveryData('${((response_delivery_dashboard[0]['delHome'] / total) * 100).toStringAsFixed(2)}%',
                response_delivery_dashboard[0]['delHome'],
                const Color.fromRGBO(51, 102, 255,0)
            ),

          ];

        }else{
          _loadDeliveryChart=false;
        }

        if(response_infant_dashboard.length > 0){
          _loadInfantChart=true;
          _fullyImmunized=response_infant_dashboard[0]['fullyImmunized'];
          _partImmunized=response_infant_dashboard[0]['partImmunized'];
          _notImmunized=response_infant_dashboard[0]['notImmunized'];

          var total=0.0;

          total=total+response_infant_dashboard[0]['totalChilderenReg'];

          if(infantChartData != null)infantChartData!.clear();
          infantChartData = [
            InfantData('${((response_infant_dashboard[0]['fullyImmunized'] / total) * 100).toStringAsFixed(2)}%',
                response_infant_dashboard[0]['fullyImmunized'],
                const Color.fromRGBO(255, 255, 0,0)
            ),

            InfantData('${((response_infant_dashboard[0]['partImmunized'] / total) * 100).toStringAsFixed(2)}%',
                response_infant_dashboard[0]['partImmunized'],
                const Color.fromRGBO(255, 0, 0,0)
            ),

            InfantData('${((response_infant_dashboard[0]['notImmunized'] / total) * 100).toStringAsFixed(2)}%',
                response_infant_dashboard[0]['notImmunized'],
                const Color.fromRGBO(51, 102, 255,0)
            ),

          ];

        }else{
          _loadInfantChart=false;
        }
        if(response_maternaldeath_dashboard.length > 0){
          _loadMaternalDeathChart=true;

          if(maternalDeathData != null)maternalDeathData.clear();
          for (int i = 0; i < response_maternaldeath_dashboard.length; i++) {
            maternalDeathData.add(MaternalData(response_maternaldeath_dashboard[i]['unitname'].toString(),
                response_maternaldeath_dashboard[i]['unitcode'].toString(),
                response_maternaldeath_dashboard[i]['unittype'].toString(),
                double.parse(response_maternaldeath_dashboard[i]['deathCount'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadMaternalDeathChart=false;
        }

        if(response_infantdeath_dashboard.length > 0){
          _loadInafntDeathDeathChart=true;

          if(infantDeathData != null)infantDeathData.clear();
          for (int i = 0; i < response_infantdeath_dashboard.length; i++) {
            infantDeathData.add(InfantDeathData(response_infantdeath_dashboard[i]['unitname'].toString(),
                response_infantdeath_dashboard[i]['unitcode'].toString(),
                response_infantdeath_dashboard[i]['unittype'].toString(),
                double.parse(response_infantdeath_dashboard[i]['deathCount'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadInafntDeathDeathChart=false;
        }
        if(response_indicatorperformace_dashboard.length > 0){
          _loadIndicatorPerformanceChart=true;

          if(indicatorPerformData != null)indicatorPerformData.clear();
          for (int i = 0; i < response_indicatorperformace_dashboard.length; i++) {
            indicatorPerformData.add(IndicatorwiseData(response_indicatorperformace_dashboard[i]['indicatorNameH'].toString(),
                response_indicatorperformace_dashboard[i]['unitcode'].toString(),
                response_indicatorperformace_dashboard[i]['unittype'].toString(),
                double.parse(response_indicatorperformace_dashboard[i]['indicatorValue'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadIndicatorPerformanceChart=false;
        }



        if(response_sexratioatbirth_dashboard.length > 0){
          _loadSexRatioAtBirthChart=true;

          if(sexRatioAtBirthData != null)sexRatioAtBirthData.clear();
          for (int i = 0; i < response_sexratioatbirth_dashboard.length; i++) {
            sexRatioAtBirthData.add(SexRatioAtBirthData(response_sexratioatbirth_dashboard[i]['monthName'].toString(),
                response_sexratioatbirth_dashboard[i]['unitcode'].toString(),
                response_sexratioatbirth_dashboard[i]['unittype'].toString(),
                double.parse(response_sexratioatbirth_dashboard[i]['girlsRatio'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadSexRatioAtBirthChart=false;
        }

        if(response_vaccinereq_dashboard.length > 0){
          _loadVaccineReqChart=true;

          if(vaccineRequiremntData != null)vaccineRequiremntData.clear();
          for (int i = 0; i < response_vaccinereq_dashboard.length; i++) {
            vaccineRequiremntData.add(VaccineRequireData(response_vaccinereq_dashboard[i]['immuName'].toString(),
                response_vaccinereq_dashboard[i]['unitcode'].toString(),
                response_vaccinereq_dashboard[i]['unittype'].toString(),
                double.parse(response_vaccinereq_dashboard[i]['vaccineReqCount'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadVaccineReqChart=false;
        }

        if(response_sterlization_dashboard.length > 0){
          _loadSterlizationChart=true;

          if(sterlizationData != null)sterlizationData.clear();
          for (int i = 0; i < response_sterlization_dashboard.length; i++) {
            sterlizationData.add(SterlizationData(response_sterlization_dashboard[i]['monthName'].toString(),
                response_sterlization_dashboard[i]['unitcode'].toString(),
                response_sterlization_dashboard[i]['unittype'].toString(),
                response_sterlization_dashboard[i]['monthValue'].toString(),
                double.parse(response_sterlization_dashboard[i]['sterlizationCount'].toString()),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
          print('sterlizationData.len ${sterlizationData.length}');
        }else{
          _loadSterlizationChart=false;
        }

        if(response_reasonwise_dashboard.length > 0){
          _loadReasonWiseChart=true;

          if(reasonWiseData != null)reasonWiseData.clear();
          for (int i = 0; i < response_reasonwise_dashboard.length; i++) {
            reasonWiseData.add(ReasonWiseHighRiskData(response_reasonwise_dashboard[i]['highRiskNameH'].toString(),
                response_reasonwise_dashboard[i]['unitcode'].toString(),
                response_reasonwise_dashboard[i]['unittype'].toString(),
                double.parse(response_reasonwise_dashboard[i]['highRiskValue'].toStringAsFixed(1)),
                Color.fromRGBO(_random.nextInt(256),
                    _random.nextInt(256),
                    _random.nextInt(256),
                    10)));
          }
        }else{
          _loadReasonWiseChart=false;
        }
      }else{
        response_anc_dashboard.clear();
        response_anm_dashboard.clear();
        response_block_dashboard.clear();
        response_birth_dashboard.clear();
        response_delivery_dashboard.clear();
        response_infant_dashboard.clear();
        if(response_anm_dashboard.length == 0){
          _loadFirstChart=false;
        }else{
          _loadFirstChart=true;
        }
        if(response_block_dashboard.length == 0){
          _load7BlockChart=false;
        }else{
          _load7BlockChart=true;
        }
        if(response_anc_dashboard.length == 0){
          _loadChart=false;
        }else{
          _loadChart=true;
        }
        if(response_birth_dashboard.length == 0) {
          _loadBirthChart=false;
        }else{
          _loadBirthChart=true;
        }
        if(response_delivery_dashboard.length == 0) {
          _loadDeliveryChart=false;
        }else{
          _loadDeliveryChart=true;
        }
        if(response_infant_dashboard.length == 0) {
          _loadInfantChart=false;
        }else{
          _loadInfantChart=true;
        }
        if(response_maternaldeath_dashboard.length == 0) {
          _loadMaternalDeathChart=false;
        }else{
          _loadMaternalDeathChart=true;
        }
        if(response_infantdeath_dashboard.length == 0) {
          _loadInafntDeathDeathChart=false;
        }else{
          _loadInafntDeathDeathChart=true;
        }
        if(response_indicatorperformace_dashboard.length == 0) {
          _loadIndicatorPerformanceChart=false;
        }else{
          _loadIndicatorPerformanceChart=true;
        }
        if(response_sexratioatbirth_dashboard.length == 0) {
          _loadSexRatioAtBirthChart=false;
        }else{
          _loadSexRatioAtBirthChart=true;
        }
        if(response_vaccinereq_dashboard.length == 0) {
          _loadVaccineReqChart=false;
        }else{
          _loadVaccineReqChart=true;
        }
        if(response_sterlization_dashboard.length == 0) {
          _loadSterlizationChart=false;
        }else{
          _loadSterlizationChart=true;
        }
        if(response_reasonwise_dashboard.length == 0) {
          _loadReasonWiseChart=false;
        }else{
          _loadReasonWiseChart=true;
        }
        EasyLoading.dismiss();
      }
    });
    EasyLoading.dismiss();
    print('chart_response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getJilaChartDataAPI(int parse_year,String _first_heading,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    print('post_unit_type ${post_unit_type}');
    print('post_unit_code ${post_unit_code}');
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      "LoginUnitType":post_unit_type,
      "LoginUnitCode": post_unit_code,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_pie_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_pie_popup_data.length > 0) {
          if (statePieChartData != null) statePieChartData.clear();
          for (int i = 0; i < response_state_pie_popup_data.length; i++) {
            statePieChartData.add(
                StatePieChartData(response_state_pie_popup_data[i]['unitname'].toString(),
                    response_state_pie_popup_data[i]['unitcode'].toString(),
                    response_state_pie_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_pie_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showReasonJilaStateChartPopup(_first_heading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getReasonWisePositionAPI(int parse_year,String _first_heading,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    print('post_unit_type ${post_unit_type}');
    print('post_unit_code ${post_unit_code}');
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      "LoginUnitType":post_unit_type,
      "LoginUnitCode": post_unit_code,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_pie_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_pie_popup_data.length > 0) {
          if (statePieChartData != null) statePieChartData.clear();
          for (int i = 0; i < response_state_pie_popup_data.length; i++) {
            statePieChartData.add(
                StatePieChartData(response_state_pie_popup_data[i]['unitname'].toString(),
                    response_state_pie_popup_data[i]['unitcode'].toString(),
                    response_state_pie_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_pie_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showReasonWisePositionChartPopup(_first_heading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

 /*
 * Sterlize work
 * */
  Future<String> getSterlizeJilaChartDataAPI(int parse_year,String _first_heading,String _flag,String _mnthry) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:1
      // UnitCode:0
      // Flag:2
      // Mthyr:202104
      // finyear:2021
      // TokenNo:cb7202f2-3af5-4f5b-a0b0-0b1e4fb0b1f3
      // UserID:sa
      "UnitType":"1",//static for sterlization case
      "UnitCode": "0",//static for sterlizaton case
      "Mthyr":_mnthry,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_sterlize_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_sterlize_popup_data.length > 0) {
          if (sterlizeStateChartData != null) sterlizeStateChartData.clear();
          for (int i = 0; i < response_state_sterlize_popup_data.length; i++) {
            sterlizeStateChartData.add(
                SterlizeStateChartData(response_state_sterlize_popup_data[i]['unitname'].toString(),
                    response_state_sterlize_popup_data[i]['unitcode'].toString(),
                    response_state_sterlize_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_sterlize_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showSterlizationJilaStateChartPopup(_first_heading,_flag,_mnthry);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getSterlizeBlockChartDataAPI(int parse_year,String _unitcode,String _unittype,String _first_heading,String _flag,String _mnthry) async {
    preferences = await SharedPreferences.getInstance();
    /*print('UnitType ${_unittype}');
    print('UnitCode ${_unitcode}');
    print('_first_heading ${_first_heading}');
    print('_flag ${_flag}');
    print('_mnthry ${_mnthry}');*/
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:1
      // UnitCode:0
      // Flag:2
      // Mthyr:202104
      // finyear:2021
      // TokenNo:cb7202f2-3af5-4f5b-a0b0-0b1e4fb0b1f3
      // UserID:sa
      "UnitType":_unittype,//static for sterlization case
      "UnitCode": _unitcode,//static for sterlizaton case
      "Mthyr":_mnthry,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_sterlize_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_sterlize_popup_data.length > 0) {
          if (sterlizeStateChartData != null) sterlizeStateChartData.clear();
          for (int i = 0; i < response_state_sterlize_popup_data.length; i++) {
            sterlizeStateChartData.add(
                SterlizeStateChartData(response_state_sterlize_popup_data[i]['unitname'].toString(),
                    response_state_sterlize_popup_data[i]['unitcode'].toString(),
                    response_state_sterlize_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_sterlize_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      //showSterlizationJilaStateChartPopup(_first_heading,_flag);
      showSterlizeBlockChartPopup("",_first_heading,_flag,_mnthry);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getSterlizeCHCPHCChartDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _flag,String _mnthry) async {
    preferences = await SharedPreferences.getInstance();
    /*print('_unitCode ${_unitCode}');
    print('_unitType ${_unitType}');
    print('_subHeading ${_subHeading}');
    print('_flag ${_flag}');
    print('_mnthry ${_mnthry}');*/
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":_mnthry,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChartCHCPHCData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_chcphc_api = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_chcphc_api.length > 0) {
          if (chcphcResponseData != null) chcphcResponseData.clear();
          for (int i = 0; i < response_chcphc_api.length; i++) {
            chcphcResponseData.add(
                ClickBlockChildData(response_chcphc_api[i]['unitname'].toString(),
                    response_chcphc_api[i]['unitcode'].toString(),
                    response_chcphc_api[i]['unittype'].toString(),
                    response_chcphc_api[i]['BlockName'].toString(),
                    double.parse(response_chcphc_api[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      //CHC PHC data will be show
      showSterlizeCHCPHCPopup(_subHeading,_flag,_mnthry);
    });
    print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<void> showSterlizeCHCPHCPopup(String _subHeading,String _flag,String _mnthry) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${_popHeaderTitle} ',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_subHeading (${Strings.block})',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            // print('onChcphcClick ${chcphcResponseData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            //print('onChcphcClick ${chcphcResponseData[selectedPointIndexSubCenter].chartname.toString()}');
                            //on click subcenter data will be show
                            _getSterlizesubCenterDataAPI(curr_parse_yr,
                                chcphcResponseData[selectedPointIndexSubCenter].unitcode.toString(),
                                chcphcResponseData[selectedPointIndexSubCenter].unittype.toString(),
                                _subHeading,
                                chcphcResponseData[selectedPointIndexSubCenter].chartname.toString(),
                                chcphcResponseData[selectedPointIndexSubCenter].BlockName.toString(),
                                _flag,
                                _mnthry
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //   opacity: 0.9,
                          width: 1,
                          spacing: 0.1,
                          dataSource: chcphcResponseData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          //  xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 6 ? value.chartname.substring(0,6) : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.chc_phc_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getSterlizesubCenterDataAPI(int parse_year,String _unitCode,String _unitType,
      String _subHeading,String _subcntrHead,
      String _subcntrHead2,String _flag,String _mnthry) async {
    preferences = await SharedPreferences.getInstance();
    /*print('_unitCode ${_unitCode}');
    print('_flag ${_flag}');
    print('_unitType ${_unitType}');
    print('_subHeading ${_subHeading}');
    print('_subcntrHead ${_subcntrHead}');
    print('_subcntrHead2 ${_subcntrHead2}');*/
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":_mnthry,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChartSubCenterData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_subcntr_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_subcntr_popup_data.length > 0) {
          if (stateCHCPHCSubCentrPieChartData != null) stateCHCPHCSubCentrPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_subcntr_popup_data.length; i++) {
            stateCHCPHCSubCentrPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_subcntr_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_subcntr_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        20)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      //showStateBlockCHCPHCSubCenterChartPopup(_subHeading,_subcntrHead,_subcntrHead2);
      showSterlizeSubCenterChartPopup(_subHeading,_subcntrHead,_subcntrHead2);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<void> showSterlizeSubCenterChartPopup(String _heading,String _subCntrHead,String _subCntrHead2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${_popHeaderTitle}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('${Strings.financial_year} $head_financl_yr $_heading(${Strings.block}) -> $_subCntrHead(${_subCntrHead2}))',textAlign:TextAlign.left,style: TextStyle(fontSize: 13),),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            //print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            //print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chartname.toString()}');

                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //width: 10,
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: stateCHCPHCSubCentrPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  * Indicator work
  * */
  Future<String> getIndicatorJilaChartDataAPI(int parse_year,String _first_heading,String _flag,String _mnthry) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:1
      // UnitCode:0
      // Flag:2
      // Mthyr:202104
      // finyear:2021
      // TokenNo:cb7202f2-3af5-4f5b-a0b0-0b1e4fb0b1f3
      // UserID:sa
      "UnitType":"1",//static for sterlization case
      "UnitCode": "0",//static for sterlizaton case
      "Mthyr":_mnthry,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_sterlize_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_sterlize_popup_data.length > 0) {
          if (sterlizeStateChartData != null) sterlizeStateChartData.clear();
          for (int i = 0; i < response_state_sterlize_popup_data.length; i++) {
            sterlizeStateChartData.add(
                SterlizeStateChartData(response_state_sterlize_popup_data[i]['unitname'].toString(),
                    response_state_sterlize_popup_data[i]['unitcode'].toString(),
                    response_state_sterlize_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_sterlize_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showSterlizationJilaStateChartPopup(_first_heading,_flag,_mnthry);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }


  final _random = Random();
  Future<String> getChartClickDetailAPI(int parse_year,String _unitCode,String _unitType,String _headingNm,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_click_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":_flag,
      "Mthyr":parse_year.toString(),
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = ChartBlockListData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_district_ = resBody['ResposeData'];
        if(response_district_.length > 0) {
          if (clickDistrictData != null) clickDistrictData.clear();
          for (int i = 0; i < response_district_.length; i++) {
            clickDistrictData.add(
                ClickDistrictData(response_district_[i]['unitname'].toString(),
                    response_district_[i]['unitcode'].toString(),
                    response_district_[i]['unittype'].toString(),
                    double.parse(response_district_[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      //block data will be show
      showTop7DistrictPopup(_headingNm,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getChartChildClickDetailAPI(int parse_year,String _unitCode,String _unitType,String _headNme2) async {
    preferences = await SharedPreferences.getInstance();
    /*print('_unitType ${_unitType}');
    print('_unitCode ${_unitCode}');*/
    var response = await post(Uri.parse(_chart_click_detail_api), body: {
      //UnitType:3
      // UnitCode:0611
      // Flag:10
      // Mthyr:
      // finyear:2021
      // TokenNo:17b7584b-811f-4f43-ab36-f1069dd84b0a
      // UserID:sa
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":"10",
      "Mthyr":"",
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = ChartBlockListData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_district_child = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_district_child.length > 0) {
          if (clickDistrictChildData != null) clickDistrictChildData.clear();
          for (int i = 0; i < response_district_child.length; i++) {
            clickDistrictChildData.add(
                ClickDistrictChildData(response_district_child[i]['unitname'].toString(),
                    response_district_child[i]['unitcode'].toString(),
                    response_district_child[i]['unittype'].toString(),
                    double.parse(response_district_child[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showChildBlockPopup(_headNme2+"(ब्लॉक)");
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  List response_chcphc_api = [];
  List<ClickBlockChildData> chcphcResponseData=[];

  Future<String> getCHCPHCChartDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    print('_unitCode ${_unitCode}');
    print('_unitType ${_unitType}');
    print('_subHeading ${_subHeading}');
    print('_flag ${_flag}');
    print('parse_year ${parse_year.toString()}');
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":parse_year.toString(),
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChartCHCPHCData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_chcphc_api = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_chcphc_api.length > 0) {
          if (chcphcResponseData != null) chcphcResponseData.clear();
          for (int i = 0; i < response_chcphc_api.length; i++) {
            chcphcResponseData.add(
                ClickBlockChildData(response_chcphc_api[i]['unitname'].toString(),
                    response_chcphc_api[i]['unitcode'].toString(),
                    response_chcphc_api[i]['unittype'].toString(),
                    response_chcphc_api[i]['BlockName'].toString(),
                    double.parse(response_chcphc_api[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      //CHC PHC data will be show
      showCHCPHCPopup(_subHeading,_flag);
    });
    print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<void> showCHCPHCPopup(String _subHeading,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${_popHeaderTitle} ',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_subHeading (${Strings.block})',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                           // print('onChcphcClick ${chcphcResponseData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            //print('onChcphcClick ${chcphcResponseData[selectedPointIndexSubCenter].chartname.toString()}');
                            //on click subcenter data will be show
                            _subCenterDataAPI(curr_parse_yr,
                                chcphcResponseData[selectedPointIndexSubCenter].unitcode.toString(),
                                chcphcResponseData[selectedPointIndexSubCenter].unittype.toString(),
                                _subHeading,
                                chcphcResponseData[selectedPointIndexSubCenter].chartname.toString(),
                                chcphcResponseData[selectedPointIndexSubCenter].BlockName.toString(),
                                _flag
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                       //   opacity: 0.9,
                          width: 1,
                          spacing: 0.1,
                          dataSource: chcphcResponseData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                        //  xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 6 ? value.chartname.substring(0,6) : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.chc_phc_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Future<String> _subCenterDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _subcntrHead,String _subcntrHead2,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    /*print('_unitCode ${_unitCode}');
    print('_flag ${_flag}');
    print('_unitType ${_unitType}');
    print('_subHeading ${_subHeading}');
    print('_subcntrHead ${_subcntrHead}');
    print('_subcntrHead2 ${_subcntrHead2}');*/
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":parse_year.toString(),
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChartSubCenterData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_subcntr_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_subcntr_popup_data.length > 0) {
          if (stateCHCPHCSubCentrPieChartData != null) stateCHCPHCSubCentrPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_subcntr_popup_data.length; i++) {
            stateCHCPHCSubCentrPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_subcntr_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_subcntr_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        20)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showStateBlockCHCPHCSubCenterChartPopup(_subHeading,_subcntrHead,_subcntrHead2);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }


  Future<String> getChartSubCenterDetailAPI(int parse_year,String _unitCode,String _unitType,String _subHeading) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:3
      // UnitCode:0611
      // Flag:10
      // Mthyr:
      // finyear:2021
      // TokenNo:17b7584b-811f-4f43-ab36-f1069dd84b0a
      // UserID:sa
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":"10",
      "Mthyr":"",
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = SubCenterChartDataList.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_district_subcenter = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_district_subcenter.length > 0) {
          if (clickDistrictSubCenterData != null) clickDistrictSubCenterData.clear();
          for (int i = 0; i < response_district_subcenter.length; i++) {
            clickDistrictSubCenterData.add(
                ClickDistrictSubCenterData(response_district_subcenter[i]['unitname'].toString(),
                    response_district_subcenter[i]['unitcode'].toString(),
                    response_district_subcenter[i]['unittype'].toString(),
                    double.parse(response_district_subcenter[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showSubCenterPopup(_subHeading);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> statePieChartDataAPI(int parse_year,String _first_heading,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      //LoginUnitType:1
      // LoginUnitCode:00000000000
      // Flag:2
      // finyear:2021
      // TokenNo:e53edada-5209-441e-afe1-ac4f2f63b405
      // UserID:sa
      "LoginUnitType":post_unit_type,
      "LoginUnitCode": post_unit_code,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_pie_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_pie_popup_data.length > 0) {
          if (statePieChartData != null) statePieChartData.clear();
          for (int i = 0; i < response_state_pie_popup_data.length; i++) {
            statePieChartData.add(
                StatePieChartData(response_state_pie_popup_data[i]['unitname'].toString(),
                    response_state_pie_popup_data[i]['unitcode'].toString(),
                    response_state_pie_popup_data[i]['unittype'].toString(),
                    double.parse(response_state_pie_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showStateChartPopup(_first_heading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> stateBlockPieChartDataAPI(int parse_year,String _unitCode,String _unitType,String _firstHeading,String _finanHeading,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      //LoginUnitType:3
      // LoginUnitCode:0101
      // Flag:2
      // finyear:2021
      // TokenNo:e53edada-5209-441e-afe1-ac4f2f63b405
      // UserID:sa
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_popup_data.length > 0) {
          if (stateBlockPieChartData != null) stateBlockPieChartData.clear();
          for (int i = 0; i < response_state_block_popup_data.length; i++) {
            stateBlockPieChartData.add(
                ClickBlockChildData(response_state_block_popup_data[i]['unitname'].toString(),
                    response_state_block_popup_data[i]['unitcode'].toString(),
                    response_state_block_popup_data[i]['unittype'].toString(),
                    response_state_block_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }//fgfg
      showStateBlockChartPopup(_firstHeading,_finanHeading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> stateBlockPieChartCHCPHCDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _finsubhead,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      //LoginUnitType:3
      // LoginUnitCode:0101
      // Flag:2
      // finyear:2021
      // TokenNo:e53edada-5209-441e-afe1-ac4f2f63b405
      // UserID:sa
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_popup_data.length > 0) {
          if (stateCHCPHCPieChartData != null) stateCHCPHCPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_popup_data.length; i++) {
            stateCHCPHCPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showStateBlockCHCPHCChartPopup(_subHeading,_finsubhead,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> stateReasonWiseChartCHCPHCSubCentrDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _subcntrHead,String _subcntrHead2,String _flag,String _subHeading3) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      //LoginUnitType:3
      // LoginUnitCode:0101
      // Flag:2
      // finyear:2021
      // TokenNo:e53edada-5209-441e-afe1-ac4f2f63b405
      // UserID:sa
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_subcntr_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_subcntr_popup_data.length > 0) {
          if (stateCHCPHCSubCentrPieChartData != null) stateCHCPHCSubCentrPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_subcntr_popup_data.length; i++) {
            stateCHCPHCSubCentrPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_subcntr_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_subcntr_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        20)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showReasonWisePositionCHCPHCSubCenterChartPopup(_subHeading,_subcntrHead,_subcntrHead2,_subHeading3);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }


  Future<String> stateBlockPieChartCHCPHCSubCentrDataAPI(int parse_year,String _unitCode,String _unitType,String _subHeading,String _subcntrHead,String _subcntrHead2,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      //LoginUnitType:3
      // LoginUnitCode:0101
      // Flag:2
      // finyear:2021
      // TokenNo:e53edada-5209-441e-afe1-ac4f2f63b405
      // UserID:sa
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_subcntr_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_subcntr_popup_data.length > 0) {
          if (stateCHCPHCSubCentrPieChartData != null) stateCHCPHCSubCentrPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_subcntr_popup_data.length; i++) {
            stateCHCPHCSubCentrPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_subcntr_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_subcntr_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_subcntr_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        20)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showStateBlockCHCPHCSubCenterChartPopup(_subHeading,_subcntrHead,_subcntrHead2);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getBlockPopupDataAPI(
      int parse_year,
      String _unitCode,
      String _unitType,
      String _subHeading,
      String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:3
      // UnitCode:0611
      // Flag:10
      // Mthyr:
      // finyear:2021
      // TokenNo:17b7584b-811f-4f43-ab36-f1069dd84b0a
      // UserID:sa
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":_flag,
      "Mthyr":"",
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = SubCenterChartDataList.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_block_popup_data = resBody['ResposeData'];
        if(response_block_popup_data.length > 0) {
          if (clickBlockPopupData != null) clickBlockPopupData.clear();
          for (int i = 0; i < response_block_popup_data.length; i++) {
            clickBlockPopupData.add(
                ClickBlockChildData(response_block_popup_data[i]['unitname'].toString(),
                    response_block_popup_data[i]['unitcode'].toString(),
                    response_block_popup_data[i]['unittype'].toString(),
                    response_block_popup_data[i]['BlockName'].toString(),
                    double.parse(response_block_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showTop7BlockChildPopup(_subHeading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getBlockPopupSubCenterDataAPI(
      int parse_year,
      String _unitCode,
      String _unitType,
      String _subHeading,
      String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      //UnitType:3
      // UnitCode:0611
      // Flag:10
      // Mthyr:
      // finyear:2021
      // TokenNo:17b7584b-811f-4f43-ab36-f1069dd84b0a
      // UserID:sa
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":_flag,
      "Mthyr":"",
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = SubCenterChartDataList.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_block_popup_subcntr_data = resBody['ResposeData'];
       // print('response_block_popup ${response_block_popup_subcntr_data.length}');
        if(response_block_popup_subcntr_data.length > 0) {
          if (clickBlockPopupSubCenterData != null) clickBlockPopupSubCenterData.clear();
          for (int i = 0; i < response_block_popup_subcntr_data.length; i++) {
            clickBlockPopupSubCenterData.add(
                ClickBlockChildSubCntrData(response_block_popup_subcntr_data[i]['unitname'].toString(),
                    response_block_popup_subcntr_data[i]['unitcode'].toString(),
                    response_block_popup_subcntr_data[i]['unittype'].toString(),
                    double.parse(response_block_popup_subcntr_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showTop7BlockChildSubCenterPopup(_subHeading);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }


  //Comman API Block Functionality
  Future<String> getBlockPopupAPI(
      int parse_year,
      String _unitCode,
      String _unitType,
      String _subHeading,
      String _mnthYr,
      String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_chart_subcenter_detail_api), body: {
      "UnitType":_unitType,
      "UnitCode":_unitCode,
      "Flag":_flag,
      "Mthyr":_mnthYr,
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = SubCenterChartDataList.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_block_popup_data = resBody['ResposeData'];
        if(response_block_popup_data.length > 0) {
          if (clickBlockPopupData != null) clickBlockPopupData.clear();
          for (int i = 0; i < response_block_popup_data.length; i++) {
            clickBlockPopupData.add(
                ClickBlockChildData(response_block_popup_data[i]['unitname'].toString(),
                    response_block_popup_data[i]['unitcode'].toString(),
                    response_block_popup_data[i]['unittype'].toString(),
                    response_block_popup_data[i]['BlockName'].toString(),
                    double.parse(response_block_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showTop7BlockChildPopup(_subHeading,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  //Comman API CHCPHC Functionality
  Future<String> getReasonWisePositionCHCPHCPopupAPI(int parse_year,String _unitCode,String _unitType,String _finsubhead,String _flag,String _topHeding) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":parse_year.toString(),
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_popup_data.length > 0) {
          if (stateCHCPHCPieChartData != null) stateCHCPHCPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_popup_data.length; i++) {
            stateCHCPHCPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showReasonWisePositionCHCPHCChartPopup(_topHeding,_finsubhead,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }

  Future<String> getCHCPHCPopupAPI(int parse_year,String _unitCode,String _unitType,String _finsubhead,String _flag) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_state_pie_chart_api), body: {
      "LoginUnitType":_unitType,
      "LoginUnitCode": _unitCode,
      "Flag":_flag,
      "Mthyr":parse_year.toString(),
      "finyear":parse_year.toString(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = StatePieBarChartData.fromJson(resBody);
    setState(() {
      EasyLoading.dismiss();
      if (apiResponse.status == true) {
        response_state_block_chcphc_popup_data = resBody['ResposeData'];
        //print('response_district_ ${response_district_.length}');
        if(response_state_block_chcphc_popup_data.length > 0) {
          if (stateCHCPHCPieChartData != null) stateCHCPHCPieChartData.clear();
          for (int i = 0; i < response_state_block_chcphc_popup_data.length; i++) {
            stateCHCPHCPieChartData.add(
                ClickBlockChildData(response_state_block_chcphc_popup_data[i]['unitname'].toString(),
                    response_state_block_chcphc_popup_data[i]['unitcode'].toString(),
                    response_state_block_chcphc_popup_data[i]['unittype'].toString(),
                    response_state_block_chcphc_popup_data[i]['BlockName'].toString(),
                    double.parse(response_state_block_chcphc_popup_data[i]['Cases'].toString()),
                    Color.fromRGBO(_random.nextInt(256),
                        _random.nextInt(256),
                        _random.nextInt(256),
                        10)));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      showStateBlockCHCPHCChartPopup("",_finsubhead,_flag);
    });
    //print('popup.chart :${apiResponse.message}');
    return "Success";
  }


  /*
  * API FOR DISTRICT LISTING
  * */
  var _showFirstTabYrView=false;
  var _showSecTabYrView=false;
  Future<String> getCurrentYear() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var formattedDate = "${dateParse.year}";
    parse_year = int.parse(formattedDate);
    // print('parse_year $parse_year');
    incr_next_year = (parse_year + 1).toString();
    //print('current-next_year $incr_next_year');
    fin_next_year = incr_next_year.substring(incr_next_year.length - 2);
   // print('current-fin_next_year $fin_next_year');
   // print('current-Year $formattedDate');
    setState(() {
      _showFirstTabYrView=true;
      _showSecTabYrView=true;
    });

    getChartDashboard(parse_year);
    return "";
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(
      // Enables the selection
        enable: true,
       // selectedColor: Colors.blueGrey,
       // unselectedColor: Colors.grey
      selectedOpacity: 1.0,
      unselectedOpacity: 0.3,
    );
    super.initState();
    getHelpDesk();

  }
  late SelectionBehavior _selectionBehavior;

  int selectedPointIndexParent = 4;
  late int selectedAxisPointIndexParent;




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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        color: ColorConstants.header_yellow_color,
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: SizedBox(
                                  width: 50,
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        head_financl_yr=parse_year.toString()+"-"+fin_next_year.toString();
                                        //print('head_financl_yr ${head_financl_yr}');
                                        count=1;
                                        ifTabOne=false;
                                        _selectedTab=true;
                                        _selected2Tab=false;
                                        curr_parse_yr=parse_year;
                                        getChartDashboard(parse_year);
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),

                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:  ColorConstants.white,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: _selectedTab == false ? ColorConstants.buttongraddark : ColorConstants.buttongradlight,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      width: 30,
                                      child: Container(
                                          child: Center(
                                            child: Visibility(
                                              visible: _showFirstTabYrView,
                                              child: Text(
                                                '$parse_year-$fin_next_year',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 13),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: SizedBox(
                                  width: 50,
                                  child: GestureDetector(
                                    onTap: (){
                                      //print('click ${parse_year}');
                                      curr_parse_yr=parse_year-1;
                                      head_financl_yr=(parse_year - 1).toString()+"-"+(int.parse(fin_next_year) - 1).toString();
                                      //print('head_financl_yr ${head_financl_yr}');
                                      setState(() {
                                        ifTabOne=true;
                                       // getANMChartDetailsAPI(parse_year-1);
                                        _selectedTab=false;
                                        _selected2Tab=true;
                                        getChartDashboard(parse_year-1);
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:  ColorConstants.white,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: _selected2Tab == false ? ColorConstants.buttongraddark : ColorConstants.buttongradlight,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      width: 30,
                                      child: Container(
                                          child: Center(
                                            child: Visibility(
                                              visible: _showSecTabYrView,
                                              child: Text(
                                                '${parse_year - 1}-${int.parse(fin_next_year) - 1}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 13),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                )),
                            Expanded(child: Container(width: 10,)),
                            Expanded(child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstants.spinner_bg_color,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      // border: Border.all(color: Colors.black)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Image.asset('Images/ic_down.png',
                                            height: 12,
                                            alignment: Alignment.centerRight,
                                          ),
                                        ),
                                        iconSize: 15,
                                        elevation: 11,
                                        style: TextStyle(color: Colors.black),
                                        isExpanded: true,
                                        hint: new Text("Select District"),
                                        items: villages_list.map((item) {
                                          return DropdownMenuItem(
                                              child: Text(
                                                item['UnitNameHindi'],    //Names that the api dropdown contains
                                                style: TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              value: item['Unitcode'].toString()       //Id that has to be passed that the dropdown has.....
                                          );
                                        }).toList(),
                                        onChanged: (String? newVal) {
                                          setState((){
                                            DistrictId = newVal!;
                                            print('DistrictID:$DistrictId');
                                            if(DistrictId == "0"){
                                              post_unit_type="1";
                                              post_unit_code=DistrictId;
                                              _districtHeading="Top 7 Districts (Performance Percentage of RCH Indicators)";
                                              _blockHeading="Top 7 Blocks (Performance Percentage of RCH Indicators)";
                                              getChartDashboard(curr_parse_yr);
                                            }else if(DistrictId.length == 6){
                                              post_unit_type="4";
                                              post_unit_code=DistrictId;
                                              _districtHeading="Top 7 Health Unit (Performance Percentage of RCH Indicators)";
                                              _blockHeading="Top 7 CHCs (Performance Percentage of RCH Indicators)";
                                              getChartDashboard(curr_parse_yr);
                                            }else{
                                              post_unit_type="3";
                                              post_unit_code=DistrictId;
                                              _districtHeading="Top 7 Blocks (Performance Percentage of RCH Indicators)";
                                              _blockHeading="Top 7 CHCs (Performance Percentage of RCH Indicators)";
                                              getChartDashboard(curr_parse_yr);
                                            }
                                          });
                                        },
                                        value: DistrictId,                 //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                         
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Header 1
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${_districtHeading}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadFirstChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.chart_heading;
                          _topSevenDistrictPopup();
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                   // title: ChartTitle(text: 'This is example'),
                    series: <ColumnSeries<TopSevenDistrictData, String>>[
                      ColumnSeries<TopSevenDistrictData, String>(
                        // Spacing between the columns
                        spacing: 0.1,
                        // Bind data source
                        dataSource: topSevenDistrictData,
                        xValueMapper: (TopSevenDistrictData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                        yValueMapper: (TopSevenDistrictData value, _) => value.chatvalue,
                        // Map color for each data points from the data source
                        pointColorMapper: (TopSevenDistrictData value, _) => value.color,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        // color: Colors.red
                        selectionBehavior: _selectionBehavior
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 2
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${_blockHeading}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _load7BlockChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.chart_heading;
                          showTop7BlockPopup();

                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<TopSevenBlockData, String>>[
                      ColumnSeries<TopSevenBlockData, String>(
                        // Spacing between the columns
                        spacing: 0.1,
                        //width: 0.4,
                        // Renders the track
                      //  isTrackVisible: true,
                        // Bind data source
                        dataSource: top7BlockPerformance,
                        xValueMapper: (TopSevenBlockData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                        yValueMapper: (TopSevenBlockData value, _) => value.chatvalue,
                        // Map color for each data points from the data source
                        pointColorMapper: (TopSevenBlockData value, _) => value.color,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        selectionBehavior: _selectionBehavior
                        // color: Colors.red

                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 3
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.anc_registration_count} $_ancRegisterCount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 150,
                color: ColorConstants.white,
                child: Row(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_red.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.after_first_trimester} $_AfterANCRegTrimister',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_yello.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.within_first_trimester} $_ANCRegTrimister',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    Expanded(child: Container(color: Colors.white,
                      child: _loadChart == true ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SfCircularChart(
                          // For storing the selected data point’s index
                          onSelectionChanged: (args) {
                            if (selectedPointIndexParent == args.pointIndex) {
                              selectedPointIndexParent = -1;
                            } else {
                              selectedPointIndexParent = args.pointIndex;
                            }
                            setState(() {
                              if(selectedPointIndexParent != -1){
                                //print('onChartClick ${ancChartData![selectedPointIndexParent].x.toString()}');
                                //print('onChartClick ${ancChartData![selectedPointIndexParent].y.toString()}');
                                showPieChartPopup(ancChartData![selectedPointIndexParent].y.toString());
                              }
                            });
                          },
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries<AncRegisterData, String>>[
                            DoughnutSeries<AncRegisterData, String>(
                                strokeWidth: 1,
                                strokeColor: Colors.orange,
                                //opacity: 0.5,
                                //explode: true,
                                //explodeIndex: 1,
                                radius: '100%',
                                dataSource: ancChartData,
                                xValueMapper: (AncRegisterData data, _) => data.x,
                                yValueMapper: (AncRegisterData data, _) => data.y,
                                /// The property used to apply the color for each douchnut series.
                                pointColorMapper: (AncRegisterData data, _) => data.colorr,
                                name: '',
                                dataLabelMapper: (AncRegisterData data, _) => data.x,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition: ChartDataLabelPosition.inside
                                ),
                                // Explode the segments on tap
                                explode: true,
                                selectionBehavior: _selectionBehavior
                            ),
                          ],
                        ),
                      ) : SizedBox(
                          height: 200,
                          child: Container(
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
                      ),)
                    )
                  ],
                ),
              ),
              //Header 4
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.total_births} $_totalBirthCount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 150,
                color: ColorConstants.white,
                child: Row(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_yello.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.live_female_births} $_liveMaleBirth',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_red.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.live_male_births} $_liveFeMaleBirth',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_blue.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.still_births} $_stillBirth',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    Expanded(child: Container(color: Colors.white,
                      child: _loadBirthChart == true ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SfCircularChart(
                          // For storing the selected data point’s index
                          onSelectionChanged: (args) {
                            if (selectedPointIndexParent == args.pointIndex) {
                              selectedPointIndexParent = -1;
                            } else {
                              selectedPointIndexParent = args.pointIndex;
                            }
                            setState(() {
                              if(selectedPointIndexParent != -1){
                               // print('onChartClick ${ancChartData![selectedPointIndexParent].x.toString()}');
                               // print('onChartClick ${ancChartData![selectedPointIndexParent].y.toString()}');
                                showPieChartPopup(ancChartData![selectedPointIndexParent].y.toString());
                              }
                            });
                          },
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries<BirthTotalData, String>>[
                            DoughnutSeries<BirthTotalData, String>(
                                radius: '100%',
                                dataSource: birthChartData,
                                xValueMapper: (BirthTotalData data, _) => data.x,
                                yValueMapper: (BirthTotalData data, _) => data.y,
                                /// The property used to apply the color for each douchnut series.
                                pointColorMapper: (BirthTotalData data, _) => data.colorr,
                                name: '',
                                dataLabelMapper: (BirthTotalData data, _) => data.x,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true, labelPosition: ChartDataLabelPosition.inside),
                                // Explode the segments on tap
                                explode: true,
                                selectionBehavior: _selectionBehavior
                            )
                            ,
                          ],
                        ),
                      ) :SizedBox(
                          height: 200,
                          child: Container(
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
                      ),)
                    )
                  ],
                ),
              ), //H
              //Header 5
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.total_deliveries} $_totalDeliveryCount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 150,
                color: ColorConstants.white,
                child: Row(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_yello.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.pvt_institution} $_delPrivate',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_red.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.public_institution} $_delPublic',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_blue.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.at_home} $_delHome',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    Expanded(child: Container(color: Colors.white,
                      child: _loadDeliveryChart == true ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SfCircularChart(
                          // For storing the selected data point’s index
                          onSelectionChanged: (args) {
                            if (selectedPointIndexParent == args.pointIndex) {
                              selectedPointIndexParent = -1;
                            } else {
                              selectedPointIndexParent = args.pointIndex;
                            }
                            setState(() {
                              if(selectedPointIndexParent != -1){
                              //  print('onChartClick ${ancChartData![selectedPointIndexParent].x.toString()}');
                               // print('onChartClick ${ancChartData![selectedPointIndexParent].y.toString()}');
                                showPieChartPopup(ancChartData![selectedPointIndexParent].y.toString());
                              }
                            });
                          },
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries<DeliveryData, String>>[
                            DoughnutSeries<DeliveryData, String>(
                                radius: '100%',
                                dataSource: deliveryChartData,
                                xValueMapper: (DeliveryData data, _) => data.x,
                                yValueMapper: (DeliveryData data, _) => data.y,
                                /// The property used to apply the color for each douchnut series.
                                pointColorMapper: (DeliveryData data, _) => data.colorr,
                                name: '',
                                dataLabelMapper: (DeliveryData data, _) => data.x,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true, labelPosition: ChartDataLabelPosition.inside),
                                // Explode the segments on tap
                                explode: true,
                                selectionBehavior: _selectionBehavior
                            )
                            ,
                          ],
                        ),
                      ) :SizedBox(
                          height: 200,
                          child: Container(
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
                      ),)
                    )
                  ],
                ),
              ),
              //Header 6
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.infant_reg} $_totalChilderenRegCount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 150,
                color: ColorConstants.white,
                child: Row(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_yello.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.pratially_infant_reg} $_partImmunized',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_red.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.fully_immunizdinfant_reg} $_fullyImmunized',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Image.asset("Images/checked_blue.png",width: 15,height: 15,), //
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text('${Strings.not_immunizdinfant_reg} $_notImmunized',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    Expanded(child: Container(color: Colors.white,
                      child: _loadInfantChart == true ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SfCircularChart(
                          // For storing the selected data point’s index
                          onSelectionChanged: (args) {
                            if (selectedPointIndexParent == args.pointIndex) {
                              selectedPointIndexParent = -1;
                            } else {
                              selectedPointIndexParent = args.pointIndex;
                            }
                            setState(() {
                              if(selectedPointIndexParent != -1){
                                //print('onChartClick ${ancChartData![selectedPointIndexParent].x.toString()}');
                               // print('onChartClick ${ancChartData![selectedPointIndexParent].y.toString()}');
                                showPieChartPopup(ancChartData![selectedPointIndexParent].y.toString());
                              }
                            });
                          },
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries<InfantData, String>>[
                            DoughnutSeries<InfantData, String>(
                                radius: '100%',
                                dataSource: infantChartData,
                                xValueMapper: (InfantData data, _) => data.x,
                                yValueMapper: (InfantData data, _) => data.y,
                                /// The property used to apply the color for each douchnut series.
                                pointColorMapper: (InfantData data, _) => data.colorr,
                                name: '',
                                dataLabelMapper: (InfantData data, _) => data.x,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true, labelPosition: ChartDataLabelPosition.inside)
                                ,
                                // Explode the segments on tap
                                explode: true,
                                selectionBehavior: _selectionBehavior
                            )
                            ,
                          ],
                        ),
                      ) :SizedBox(
                          height: 200,
                          child: Container(
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
                      ),)
                    )
                  ],
                ),
              ),
              //Header 7
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.maternal_death}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadMaternalDeathChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.maternal_death;
                          showMaternalBarChartPopup(maternalDeathData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<MaternalData, String>>[
                      ColumnSeries<MaternalData, String>(
                        // Spacing between the columns
                        spacing: 0.1,
                        //width: 0.4,
                        // Renders the track
                       // isTrackVisible: true,
                        // Bind data source
                        dataSource: maternalDeathData,
                        xValueMapper: (MaternalData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                        yValueMapper: (MaternalData value, _) => value.chatvalue,
                        // Map color for each data points from the data source
                        pointColorMapper: (MaternalData value, _) => value.color,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 8
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.infant_death}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadInafntDeathDeathChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.infant_death;
                          showInfantDeathBarChartPopup(infantDeathData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<InfantDeathData, String>>[
                      ColumnSeries<InfantDeathData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                          // isTrackVisible: true,
                          // Bind data source
                          dataSource: infantDeathData,
                          xValueMapper: (InfantDeathData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (InfantDeathData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (InfantDeathData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 9
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.indicator_death}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadIndicatorPerformanceChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.indicator_death;
                          showIndicatorPerformBarChartPopup(indicatorPerformData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<IndicatorwiseData, String>>[
                      ColumnSeries<IndicatorwiseData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          // Bind data source
                          dataSource: indicatorPerformData,
                          xValueMapper: (IndicatorwiseData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (IndicatorwiseData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (IndicatorwiseData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 10
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.sex_ratioatbirth}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadSexRatioAtBirthChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                        //print('onClick ${selectedPointIndexParent}');
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                        //print('onClick ${selectedPointIndexParent}');
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.sex_ratioatbirth;
                          showSexRatioBarChartPopup(sexRatioAtBirthData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<SexRatioAtBirthData, String>>[
                      ColumnSeries<SexRatioAtBirthData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                          // isTrackVisible: true,
                          // Bind data source
                          dataSource: sexRatioAtBirthData,
                          xValueMapper: (SexRatioAtBirthData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (SexRatioAtBirthData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (SexRatioAtBirthData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 11
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.vaccine_requiremnt}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadVaccineReqChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                        //print('onClick ${selectedPointIndexParent}');
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                        //print('onClick ${selectedPointIndexParent}');
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.vaccine_requiremnt;
                          showVaccineBarChartPopup(vaccineRequiremntData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<VaccineRequireData, String>>[
                      ColumnSeries<VaccineRequireData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                          // isTrackVisible: true,
                          // Bind data source
                          dataSource: vaccineRequiremntData,
                          xValueMapper: (VaccineRequireData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (VaccineRequireData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (VaccineRequireData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 12
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.sterlization_title}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadSterlizationChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                        //print('onClick ${selectedPointIndexParent}');
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                        //print('onClick ${selectedPointIndexParent}');
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.sterlization_title;
                           print('onSterClick ${sterlizationData[selectedPointIndexParent].monthValue.toString()}');
                          showSterlizationChartPopup(sterlizationData,sterlizationData[selectedPointIndexParent].monthValue.toString());
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<SterlizationData, String>>[
                      ColumnSeries<SterlizationData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                          // isTrackVisible: true,
                          // Bind data source
                          dataSource: sterlizationData,
                          xValueMapper: (SterlizationData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (SterlizationData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (SterlizationData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
              //Header 13
              Container(
                height: 40,
                color: ColorConstants.dark_bar_color,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Text('${Strings.reasonwise_highrisk}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 250,
                color: ColorConstants.white,
                child: _loadReasonWiseChart == true ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexParent == args.pointIndex) {
                        selectedPointIndexParent = -1;
                        //print('onClick ${selectedPointIndexParent}');
                      } else {
                        selectedPointIndexParent = args.pointIndex;
                        //print('onClick ${selectedPointIndexParent}');
                      }
                      setState(() {
                        if(selectedPointIndexParent != -1){
                          _popHeaderTitle=Strings.reasonwise_highrisk;
                          showReasonWiseChartPopup(reasonWiseData);
                        }
                      });
                    },
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    series: <ColumnSeries<ReasonWiseHighRiskData, String>>[
                      ColumnSeries<ReasonWiseHighRiskData, String>(
                        // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                          // isTrackVisible: true,
                          // Bind data source
                          dataSource: reasonWiseData,
                          xValueMapper: (ReasonWiseHighRiskData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ReasonWiseHighRiskData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ReasonWiseHighRiskData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          selectionBehavior: _selectionBehavior
                        // color: Colors.red
                      )
                    ],

                  ),
                )
                    : SizedBox(
                    height: 200,
                    child: Container(
                      child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  /*
  * TOP 7 DISTRICT POPUP
  * */
  Future<void> _topSevenDistrictPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(Strings.chart_heading,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndex == args.pointIndex) {
                          selectedPointIndex = -1;
                          //print('onClick ${selectedPointIndex}');
                        } else {
                          selectedPointIndex = args.pointIndex;
                          //print('onClick ${selectedPointIndex}');
                        }
                        setState(() {
                          if(selectedPointIndex != -1){
                            print('top7Disct ${topSevenDistrictData[selectedPointIndex].chatvalue.toString()}');
                            //print('top7Disct ${topSevenDistrictData[selectedPointIndex].chartname.toString()}');
                            //print('top7Disct ${topSevenDistrictData[selectedPointIndex].unitcode.toString()}');
                            //print('top7Disct ${topSevenDistrictData[selectedPointIndex].unittype.toString()}');

                            //Check Login Session based on Type basis
                            // -unittype= 1 (super admin)
                            // -unittype= 3 (district)
                            // -unittype= 4 (block)
                            // -unittype= 9 (chch)
                            if(preferences.getString("UnitType").toString() == "1"){ //On Click show Block Data
                              getChartClickDetailAPI(curr_parse_yr,topSevenDistrictData[selectedPointIndexParent].unitcode.toString().substring(0,4),
                                  topSevenDistrictData[selectedPointIndexParent].unittype.toString(),
                                  topSevenDistrictData[selectedPointIndexParent].chartname.toString(),
                                  "10");
                            }else if(preferences.getString("UnitType").toString() == "3"){//on click CHPCH API called
                              //on click CHPCH API called
                              getCHCPHCChartDataAPI(curr_parse_yr,
                                  topSevenDistrictData[selectedPointIndexParent].unitcode.toString().toString().substring(0,6),
                                  topSevenDistrictData[selectedPointIndexParent].unittype.toString(),
                                  "("+topSevenDistrictData[selectedPointIndexParent].chartname.toString(),
                                  "10"
                              );
                            }else if(preferences.getString("UnitType").toString() == "4"){

                            }else if(preferences.getString("UnitType").toString() == "9"){

                            }
                            print('checkLoginType ${preferences.getString("UnitType").toString()}');
                          }

                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // title: ChartTitle(text: 'This is example'),
                      series: <ColumnSeries<TopSevenDistrictData, String>>[
                        ColumnSeries<TopSevenDistrictData, String>(
                          spacing: 0.1,
                          dataSource: topSevenDistrictData,
                          xValueMapper: (TopSevenDistrictData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (TopSevenDistrictData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (TopSevenDistrictData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showTop7DistrictPopup(String _headNme,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr ($_headNme)',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndex == args.pointIndex) {
                          selectedPointIndex = -1;
                          print('onClick ${selectedPointIndex}');
                        } else {
                          selectedPointIndex = args.pointIndex;
                          print('onClick ${selectedPointIndex}');
                        }
                        setState(() {
                          if(selectedPointIndex != -1){
                            print('onBlockClick ${clickDistrictData[selectedPointIndex].chatvalue.toString()}');
                           // print('onBlockClick ${clickDistrictData[selectedPointIndex].chartname.toString()}');
                           // print('onBlockClick ${clickDistrictData[selectedPointIndex].unitcode.toString()}');
                            //print('onBlockClick ${clickDistrictData[selectedPointIndex].unittype.toString()}');
                            //on click CHPCH API called
                            getCHCPHCChartDataAPI(curr_parse_yr,
                                clickDistrictData[selectedPointIndex].unitcode.toString(),
                                clickDistrictData[selectedPointIndex].unittype.toString(),
                                "("+_headNme +" -> "+ clickDistrictData[selectedPointIndex].chartname.toString(),
                                _flag
                            );
                          }

                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // title: ChartTitle(text: 'This is example'),
                      series: <ColumnSeries<ClickDistrictData, String>>[
                        ColumnSeries<ClickDistrictData, String>(
                          spacing: 0.1,
                          dataSource: clickDistrictData,
                          xValueMapper: (ClickDistrictData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickDistrictData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickDistrictData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                        )
                      ],

                    )
                ),
                Container(
                    child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.block}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                    ),
                    ),
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

  int selectedPointIndex = 4;
  late int selectedAxisPointIndex;

  int selectedPointIndexChild = 4;
  late int selectedAxisPointIndexChild;

  int selectedPointIndexSubCenter = 4;
  late int selectedAxisPointIndexSubCenter;

  /*
  * Bar CHART Functionality ---------start -----------
  */

  Future<void> showChildBlockPopup(String _headNme) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Align(
                   alignment: Alignment.centerLeft,
                   child:  Padding(
                     padding: const EdgeInsets.all(5.0),
                     child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                   ),
                 ),
               ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(Strings.chart_heading,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_headNme',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                 // margin: EdgeInsets.all(20),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexChild == args.pointIndex) {
                        selectedPointIndexChild = -1;
                        print('onClick ${selectedPointIndexChild}');
                      } else {
                        selectedPointIndexChild = args.pointIndex;
                        print('onClick ${selectedPointIndexChild}');
                      }
                      setState(() {
                        if(selectedPointIndexChild != -1){
                          print('onTouch3 ${clickDistrictChildData[selectedPointIndexChild].chatvalue.toString()}');
                          print('onTouch3 ${clickDistrictChildData[selectedPointIndexChild].chartname.toString()}');
                          print('onTouch3 ${clickDistrictChildData[selectedPointIndexChild].unitcode.toString()}');
                          print('onTouch3 ${clickDistrictChildData[selectedPointIndexChild].unittype.toString()}');
                          getChartSubCenterDetailAPI(curr_parse_yr,clickDistrictChildData[selectedPointIndexChild].unitcode.toString(),
                              clickDistrictChildData[selectedPointIndexChild].unittype.toString(),
                              _headNme+" -> "+clickDistrictChildData[selectedPointIndexChild].chartname.toString()+"(PHC)");
                        }

                      });
                    },
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    // title: ChartTitle(text: 'This is example'),
                    series: <ColumnSeries<ClickDistrictChildData, String>>[
                      ColumnSeries<ClickDistrictChildData, String>(
                          // Spacing between the columns
                          spacing: 0.1,
                          //width: 0.4,
                          // Renders the track
                         // isTrackVisible: true,
                          // Bind data source
                          dataSource: clickDistrictChildData,
                          xValueMapper: (ClickDistrictChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickDistrictChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickDistrictChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                )
                    ],

                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSubCenterPopup(String _subCenterHeadng) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Align(
                   alignment: Alignment.centerLeft,
                   child:  Padding(
                     padding: const EdgeInsets.all(5.0),
                     child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                   ),
                 ),
               ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(Strings.chart_heading,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_subCenterHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                 // margin: EdgeInsets.all(20),
                  child: SfCartesianChart(
                    // For storing the selected data point’s index
                    onSelectionChanged: (args) {
                      if (selectedPointIndexSubCenter == args.pointIndex) {
                        selectedPointIndexSubCenter = -1;
                        print('onClick ${selectedPointIndexSubCenter}');
                      } else {
                        selectedPointIndexSubCenter = args.pointIndex;
                        print('onClick ${selectedPointIndexSubCenter}');
                      }
                      setState(() {
                        if(selectedPointIndexSubCenter != -1){
                          print('onTouch ${clickDistrictSubCenterData[selectedPointIndexSubCenter].chatvalue.toString()}');
                          print('onTouch ${clickDistrictSubCenterData[selectedPointIndexSubCenter].chartname.toString()}');
                        }

                      });
                    },
                    primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.black),
                      axisLine: AxisLine(width: 0),
                      labelPosition: ChartDataLabelPosition.outside,
                      majorTickLines: MajorTickLines(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: 45,
                      placeLabelsNearAxisLine: false,
                    ),
                    // title: ChartTitle(text: 'This is example'),
                    series: <ColumnSeries<ClickDistrictSubCenterData, String>>[
                      ColumnSeries<ClickDistrictSubCenterData, String>(
                          spacing: 0.1,
                          // Renders the track
                        //  isTrackVisible: true,
                          // Bind data source
                          dataSource: clickDistrictSubCenterData,
                          xValueMapper: (ClickDistrictSubCenterData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickDistrictSubCenterData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickDistrictSubCenterData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                )
                    ],

                  )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showTop7BlockPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_popHeaderTitle',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndex == args.pointIndex) {
                          selectedPointIndex = -1;
                          print('onClick ${selectedPointIndex}');
                        } else {
                          selectedPointIndex = args.pointIndex;
                          print('onClick ${selectedPointIndex}');
                        }
                        setState(() {
                          if(selectedPointIndex != -1){
                            /*print('onTouch22 ${top7BlockPerformance[selectedPointIndex].chatvalue.toString()}');
                            print('onTouch22 ${top7BlockPerformance[selectedPointIndex].chartname.toString()}');
                            print('onTouch22 ${top7BlockPerformance[selectedPointIndex].unitcode.toString()}');
                            print('onTouch22 ${top7BlockPerformance[selectedPointIndex].unittype.toString()}');*/
                            //Check Login Session based on Type basis
                            // -unittype= 1 (super admin)
                            // -unittype= 3 (district)
                            // -unittype= 4 (block)
                            // -unittype= 9 (chch)
                            if(preferences.getString("UnitType").toString() == "1"){ //On Click show Block Data
                              //on click CHPCH API called
                              getCHCPHCChartDataAPI(curr_parse_yr,
                                  top7BlockPerformance[selectedPointIndex].unitcode.toString().toString().substring(0,6),
                                  top7BlockPerformance[selectedPointIndex].unittype.toString(),
                                  "("+top7BlockPerformance[selectedPointIndex].chartname.toString(),
                                  "11"
                              );
                            }else if(preferences.getString("UnitType").toString() == "3"){//on click CHPCH API called
                              //on click CHPCH API called
                              getCHCPHCChartDataAPI(curr_parse_yr,
                                  topSevenDistrictData[selectedPointIndexParent].unitcode.toString().toString().substring(0,6),
                                  topSevenDistrictData[selectedPointIndexParent].unittype.toString(),
                                  "("+topSevenDistrictData[selectedPointIndexParent].chartname.toString(),
                                  "11"
                              );
                            }else if(preferences.getString("UnitType").toString() == "4"){//block

                            }else if(preferences.getString("UnitType").toString() == "9"){//chc

                            }


                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // title: ChartTitle(text: 'This is example'),
                      series: <ColumnSeries<TopSevenBlockData, String>>[
                        ColumnSeries<TopSevenBlockData, String>(
                          // Spacing between the columns
                          spacing: 0.1,
                          dataSource: top7BlockPerformance,
                          xValueMapper: (TopSevenBlockData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (TopSevenBlockData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (TopSevenBlockData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showTop7BlockChildPopup(String _subCenterHeadng,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr ($_subCenterHeadng)',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                          print('onClick ${selectedPointIndexSubCenter}');
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                          print('onClick ${selectedPointIndexSubCenter}');
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            print('onTouch ${clickBlockPopupData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            print('onTouch ${clickBlockPopupData[selectedPointIndexSubCenter].chartname.toString()}');
                            if(_flag == "8"){
                              getCHCPHCPopupAPI(
                                  curr_parse_yr,
                                  clickBlockPopupData[selectedPointIndexSubCenter].unitcode.toString(),
                                  clickBlockPopupData[selectedPointIndexSubCenter].unittype.toString(),
                                  "("+_subCenterHeadng +" -> "+ clickBlockPopupData[selectedPointIndexSubCenter].chartname.toString()
                                      +"("+clickBlockPopupData[selectedPointIndexSubCenter].BlockName.toString()+"))",
                                  _flag
                              );
                            }else{
                              getBlockPopupSubCenterDataAPI(
                                  curr_parse_yr,
                                  clickBlockPopupData[selectedPointIndexSubCenter].unitcode.toString(),
                                  clickBlockPopupData[selectedPointIndexSubCenter].unittype.toString(),
                                  "("+_subCenterHeadng +" -> "+ clickBlockPopupData[selectedPointIndexSubCenter].chartname.toString()
                                      +"("+clickBlockPopupData[selectedPointIndexSubCenter].BlockName.toString()+"))",
                                  _flag
                              );
                            }

                          }

                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // title: ChartTitle(text: 'This is example'),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: clickBlockPopupData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showTop7BlockChildSubCenterPopup(String _subCenterHeadng) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(Strings.chart_heading,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_subCenterHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                          print('onClick ${selectedPointIndexSubCenter}');
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                          print('onClick ${selectedPointIndexSubCenter}');
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            print('onTouch ${clickBlockPopupData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            print('onTouch ${clickBlockPopupData[selectedPointIndexSubCenter].chartname.toString()}');
                          }

                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      // title: ChartTitle(text: 'This is example'),
                      series: <ColumnSeries<ClickBlockChildSubCntrData, String>>[
                        ColumnSeries<ClickBlockChildSubCntrData, String>(
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: clickBlockPopupSubCenterData,
                          xValueMapper: (ClickBlockChildSubCntrData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildSubCntrData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildSubCntrData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,

                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //MATERNAL BAR CHART POPUP
  var _popHeaderTitle="";
  Future<void> showMaternalBarChartPopup(List<MaternalData> maternalDeathData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                          //print('onClick ${selectedPointIndexParent}');
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                          //print('onClick ${selectedPointIndexParent}');
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){

                            //On Click show Block Data
                            getChartClickDetailAPI(curr_parse_yr,maternalDeathData[selectedPointIndexParent].unitcode.toString().substring(0,4),
                                maternalDeathData[selectedPointIndexParent].unittype.toString(),
                                maternalDeathData[selectedPointIndexParent].chartname.toString(),
                                "8");
                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<MaternalData, String>>[
                        ColumnSeries<MaternalData, String>(
                            spacing: 0.1,
                            dataSource: maternalDeathData,
                            xValueMapper: (MaternalData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (MaternalData value, _) => value.chatvalue,
                            pointColorMapper: (MaternalData value, _) => value.color,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showVaccineBarChartPopup(List<VaccineRequireData> vaccineRequiremntData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            print('onClick ${vaccineRequiremntData[selectedPointIndexParent].chartname.toString()}');
                            //On Click show Block Data
                            if(vaccineRequiremntData[selectedPointIndexParent].chartname.toString() == "BCG"){
                              statePieChartDataAPI(curr_parse_yr,"Vaccine Requirement","3");
                            }else if(vaccineRequiremntData[selectedPointIndexParent].chartname.toString() == "Pentavalent"){
                              statePieChartDataAPI(curr_parse_yr,"Vaccine Requirement","4");
                            }else if(vaccineRequiremntData[selectedPointIndexParent].chartname.toString() == "OPV"){
                              statePieChartDataAPI(curr_parse_yr,"Vaccine Requirement","5");
                            }else if(vaccineRequiremntData[selectedPointIndexParent].chartname.toString() == "Measles"){
                              statePieChartDataAPI(curr_parse_yr,"Vaccine Requirement","6");
                            }else if(vaccineRequiremntData[selectedPointIndexParent].chartname.toString() == "Hepatitis"){
                              statePieChartDataAPI(curr_parse_yr,"Vaccine Requirement","7");
                            }else {

                            }
                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<VaccineRequireData, String>>[
                        ColumnSeries<VaccineRequireData, String>(
                            spacing: 0.1,
                            dataSource: vaccineRequiremntData,
                            xValueMapper: (VaccineRequireData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (VaccineRequireData value, _) => value.chatvalue,
                            pointColorMapper: (VaccineRequireData value, _) => value.color,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showInfantDeathBarChartPopup(List<InfantDeathData> infantDeathData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            //On Click show Block Data
                            getChartClickDetailAPI(curr_parse_yr,infantDeathData[selectedPointIndexParent].unitcode.toString().substring(0,4),
                                infantDeathData[selectedPointIndexParent].unittype.toString(),
                                infantDeathData[selectedPointIndexParent].chartname.toString(),
                                "9");
                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<InfantDeathData, String>>[
                        ColumnSeries<InfantDeathData, String>(
                            spacing: 0.1,
                            dataSource: infantDeathData,
                            xValueMapper: (InfantDeathData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (InfantDeathData value, _) => value.chatvalue,
                            pointColorMapper: (InfantDeathData value, _) => value.color,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSexRatioBarChartPopup(List<SexRatioAtBirthData> sexRatioAtBirthData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                          //print('onClick ${selectedPointIndexParent}');
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                          //print('onClick ${selectedPointIndexParent}');
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            //On Click show Jila Data
                            getJilaChartDataAPI(curr_parse_yr,_popHeaderTitle,"1");
                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<SexRatioAtBirthData, String>>[
                        ColumnSeries<SexRatioAtBirthData, String>(
                            spacing: 0.1,
                            dataSource: sexRatioAtBirthData,
                            xValueMapper: (SexRatioAtBirthData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (SexRatioAtBirthData value, _) => value.chatvalue,
                            pointColorMapper: (SexRatioAtBirthData value, _) => value.color,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showIndicatorPerformBarChartPopup(List<IndicatorwiseData> indicatorPerformData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            //On Click show Jila Data
                            getSterlizeJilaChartDataAPI(curr_parse_yr,"Performance Percentage of "+indicatorPerformData[selectedPointIndexParent].chartname.toString(),"16","");
                          }
                        });
                      },
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<IndicatorwiseData, String>>[
                        ColumnSeries<IndicatorwiseData, String>(
                            spacing: 0.1,
                            dataSource: indicatorPerformData,
                            xValueMapper: (IndicatorwiseData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (IndicatorwiseData value, _) => value.chatvalue,
                            pointColorMapper: (IndicatorwiseData value, _) => value.color,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Reason wise chart popup
  Future<void> showReasonWiseChartPopup(List<ReasonWiseHighRiskData> reasonWiseData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            print('print.pos ${selectedPointIndexParent}');
                            print('print ${reasonWiseData[selectedPointIndexParent].chartname.toString()}');
                            if(preferences.getString("UnitType").toString() == "1"){//sa type
                              //On Click show Block Data
                              //getJilaChartDataAPI(curr_parse_yr,"HighRisk -> High B.P.","21");
                              if(selectedPointIndexParent == 0){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> High B.P.","21");
                              }else if(selectedPointIndexParent == 1){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Diabetes","22");
                              }else if(selectedPointIndexParent == 2){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> APH","23");
                              }else if(selectedPointIndexParent == 3){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Malaria ","24");
                              }else if(selectedPointIndexParent == 4){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Other","25");
                              }else if(selectedPointIndexParent == 5){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Anemia","26");
                              }else if(selectedPointIndexParent == 6){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Age","27");
                              }else if(selectedPointIndexParent == 7){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Height","28");
                              }else if(selectedPointIndexParent == 8){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Delivery","29");
                              }else if(selectedPointIndexParent == 9){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> LieAndBreech","30");
                              }else if(selectedPointIndexParent == 10){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Heart ","31");
                              }else if(selectedPointIndexParent == 11){
                                getJilaChartDataAPI(curr_parse_yr,"HighRisk -> Kidney ","32");
                              }
                            }else if(preferences.getString("UnitType").toString() == "3"){//District Type
                                if(selectedPointIndexParent == 0){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> High B.P.","21");
                                }else if(selectedPointIndexParent == 1){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Diabetes","22");
                                }else if(selectedPointIndexParent == 2){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> APH","23");
                                }else if(selectedPointIndexParent == 3){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Malaria ","24");
                                }else if(selectedPointIndexParent == 4){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Other","25");
                                }else if(selectedPointIndexParent == 5){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Anemia","26");
                                }else if(selectedPointIndexParent == 6){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Age","27");
                                }else if(selectedPointIndexParent == 7){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Height","28");
                                }else if(selectedPointIndexParent == 8){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Delivery","29");
                                }else if(selectedPointIndexParent == 9){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> LieAndBreech","30");
                                }else if(selectedPointIndexParent == 10){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Heart ","31");
                                }else if(selectedPointIndexParent == 11){
                                  getReasonWisePositionAPI(curr_parse_yr,"HighRisk -> Kidney ","32");
                                }
                            }else if(preferences.getString("UnitType").toString() == "4"){

                            }else if(preferences.getString("UnitType").toString() == "9"){

                            }
                          }
                        });
                      },
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<ReasonWiseHighRiskData, String>>[
                        ColumnSeries<ReasonWiseHighRiskData, String>(
                            spacing: 0.1,
                            dataSource: reasonWiseData,
                            xValueMapper: (ReasonWiseHighRiskData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (ReasonWiseHighRiskData value, _) => value.chatvalue,
                            // Map color for each data points from the data source
                            pointColorMapper: (ReasonWiseHighRiskData value, _) => value.color,
                            // Enable data label
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                          // color: Colors.red
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Reason wise chart popup
  Future<void> showSterlizationChartPopup(List<SterlizationData> sterlizationData,String mnthValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(_popHeaderTitle,textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            getSterlizeJilaChartDataAPI(curr_parse_yr,Strings.sterlization_title,"2",mnthValue);
                          }
                        });
                      },
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<SterlizationData, String>>[
                        ColumnSeries<SterlizationData, String>(
                            spacing: 0.1,
                            dataSource: sterlizationData,
                            xValueMapper: (SterlizationData value, _) => value.chartname.length > 6 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                            yValueMapper: (SterlizationData value, _) => value.chatvalue,
                            // Map color for each data points from the data source
                            pointColorMapper: (SterlizationData value, _) => value.color,
                            // Enable data label
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            selectionBehavior: _selectionBehavior
                          // color: Colors.red
                        )
                      ],

                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  * Bar CHART Functionality ---------end -----------
  */

  /*
  * PIE CHART Functionality ---------start -----------
  */

  Future<void> showPieChartPopup(String _headNme) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${Strings.anc_registration_count} $_ancRegisterCount',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr ',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCircularChart(
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexParent == args.pointIndex) {
                          selectedPointIndexParent = -1;
                        } else {
                          selectedPointIndexParent = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexParent != -1){
                            if(selectedPointIndexParent == 0){
                              statePieChartDataAPI(curr_parse_yr,"Within First Trimester","2");
                            }else if(selectedPointIndexParent == 1){//After First Trimester
                              statePieChartDataAPI(curr_parse_yr,"After First Trimester","1");
                            }
                          }
                        });
                      },
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries<AncRegisterData, String>>[
                        DoughnutSeries<AncRegisterData, String>(
                            strokeWidth: 1,
                            strokeColor: Colors.orange,
                            radius: '100%',
                            dataSource: ancChartData,
                            xValueMapper: (AncRegisterData data, _) => data.x,
                            yValueMapper: (AncRegisterData data, _) => data.y,
                            /// The property used to apply the color for each douchnut series.
                            pointColorMapper: (AncRegisterData data, _) => data.colorr,
                            name: '',
                            dataLabelMapper: (AncRegisterData data, _) => data.x,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside
                            ),
                            // Explode the segments on tap
                            explode: true,
                            selectionBehavior: _selectionBehavior
                        ),
                      ],
                    )
                ),
                Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Image.asset("Images/checked_red.png",width: 15,height: 15,), //
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('${Strings.after_first_trimester} $_AfterANCRegTrimister',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10)),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Image.asset("Images/checked_yello.png",width: 15,height: 15,), //
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('${Strings.within_first_trimester} $_ANCRegTrimister',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSterlizationJilaStateChartPopup(String _firstHeadng,String _flag,String _mnthry) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_firstHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            getSterlizeBlockChartDataAPI(curr_parse_yr,
                                sterlizeStateChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                sterlizeStateChartData[selectedPointIndexSubCenter].unittype.toString(),
                                "("+Strings.jila_titele+" -> "+sterlizeStateChartData[selectedPointIndexSubCenter].chartname.toString(),
                              _flag,
                                _mnthry
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                      series: <ColumnSeries<SterlizeStateChartData, String>>[
                        ColumnSeries<SterlizeStateChartData, String>(
                          spacing: 0.1,
                          dataSource: sterlizeStateChartData,
                          xValueMapper: (SterlizeStateChartData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (SterlizeStateChartData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (SterlizeStateChartData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.jila_titele}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showReasonWisePositionChartPopup(String _firstHeadng,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_firstHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            getReasonWisePositionCHCPHCPopupAPI(
                                curr_parse_yr,
                                statePieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                statePieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                "("+statePieChartData[selectedPointIndexSubCenter].chartname.toString(),
                                _flag,
                                _firstHeadng
                            );

                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<StatePieChartData, String>>[
                        ColumnSeries<StatePieChartData, String>(
                          spacing: 0.1,
                          dataSource: statePieChartData,
                          xValueMapper: (StatePieChartData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (StatePieChartData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (StatePieChartData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.block}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showReasonJilaStateChartPopup(String _firstHeadng,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_firstHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            stateBlockPieChartDataAPI(curr_parse_yr,
                                statePieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                statePieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                _firstHeadng,
                                "("+Strings.jila_titele+" -> "+statePieChartData[selectedPointIndexSubCenter].chartname.toString(),
                              _flag
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<StatePieChartData, String>>[
                        ColumnSeries<StatePieChartData, String>(
                          spacing: 0.1,
                          dataSource: statePieChartData,
                          xValueMapper: (StatePieChartData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (StatePieChartData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (StatePieChartData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.jila_titele}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showStateChartPopup(String _firstHeadng,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${Strings.anc_registration_count} $_firstHeadng',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            stateBlockPieChartDataAPI(curr_parse_yr,
                                statePieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                statePieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                _firstHeadng,
                                "("+Strings.jila_titele+" -> "+statePieChartData[selectedPointIndexSubCenter].chartname.toString(),
                              _flag
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<StatePieChartData, String>>[
                        ColumnSeries<StatePieChartData, String>(
                          spacing: 0.1,
                          dataSource: statePieChartData,
                          xValueMapper: (StatePieChartData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (StatePieChartData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (StatePieChartData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.jila_titele}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSterlizeBlockChartPopup(String frstHead,String finHead,String _flag,String _mnthry) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${Strings.anc_registration_count}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $finHead)',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            //on click CHPCH API called
                            getSterlizeCHCPHCChartDataAPI(curr_parse_yr,
                                sterlizeStateChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                sterlizeStateChartData[selectedPointIndexSubCenter].unittype.toString(),
                                "("+finHead +" -> "+ sterlizeStateChartData[selectedPointIndexSubCenter].chartname.toString(),
                                _flag,
                                _mnthry
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<SterlizeStateChartData, String>>[
                        ColumnSeries<SterlizeStateChartData, String>(
                          spacing: 0.1,
                          dataSource: sterlizeStateChartData,
                          xValueMapper: (SterlizeStateChartData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (SterlizeStateChartData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (SterlizeStateChartData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.block}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showStateBlockChartPopup(String frstHead,String finHead,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${Strings.anc_registration_count}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $finHead)',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            stateBlockPieChartCHCPHCDataAPI(curr_parse_yr,
                                stateBlockPieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                stateBlockPieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                frstHead,
                              finHead+" -> "+stateBlockPieChartData[selectedPointIndexSubCenter].chartname.toString(),
                              _flag
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          spacing: 0.1,
                          dataSource: stateBlockPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.block}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showReasonWisePositionCHCPHCChartPopup(String _subHeading,String _finsubhead,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_subHeading',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_finsubhead (${Strings.block})',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            stateReasonWiseChartCHCPHCSubCentrDataAPI(curr_parse_yr,
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                _finsubhead,
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].chartname.toString(),
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].BlockName.toString(),
                                _flag,
                                _subHeading
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //width: 10,
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: stateCHCPHCPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.chc_phc_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showStateBlockCHCPHCChartPopup(String _subHeading,String _finsubhead,String _flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${Strings.anc_registration_count} $_subHeading',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${Strings.financial_year} $head_financl_yr $_finsubhead (${Strings.block})',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            stateBlockPieChartCHCPHCSubCentrDataAPI(curr_parse_yr,
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].unitcode.toString(),
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].unittype.toString(),
                                _finsubhead,
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].chartname.toString(),
                                stateCHCPHCPieChartData[selectedPointIndexSubCenter].BlockName.toString(),
                                _flag
                            );
                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                        visibleMaximum: 10,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //width: 10,
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: stateCHCPHCPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.chc_phc_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showReasonWisePositionCHCPHCSubCenterChartPopup(String _heading,String _subCntrHead,String _subCntrHead2,String _subHeading3) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${_subHeading3}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('${Strings.financial_year} $head_financl_yr $_heading(${Strings.block} -> $_subCntrHead(${_subCntrHead2}))',textAlign:TextAlign.left,style: TextStyle(fontSize: 13),),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                          print('onClick ${selectedPointIndexSubCenter}');
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                          print('onClick ${selectedPointIndexSubCenter}');
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chartname.toString()}');

                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //width: 10,
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: stateCHCPHCSubCentrPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showStateBlockCHCPHCSubCenterChartPopup(String _heading,String _subCntrHead,String _subCntrHead2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('Images/ic_back.png',width: 20,height: 20,),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ColorConstants.dark_bar_color,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${_popHeaderTitle}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13),),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('${Strings.financial_year} $head_financl_yr $_heading(${Strings.block} -> $_subCntrHead(${_subCntrHead2}))',textAlign:TextAlign.left,style: TextStyle(fontSize: 13),),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    // margin: EdgeInsets.all(20),
                    child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      // For storing the selected data point’s index
                      onSelectionChanged: (args) {
                        if (selectedPointIndexSubCenter == args.pointIndex) {
                          selectedPointIndexSubCenter = -1;
                          print('onClick ${selectedPointIndexSubCenter}');
                        } else {
                          selectedPointIndexSubCenter = args.pointIndex;
                          print('onClick ${selectedPointIndexSubCenter}');
                        }
                        setState(() {
                          if(selectedPointIndexSubCenter != -1){
                            print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chatvalue.toString()}');
                            print('onCHCPHCSubCntrTouch ${stateCHCPHCSubCentrPieChartData[selectedPointIndexSubCenter].chartname.toString()}');

                          }
                        });
                      },
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        labelPosition: ChartDataLabelPosition.outside,
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        labelRotation: 45,
                        placeLabelsNearAxisLine: false,
                      ),
                     // primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 20, interval: 1),
                      series: <ColumnSeries<ClickBlockChildData, String>>[
                        ColumnSeries<ClickBlockChildData, String>(
                          //width: 10,
                          spacing: 0.1,
                          // Renders the track
                          //  isTrackVisible: true,
                          // Bind data source
                          dataSource: stateCHCPHCSubCentrPieChartData,
                          xValueMapper: (ClickBlockChildData value, _) => value.chartname.length > 3 ? value.chartname.replaceAll(' ', '\n') : value.chartname,
                          yValueMapper: (ClickBlockChildData value, _) => value.chatvalue,
                          // Map color for each data points from the data source
                          pointColorMapper: (ClickBlockChildData value, _) => value.color,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          // color: Colors.red
                          selectionBehavior: _selectionBehavior,
                        )
                      ],

                    )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${Strings.upkendra_title}',textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: ColorConstants.redTextColor),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  * PIE CHART Functionality ---------end -----------
  */
}

class AncRegisterData {
  AncRegisterData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class BirthTotalData {
  BirthTotalData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class DeliveryData {
  DeliveryData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class InfantData {
  InfantData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class TopSevenDistrictData {
  TopSevenDistrictData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class ClickDistrictData {
  ClickDistrictData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class ClickDistrictChildData {
  ClickDistrictChildData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class ClickDistrictSubCenterData {
  ClickDistrictSubCenterData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class ClickBlockChildData {
  ClickBlockChildData(this.chartname,this.unitcode,this.unittype,this.BlockName, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final String BlockName;
  final double chatvalue;
  final Color color;
}
class ClickBlockChildSubCntrData {
  ClickBlockChildSubCntrData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}

class TopSevenBlockData {
  TopSevenBlockData(this.chartname,this.unitcode,this.unittype,this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class CommanBlockData {
  CommanBlockData(this.chartname,this.unitcode,this.unittype,this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class MaternalData {
  MaternalData(this.chartname,this.unitcode,this.unittype,this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class InfantDeathData {
  InfantDeathData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class IndicatorwiseData {
  IndicatorwiseData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class SexRatioAtBirthData {
  SexRatioAtBirthData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class VaccineRequireData {
  VaccineRequireData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class SterlizationData {
  SterlizationData(this.chartname,this.unitcode,this.unittype, this.monthValue, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final String monthValue;
  final double chatvalue;
  final Color color;
}
class ReasonWiseHighRiskData {
  ReasonWiseHighRiskData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}

//Pie Chart Data
class StatePieChartData {
  StatePieChartData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}
class SterlizeStateChartData {
  SterlizeStateChartData(this.chartname,this.unitcode,this.unittype, this.chatvalue,this.color);
  final String chartname;
  final String unitcode;
  final String unittype;
  final double chatvalue;
  final Color color;
}

