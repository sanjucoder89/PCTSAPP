import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'model/GetANMDashboardListData.dart';

class AnmDashboard extends StatefulWidget {
  const AnmDashboard({Key? key}) : super(key: key);

  @override
  State<AnmDashboard> createState() => _AnmDashboardState();
}

class _AnmDashboardState extends State<AnmDashboard> {
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

  var _selectedTab=true;
  var _selected2Tab=false;
  List<IndicatorData>? chartData;
  List<VaccinationData>? chartData2;
  List<AncRegisterData>? ancChartData;
  List<ChartData>? deliveryChartData;
  List<BirthData>? birthChartData;
  List<ImmuData>? ImmuChartData;
  var isChartWindowOpen=false;
  var _get_anm_chart_details_url = AppConstants.app_base_url + "CreateDashboard";
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


  /*
  * API FOR DISTRICT LISTING
  * */
  Future<String> getCurrentYear() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var formattedDate = "${dateParse.year}";
    parse_year = int.parse(formattedDate);
   // print('current-parse_year $parse_year');
    incr_next_year = (parse_year + 1).toString();
    //print('current-next_year $incr_next_year');
    fin_next_year = incr_next_year.substring(incr_next_year.length - 2);
    //print('current-fin_next_year $fin_next_year');
    //print('current-Year $formattedDate');

    getANMChartDetailsAPI(parse_year);
    return "";
  }

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
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  late Timer _timer;
  int _start = 20000;

  @override
  void initState() {
    super.initState();
    getCurrentYear();
    //startTimer();
  }

  void startTimer() {
    print('on tap start timerrrrr....');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          print('cancel timer');
          timer.cancel();
          //logoutSession();
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
  void dispose() {
    _timer.cancel();
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.AppColorDark,
      body: Container(
        margin: EdgeInsets.only(top: 30),
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
                                getANMChartDetailsAPI(parse_year);
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
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            Strings.anm_dashboard,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
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
                              padding: const EdgeInsets.all(10.0),
                              child: SfCircularChart(
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <CircularSeries<AncRegisterData, String>>[
                                  DoughnutSeries<AncRegisterData, String>(
                                      strokeWidth: 2,
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
                                      )),
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
                                child: Container(
                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                )
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
                                child: Container(
                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                )
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
                                child: Container(
                                  child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                                )
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
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
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
                            child: Center(child: Text(Strings.loading,style: TextStyle(color: Colors.red,fontSize: 14),)),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ))
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