import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:pcts/ui/birth_certificate/pdf_viewer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../anmworkplan/model/GetYearListData.dart';
import 'package:intl/intl.dart';

import '../childgrowthcart/chart_details.dart';
import '../childgrowthcart/model/ChildGrowthList2Data.dart';
import '../childgrowthcart/model/ChildGrowthListData.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../loginui/model/OTPSentData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'find_birth_certificate_list.dart'; //for date format


String getFormattedDate(String date) {
  if(date != "null"){
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());
    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }else{
    return "";
  }
}


class BirthCertificateListScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _BirthCertificateListScreen();


}

class _BirthCertificateListScreen extends State<BirthCertificateListScreen> {

  var _get_otp_url = AppConstants.app_base_url + "PostSentSMS";
  var _check_otp_url = AppConstants.app_base_url + "PostCheckOTP";
  StreamController<ErrorAnimationType>? errorController;

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

  Future<String> getOTPAPI(_mobileno,_infantID) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_otp_url), body: {
      "MobileNo":_mobileno,
      "SmsFlag":"82",
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = OTPSentData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        showSMSPopupDialog(_mobileno,_infantID);
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
    return "Success";
  }

  Future<String> checkOTPAPI(_otp,_mobileno,_infantID) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_check_otp_url), body: {
      "MobileNo":_mobileno,
      "SmsFlag":"82",
      "OTP":_otp,
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId"),
      "DeviceID":preferences.getString("deviceId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = OTPSentData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewer(infantId: _infantID),
          ),
        );
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
    return "Success";
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    getCurrentMonthYear();
    getHelpDesk();

  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
    EasyLoading.dismiss();
  }

  var _finalYrMnth = "";

  getCurrentMonthYear() {
   // var date = DateTime.now().toString();
   // DateTime now = DateTime.now();
   // var dateParse = DateTime.parse(date);
  // String formattedDate = DateFormat('yyyy/MM/dd').format(now);

    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    //var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    var nowMonth = "${dateParse.month}";
    var nowYear = "${dateParse.year}";

    setState(() {
      print('nowMonth ${nowMonth}');
      print('nowYear ${nowYear}');
      setState(() {
       // _pirDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
        //_pirDate2 = "${dateParse.year}/${dateParse.month}/${dateParse.day}";
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

  /*
  * API FOR DISTRICT LISTING
  * */
  var mobileno="";
  Future<String> getChildGrowthListAPI(String _yrmnth) async {
    preferences = await SharedPreferences.getInstance();
    print('login-unit-id ${preferences.getString('UnitID')}');
    print('login-unit-code ${preferences.getString('UnitCode')}');
    print('login-_yrmnth ${_yrmnth}');
    var response = await post(Uri.parse(_child_growth_list_url), body: {
      //Testing Static ID
     /* "LoginUnitcode":"0101010020299562",
      "FromDate": "201805",
      "TokenNo": "4c6b6e7e-0e84-4d23-a774-d0c17c9d0e8e",
      "UserID": "0101065030203"*/
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
    print('response:${apiResponse.message}');
    return "Success";
  }
  /*
  * API FOR FIND POPUP PICTS ID LISTING
  * */
  Future<String> getChildGrowthListAPI2(String _yrmnth,String _id) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_child_growth_list_url2), body: {
      //PCTSID:01010900404991090
      // TagName:3
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
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
    print('child_growth_list.len ${child_growth_list.length}');
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
        title: Text('',style: TextStyle(color: Colors.white, fontSize: 18)),
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
                          child: Image.asset("Images/writing.png",width: 40,height: 40,),
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
                  borderRadius: BorderRadius.circular(0),
                  //color: ColorConstants.lifebgColor,
                ),
                margin: EdgeInsets.only(left: 10,bottom: 5,right: 10,top: 0),
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: child_growth_list[index]['infantList'].length,
                        itemBuilder: (context, childindex) {
                          return GestureDetector(
                            onTap: (){
                              getOTPAPI(child_growth_list[index]['Mobileno'],child_growth_list[index]['infantList'][childindex]['InfantID'].toString());
                              },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: ColorConstants.lifebgColor,
                                elevation: 5,
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
                                                  child_growth_list[index]['infantList'][childindex]['ChildName'],
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
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  child_growth_list[index]['infantList'][childindex]['Sex'].toString(),
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                        children: [
                                          Text(Strings.pcts_id_vivran,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: ColorConstants.AppColorPrimary,
                                                fontWeight: FontWeight.bold),),
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
                                      ),
                                    )
                                  ],
                                ),
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
  TextEditingController enterOTPController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FindBirthCertificateList(pctsid:pctsIdController.text.toString().trim()),
                              ));
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
  String otpvalue="";
  String currentText = "";

  Future<void> showSMSPopupDialog(String _mobileno,String _infantID) async {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(Strings.recv_otp,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.appNewBrowne,fontSize: 13),),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'Images/ic_cross.png',
                            height: 12.0,
                            color: ColorConstants.redTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //const Divider(color: ColorConstants.dark_yellow_color,height: 1,),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Container(
                    child: Form(
                      key: _formKey2,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: PinCodeTextField(
                            autoDisposeControllers: false,
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 4,
                            obscureText: true,
                            obscuringCharacter: '*',
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v!.length < 3) {
                                return "${Strings.enter_otp_error}";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              inactiveFillColor: ColorConstants.map_green_color,
                              errorBorderColor: ColorConstants.map_green_color,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 45,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            cursorColor: Colors.black,
                            animationDuration: Duration(milliseconds: 300),
                            enableActiveFill: true,
                            //errorAnimationController: errorController,
                            controller: enterOTPController,
                            keyboardType: TextInputType.number,
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              print("Completed$v");
                              otpvalue = v;
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                currentText = value;
                                print(currentText);
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          )),
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
                          if(otpvalue.length == 4){
                            checkOTPAPI(otpvalue,_mobileno,_infantID);
                          }else{
                            Fluttertoast.showToast(
                                msg:"OTP नंबर दर्ज करें ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child:Container(
                              width: 50,
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
                              width: 100,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(Strings.resend_otp,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
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
