import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../anmworkplan/model/GetYearListData.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'chart_demo.dart';
import 'chart_details.dart';
import 'model/ChildGrowthList2Data.dart';
import 'model/ChildGrowthListData.dart';
import 'package:intl/intl.dart'; //for date format


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


class ChildGrowthChartScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ChildGrowthChartScreen();


}

class _ChildGrowthChartScreen extends State<ChildGrowthChartScreen> {

  late String _apiMonthKey = "0";
  late String _apiYearKey = "0";
  late String _selectedMonthID = "0";
  List yearlist = [];

  late String yearselect = "";

  List<CustomMonthsList> month_list = [
    CustomMonthsList(
      mid: "0",
      name: "चुनें",
    ),
    CustomMonthsList(
      mid: "1",
      name: "जनवरी",
    ),
    CustomMonthsList(
      mid: "2",
      name: "फरवरी",
    ),
    CustomMonthsList(
      mid: "3",
      name: "मार्च",
    ),
    CustomMonthsList(
      mid: "4",
      name: "अप्रैल",
    ),
    CustomMonthsList(
      mid: "5",
      name: "मई",
    ),
    CustomMonthsList(
      mid: "6",
      name: "जून",
    ),
    CustomMonthsList(
      mid: "7",
      name: "जुलाई",
    ),
    CustomMonthsList(
      mid: "8",
      name: "अगस्त",
    ),
    CustomMonthsList(
      mid: "9",
      name: "सितम्बर",
    ),
    CustomMonthsList(
      mid: "10",
      name: "अक्टूबर",
    ),
    CustomMonthsList(
      mid: "11",
      name: "नवम्बर",
    ),
    CustomMonthsList(
      mid: "12",
      name: "दिसम्बर",
    ),
  ];

  int getMonthsLength() {
    return month_list.length;
  }

  Future<String> getYearForAnmPlan(String _yrmnth) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var response = await get(Uri.parse(_year_api_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetYearListData.fromJson(resBody);

    setState(() {
      if (apiResponse.status == true) {
        // yearlist = apiResponse.resposeData!;
        yearlist = resBody['ResposeData'];
        // yearselect = apiResponse.resposeData![0].year.toString();
       // yearselect = resBody['ResposeData'][0]['Year'].toString();
        //print('responceyeardata ${yearlist.length} $yearselect');
      } else {

      }
      getChildGrowthListAPI(_yrmnth);
    });

    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMonthYear();
    getHelpDesk();
  }

  var _finalYrMnth = "";

  getCurrentMonthYear() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var nowMonth = "${dateParse.month}";
    var nowYear = "${dateParse.year}";
    setState(() {
      setState(() {
        if(dateParse.month.toString().length == 1){
          yearselect=dateParse.year.toString();
          _apiMonthKey="0"+dateParse.month.toString();
          _apiYearKey=dateParse.year.toString();
          _finalYrMnth=dateParse.year.toString()+"0"+dateParse.month.toString();
          _selectedMonthID=dateParse.month.toString();
        }else{
          yearselect=dateParse.year.toString();
          _selectedMonthID=dateParse.month.toString();
          _apiMonthKey=dateParse.month.toString();
          _apiYearKey=dateParse.year.toString();
          _finalYrMnth=dateParse.year.toString()+dateParse.month.toString();
        }
        print('defaultDate ${_finalYrMnth}');
      });
      getYearForAnmPlan(_finalYrMnth);
    });
  }

  var _year_api_url = AppConstants.app_base_url + "GetYearList";
  var _child_growth_list_url = AppConstants.app_base_url + "UspBirthCertificateList";
  var _child_growth_list_url2 = AppConstants.app_base_url + "PostPCTSID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";

  List help_response_listing = [];
  ScrollController? _controller;
  List child_growth_list = [];
  List years_list = [];
  late SharedPreferences preferences;

  /*
  * API FOR DISTRICT LISTING
  * */
  Future<String> getYearListAPI() async {
    preferences = await SharedPreferences.getInstance();

    var response = await get(Uri.parse(_year_api_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetYearListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        years_list = resBody['ResposeData'];
        yearselect = resBody['ResposeData'][0]['Year'].toString();
        print('years_list.len ${years_list.length}');
      } else {
        //reLoginDialog();
      }
    });
    print('response:${apiResponse.message}');
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



  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  /*
  * API FOR DISTRICT LISTING
  * */
  Future<String> getChildGrowthListAPI(String _yrmnth) async {
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitcode ${preferences.getString('UnitCode')}');
    print('FromDate ${_yrmnth}');
    var response = await post(Uri.parse(_child_growth_list_url), body: {
      "LoginUnitcode": preferences.getString('UnitCode'),
      "FromDate": _yrmnth,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ChildGrowthListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        child_growth_list = resBody['ResposeData'];
        print('child_growth_list.len ${child_growth_list.length}');
      } else {
        child_growth_list.clear();
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    EasyLoading.dismiss();
    return "Success";
  }

  /*
  * API FOR FIND POPUP PICTS ID LISTING
  * */
  Future<String> getChildGrowthListAPI2(String _yrmnth,String _id) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_child_growth_list_url2), body: {
      "PCTSID": _id,
      "TagName": "3",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ChildGrowthList2Data.fromJson(resBody);
    setState(() {
      child_growth_list.clear();
      if (apiResponse.status == true) {

        child_growth_list = resBody['ResposeData'];

      } else {

      }
    });
    EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
  }


  late String _selectedYear = "";


  int getLength() {
    if(child_growth_list.isNotEmpty){
      return child_growth_list.length;
    }else{
      return 0;
    }
  }
  var option1=Strings.logout;
  var option2=Strings.sampark_sutr;
  var option3=Strings.video_title;
  var option4=Strings.app_ki_jankari;
  var option5=Strings.help_desk;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQueryData.fromWindow(window);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('बच्चे का ग्रोथ चार्ट',style: TextStyle(color: Colors.white, fontSize: 16)),
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
      body: Stack(
        children:<Widget> [
          Container(
            color: Colors.white,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                //height: double.infinity,
                child: Column(
                  children:<Widget> [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all(color: Colors.black)),
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        'माह',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            icon: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Image.asset(
                                                'Images/ic_down.png',
                                                height: 12,
                                                alignment: Alignment.centerRight,
                                              ),
                                            ),
                                            iconSize: 15,
                                            elevation: 11,
                                            style: TextStyle(color: Colors.black),
                                            isExpanded: true,
                                            hint: new Text("माह"),

                                            items: month_list.map((item) {
                                              return DropdownMenuItem(
                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item.name.toString(),

                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.normal),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item.mid
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: (String? newVal) {
                                              setState(() {
                                                _selectedMonthID = newVal!;
                                                print('_selectedMonthID:$_selectedMonthID');
                                                if(_selectedMonthID.length == 1){
                                                  _apiMonthKey="0"+_selectedMonthID;
                                                }else{
                                                  _apiMonthKey=_selectedMonthID;
                                                }
                                                print('_apiMonthKey:$_apiMonthKey');
                                                getChildGrowthListAPI(yearselect+_apiMonthKey);
                                              });
                                            },
                                            value:
                                            _selectedMonthID, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      ))
                                ],
                              )),
                          Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        'वर्ष',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            icon: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Image.asset(
                                                'Images/ic_down.png',
                                                height: 12,
                                                alignment: Alignment.centerRight,
                                              ),
                                            ),
                                            iconSize: 15,
                                            elevation: 11,
                                            style: TextStyle(color: Colors.black),
                                            isExpanded: true,
                                            hint: new Text("Select"),
                                            items: yearlist.map((item) {
                                              return DropdownMenuItem(
                                                  child: Row(
                                                    children: [
                                                      new Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(
                                                              item['Year'],
                                                              //Names that the api dropdown contains
                                                              style: TextStyle(
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.normal),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  value: item['Year']
                                                      .toString() //Id that has to be passed that the dropdown has.....
                                              );
                                            }).toList(),
                                            onChanged: (String? newVal) {
                                              setState(() {
                                                yearselect = newVal!;
                                                print('_yearselect:$yearselect');
                                                getChildGrowthListAPI(yearselect+_apiMonthKey);
                                              });
                                            },
                                            value:
                                            yearselect, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                          ),
                                        ),
                                      ))
                                ],
                              ))
                        ],
                      ),
                    ),
                    _myListView()
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right:10,
              child: GestureDetector(
              onTap: (){
                showPopupDialog(preferences.getString('UnitCode').toString());
              },
              child: Container(
               // margin: EdgeInsets.all(20),
                // width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ColorConstants.AppColorPrimary,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset("Images/pencil.png",width: 40,height: 40,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(Strings.pcts_id_darj_krai,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              )
          ),
        ],
      ),
    );
  }

  Widget _myListView(){
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
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.mahila_ka_naam,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.pita_ka_naam,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Strings.mobile_num,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.AppColorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${child_growth_list[index]['name']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${child_growth_list[index]['Husbname']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Container(
                              //  color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${child_growth_list[index]['Mobileno']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConstants.lifebgColor,
                ),
                margin: EdgeInsets.all(10),
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: child_growth_list[index]['infantList'].length,
                        itemBuilder: (context, childindex) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChartDetails(
                                infantId:  child_growth_list[index]['infantList'][childindex]['InfantID'].toString(),
                                name: child_growth_list[index]['name'],
                                childname: child_growth_list[index]['infantList'][childindex]['ChildName'].toString(),
                                dob: child_growth_list[index]['infantList'][childindex]['Birth_date'].toString(),
                                childsex: child_growth_list[index]['infantList'][childindex]['Sex'].toString(),
                                Mahilaname: child_growth_list[index]['name']+" W/o "+child_growth_list[index]['Husbname'],
                              ),));
                           //   Navigator.push(context, MaterialPageRoute(builder: (context) => DemoChartApp(),));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: ColorConstants.lifebgColor,
                              elevation: 0,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              Strings.shishu_ka_naam,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              child_growth_list[index]['infantList'][childindex]['ChildName'].toString() == "null" ? "" :child_growth_list[index]['infantList'][childindex]['ChildName'].toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              Strings.shishu_ki_janam_tithi,
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
                                              getFormattedDate(child_growth_list[index]['infantList'][childindex]['Birth_date'].toString()),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              Strings.shishu_ki_ling,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text('${child_growth_list.length == 0 ? "" : child_growth_list[index]['infantList'][childindex]['Sex'].toString()}',
                                           // child: Text('${child_growth_list.length == 0 ? "" : child_growth_list[index]['infantList'][childindex]['Sex'].toString() == "1" ? Strings.boy_title : child_growth_list[index]['infantList'][childindex]['Sex'].toString() == "2" ? Strings.girl_title : child_growth_list[index]['infantList'][childindex]['Sex'].toString() == "3" ? Strings.transgender : ""}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              Strings.shishu_ki_id,
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
                                              child_growth_list[index]['infantList'][childindex]['ChildID'].toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                    crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                    children: [
                                      Text(Strings.pcts_id_vivran,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: ColorConstants.AppColorPrimary,
                                            fontWeight: FontWeight.normal),),
                                      Container(
                                        width: 80,
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: [
                                            FlutterRipple(
                                              radius: 10,
                                              child: Image.asset('Images/cursor_click.png'),
                                              rippleColor: ColorConstants.dark_yellow_color,
                                              onTap: () {
                                                print("hello");
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true
                    )
                ),
              ),
            ],
          ),
        ),
      ),
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
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            getChildGrowthListAPI2(_finalYrMnth,pctsIdController.text.toString().trim());
                            //close popup dialoge
                            Navigator.pop(context);
                          }
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



class CustomMonthsList {
  String? mid;
  String? name;

  CustomMonthsList({
    this.mid,
    this.name,
  });
}

class CustomYearList {
  String? yid;
  String? name;

  CustomYearList({
    this.yid,
    this.name,
  });
}
