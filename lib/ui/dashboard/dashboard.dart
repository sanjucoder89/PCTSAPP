import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:pcts/ui/aasharecords/aasha_records.dart';
import 'package:pcts/ui/anmworkplan/anmworkplan_list.dart';
import 'package:pcts/ui/dashboard/model/GetAnmRankData.dart';
import 'package:pcts/ui/hbyc/hbyc_list.dart';
import 'package:pcts/ui/pcts/pctsids/findpcts.dart';
import 'package:pcts/ui/pcts/pctsids/findpcts_details.dart';
import 'package:pcts/ui/samparksutra/samparksutra.dart';
import 'package:pcts/ui/splashnew.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:pie_chart/pie_chart.dart'; // import the package
import '../../constant/AboutAppDialoge.dart';
import '../../constant/AlreadyUpdateLatLngDialog.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/UpdateLatLngDialog.dart';
import '../aashaincentive/asha_incentive.dart';
import '../admindashboard/admin_dashboard.dart';
import '../admindashboard/anm_panel.dart';
import '../anmworkplan/anmworkplan.dart';
import '../birth_certificate/birth_certification_list.dart';
import '../birth_certificate/pdf_viewer.dart';
import '../childgrowthcart/child_gwoth_chart.dart';
import '../../main.dart';
import '../motherdeath/mothers_death_list.dart';
import '../prasav/after/after_prasav_list.dart';
import '../prasav/before/purv_prasav_list.dart';
import '../shishudeath/shishu_death_list.dart';
import '../shishutikakan/shishu_tikakaran_list.dart';
import '../videos/tab_view.dart';
import 'DropDownList.dart';
import 'anm_dashboard.dart';
import 'model/GetANMDashboardListData.dart';
import 'model/GetHelpDeskData.dart';
import 'model/GetUpdateLatLngData.dart';
import 'model/LogoutData.dart';
import 'model/UpdateLatLngData.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
void main() {
  runApp(DashboardScreen());
}

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _value = "";
  var _anmRank_url = AppConstants.app_base_url + "anmRank";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";

  var _get_anm_chart_details_url = AppConstants.app_base_url + "CreateDashboard";
  var _get_location_url = AppConstants.app_base_url + "PostLatitudeLongitude";

  List help_response_listing = [];
  late SharedPreferences preferences;
  List response_list = [];
  List response_anm_dashboard = [];
  List response_birthDetails = [];
  List response_deliveryDetails = [];
  List response_immunizationDetails = [];
  List response_indicatorWisePerformance = [];
  List response_vaccination = [];
  var incr_next_year = "";
  var fin_next_year = "";
  var parse_year = 0;

  var jilai_rank_value = "";
  var jilai_rank_value2 = "";
  var anc_value = "";
  var sansthagat_prasaav_value = "";
  var pun_tikakaran_value = "";
  var nasbandi_value = "";
  var iud_value = "";

  var block_value = "";
  var block_value2 = "";
  var block_anc_value = "";
  var block_sansthagat_prasaav_value = "";
  var block_pun_tikakaran_value = "";
  var block_nasbandi_value = "";
  var block_iud_value = "";

  var dashboardName="";
  var _districtName="";
  var _blockName="";
  /*
  * API FOR DISTRICT LISTING
  * */

  List response_listing = [];
  var _latitude="0.0";
  var _longitude="0.0";
  Future<String> getupdateLocation() async {
    preferences = await SharedPreferences.getInstance();
    print('UnitID:....> ${preferences.getString("UnitID")}');
    var response = await post(Uri.parse(_get_location_url), body: {
      "UnitID":preferences.getString("UnitID"),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetUpdateLatLngData.fromJson(resBody);
    if (apiResponse.status == true) {
      response_listing = resBody['ResposeData'];
      _latitude=response_listing[0]['AppLatitude'].toString() == "null" ? "0.0" : response_listing[0]['AppLatitude'].toString();
      _longitude=response_listing[0]['AppLongitude'].toString() == "null" ? "0.0" : response_listing[0]['AppLongitude'].toString();
      //print("api resonse lat: ${_latitude}");
      //print("api resonse lng: ${_longitude}");
      if(_latitude == "0.0" || _longitude == "0.0"){
        _updateLocationDialog();
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) => AlreadyUpdateLatLngDialog(),
        );
      }
    }
    return "Success";
  }


  Future<String> getAnmRankAPI() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var formattedDate = "${dateParse.year}";
    parse_year = int.parse(formattedDate);
    //print('current-parse_year $parse_year');
    incr_next_year = (parse_year + 1).toString();
    //print('current-next_year $incr_next_year');
    fin_next_year = incr_next_year.substring(incr_next_year.length - 2);
   // print('current-fin_next_year $fin_next_year');
   // print('current-Year $formattedDate');

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_anmRank_url), body: {
      "UnitCode": preferences.getString('UnitCode'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetAnmRankData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        if(resBody['ResposeData'].length > 0){
          jilai_rank_value2 = resBody['ResposeData'][0]['DistrictWiseRCHRank'].toString();
          jilai_rank_value = resBody['ResposeData'][0]['DistrictWise_TotalUnit'].toString();
          anc_value = resBody['ResposeData'][0]['DistrictWiseRank_ANC3'].toString();
          sansthagat_prasaav_value = resBody['ResposeData'][0]['DistrictWiseRank_InstDel'].toString();
          pun_tikakaran_value = resBody['ResposeData'][0]['DistrictWiseRank_FullImmu'].toString();
          nasbandi_value = resBody['ResposeData'][0]['DistrictWiseRank_IUD'].toString();
          iud_value = resBody['ResposeData'][0]['DistrictWiseRank_Ster'].toString();

          //Block value
          block_value2 = resBody['ResposeData'][0]['BlockWiseRank_TotalUnit'].toString();
          block_value = resBody['ResposeData'][0]['BlockWiseRCHRank'].toString();
          block_anc_value = resBody['ResposeData'][0]['BlockWiseRank_ANC3'].toString();
          block_sansthagat_prasaav_value = resBody['ResposeData'][0]['BlockWiseRank_InstDel'].toString();
          block_pun_tikakaran_value = resBody['ResposeData'][0]['BlockWiseRank_FullImmu'].toString();
          block_nasbandi_value = resBody['ResposeData'][0]['BlockWiseRank_IUD'].toString();
          block_iud_value = resBody['ResposeData'][0]['BlockWiseRank_Ster'].toString();
        }
      } else {
        //reLoginDialog();
      }
      print('anmrank.len ${response_list.length}');
      showModalSheet(context);
    });
    return "Success";
  }

  Future<String> loadFirstReponse() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _districtName=preferences.getString('DistrictName').toString();
      _blockName=preferences.getString("BlockName").toString();
      setState(() {
        dashboardName=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_dashboard : Strings.anm_dashboard;
        _anmAshaTitle=preferences.getString("AppRoleID").toString() == '33' ? Strings.aasha_title : Strings.anm_title;
        _anganbadiTitle=preferences.getString("AnganwariHindi").toString();
      });
      _unitNme=preferences.getString('UnitName').toString();
      _anmName=preferences.getString('ANMName').toString();
      _unitCode=preferences.getString('UnitCode').toString();
      _topHeaderName=preferences.getString('topName').toString();
      /*
      * 33= Asha Login
      * 32= ANM Login
      * */
      if(preferences.getString("AppRoleID").toString() == '33'){
        _isANMSESSION=false;
        _isASHASESSION=true;
      }else{
        getAnmRankAPI();
        _isANMSESSION=true;
        _isASHASESSION=false;
      }
    });
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

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  var _anganbadiTitle="";
  var _anmAshaTitle="";
  var _anmName="";
  var _unitNme="";
  var _unitCode="";
  var _topHeaderName="";
  var _totalANCReg=0;
  var _ANCRegTrimister=0;
  var _AfterANCRegTrimister=0;


  bool _loadChart = false;
  bool _loadIndicatorPer= false;
  bool _loadVaccination= false;
  bool _loadBirthDetailsChart = false;
  bool _loadDeliveryChart = false;
  bool _loadimmunizationDetailsChart= false;

  var _totalBirth=0;
  var _liveMaleBirth=0;
  var _liveFeMaleBirth=0;
  var _stillBirth=0;


  var _totalDelivery=0;
  var _delPublic=0;
  var _delPrivate=0;
  var _delHome=0;

  var _totalChilderenReg=0;
  var _fullyImmunized=0;
  var _partImmunized=0;
  var _notImmunized=0;

  late double finalImmuChartValue1;
  late double finalImmuChartValue2;
  late double finalImmuChartValue3;


   List<IndicatorData>? chartData;
   List<VaccinationData>? chartData2;
   List<AncRegisterData>? ancChartData;
   List<ChartData>? deliveryChartData;
   List<BirthData>? birthChartData;
   List<ImmuData>? ImmuChartData;
  var isChartWindowOpen=false;

  Future<String> getANMChartDetailsAPI(int parse_year) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_anm_chart_details_url), body: {
      "LoginUnitType": preferences.getString("UnitType"),
      "LoginUnitCode": preferences.getString("UnitCode"),
      "finyear": parse_year.toString(),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetANMDashboardListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
            response_anm_dashboard.clear();
            response_birthDetails.clear();
            response_deliveryDetails.clear();
            response_immunizationDetails.clear();
            response_indicatorWisePerformance.clear();
            response_vaccination.clear();
            EasyLoading.dismiss();

            response_anm_dashboard = resBody['ResposeData']['ancRegDashboard'];
            response_birthDetails = resBody['ResposeData']['birthDetails'];
            response_deliveryDetails = resBody['ResposeData']['deliveryDetails'];
            response_immunizationDetails = resBody['ResposeData']['immunizationDetails'];
            response_indicatorWisePerformance = resBody['ResposeData']['indicatorWisePerformance'];
            response_vaccination = resBody['ResposeData']['vaccineRequirement'];
            print('anm.len ${response_anm_dashboard.length}');

            if(response_anm_dashboard.length > 0){
              _loadChart=true;
              _totalANCReg=response_anm_dashboard[0]['TotalANCReg'];
              _ANCRegTrimister=response_anm_dashboard[0]['ANCRegTrimister'];
              _AfterANCRegTrimister=_totalANCReg-_ANCRegTrimister;

              var total=0.0;

              total=total+response_anm_dashboard[0]['TotalANCReg'];

             // print('ancfirst ${((response_anm_dashboard[0]['ANCRegTrimister'] / total) * 100)}%');
            //  print('ancsec ${(((response_anm_dashboard[0]['TotalANCReg']-response_anm_dashboard[0]['ANCRegTrimister']) / total) * 100)}%');
              if(ancChartData != null)ancChartData!.clear();
              ancChartData = [
                AncRegisterData('${((response_anm_dashboard[0]['ANCRegTrimister'] / total) * 100)}%',
                    response_anm_dashboard[0]['TotalANCReg'],
                    const Color.fromRGBO(255, 255, 0,0)
                ),

                AncRegisterData('${(((response_anm_dashboard[0]['TotalANCReg']-response_anm_dashboard[0]['ANCRegTrimister']) / total) * 100)}%',
                    (response_anm_dashboard[0]['TotalANCReg']-response_anm_dashboard[0]['ANCRegTrimister']),
                    const Color.fromRGBO(255, 0, 0,0)
                ),
              ];

            }else{
              _loadChart=false;
            }
            if(response_birthDetails.length > 0) {
              _loadBirthDetailsChart=true;
              _totalBirth=response_birthDetails[0]['totalBirth'];
              _liveMaleBirth=response_birthDetails[0]['liveMaleBirth'];
              _liveFeMaleBirth=response_birthDetails[0]['liveFeMaleBirth'];
              _stillBirth=response_birthDetails[0]['stillBirth'];

              var total=0.0;

              total=total+response_birthDetails[0]['totalBirth'];

              /*print('brthfirst ${((response_birthDetails[0]['liveMaleBirth'] / total) * 100)}%');
              print('brthsec ${((response_birthDetails[0]['liveFeMaleBirth'] / total) * 100)}%');
              print('brththrd ${((response_birthDetails[0]['stillBirth']/ total) * 100)}%');*/
              if(birthChartData != null)birthChartData!.clear();
              birthChartData = [
                BirthData('${((response_birthDetails[0]['liveMaleBirth'] / total) * 100)}%',
                    response_birthDetails[0]['liveMaleBirth'],
                    const Color.fromRGBO(255, 255, 0,0)
                ),

                BirthData('${((response_birthDetails[0]['liveFeMaleBirth'] / total) * 100)}%',
                    response_birthDetails[0]['liveFeMaleBirth'],
                    const Color.fromRGBO(255, 0, 0,0)
                ),

                BirthData('${((response_birthDetails[0]['stillBirth'] / total) * 100)}%',
                    response_birthDetails[0]['stillBirth'],
                    const Color.fromRGBO(51, 102, 255,0)
                ),

              ];
            }else{
              _loadBirthDetailsChart=false;
            }
            if(response_deliveryDetails.length > 0) {
              _loadDeliveryChart=true;
              _totalDelivery=response_deliveryDetails[0]['totalDelivery'];
              _delPublic=response_deliveryDetails[0]['delPublic'];
              _delPrivate=response_deliveryDetails[0]['delPrivate'];
              _delHome=response_deliveryDetails[0]['delHome'];
              var total=0.0;

              total=total+response_deliveryDetails[0]['delPublic']+response_deliveryDetails[0]['delPrivate']+response_deliveryDetails[0]['delHome'];

            /*  print('first ${((response_deliveryDetails[0]['delPublic'] / total) * 100)}%');
              print('sec ${((response_deliveryDetails[0]['delPrivate'] / total) * 100)}%');
              print('third ${((response_deliveryDetails[0]['delHome'] / total) * 100)}%');*/
              if(deliveryChartData != null)deliveryChartData!.clear();
              deliveryChartData = [

                ChartData('${((response_deliveryDetails[0]['delPublic'] / total) * 100)}%',
                    response_deliveryDetails[0]['delPublic'],
                    const Color.fromRGBO(255, 255, 0,0)),

                ChartData('${((response_deliveryDetails[0]['delPrivate'] / total) * 100)}%',
                    response_deliveryDetails[0]['delPrivate'],
                    const Color.fromRGBO(255, 0, 0,0)),

                ChartData('${((response_deliveryDetails[0]['delHome'] / total) * 100)}%',
                    response_deliveryDetails[0]['delHome'],
                    const Color.fromRGBO(51, 102, 255,0)),



              ];
            }else{
              _loadDeliveryChart=false;
            }
            if(response_immunizationDetails.length > 0){
              _loadimmunizationDetailsChart=true;
              _totalChilderenReg=response_immunizationDetails[0]['fullyImmunized']+response_immunizationDetails[0]['partImmunized']+response_immunizationDetails[0]['notImmunized'];
              _fullyImmunized=response_immunizationDetails[0]['fullyImmunized'];
              _partImmunized=response_immunizationDetails[0]['partImmunized'];
              _notImmunized=response_immunizationDetails[0]['notImmunized'];

              finalImmuChartValue1=response_immunizationDetails[0]['fullyImmunized']/_totalChilderenReg*100;
              finalImmuChartValue2=response_immunizationDetails[0]['partImmunized']/_totalChilderenReg*100;
              finalImmuChartValue3=response_immunizationDetails[0]['notImmunized']/_totalChilderenReg*100;


              var total=0.0;

              total=total+response_immunizationDetails[0]['fullyImmunized']+response_immunizationDetails[0]['partImmunized']+response_immunizationDetails[0]['notImmunized'];

             /* print('Immufirst ${((response_immunizationDetails[0]['fullyImmunized'] / total) * 100).toStringAsFixed(2)}%');
              print('Immusec ${((response_immunizationDetails[0]['partImmunized'] / total) * 100).toStringAsFixed(2)}%');
              print('Immuthird ${((response_immunizationDetails[0]['notImmunized'] / total) * 100).toStringAsFixed(2)}%');*/
              if(ImmuChartData != null)ImmuChartData!.clear();
              ImmuChartData = [

                ImmuData('${((response_immunizationDetails[0]['fullyImmunized'] / total) * 100).toStringAsFixed(2)}%',
                    response_immunizationDetails[0]['fullyImmunized'],
                    const Color.fromRGBO(255, 255, 0,0)),

                ImmuData('${((response_immunizationDetails[0]['partImmunized'] / total) * 100).toStringAsFixed(2)}%',
                    response_immunizationDetails[0]['partImmunized'],
                    const Color.fromRGBO(255, 0, 0,0)),

                ImmuData('${((response_immunizationDetails[0]['notImmunized'] / total) * 100).toStringAsFixed(2)}%',
                    response_immunizationDetails[0]['notImmunized'],
                    const Color.fromRGBO(51, 102, 255,0)),

              ];
            }else{
              _loadimmunizationDetailsChart=false;
            }
            if(response_indicatorWisePerformance.length > 0){
              _loadIndicatorPer=true;

              if(chartData != null)chartData!.clear();
               chartData = [
                IndicatorData(response_indicatorWisePerformance[0]['indicatorNameH'].toString(),
                    double.parse(response_indicatorWisePerformance[0]['indicatorValue']),
                    Color.fromRGBO(9,0,136,1)),
                IndicatorData(response_indicatorWisePerformance[1]['indicatorNameH'].toString(),
                    double.parse(response_indicatorWisePerformance[1]['indicatorValue']),
                    Color.fromRGBO(147,0,119,1)),
                IndicatorData(response_indicatorWisePerformance[2]['indicatorNameH'].toString(),
                    double.parse(response_indicatorWisePerformance[2]['indicatorValue']),
                    Color.fromRGBO(228,0,124,1)),
                IndicatorData(response_indicatorWisePerformance[3]['indicatorNameH'].toString(),
                    double.parse(response_indicatorWisePerformance[3]['indicatorValue']),
                    Color.fromRGBO(255,189,57,1)),
                IndicatorData(response_indicatorWisePerformance[4]['indicatorNameH'].toString(),
                    double.parse(response_indicatorWisePerformance[4]['indicatorValue']),
                    Color.fromRGBO(9,0,136,1)),

              ];
            }else{
              _loadIndicatorPer=false;
            }
            if(response_vaccination.length > 0){
              _loadVaccination=true;

              if(chartData2 != null)chartData2!.clear();
              chartData2 = [
                VaccinationData(response_vaccination[0]['immuName'].toString(),double.parse(response_vaccination[0]['vaccineReqCount'].toString())),
                VaccinationData(response_vaccination[1]['immuName'].toString(),double.parse(response_vaccination[1]['vaccineReqCount'].toString())),
                VaccinationData(response_vaccination[2]['immuName'].toString(),double.parse(response_vaccination[2]['vaccineReqCount'].toString())),
                VaccinationData(response_vaccination[3]['immuName'].toString(),double.parse(response_vaccination[3]['vaccineReqCount'].toString())),
                VaccinationData(response_vaccination[4]['immuName'].toString(),double.parse(response_vaccination[4]['vaccineReqCount'].toString())),

              ];
            }else{
              _loadVaccination=false;
            }
        }else{

           _totalANCReg=0;
           _ANCRegTrimister=0;
           _AfterANCRegTrimister=0;

             _totalBirth=0;
             _liveMaleBirth=0;
             _liveFeMaleBirth=0;
             _stillBirth=0;


             _totalDelivery=0;
             _delPublic=0;
             _delPrivate=0;
             _delHome=0;

             _totalChilderenReg=0;
             _fullyImmunized=0;
             _partImmunized=0;
             _notImmunized=0;
            response_anm_dashboard.clear();
            response_birthDetails.clear();
            response_deliveryDetails.clear();
            response_immunizationDetails.clear();
            response_indicatorWisePerformance.clear();
            response_vaccination.clear();
            print('inside else ');
            print('anm else dash.len ${response_anm_dashboard.length}');
            print('anm else birth.len ${response_birthDetails.length}');
            if(response_anm_dashboard.length == 0){
              _loadChart=false;
            }else{
              _loadChart=true;
            }
            if(response_birthDetails.length == 0) {
              _loadBirthDetailsChart=false;
            }else{
              _loadBirthDetailsChart=true;
            }
            if(response_deliveryDetails.length == 0){
              _loadDeliveryChart=false;
            }else{
              _loadDeliveryChart=true;
            }

            if(response_immunizationDetails.length == 0){
              _loadimmunizationDetailsChart=false;
            }else{
              _loadimmunizationDetailsChart=true;
            }

            if(response_indicatorWisePerformance.length == 0){
              _loadIndicatorPer=false;
            }else{
              _loadIndicatorPer=true;
            }

            if(response_vaccination.length == 0){
              _loadVaccination=false;
            }else{
              _loadVaccination=true;
            }
           EasyLoading.dismiss();
      }
      //print('isResultShow ${isResultShow}');
      if(isResultShow == false){
        _recallCheckBookingStatusAPI(parse_year);
      }

    });
   // print('response:${apiResponse.status}');
   // print('response:${apiResponse.message}');
    return "Success";
  }
  var count=1;
  var ifTabOne=false;
  var isResultShow=false;

  _recallCheckBookingStatusAPI(int parse_year)async{
    await Future.delayed(Duration(milliseconds: 1000), () {
      count++;
      print('counter ${count}');
      if(ifTabOne == false){
        getANMChartDetailsAPI(parse_year);
      }else{
        getANMChartDetailsAPI(parse_year-1);
      }
      if(count == 2){
        isResultShow=true;
        count=1;
        EasyLoading.dismiss();
        if(isChartWindowOpen == false){
          showANMDashBoardSheet(context);
        }
      }

    });
  }

  @override
  void initState() {
    super.initState();
    loadFirstReponse();
    getHelpDesk();
    startTimer();
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    EasyLoading.dismiss();
  }

  var _isANMSESSION=true;
  var _isASHASESSION=false;

  late Timer _timer;
  int _start = 20000;


  void startTimer() {
    print('on tap start timerrrrr....');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
        if (_start == 0) {
          setState(() {
            print('cancel timer');
            timer.cancel();
            logoutSession();
          });
        } else {
          setState(() {
            _start--;
            print('timer runing $_start');
          });
        }
      },
    );
  }
  void stopTimer() {
    setState(() {
      print('on tap stop timerrrrr....');
      _start = 20000;
      _timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('${Strings.exit_from_app}',style: TextStyle(fontSize: 15,color: ColorConstants.AppColorPrimary),),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        willLeave = true;
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
          return willLeave;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Container(
              child: new Image.asset(
                'Images/pcts_logo1.png',
                height: 60.0,
              ),
            ),
            backgroundColor: ColorConstants.AppColorPrimary,
            actions: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(right: 10),
                    child:Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                          child: Image.asset("Images/nationalem.png")//widget.country_img
                      ),
                      alignment: Alignment.centerRight,

                    ),
                  ),
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
              )
            ],
          ),
          backgroundColor: ColorConstants.asha_white,
          key: _scaffoldKey,
          drawer: Drawer(
            child:
            Container(color: ColorConstants.AppColorDark, child: _myListView()),
          ),
          body: GestureDetector(
            onTap: (){
              stopTimer();
            },
            child: Container(
              child: Column(
                  children: <Widget>[
                    Container(
                      color: ColorConstants.appNewBrowne,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '$_anmAshaTitle',
                                              style: TextStyle(
                                                  color: ColorConstants.app_yellow_color,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )),
                                    Container(
                                      child: Flexible(
                                       child: Text(_anmName == "null" ? "-" :_anmName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: ColorConstants.white,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 3),
                                          child: Text(Strings.sanstha_title,
                                              style: TextStyle(
                                                  color: ColorConstants.app_yellow_color,
                                                  fontSize: 14)),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(_topHeaderName == "null" ? "-" : _topHeaderName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: ColorConstants.white,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                          _isASHASESSION == true ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: Text(Strings.anganbadi,
                                      style: TextStyle(
                                          color: ColorConstants.app_yellow_color,
                                          fontSize: 14)),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(': ${_anganbadiTitle}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        color: ColorConstants.white,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                              )
                            ],
                          ): Container()
                        ],
                      ),
                    ),
                    _isASHASESSION == true
                        ?
                    Container(
                      color: ColorConstants.asha_white,
                      height: 10.0,
                    )
                        :
                    Container(
                      color: ColorConstants.asha_white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: ColorConstants.appNewlightyello,
                            ),
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            _scaffoldKey.currentState!.openDrawer();
                                          },
                                          child: Container(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(child: Text(//' $jilai_rank_value / $jilai_rank_value2'
                                                      "${_districtName == "null" ? "" : _districtName} जिले में रैंक",
                                                      style:
                                                      TextStyle(color: ColorConstants.AppColorDark,fontWeight: FontWeight.normal,fontSize: 13),
                                                    )),
                                                    Expanded(child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Center(
                                                        child: Text(
                                                          "$jilai_rank_value / $jilai_rank_value2",
                                                          textAlign: TextAlign.left,
                                                          style:
                                                          TextStyle(color: ColorConstants.black,fontWeight: FontWeight.normal,fontSize: 13),
                                                        ),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))),
                                Center(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: VerticalDivider(
                                          width: 0,
                                          color: Colors.black,
                                          thickness: 1.5,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Expanded(child: Text(
                                                  "${_blockName == "null" ? "" : _blockName} ब्लॉक में रैंक",
                                                  style: TextStyle(color: ColorConstants.AppColorDark,fontWeight: FontWeight.normal,fontSize: 13),
                                                )),
                                                Expanded(child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Center(
                                                    child: Text(
                                                      '$block_value-$block_value2',
                                                      textAlign: TextAlign.left,
                                                      style:
                                                      TextStyle(color: ColorConstants.black,fontWeight: FontWeight.normal,fontSize: 13),
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(child: Container(
                      color: ColorConstants.asha_white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: _isANMSESSION,
                                    child: Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              stopTimer();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        AashaRecords(),
                                                  ));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight: Radius.circular(5),
                                                    bottomLeft: Radius.circular(5),
                                                    bottomRight: Radius.circular(5)),
                                              ),
                                              color: ColorConstants.AppColorDark,
                                              elevation: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(5)),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        ColorConstants.buttongraddark,
                                                        ColorConstants.buttongradlight
                                                      ],
                                                      begin: Alignment.bottomLeft,
                                                      end: Alignment.bottomRight,
                                                    )),
                                                margin: EdgeInsets.only(
                                                    left: 1, right: 1, top: 1, bottom: 1),
                                                height: 100.0,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset(
                                                        "Images/certificate.png",
                                                        fit: BoxFit.fitHeight,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Center(
                                                          child: Text(
                                                            'आशा रिकॉर्ड ',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))),),
                                  Visibility(
                                    visible: _isASHASESSION,
                                    child: Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              stopTimer();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        AshaIncentive(),
                                                  )).then((value){setState(() {
                                                   // startTimer();
                                              });});
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight: Radius.circular(5),
                                                    bottomLeft: Radius.circular(5),
                                                    bottomRight: Radius.circular(5)),
                                              ),
                                              color: ColorConstants.AppColorDark,
                                              elevation: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(5)),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        ColorConstants.buttongraddark,
                                                        ColorConstants.buttongradlight
                                                      ],
                                                      begin: Alignment.bottomLeft,
                                                      end: Alignment.bottomRight,
                                                    )),
                                                margin: EdgeInsets.only(
                                                    left: 1, right: 1, top: 1, bottom: 1),
                                                height: 100.0,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset(
                                                        "Images/certificate.png",
                                                        fit: BoxFit.fitHeight,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Center(
                                                          child: Text(
                                                            'प्रोत्साहन राशि',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))),),
                                  Expanded(
                                      child:GestureDetector(
                                          onTap: () {
                                            stopTimer();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      AnmWorkPlanListScreen(),
                                                )).then((value){setState(() {
                                              //startTimer();
                                            });});
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5)),
                                            ),
                                            color: ColorConstants.AppColorDark,
                                            elevation: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(5)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorConstants.buttongraddark,
                                                      ColorConstants.buttongradlight
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.bottomRight,
                                                  )),
                                              margin: EdgeInsets.only(
                                                  left: 1, right: 1, top: 1, bottom: 1),
                                              height: 100.0,
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Image.asset(
                                                      "Images/anm_wo_plan.png",
                                                      fit: BoxFit.fitHeight,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(
                                                        child: Text(
                                                          'मासिक कार्य योजना',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          preferences = await SharedPreferences.getInstance();
                                          showPopupDialog(preferences.getString('UnitCode').toString());
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/mother_des.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'महिला का विवरण',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    PurvPrasavScreenList(),
                                              )).then((value){setState(() {
                                         //   startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/anc_btn.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'प्रसव पूर्व जाँच',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    AfterPrasavScreenList(),
                                              )).then((value){setState(() {
                                           // startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/pnc_btn.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'प्रसव पश्चात जाँच',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    ShishuTikaKaranList(),//PopupMenu ,ShishuTikaKaranList
                                              )).then((value){setState(() {
                                           // startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/imm_btn_1.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        Strings.shishu_tikakarn_title,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            /*Shihu Tikakarn View*/
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    MothersDeathList(),
                                              )).then((value){setState(() {
                                           // startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/anc_btn.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'मातृ मृत्यु',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    ShishuDeathList(),
                                              )).then((value){setState(() {
                                          //  startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/baby_death.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'शिशु मृत्यु ',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    HBYCListScreen(),//PopupMenu ,ShishuTikaKaranList
                                              )).then((value){setState(() {
                                          //  startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/hbyc.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'एचबीवाईसी ',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    FindPCTSIDScreen(),
                                              )).then((value){setState(() {
                                         //   startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/search_1.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'पीसीटीएस आईडी ढूँढे',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    TabViewScreen(),//TabViewScreen ,VideoScreen
                                              )).then((value){setState(() {
                                         //   startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/youtube.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'वीडियो',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    ChildGrowthChartScreen(),//TabViewScreen ,VideoScreen
                                              )).then((value){setState(() {
                                           // startTimer();
                                          });});
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                          ),
                                          color: ColorConstants.AppColorDark,
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ColorConstants.buttongraddark,
                                                    ColorConstants.buttongradlight
                                                  ],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                            margin: EdgeInsets.only(
                                                left: 1, right: 1, top: 1, bottom: 1),
                                            height: 100.0,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/growthchartnew.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'बच्चे का ग्रोथ चार्ट',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 70.0,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Visibility(
                                        visible: false,
                                        child: GestureDetector(
                                          onTap: (){
                                            stopTimer();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      ChildGrowthChartScreen(),//TabViewScreen ,VideoScreen
                                                )).then((value){setState(() {
                                             // startTimer();
                                            });});
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5),
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5)),
                                            ),
                                            color: ColorConstants.AppColorDark,
                                            elevation: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(5)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorConstants.buttongraddark,
                                                      ColorConstants.buttongradlight
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.bottomRight,
                                                  )),
                                              margin: EdgeInsets.only(
                                                  left: 1, right: 1, top: 1, bottom: 1),
                                              height: 100.0,
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Image.asset(
                                                      "Images/growthchartnew.png",
                                                      fit: BoxFit.fitHeight,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(
                                                        child: Text(
                                                          'बच्चे का ग्रोथ चार्ट',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: Column(
                                        children:<Widget>[
                                          Visibility(
                                              visible: false,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5),
                                                      topRight: Radius.circular(5),
                                                      bottomLeft: Radius.circular(5),
                                                      bottomRight: Radius.circular(5)),
                                                ),
                                                color: ColorConstants.AppColorDark,
                                                elevation: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(5)),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          ColorConstants.buttongraddark,
                                                          ColorConstants.buttongradlight
                                                        ],
                                                        begin: Alignment.bottomLeft,
                                                        end: Alignment.bottomRight,
                                                      )),
                                                  margin: EdgeInsets.only(
                                                      left: 1, right: 1, top: 1, bottom: 1),
                                                  height: 100.0,
                                                  width: double.infinity,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Image.asset(
                                                          "Images/certificate.png",
                                                          fit: BoxFit.fitHeight,
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Center(
                                                            child: Text(
                                                              'Record Verification',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 14),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            color: ColorConstants.asha_white,
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        stopTimer();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BirthCertificateListScreen(),//DropDownList  ,BirthCertificateListScreen
                                            )).then((value){setState(() {
                                          //startTimer();
                                        });});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2, right: 5),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorConstants.AppColorDark,
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40.0),
                                                  bottomRight: Radius.circular(0.0),
                                                  topLeft: Radius.circular(0.0),
                                                  bottomLeft: Radius.circular(0.0)),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    "Images/certificate.png",
                                                    fit: BoxFit.fitHeight,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                      child: Text(
                                                        'जन्म प्रमाण पत्र',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorConstants.app_yellow_color,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            )),
                                      ),
                                    )),
                                Expanded(
                                    child: Visibility(
                                      visible: false,
                                      child: GestureDetector(
                                        onTap: (){
                                          stopTimer();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => AnmDashboard()//AdminDashboard ,AnmDashboard
                                            ),
                                          ).then((value){setState(() {
                                            //startTimer();
                                          });});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 2, left: 5),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorConstants.AppColorDark,
                                                border: Border.all(
                                                  color: Colors.blue,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(0.0),
                                                    bottomRight: Radius.circular(0.0),
                                                    topLeft: Radius.circular(40.0),
                                                    bottomLeft: Radius.circular(0.0)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Image.asset(
                                                      "Images/anm_dashboard_icn.png",
                                                      fit: BoxFit.fitHeight,
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Center(
                                                        child: Text(
                                                          dashboardName,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: ColorConstants.app_yellow_color,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14),
                                                        )),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Image.asset(
                            "Images/footerpcts.jpg",
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.bottomLeft,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }


  ShowAboutAppDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AboutAppDialoge(),
    );
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

  var _selected=false;
  var _selectedTab=true;
  var _selected2Tab=false;
  void showANMDashBoardSheet(BuildContext context) {
    setState(() {
      isChartWindowOpen=true;
      Future<void> future = showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          builder: (context) {
            return DraggableScrollableSheet(
                initialChildSize: 0.94,
                minChildSize: 0.94,
                maxChildSize: 0.94,
                expand: false,
                builder: (context, scrollController) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
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
                                            child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  count=1;
                                                  ifTabOne=false;
                                                  getANMChartDetailsAPI(parse_year);
                                                  _selectedTab=true;
                                                  _selected2Tab=false;
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
                                                      child: Text(
                                                        '$parse_year-$fin_next_year',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 13),
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
                                                print('click ${parse_year}');
                                                setState(() {
                                                  ifTabOne=true;
                                                  getANMChartDetailsAPI(parse_year-1);
                                                  _selectedTab=false;
                                                  _selected2Tab=true;
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
                                                      child: Text(
                                                        //'$parse_year-$fin_next_year',
                                                        '${parse_year - 1}-${int.parse(fin_next_year) - 1}',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 13),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                //_selected=!_selected;
                                                //print('_selected ${_selected}');
                                              });
                                            },
                                            child: Container(
                                              child: Text(
                                                Strings.anm_dashboard,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: _selected ==true ? Colors.black : Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  padding: EdgeInsets.only(right: 10),
                                                  child: Image.asset(
                                                    "Images/ic_cross.png",
                                                    width: 20,
                                                    height: 20,
                                                  )),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(child: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
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
                                                    Text('${Strings.anc_panjikaran} $_totalANCReg',
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
                                                                Text('${Strings.first_3_mahi_k_andar} $_ANCRegTrimister',
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
                                                                Text('${Strings.first_3_mahi_k_baad} $_AfterANCRegTrimister',
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
                                              child: _loadChart == true ? Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: SfCircularChart(
                                                  tooltipBehavior: TooltipBehavior(enable: true),
                                                  series: <CircularSeries<AncRegisterData, String>>[
                                                    DoughnutSeries<AncRegisterData, String>(
                                                        radius: '100%',
                                                        dataSource: ancChartData,
                                                        xValueMapper: (AncRegisterData data, _) => data.x,
                                                        yValueMapper: (AncRegisterData data, _) => data.y,
                                                        /// The property used to apply the color for each douchnut series.
                                                        pointColorMapper: (AncRegisterData data, _) => data.colorr,
                                                        name: '',
                                                        dataLabelMapper: (AncRegisterData data, _) => data.x,
                                                        dataLabelSettings: const DataLabelSettings(
                                                            isVisible: true, labelPosition: ChartDataLabelPosition.inside))
                                                    ,
                                                  ],

                                                ),
                                              ) : SizedBox(
                                                height: 200,
                                                /*child: Container(
                                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                                )*/
                                              ),)
                                            )
                                          ],
                                        ),
                                      ),

                                      //Header2
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
                                                    Text('${Strings.total_birth} $_totalBirth',
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
                                                                Text('${Strings.live_girl_birth} $_liveMaleBirth',
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
                                                                Text('${Strings.live_boy_birth} $_liveFeMaleBirth',
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
                                                                Text('${Strings.total_death_birth} $_stillBirth',
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
                                              child: _loadBirthDetailsChart == true ? Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: SfCircularChart(
                                                  tooltipBehavior: TooltipBehavior(enable: true),
                                                  series: <CircularSeries<BirthData, String>>[
                                                    DoughnutSeries<BirthData, String>(
                                                        radius: '100%',
                                                        dataSource: birthChartData,
                                                        xValueMapper: (BirthData data, _) => data.x,
                                                        yValueMapper: (BirthData data, _) => data.y,
                                                        /// The property used to apply the color for each douchnut series.
                                                        pointColorMapper: (BirthData data, _) => data.colorr,
                                                        name: '',
                                                        dataLabelMapper: (BirthData data, _) => data.x,
                                                        dataLabelSettings: const DataLabelSettings(
                                                            isVisible: true, labelPosition: ChartDataLabelPosition.inside))
                                                    ,
                                                  ],
                                                ),
                                              ) :SizedBox(
                                                height: 200,
                                               /* child: Container(
                                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                                ),*/
                                              ),)
                                            )
                                          ],
                                        ),
                                      ),


                                      //Header3
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
                                                    Text('${Strings.total_deli} $_totalDelivery',
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
                                                                Text('${Strings.deli_in_govt} $_delPublic',
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
                                                                Text('${Strings.deli_in_pvt} $_delPrivate',
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
                                                                Text('${Strings.deli_in_home} $_delHome',
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
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <CircularSeries<ChartData, String>>[
                                                      DoughnutSeries<ChartData, String>(
                                                          radius: '100%',
                                                          dataSource: deliveryChartData,
                                                          xValueMapper: (ChartData data, _) => data.x,
                                                          yValueMapper: (ChartData data, _) => data.y,
                                                          /// The property used to apply the color for each douchnut series.
                                                          pointColorMapper: (ChartData data, _) => data.colorr,
                                                          name: '',
                                                          dataLabelMapper: (ChartData data, _) => data.x,
                                                          dataLabelSettings: const DataLabelSettings(
                                                              isVisible: true, labelPosition: ChartDataLabelPosition.inside))
                                                      ,
                                                    ],
                                                  )
                                              ) : SizedBox(
                                                height: 200,
                                                /*child: Container(
                                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                                ),*/
                                              ),)
                                            )
                                          ],
                                        ),
                                      ),

                                      //Header4
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
                                                    Text('${Strings.reg_sishu} $_totalChilderenReg',
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
                                                                Text('${Strings.pun_tikkaran} $_fullyImmunized',
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
                                                                Text('${Strings.anshik_tikkaran} $_partImmunized',
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
                                                                Text('${Strings.tikkaran_pending} $_notImmunized',
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
                                              child: _loadimmunizationDetailsChart == true ? Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: SfCircularChart(
                                                    tooltipBehavior: TooltipBehavior(enable: true),
                                                    series: <CircularSeries<ImmuData, String>>[
                                                      DoughnutSeries<ImmuData, String>(
                                                          radius: '100%',
                                                          dataSource: ImmuChartData,
                                                          xValueMapper: (ImmuData data, _) => data.x,
                                                          yValueMapper: (ImmuData data, _) => data.y,
                                                          /// The property used to apply the color for each douchnut series.
                                                          pointColorMapper: (ImmuData data, _) => data.colorr,
                                                          name: '',
                                                          dataLabelMapper: (ImmuData data, _) => data.x,
                                                          dataLabelSettings: const DataLabelSettings(
                                                              isVisible: true, labelPosition: ChartDataLabelPosition.inside))
                                                      ,
                                                    ],
                                                  )
                                              ) : SizedBox(
                                                height: 200,
                                                /*child: Container(
                                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                                ),*/
                                              ),)
                                            )
                                          ],
                                        ),
                                      ),

                                      //Header5
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
                                                    Text('${Strings.indicator_perfomance}',
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
                                        height: 200,
                                        color: ColorConstants.white,
                                        child: _loadIndicatorPer == true ? Padding(
                                          padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                          child: SfCartesianChart(
                                            // Initialize category axis
                                            primaryXAxis: CategoryAxis(),
                                            // Palette colors
                                            palette: <Color>[
                                              Colors.red,
                                              Colors.orange,
                                              Colors.yellow,
                                              Colors.green,
                                              Colors.brown
                                            ],
                                            series: <ColumnSeries<IndicatorData, String>>[
                                              ColumnSeries<IndicatorData, String>(
                                                // Renders the track
                                                isTrackVisible: true,
                                                // Bind data source
                                                dataSource: chartData!,
                                                xValueMapper: (IndicatorData sales, _) => sales.indicatorNameH,
                                                yValueMapper: (IndicatorData sales, _) => sales.indicatorValue,
                                                //color: (IndicatorData sales, _) => sales.color,
                                                // Enable data label
                                                dataLabelSettings: DataLabelSettings(isVisible: true),
                                                // color: Colors.red
                                              )
                                            ],
                                          ),
                                        )
                                            : SizedBox(
                                          height: 200,
                                          child: Container(
                                            color: ColorConstants.white,
                                          ),
                                        ),
                                      ),

                                      //Header6
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
                                                    Text('${Strings.need_of_vacination}',
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
                                        height: 200,
                                        color: ColorConstants.white,
                                        child: _loadVaccination == true ? Padding(
                                          padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                          child: SfCartesianChart(
                                            // Initialize category axis
                                            primaryXAxis: CategoryAxis(),
                                            series: <ColumnSeries<VaccinationData, String>>[
                                              ColumnSeries<VaccinationData, String>(
                                                // Bind data source
                                                dataSource: chartData2!,
                                                xValueMapper: (VaccinationData sales, _) => sales.immuName,
                                                yValueMapper: (VaccinationData sales, _) => sales.vaccineReqCount,
                                                // Enable data label
                                                dataLabelSettings: DataLabelSettings(isVisible: true),
                                                // color: Colors.red
                                              )
                                            ],
                                          ),
                                        )
                                            : SizedBox(
                                              height: 200,
                                          child: Container(
                                            color: ColorConstants.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        );
                      });
                });
          });
      future.then((void value) => _closeModal(value));
    });

  }


  void _closeModal(void value) {
    isResultShow=false;
    var _selected=false;
    var _selectedTab=true;
    var _selected2Tab=false;
    isChartWindowOpen=false;
  }

  createBox(BuildContext context, StateSetter state) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: ColorConstants.buttongradlight,
                            ),
                            padding: EdgeInsets.all(5),
                            width: 30,
                            child: Container(
                                child: Center(
                              child: Text(
                                '$parse_year-$fin_next_year',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          child: Text(
                            Strings.anm_ki_rank,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  "Images/ic_cross.png",
                                  width: 20,
                                  height: 20,
                                )),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.dark_bar_color,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.jila_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          ' $jilai_rank_value / $jilai_rank_value2',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.anc_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          anc_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.sansthagat_prasav_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          sansthagat_prasaav_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.puntikaikaran_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          pun_tikakaran_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.nasbandi_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          nasbandi_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.ieud_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          iud_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.dark_bar_color,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.block_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          '$block_value-$block_value2',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.anc_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          block_anc_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.sansthagat_prasav_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          block_sansthagat_prasaav_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.puntikaikaran_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          block_pun_tikakaran_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.nasbandi_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          block_nasbandi_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  color: ColorConstants.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(Strings.ieud_ki_rank,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      )),
                      Container(
                        width: 100,
                        child: Text(
                          block_iud_value,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ])
        ],
      ),
    );
  }

  Widget _myListView() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            color: ColorConstants.AppColorPrimary,
            child: Column(
              children:<Widget> [
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "स्वागत , ",
                          style: TextStyle(
                              color: ColorConstants.headerTitleColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      )),
                      Expanded(child:GestureDetector(
                        onTap: (){
                          // Then close the drawer
                           Navigator.pop(context);
                           stopTimer();
                        },
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset("Images/ic_cross.png",width: 15,height: 15,color: ColorConstants.white,),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "${_anmName}",
                        maxLines: 1,
                        //overflow: TextOverflow.ellipsis,
                        //softWrap: false,
                        style: TextStyle(
                            color: ColorConstants.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    )),
                    Expanded(child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        child: Text(
                          "$_unitNme ${_unitCode}",
                          maxLines: 1,
                        //  overflow: TextOverflow.ellipsis,
                         // softWrap: false,
                          style: TextStyle(
                              color: ColorConstants.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 1000,
            child: Column(
              children: [
                Container(
                  decoration: new BoxDecoration (
                      color: Colors.white
                  ),
                  child: ListTile(
                    title: Text("होम पेज"),
                    onTap: () {
                      stopTimer();
                      if(preferences.getString("LoginType") == "superadmin"){//super admin panel access
                        preferences.setString("UnitCode", preferences.getString("temp_unitcode").toString());
                        preferences.setString("UnitID", preferences.getString("temp_unitid").toString());
                        preferences.setString("ANMName", preferences.getString("temp_anmname").toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AdminDashboard(),
                            )).then((value){setState(() {
                         // startTimer();
                        });});
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DashboardScreen()
                          ),
                        ).then((value){setState(() {
                        //  startTimer();
                        });});
                      }
                    },
                    leading: Image.asset(
                      'Images/homebtnimg.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Divider(height: 1),
                Container(
                  decoration: new BoxDecoration (
                      color: ColorConstants.lifebgColor
                  ),
                  child: ListTile(
                    title: Text("एएनसी के डयू केसेज"),
                    onTap: () {
                      stopTimer();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PurvPrasavScreenList(),
                          )).then((value){setState(() {
                        //startTimer();
                      });});
                    },
                    leading: Image.asset(
                      'Images/anc_btn_img.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("पीएनसी के डयू केसेज"),
                  onTap: () {
                    stopTimer();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AfterPrasavScreenList(),
                        )).then((value){setState(() {
                      //startTimer();
                    });});
                  },
                  leading: Image.asset(
                    'Images/pnc_btn.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                Container(
                  decoration: new BoxDecoration (
                      color: ColorConstants.lifebgColor
                  ),
                  child: ListTile(
                    title: Text("टीकाकरण के डयू केसेज"),
                    onTap: () {
                      stopTimer();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ShishuTikaKaranList(),//PopupMenu ,ShishuTikaKaranList
                          )).then((value){setState(() {
                       // startTimer();
                      });});
                    },
                    leading: Image.asset(
                      'Images/imm_btn_side.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text("पीसीटीएस आईडी ढूँढे"),
                  onTap: () {
                    stopTimer();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FindPCTSIDScreen(),
                        )).then((value){setState(() {
                     // startTimer();
                    });});
                  },
                  leading: Image.asset(
                    'Images/search_1.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Divider(height: 1),
                Container(
                  decoration: new BoxDecoration (
                      color: ColorConstants.lifebgColor
                  ),
                  child: ListTile(
                    title: Text("संस्था को मैप पर चिन्हित करें"),
                    onTap: () {
                      stopTimer();
                      Navigator.pop(context);
                      getupdateLocation();
                    },
                    leading: Image.asset(
                      'Images/location_icon.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          )
        ],
      ),
    );
  }

  _updateLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateLatLngDialog(),
    );
  }

  TextEditingController pctsIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> showPopupDialog(String _unitCode) async {
    pctsIdController.text= _unitCode;
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
                  color: ColorConstants.light_yellow_color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Strings.pcts_id_saish_darj_krai,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.appNewBrowne,fontSize: 13),),
                  ),
                ),
                const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: pctsIdController,
                      decoration: InputDecoration(
                        hintText: Strings.pcts_id,
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
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          stopTimer();
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pop(context);
                          Navigator.push(context,MaterialPageRoute(builder: (context) => FindPCTSDetails(pctsID:pctsIdController.text.toString().trim()))
                          ).then((value){setState(() {
                           // startTimer();
                          });});
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child:Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(Strings.aagai_badai,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Strings.radd_krai,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
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
class IndicatorData {
  IndicatorData(this.indicatorNameH, this.indicatorValue,this.color);
  final String indicatorNameH;
  final double indicatorValue;
  final Color color;
}
class VaccinationData {
  VaccinationData(this.immuName, this.vaccineReqCount);
  final String immuName;
  final double vaccineReqCount;
}
class AncRegisterData {
  AncRegisterData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class DelivryData {
  DelivryData(this.totalDelivery, this.delPublic,this.delPrivate, this.delHome);
  final String totalDelivery;
  final String delPublic;
  final String delPrivate;
  final String delHome;
}
class ChartData {
  ChartData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class BirthData {
  BirthData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}
class ImmuData {
  ImmuData(this.x, this.y,this.colorr);
  final String x;
  final int y;
  final Color colorr;
}