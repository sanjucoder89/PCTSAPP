import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/AboutAppDialoge.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/LogoutAppDialoge.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../samparksutra/samparksutra.dart';
import '../videos/tab_view.dart';
import 'model/TotalCasesListData.dart';

class VerifyCasesList extends StatefulWidget {
  const VerifyCasesList(
      {Key? key,
        required this.ashaAutoID,
        required this.type
      })
      : super(key: key);

  final String ashaAutoID;
  final String type;

  @override
  State<VerifyCasesList> createState() => _VerifyCasesListState();
}

class _VerifyCasesListState extends State<VerifyCasesList> {

  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  var _total_cases_list_url = AppConstants.app_base_url + "uspListForANMVerify";

  List help_response_listing = [];
  late SharedPreferences preferences;
  var _anmName="";
  var _topHeaderName="";

  Future<String> getHelpDesk() async {
    preferences = await SharedPreferences.getInstance();
    _anmName=preferences.getString('ANMName').toString();
    _topHeaderName=preferences.getString('topName').toString();
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
        help_response_listing = resBody['ResposeData'];
        if(resBody['ResposeData'].length > 0){

        }
      } else {

      }
    });
    return "Success";
  }

  var firstTabTitle=Strings.krmank;
  var secondTabTitle=Strings.mahila_patikaName;
  var thirdTabTitle=Strings.pcts_id;
  var fourthTabTitle=Strings.anc_count;
  var fifthTabTitle=Strings.anc_ki_tithi;
  @override
  void initState() {
    super.initState();
    checkCases();
    getCasesDataAPI();
    getHelpDesk();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void checkCases() {
    print('check_type: ${widget.type}');
    setState(() {
      if(widget.type == "3" || widget.type == "5" || widget.type == "6"){
        secondTabTitle=Strings.shishu_pcts_id;
      }
      if(widget.type == "1" || widget.type == "2" || widget.type == "3"){
        if(widget.type == "1"){
          fourthTabTitle=Strings.anc_count;
          fifthTabTitle=Strings.anc_ki_tithi;
        }else if(widget.type == "2"){
          fourthTabTitle=Strings.pnc_count;
          fifthTabTitle=Strings.pncDate;
        }else if(widget.type == "3"){
          fourthTabTitle=Strings.immu_count;
          fifthTabTitle=Strings.immDate;
        }
      }else if(widget.type == "6"){
        fifthTabTitle=Strings.hbyc_count;
        fourthTabTitle=Strings.visit_schedule;
      }else{
        fifthTabTitle=Strings.death_date;
        fourthTabTitle=Strings.death_reason;
      }
    });
  }

  int getHelpLength() {
    if(help_response_listing.isNotEmpty){
      return help_response_listing.length;
    }else{
      return 0;
    }
  }


  List response_list = [];
  Future<String> getCasesDataAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_total_cases_list_url), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "ASHAAutoid": widget.ashaAutoID,
      "type": widget.type,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId'),
      "action": "0"
    });
    var resBody = json.decode(response.body);
    final apiResponse = TotalCasesListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        print('response_list.len ${response_list.length}');

      }else{
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

  int getListLength() {
    if (response_list.isNotEmpty) {
      return response_list.length;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(Strings.verify_cases,
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: ColorConstants.redTextColor,
              height: 40,
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
                  )),
                ],
              ),
            ),
            Container(
              height: 25,
              child: Row(
                children: [
                  Container(
                    //width: 25,
                    child: Text(firstTabTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorConstants.AppColorPrimary)),),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Expanded(child: Container(child: Text(secondTabTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorConstants.AppColorPrimary)),)),
                  const VerticalDivider(
                    thickness: 1.5,
                  ),
                  Container(
                    width: 75,
                    child: Text(thirdTabTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorConstants.AppColorPrimary)),),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Container(width: 75,child: Text(fourthTabTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorConstants.AppColorPrimary)),),
                  const VerticalDivider(
                    thickness: 1.5,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Container(width: 75,child: Text(fifthTabTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: ColorConstants.AppColorPrimary)),)
                ],
              ),

            ),
            const Divider(
              height: 2,
              thickness: 1,
              color: ColorConstants.app_yellow_color,
            ),
            Expanded(child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: listview(),
            )),
            Container(
              width: MediaQuery.of(context).size.width,
              color: ColorConstants.brown_grey,
              height: 45,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('सत्यापित करने पर यह रिकॉर्ड आशा के स्तर पर परिवर्तन / संशोधन \n नहीं किया जा सकेगा |',style: TextStyle(color: Colors.white,fontSize: 13),),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listview() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getListLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return  InkWell(
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
                    child: Text(response_list == null ? "" : (index+1).toString(),
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
                      '${response_list.length == 0 ? "" :widget.type == "5" || widget.type == "3" ?
                      response_list[index]['ChildID'] : response_list[index]['Name']+" W/o "+response_list[index]['HusbName']}',
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
                  Container(
                    width: 75,
                    child: Text(
                        '${response_list == null ? "": response_list[index]['PCTSID'].toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11,color:ColorConstants.black)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Container(width: 75,child: Text(
                      '${response_list == null ? "": response_list[index]['Flag'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11,color:ColorConstants.black)),),
                  const VerticalDivider(
                    thickness: 1,
                    color: ColorConstants.app_yellow_color,
                  ),
                  Container(width: 75,child: Text(
                      '${response_list == null ? "": response_list[index]['AncPncImmuDeathDate'].toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11,color:ColorConstants.black)),)

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

  ShowAboutAppDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AboutAppDialoge(),
    );
  }

  _showLogoutAppDialoge() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          LogoutAppDialoge(context),
    );
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


}
