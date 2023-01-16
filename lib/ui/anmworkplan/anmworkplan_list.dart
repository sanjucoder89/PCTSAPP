import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/anmworkplan/model/GetYearListData.dart';
import 'package:pcts/ui/prasav/add_anc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import 'package:intl/intl.dart';

import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/before/anc_expand_details.dart';
import '../prasav/before/model/GetPrasavListData.dart';
import '../samparksutra/samparksutra.dart';
import '../shishutikakan/tikakaran_details.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'model/AncWorkPlanModel.dart';
import 'model/ImmWorkPlanModel.dart';
import 'model/PncWorkPlanModel.dart';
import 'model/StalizationWorkPlanModel.dart';
void main() {
  runApp(AnmWorkPlanListScreen());
}

class AnmWorkPlanListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnmWorkPlanListScreen();
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
class _AnmWorkPlanListScreen extends State<AnmWorkPlanListScreen> with TickerProviderStateMixin{
  late String _selectedMonthID = "00";
  late String _finalMonthYear = "01";
  List yearlist = [];

  ScrollController? _controller;
  ScrollController? _pnccontroller;
  ScrollController? _immucontroller;
  ScrollController? _statecontroller;
  List Ancresponse_list = [];
  List Pncresponse_list = [];
  List Immresponse_list = [];
  List Staliresponse_list = [];
  late String yearselect = "";

  List<CustomMonthsList> month_list = [
    CustomMonthsList(
      mid: "00",
      name: "चुनें",
    ),
    CustomMonthsList(
      mid: "01",
      name: "जनवरी",
    ),
    CustomMonthsList(
      mid: "02",
      name: "फरवरी",
    ),
    CustomMonthsList(
      mid: "03",
      name: "मार्च",
    ),
    CustomMonthsList(
      mid: "04",
      name: "अप्रैल",
    ),
    CustomMonthsList(
      mid: "05",
      name: "मई",
    ),
    CustomMonthsList(
      mid: "06",
      name: "जून",
    ),
    CustomMonthsList(
      mid: "07",
      name: "जुलाई",
    ),
    CustomMonthsList(
      mid: "08",
      name: "अगस्त",
    ),
    CustomMonthsList(
      mid: "09",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getYearForAnmPlan();
    getHelpDesk();
  }



  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }


  var _year_api_url = AppConstants.app_base_url + "GetYearListForANMPlan";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _find_prasav_id = AppConstants.app_base_url + "PostPCTSID";
  var _uspANMWorkPlan = AppConstants.app_base_url + "uspANMWorkPlan";
  /*
  * API FOR DISTRICT LISTING
  * */

  /*
  * API FOR FIND PRASV DATA
  * */
  List find_response_listing = [];
  Future<String> findPrasavDataByIDAPI(String id,String _tagId) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_find_prasav_id), body: {
      //PCTSID:01010900404991090
      // TagName:3
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
      "PCTSID":id,
      "TagName":_tagId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetPrasavListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        find_response_listing = resBody['ResposeData'];
        print('find-resp-listing.len ${find_response_listing.length}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AncExpandDetails(ancregid:find_response_listing[0]['ancregid'].toString()),
          ),
        );
      } else {
        find_response_listing.clear();
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

  Future<String> getAncWorkPlan(String _monthyear) async {
    print('UnitCode ${preferences.getString('UnitCode')}');
    print('_monthyear ${_monthyear}');
    preferences = await SharedPreferences.getInstance();

    var response = await post(Uri.parse(_uspANMWorkPlan), body: {
      "TagName": "A",
      "Mthyr": _monthyear,
      "LoginUnitcode": preferences.getString('UnitCode'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = AncWorkPlanModel.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Ancresponse_list = resBody['ResposeData'];
        print('ancres.len ${Ancresponse_list.length}');
        if(Ancresponse_list.length > 0){
          isANCFound=true;
        }else{
          isANCFound=false;
        }
      }
    });
    return "Success";
  }
  Future<String> getPncWorkPlan(String _monthyear) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_uspANMWorkPlan), body: {
      "TagName": "P",
      "Mthyr": _monthyear,
      //"Mthyr": "202105",
      "LoginUnitcode": preferences.getString('UnitCode'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = PncWorkPlanModel.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Pncresponse_list = resBody['ResposeData'];
        print('Pncresponse_list.len ${Pncresponse_list.length}');
        if(Pncresponse_list.length > 0){
          isPNCFound=true;
        }else{
          isPNCFound=false;
        }
      }
    });
    return "Success";
  }
  Future<String> getImmWorkPlan(String _monthyear) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_uspANMWorkPlan), body: {
      "TagName": "I",
       "Mthyr": _monthyear,
      //"Mthyr": "202105",
      "LoginUnitcode": preferences.getString('UnitCode'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = ImmWorkPlanModel.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Immresponse_list = resBody['ResposeData'];
        print('Immresponse_list.len ${Immresponse_list.length}');
        if(Immresponse_list.length > 0){
          isImmuFound=true;
        }else{
          isImmuFound=false;
        }
      }
    });
    return "Success";
  }
  Future<String> getStalizationWorkPlan(String _monthyear) async {

    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_uspANMWorkPlan), body: {
      "TagName": "S",
      "Mthyr": _monthyear,
    //  "Mthyr": "202105",
      "LoginUnitcode": preferences.getString('UnitCode'),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = StalizationWorkPlanModel.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        Staliresponse_list = resBody['ResposeData'];
        print('Staliresponse_list.len ${Staliresponse_list.length}');
        if(Staliresponse_list.length > 0){
          isSterilFound=true;
        }else{
          isSterilFound=false;
        }
      }
    });
    return "Success";
  }

  Future<String> getYearForAnmPlan() async {
    preferences = await SharedPreferences.getInstance();
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
    var response = await get(Uri.parse(_year_api_url));
    var resBody = json.decode(response.body);
    final apiResponse = GetYearListData.fromJson(resBody);

    setState(() {
      if (apiResponse.status == true) {
        // yearlist = apiResponse.resposeData!;
        yearlist = resBody['ResposeData'];
        // yearselect = apiResponse.resposeData![0].year.toString();
        yearselect = resBody['ResposeData'][0]['Year'].toString();
        print('responceyeardata ${yearlist.length} $yearselect');
      } else {}
    });
    setCurrentMonth("1");
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


  List help_response_listing = [];
  List years_list = [];
  late SharedPreferences preferences;

  late String _selectedYear = "";
  late TabController _tabcontroller;
  int _selectedIndex = 0;
  var _anmName="";
  var _topHeaderName="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('मासिक कार्य योजना',
            style: TextStyle(color: Colors.white, fontSize: 18)),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: ColorConstants.redTextColor,
                height: 50,
                child: Column(
                  children: [
                    Expanded(child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                        Strings.anm_title,
                                        style: TextStyle(
                                            color: ColorConstants.app_yellow_color,
                                            fontSize: 13),
                                      ),
                                    ),
                                  )),
                              Flexible(child: Container(
                                child: Text(_anmName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: ColorConstants.white,
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ))
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
                                            fontSize: 13)),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    child: Text(_topHeaderName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                          color: ColorConstants.white,
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ))
                  ],
                ),
              ),
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
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.normal),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            value: item.mid.toString()
                                        );
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          _selectedMonthID = newVal!;
                                          print('_selectedMonthID:$_selectedMonthID');
                                          setCustomMnthYr();
                                        });
                                      },
                                      value: _selectedMonthID,
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
                                child: const Text(
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
                                                Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: Text(
                                                        item['Year'],
                                                        //Names that the api dropdown contains
                                                        style: const TextStyle(
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
                                          _selectedYear=yearselect;
                                          print('_yearselect:$yearselect');
                                          setCustomMnthYr();
                                        });
                                      },
                                      value: yearselect, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                    ),
                                  ),
                                ))
                          ],
                        ))
                  ],
                ),
              ),
              DefaultTabController(
                  length: 4, // length of tabs
                  initialIndex: 0,
                  child: Builder(builder: (context){
                    final tabController = DefaultTabController.of(context)!;
                    tabController.addListener(() {
                      print("New tab index: ${tabController.index}");
                      if(tabController.index == 0){
                        getAncWorkPlan(_finalMonthYear);
                      }else if(tabController.index == 1){
                        getPncWorkPlan(_finalMonthYear);
                      }else if(tabController.index == 2){
                        getImmWorkPlan(_finalMonthYear);
                      }else if(tabController.index == 3){
                        getStalizationWorkPlan(_finalMonthYear);
                      }
                    });
                    return Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                                labelColor: ColorConstants.AppColorPrimary,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Container(
                                    child: new Tab(text: 'एएनसी'),
                                  ),
                                  Container(
                                    child: new Tab(text: 'पीएनसी'),
                                  ),
                                  Container(
                                    child: new Tab(text: 'टीकाकरण'),
                                  ),
                                  Container(
                                    child: new Tab(
                                      text: '   नसबन्दी /\nअंतराल साधन',
                                    ),
                                  )
                                ],
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                unselectedLabelStyle:
                                TextStyle(fontStyle: FontStyle.normal),
                              ),
                            ),
                            Container(
                                height: 500.0, //height of TabBarView
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5))),
                                child: TabBarView(children: <Widget>[
                                  isANCFound == false ? Container(
                                    child: Center(child: Text(Strings.anc_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                  ) :SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Container(
                                        child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: GestureDetector(
                                                  child: Container(
                                                    height: 20,
                                                    color: ColorConstants.redTextColor,
                                                    margin:
                                                    EdgeInsets.only(left: 0, top: 1),
                                                    child: const Center(
                                                      child: Text(
                                                        "एएनसी दर्ज करने के लिए सम्बन्धित केस पर क्लिक करें ",
                                                        style: TextStyle(
                                                            color: ColorConstants
                                                                .white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                )),

                                            Container(
                                              height: 25,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    child: Text(Strings.Kramnk,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.mahila_patikaName,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(Strings.dateOfRegistration,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.ANC_dueDate,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),))
                                                ],
                                              ),

                                            ),
                                            const Divider(
                                              color: ColorConstants.app_yellow_color,
                                              height: 2,
                                            ),
                                            Container(

                                              child: _AncListView(),
                                            )
                                          ],
                                        )),
                                  ),
                                  isPNCFound == false ? Container(
                                    child: Center(child: Text(Strings.pnc_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                  ) :SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    color: ColorConstants.redTextColor,
                                                    height: 25,
                                                    child: Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Container(
                                                          margin: const EdgeInsets.only(
                                                              left: 3, top: 3),
                                                          child: const Center(
                                                            child: Text(
                                                              "पीएनसी दर्ज करने के लिए सम्बन्धित केस पर क्लिक करें ",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 25,
                                                          child: Text(Strings.Kramnk,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                        const VerticalDivider(
                                                          thickness: 1.5,
                                                          color: ColorConstants.app_yellow_color,
                                                        ),
                                                        Expanded(child: Container(child: Text(Strings.mahila_patikaName,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                        const VerticalDivider(
                                                          thickness: 1.5,
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          child: Text(Strings.dateOfRegistration,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                        const VerticalDivider(
                                                          thickness: 1.5,
                                                          color: ColorConstants.app_yellow_color,
                                                        ),
                                                        Expanded(child: Container(child: Text(Strings.ANC_dueDate,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),))
                                                      ],
                                                    ),

                                                  ),
                                                  const Divider(
                                                    color: ColorConstants.app_yellow_color,
                                                    height: 2,
                                                  ),
                                                  Container(
                                                    child: _PncListView(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  isImmuFound == false ? Container(
                                    child: Center(child: Text(Strings.tikai_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                  ) :SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 20,
                                              color: ColorConstants.redTextColor,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Align(
                                                              alignment:
                                                              Alignment.centerLeft,
                                                              child: Container(
                                                                margin: const EdgeInsets.only(
                                                                    left: 3, top: 3),
                                                                child: const Center(
                                                                  child: Text(
                                                                    "टीकाकरण दर्ज करने के लिए सम्बन्धित केस पर क्लिक करें ",
                                                                    style: TextStyle(
                                                                        color: ColorConstants
                                                                            .white,
                                                                        fontSize: 12),
                                                                  ),
                                                                ),
                                                              ))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 25,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    child: Text(Strings.Kramnk,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.mahila_patikaName,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(Strings.dateOfRegistration,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.ANC_dueDate,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),))
                                                ],
                                              ),

                                            ),
                                            const Divider(
                                              color: ColorConstants.app_yellow_color,
                                              height: 2,
                                            ),
                                            Container(
                                              child: _ImmListView(),
                                            ),
                                          ],
                                        )),
                                  ),
                                  isSterilFound == false ? Container(
                                    child: Center(child: Text(Strings.seril_no_due,style: TextStyle(color: ColorConstants.appNewBrowne,fontSize: 18,fontWeight: FontWeight.bold),)),
                                  ) :SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 25,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    child: Text(Strings.Kramnk,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.mahila_patikaName,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),)),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(Strings.prasav_anumanit_date,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                    color: ColorConstants.app_yellow_color,
                                                  ),
                                                  Expanded(child: Container(child: Text(Strings.child_count,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 11,fontWeight: FontWeight. bold,color: ColorConstants.AppColorPrimary)),))
                                                ],
                                              ),

                                            ),
                                            const Divider(
                                              color: ColorConstants.app_yellow_color,
                                              height: 2,
                                            ),
                                            Container(
                                              child: _StalioListView(),
                                            ),
                                          ],
                                        )),
                                  ),

                                ]))
                          ]),
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedDate(String date) {
    /// Convert into local date format.
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }


  Widget _AncListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getAncWorkPlanResLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _StalioListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _statecontroller,
            itemCount: getStaliWorkPlanResLength(),
            itemBuilder: _SerialItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _PncListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _pnccontroller,
            itemCount: getPncWorkPlanResLength(),
            itemBuilder: _pncItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  Widget _ImmListView() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _immucontroller,
            itemCount: getImmWorkPlanResLength(),
            itemBuilder: _ImmuItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }
  getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
  var isANCFound=false;
  var isPNCFound=false;
  var isImmuFound=false;
  var isSterilFound=false;
  Widget _itemBuilder(BuildContext context, int index) {
    return  InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }

          //API Response Date
          var ancdueDate = Ancresponse_list[index]['ancdue'].toString().trim().substring(Ancresponse_list[index]['ancdue'].toString().trim().length - 10);
          //print('ancdueDate $ancdueDate');
          var inputFormat = DateFormat('dd/MM/yyyy');
          var date1 = inputFormat.parse(ancdueDate);//15/01/2023
          //var date1 = inputFormat.parse('15/01/2023');//15/01/2023

          var outputFormat = DateFormat('yyyy-MM-dd');
          var date2 = outputFormat.format(date1); // 2019-08-18
          //print('date2 ${date2}');


          var parseCalenderSelectedAncDate = DateTime.parse(date2);

          var intentAncDate = DateTime.parse(getConvertRegDateFormat(getCurrentDate()));
          //print('anc calendr ${parseCalenderSelectedAncDate}');
          //print('anc intentt ${intentAncDate}');
          final diff_lmp_ancdate = parseCalenderSelectedAncDate.difference(intentAncDate).inDays;
          print('check_diff_date ${diff_lmp_ancdate}');
          if (diff_lmp_ancdate > 0) {
            _showErrorPopup(Strings.not_eligible_anc_,ColorConstants.AppColorPrimary);
          }else{
            print('done');
            findPrasavDataByIDAPI(Ancresponse_list[index]['pctsid'].toString().trim(),"1");//Tag Id 1= ANC
          }
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Ancresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Ancresponse_list == null ? "" : Ancresponse_list[index]['name'].toString()+' w/o '+Ancresponse_list[index]['Husbname'].toString()}\n(${Ancresponse_list[index]['pctsid'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: ColorConstants.AppColorPrimary,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  Container(
                    width: 80,
                    child: Text(getFormattedDate('${Ancresponse_list == null ? "": Ancresponse_list[index]['LMPDT'].toString().substring(0,10)}')
                      ,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child: Text('${Ancresponse_list == null ? "": Ancresponse_list[index]['ancdue'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),))

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
        ),

    );
  }
  Widget _pncItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          findPrasavDataByIDAPI(Ancresponse_list[index]['pctsid'].toString().trim(),"2");//Tag Id 1= ANC
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Pncresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Pncresponse_list == null ? "" : Pncresponse_list[index]['name'].toString()+' w/o '+Pncresponse_list[index]['Husbname'].toString()}\n(${Pncresponse_list[index]['pctsid'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  Container(
                    width: 80,
                    child: Text(('${Pncresponse_list[index]['deliveryDate'].toString() == "null" ? "-": getFormattedDate(Pncresponse_list[index]['deliveryDate'].toString().substring(0,10))}')
                      ,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child: Text('${Pncresponse_list[index]['PNCDueDate'].toString() == "null" ? "-": Pncresponse_list[index]['PNCDueDate'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),))

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
        ),

    );
  }
  Widget _ImmuItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => TikaKaranDetails(
              pctsID: Immresponse_list[index]['pctsid'].toString(),
              infantId:Immresponse_list[index]['infantid'].toString()
          ),));
          print('Immresponse_list>> : ${Immresponse_list[index]['name'].toString()}');
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Immresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Immresponse_list == null ? "" : Immresponse_list[index]['name'].toString()+' w/o '+Immresponse_list[index]['Husbname'].toString()}\n(${Immresponse_list[index]['pctsid'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  Container(
                    width: 80,
                    child: Text(('${Immresponse_list[index]['deliveryDate'].toString() == "null" ? "-": getFormattedDate(Immresponse_list[index]['deliveryDate'].toString().substring(0,10))}')
                      ,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child: Text('${Immresponse_list[index]['immudue'].toString() == "null" ? "-": Immresponse_list[index]['immudue'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),))

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
        ),

    );
  }
  Widget _SerialItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: Container(
          color: (index % 2 == 0) ? ColorConstants.white :ColorConstants.lifebgColor2,
          child: Column(
            children: [
              IntrinsicHeight(child: Row(
                children: [
                  Container(
                    width: 25,
                    child: Text(Staliresponse_list == null ? "" : (index+1).toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child:Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '${Staliresponse_list == null ? "" : Staliresponse_list[index]['name'].toString()+' w/o '+Staliresponse_list[index]['Husbname'].toString()}\n(${Staliresponse_list[index]['pctsid'].toString()})',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),)),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  //getFormattedDate
                  Container(
                    width: 80,
                    child: Text(('${Staliresponse_list[index]['ExpDeliveryDate'].toString() == "null" ? "-": getFormattedDate(Staliresponse_list[index]['ExpDeliveryDate'].toString().substring(0,10))}')
                      ,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child: Text('${Staliresponse_list[index]['livechild'].toString() == "null" ? "-": Staliresponse_list[index]['livechild'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11)),))

                ],
              ),),
              const Divider(
                height: 2,
                thickness: 1,
                color: ColorConstants.app_yellow_color,
              ),
            ],
          ),

        ),
        ),

    );
  }

  int getAncWorkPlanResLength() {
    if (Ancresponse_list.isNotEmpty) {
      return Ancresponse_list.length;
    } else {
      return 0;
    }
  }
  int getPncWorkPlanResLength() {
    if (Pncresponse_list.isNotEmpty) {
      return Pncresponse_list.length;
    } else {
      return 0;
    }
  }
  int getImmWorkPlanResLength() {
    if (Immresponse_list.isNotEmpty) {
      return Immresponse_list.length;
    } else {
      return 0;
    }
  }
  int getStaliWorkPlanResLength() {
    if (Staliresponse_list.isNotEmpty) {
      return Staliresponse_list.length;
    } else {
      return 0;
    }
  }



  void setCurrentMonth(String _tabpos) {
    DateTime now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
    print("currentdates=>${lastDayOfMonth.month}/${lastDayOfMonth.day}/${lastDayOfMonth.year}");
    if(lastDayOfMonth.month == 0){
      _selectedMonthID="00";
      _selectedYear="00";
      _finalMonthYear=lastDayOfMonth.year.toString() +"00";
    }else if(lastDayOfMonth.month == 1){
      _selectedMonthID="01";
      _finalMonthYear=lastDayOfMonth.year.toString() +"01";
      _selectedYear=lastDayOfMonth.year.toString();
    }else if(lastDayOfMonth.month == 2){
      _selectedMonthID="02";
      _finalMonthYear=lastDayOfMonth.year.toString() +"02";
      _selectedYear=lastDayOfMonth.year.toString();
    }else if(lastDayOfMonth.month == 3){
      _selectedMonthID="03";
      _finalMonthYear=lastDayOfMonth.year.toString() +"03";
      _selectedYear=lastDayOfMonth.year.toString();
    }else if(lastDayOfMonth.month == 4){
      _selectedMonthID="04";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"04";
    }else if(lastDayOfMonth.month == 5){
      _selectedMonthID="05";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"05";
    }else if(lastDayOfMonth.month == 6){
      _selectedMonthID="06";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"06";
    }else if(lastDayOfMonth.month == 7){
      _selectedMonthID="07";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"07";
    }else if(lastDayOfMonth.month == 8){
      _selectedMonthID="08";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"08";
    }else if(lastDayOfMonth.month == 9){
      _selectedMonthID="09";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"09";
    }else if(lastDayOfMonth.month == 10){
      _selectedMonthID="10";
      _selectedYear=lastDayOfMonth.year.toString();
      _finalMonthYear=lastDayOfMonth.year.toString() +"10";
    }else if(lastDayOfMonth.month == 11){
      _selectedMonthID="11";
      _finalMonthYear=lastDayOfMonth.year.toString() +"11";
      _selectedYear=lastDayOfMonth.year.toString();
    }else if(lastDayOfMonth.month == 12){
      _selectedMonthID="12";
      _finalMonthYear=lastDayOfMonth.year.toString() +"12";
      _selectedYear=lastDayOfMonth.year.toString();
    }
    if(_tabpos == "1"){
      getAncWorkPlan(_finalMonthYear);
    }else if(_tabpos == "2"){
      getPncWorkPlan(_finalMonthYear);
    }else if(_tabpos == "3"){
      getImmWorkPlan(_finalMonthYear);
    }else if(_tabpos == "4"){
      getStalizationWorkPlan(_finalMonthYear);
    }
  }
  void setCustomMnthYr() {
    _finalMonthYear=_selectedYear+_selectedMonthID;
    print('_finalMonthYear ${_finalMonthYear}');
    getAncWorkPlan(_finalMonthYear);
  }
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
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
