import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../../utils/ShowPlayStoreDialoge.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../hbyc/model/SavedHBYCDetailsData.dart';
import '../prasav/model/GetAashaListData.dart';
import '../prasav/model/GetBlockListData.dart';
import '../prasav/model/GetDistrictListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';


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


class AddHRPScreen extends StatefulWidget {
  const AddHRPScreen(
      {Key? key,
        required this.VillageAutoID,
        required this.HRFlag,
        required this.ANCRegId,
        required this.MotherId,
        required this.ContactDate
      })
      : super(key: key);


  final String HRFlag;
  final String VillageAutoID;
  final String ANCRegId;
  final String MotherId;
  final String ContactDate;


  @override
  State<AddHRPScreen> createState() => _AddHRPScreenState();
}

class _AddHRPScreenState extends State<AddHRPScreen> {

  var _aasha_list_url = AppConstants.app_base_url + "PostASHAList";
  var _get_district_list_url = AppConstants.app_base_url + "postDistdata";
  var _get_block_list_url = AppConstants.app_base_url + "postBlockData";
  var _add_hrp_form_url = AppConstants.app_base_url + "PostHighRiskDetail";

  late SharedPreferences preferences;
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  List help_response_listing = [];
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
                  SplashNew(),
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


  List<CustomPlacesReferCodeList> custom_placesrefer_list = [];


  List<CustomAashaList> custom_aasha_list = [];
  List aasha_response_list = [];
  bool _isItAsha=false;
  late String aashaId = "0";
  var _regUnitType="";
  var _selectedPlacesReferCode = "0";
  var _selectedPlacesReferCode2 = "0";
  var _changeTitle=Strings.block;
  var _changeTitle2=Strings.block;
  bool _isDropDownRefresh=false;
  bool _isDropDownRefresh2=false;
  Future<String> getAashaListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitid ${preferences.getString('UnitID')}');
    print('RegUnitid ${preferences.getString('UnitID')}');
    print('VillageAutoid ${widget.VillageAutoID}');
    _regUnitType=preferences.getString("UnitType").toString();
    var response = await post(Uri.parse(_aasha_list_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "DelplaceUnitid": "0",
      "RegUnitid": preferences.getString('UnitID'),
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
      }
      EasyLoading.dismiss();
      addPlacesReferList();
    });
    print('response:${apiResponse.message}');
    return "Success";
  }

  List response_district_list= [];
  List response_district_list2= [];
  List<CustomDistrictCodeList> custom_district_list = [];
  List<CustomDistrictCodeList> custom_district_list2 = [];
  List<CustomBlockCodeList> custom_block_list = [];
  List<CustomBlockCodeList> custom_block_list2 = [];
  var _selectedDistrictUnitCode = "0000";
  var _selectedDistrictUnitCode2 = "0000";
  var _selectedBlockUnitCode = "0";
  var _selectedBlockUnitCode2 = "0";

  Future<GetDistrictListData> getDistrictListAPI(String refUnitType) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_district_list_url), body: {
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

  Future<GetDistrictListData> getDistrictListAPI2(String refUnitType) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_district_list_url), body: {
      "RefUnittype": refUnitType,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetDistrictListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_district_list2 = resBody['ResposeData'];
        custom_district_list2.clear();
        custom_district_list2.add(CustomDistrictCodeList(unitcode: "0", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_district_list2.length; i++) {
          custom_district_list2.add(CustomDistrictCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedDistrictUnitCode2 = custom_district_list2[0].unitcode.toString();
        print('_selectedDistrictUnitCode2 ${_selectedDistrictUnitCode2}');
        print('disctict2.len ${custom_district_list2.length}');
      } else {
        custom_district_list2.clear();
        print('disctict.len ${custom_district_list2.length}');
      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetDistrictListData.fromJson(resBody);
  }

  List response_block_list= [];
  List response_block_list2= [];
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

  Future<GetBlockListData> getBlockListAPI2(String refUnitType,String refUnitCode) async {
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
        response_block_list2 = resBody['ResposeData'];
        custom_block_list2.clear();
        custom_block_list2.add(CustomBlockCodeList(unitcode: "0", unitNameHindi:Strings.choose));
        for (int i = 0; i < response_block_list2.length; i++) {
          custom_block_list2.add(CustomBlockCodeList(unitcode: resBody['ResposeData'][i]['unitcode'],unitNameHindi: resBody['ResposeData'][i]['unitNameHindi']));
        }
        _selectedBlockUnitCode2 = custom_block_list2[0].unitcode.toString();
        print('_selectedDistrictUnitCode2 ${_selectedBlockUnitCode2}');
        print('block2.len ${custom_block_list2.length}');
      } else {
        custom_block_list2.clear();
        print('block.len ${custom_block_list2.length}');

      }
      EasyLoading.dismiss();
    });
    print('response:${apiResponse.message}');
    return GetBlockListData.fromJson(resBody);
  }

  void addPlacesReferList() {
    print('RegUnitTYpe ${_regUnitType}');
    custom_placesrefer_list.clear();
    custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.choose, code:"0"));

    if(_regUnitType == "10" || _regUnitType == "11"){
      if(_regUnitType == "11"){
       // custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.city_dispancry, code:"13"));
       // custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.pra_sva_center, code:"10"));
      }
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.sa_sva_center, code:"9"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.up_jila_Hospital, code:"8"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
    //  custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.other_hospital, code:"15"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));

    }else if(_regUnitType == "9" || _regUnitType == "13" || _regUnitType == "14"){

      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.sa_sva_center, code:"9"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.up_jila_Hospital, code:"8"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));
    }else if(_regUnitType == "8"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));

    }else if(_regUnitType == "6" || _regUnitType == "7"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.medical_collage, code:"7"));
    }else if(_regUnitType == "5"){
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.jila_Hospital, code:"6"));
      custom_placesrefer_list.add(CustomPlacesReferCodeList(title: Strings.setelite_hospital, code:"5"));
    }
    print('custom_placesrefer_list.len ${custom_placesrefer_list.length}');
  }
  var _selectedHRPDate="DD/MM/YYYY";
  var _selectedHRPDateAPI="DD/MM/YYYY";
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
            Text('',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text('',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
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
              Container(
                width: 50,
                child: PopupMenuButton(
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
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children:<Widget>[
            Expanded(child: Container(child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: ColorConstants.redTextColor,
                    height: 30,
                    child:Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              Strings.highrisk_report,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ),
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
                              isExpanded: true,
                              items: custom_aasha_list.map((item) {
                                return DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        new Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(
                                                item.ASHAName.toString(),
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
                                });
                              },
                              value: aashaId,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${widget.HRFlag == "5" ?
                      "1st " : widget.HRFlag == "6" ?
                      "2nd " : widget.HRFlag == "7" ?
                      "3rd " : widget.HRFlag == "8" ?
                      "4th " : widget.HRFlag == "9" ?
                      "5th " : "1st "
                      }'+ Strings.sampark_date,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.all(1),
                    margin: EdgeInsets.all(3),
                    height: 30,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectHrpDatePopup();
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                            padding: EdgeInsets.all(5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(_selectedHRPDate,style:TextStyle(color: Colors.grey,fontSize: 13),),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: Image.asset(
                                "Images/calendar_icon.png",
                                width: 20,
                                height: 20,
                              ))
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      Strings.hospital_sanstha_ka_naam,
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
                                  if(_selectedPlacesReferCode == "9" || _selectedPlacesReferCode == "8" || _selectedPlacesReferCode == "6" || _selectedPlacesReferCode == "7" || _selectedPlacesReferCode == "5"){
                                    for(int i=0 ;i<custom_placesrefer_list.length; i++){
                                      if(_selectedPlacesReferCode == custom_placesrefer_list[i].code.toString()){
                                        _changeTitle=custom_placesrefer_list[i].title.toString();
                                      }
                                    }
                                  }else{
                                    _changeTitle=Strings.block;
                                  }
                                  getDistrictListAPI("3");
                                  if(_isDropDownRefresh == true){
                                    _isDropDownRefresh=false;
                                    _selectedBlockUnitCode = custom_block_list[0].unitcode.toString();
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
                    child: Text(
                      Strings.jila_titele,
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
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      _changeTitle,
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
                                 // _ReferUnitCode=_selectedBlockUnitCode;

                                });
                              },
                              value:
                              _selectedBlockUnitCode,
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
                    color: ColorConstants.redTextColor,
                    height: 30,
                    child:Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              Strings.prasv_yujna,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  /*
                  *
                  * After Delivery UI
                  * */
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      Strings.hospital_sanstha_ka_naam,
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
                                  _selectedPlacesReferCode2 = newVal!;
                                  print('refercode2:$_selectedPlacesReferCode2');
                                  if(_selectedPlacesReferCode2 == "9" || _selectedPlacesReferCode2 == "8" || _selectedPlacesReferCode2 == "6" || _selectedPlacesReferCode2 == "7" || _selectedPlacesReferCode2 == "5"){
                                    for(int i=0 ;i<custom_placesrefer_list.length; i++){
                                      if(_selectedPlacesReferCode2 == custom_placesrefer_list[i].code.toString()){
                                        _changeTitle2=custom_placesrefer_list[i].title.toString();
                                      }
                                    }
                                  }else{
                                    _changeTitle2=Strings.block;
                                  }
                                  getDistrictListAPI2("3");
                                  if(_isDropDownRefresh2 == true){
                                    _isDropDownRefresh2=false;
                                    _selectedBlockUnitCode2 = custom_block_list2[0].unitcode.toString();
                                    print('_selectedDistrictUnitCode2 ${_selectedBlockUnitCode2}');
                                  }
                                });
                              },
                              value: _selectedPlacesReferCode2, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      Strings.jila_titele,
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
                              items: custom_district_list2.map((item) {
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
                                  _selectedDistrictUnitCode2 = newVal!;
                                  print('distrcode:$_selectedDistrictUnitCode2');
                                  print('ReferCode:$_selectedPlacesReferCode2');

                                  getBlockListAPI2(_selectedPlacesReferCode2,_selectedDistrictUnitCode2.substring(0, 4));
                                });
                              },
                              value: _selectedDistrictUnitCode2, //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      _changeTitle,
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
                              items: custom_block_list2.map((item) {
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
                                  _selectedBlockUnitCode2 = newVal!;
                                  print('blockcode2:$_selectedBlockUnitCode2');
                                  _isDropDownRefresh2=true;//that mean first time block value selected,now value will be reset if refer jila value changed
                                  // _ReferUnitCode=_selectedBlockUnitCode;

                                });
                              },
                              value:
                              _selectedBlockUnitCode2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),)),
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
          ],
        ),
      ),
    );
  }
  var _Media="";
  var _UpdateUserNo="";
  postHbycRequest() async {
    preferences = await SharedPreferences.getInstance();
    if(aashaId == "0"){
      _showErrorPopup(Strings.aasha_chunai,ColorConstants.AppColorPrimary);
    }else if(_selectedHRPDate.isEmpty || _selectedHRPDate == "DD/MM/YYYY"){
      _showErrorPopup(Strings.choose_visit_date, Colors.black);
    }else if(_selectedPlacesReferCode == "0"){
      _showErrorPopup(Strings.choose_refer_type,ColorConstants.AppColorPrimary);
    }else if((_selectedPlacesReferCode == "9" || _selectedPlacesReferCode == "8" || _selectedPlacesReferCode == "6" || _selectedPlacesReferCode == "7" || _selectedPlacesReferCode == "5") && (_changeTitle == "" || _changeTitle =="चुनें" || _selectedBlockUnitCode == "0")){
      _showErrorPopup("कृपया "+_changeTitle +" चुनें!",ColorConstants.AppColorPrimary);
    }else{

      if(preferences.getString("AppRoleID") == "33"){//assha=33,32anm
        _Media="2";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }else{
        _Media="1";
        _UpdateUserNo=preferences.getString("UserNo").toString();
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print('pkg_version: ${packageInfo.version}');
      print('AppVersion:${"5.5.5.22"+
          "IOSAppVersion:"+""+
          "ANCDate:"+_selectedHRPDateAPI+
          "ANCFlag:"+widget.HRFlag+
          "ContactUnitcode:"+_selectedBlockUnitCode+
          "DelUnitcode:"+_selectedBlockUnitCode2+
          "Ashaautoid:"+aashaId+
          "Media:"+_Media+
          "motherid:"+widget.MotherId+
          "UpdateUserNo:"+_UpdateUserNo+
          "ANCRegid:"+widget.ANCRegId+
          "VillageAutoID:"+widget.VillageAutoID+
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
    var response = await post(Uri.parse(_add_hrp_form_url), body: {
      "AppVersion":"5.5.5.22",
      "IOSAppVersion":aashaId,
      "ANCDate":_selectedHRPDateAPI,
      "ANCFlag":widget.HRFlag,
      "ContactUnitcode":_selectedBlockUnitCode,
      "DelUnitcode":_selectedBlockUnitCode2,
      "Ashaautoid": aashaId,
      "Media": _Media,
      "motherid":widget.MotherId,
      "UpdateUserNo": _UpdateUserNo,
      "ANCRegid": widget.ANCRegId,
      "VillageAutoID":widget.VillageAutoID,
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

  late DateTime _selectedDate;

  void _selectHrpDatePopup(){
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
      _selectedDate = pickedDate;
      String formattedDate4 = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String formattedDate2 = DateFormat('yyyy/MM/dd').format(_selectedDate);
      String finalhrpDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
      String formattedDateAPI = DateFormat('yyyy/MM/dd').format(_selectedDate);
      setState(() {
        if (formattedDate2.compareTo(getCurrentDate()) > 0) {
          _showErrorPopup(Strings.aaj_ki_tareek_sai_phale,ColorConstants.AppColorPrimary);
        }else{
          var calendrHrpDate = DateTime.parse(formattedDate4.toString());
          var lastHrpDate = DateTime.parse(getConvertRegDateFormat(widget.ContactDate));
          final diff_in_date = calendrHrpDate.difference(lastHrpDate).inDays;
          print('diff_in_date ${diff_in_date}');
          if(diff_in_date <= 25){
            _showErrorPopup("Please Check Enter Date",Colors.black);
          }else{
            _selectedHRPDateAPI=formattedDateAPI;
            _selectedHRPDate=finalhrpDate;
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

  getCurrentDate() {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }
  @override
  void initState() {
    super.initState();
    getAashaListAPI();

  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}
class CustomAashaList {
  String? ASHAName;
  String? ASHAAutoid;

  CustomAashaList({this.ASHAName, this.ASHAAutoid});
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