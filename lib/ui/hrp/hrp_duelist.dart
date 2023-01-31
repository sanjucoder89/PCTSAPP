import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/ui/hrp/Model/HrpDueListData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import '../../../constant/AboutAppDialoge.dart';
import '../../../constant/ApiUrl.dart';
import '../../../constant/LocaleString.dart';
import '../../../constant/LogoutAppDialoge.dart';
import '../../../constant/MyAppColor.dart';
import '../dashboard/model/GetHelpDeskData.dart';
import '../dashboard/model/LogoutData.dart';
import '../prasav/before/anc_expand_details.dart';
import '../prasav/before/model/GetPrasavListData.dart';
import '../prasav/before/model/GetVillageListData.dart';
import '../samparksutra/samparksutra.dart';
import '../splashnew.dart';
import '../videos/tab_view.dart';
import 'hrp_expand_details.dart';

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


class HrpDueScreenList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HrpDueScreenList();


}

var option1=Strings.logout;
var option2=Strings.sampark_sutr;
var option3=Strings.video_title;
var option4=Strings.app_ki_jankari;
var option5=Strings.help_desk;

class _HrpDueScreenList extends State<HrpDueScreenList> {
  late SharedPreferences preferences;
  var _get_village_list = AppConstants.app_base_url+"uspGetVillageList";
  var _get_village_list_asha = AppConstants.app_base_url+"uspGetVillageListAsha";
  var _get_prasav_list = AppConstants.app_base_url+"postHighRiskCasesList";
  var _find_prasav_id = AppConstants.app_base_url + "PostPCTSID";
  var _help_desk_url = AppConstants.app_base_url + "HelpDesk";
  var _logout_url = AppConstants.app_base_url + "LogoutToken";

  List help_response_listing = [];
  List villages_list = [];
  List response_listing = [];
  List find_response_listing = [];
  late String villageId="0";
  ScrollController? _controller;
  //bool isToggle=false;
  /*
  * API FOR Village  LISTING
  * */
  Future<String> checkLoginSession() async {
    preferences = await SharedPreferences.getInstance();
    if(preferences.getString("AppRoleID").toString() == '33'){
      getVillageListAshaAPI(preferences.getString('ANMAutoID'));
    }else{
      getVillageListAPI(preferences.getString('UnitID'));
    }
    return "onSucess";
  }
  Future<String> getVillageListAPI(_id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_village_list), body: {
      "LoginUnitid": _id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetVillageListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        villages_list = resBody['ResposeData'];
        villageId = resBody['ResposeData'][0]['VillageautoID'].toString();
        print('villages_list.len ${villages_list.length}');
        print('villageId ${villageId}');

      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    getPrasavLisingAPI(villageId);
    print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getVillageListAshaAPI(_id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_village_list_asha), body: {
      "LoginUnitid": _id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetVillageListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        villages_list = resBody['ResposeData'];
        villageId = resBody['ResposeData'][0]['VillageautoID'].toString();
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    getPrasavLisingAPI(villageId);
    return "Success";
  }

  /*
  * API FOR Prasav  LISTING
  * */
  Future<String> getPrasavLisingAPI(String village_id) async {
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitid ${preferences.getString('UnitID')}');
    print('VillageAutoid $village_id');
    print('TokenNo ${preferences.getString('Token')}');
    print('UserID ${preferences.getString('UserId')}');
    var response = await post(Uri.parse(_get_prasav_list), body: {
      "LoginUnitid": preferences.getString('UnitID'),
      "VillageAutoid":village_id,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
      /*"LoginUnitid":"250",
      "VillageAutoid":"623",
      "TokenNo":"fc9b1a5a-2593-4bbe-ab40-b70b7785a041",
      "UserID":"0101010020201"*/
    });
    var resBody = json.decode(response.body);
    final apiResponse = HrpDueListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_listing = resBody['ResposeData'];
        print('response_listing.len ${response_listing.length}');

      } else {
        //reLoginDialog();
      }
    });
    //dismiss loader
    await EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
  }


  /*
  * API FOR FIND PRASV DATA
  * */
  Future<String> findPrasavDataByIDAPI(String id) async {
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
      "TagName":"1",
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

  bool showbtn = true;
  @override
  void initState() {
    super.initState();
    checkLoginSession();
    getHelpDesk();
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

  int getLength() {
    if(response_listing.isNotEmpty){
      return response_listing.length;
    }else{
      return 0;
    }
  }
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
              controller: scrollController,
              physics: ScrollPhysics(),
              child: Column(
                children:<Widget>[
                  Container(
                    color: ColorConstants.prsav_header_color,
                    height: 40,
                    child: Row(
                      children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(Strings.highrisk_due_cases,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                          ),
                        ),
                      ),
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
                            padding: const EdgeInsets.only(top: 12,left: 5),
                            child: Container(
                              height: 30,
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
                                        child: MediaQuery.removePadding(context: context, child: Container(
                                          height: 25,
                                          child: Column(
                                            children: [
                                              Text(
                                                item['VillageName'],    //Names that the api dropdown contains
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),
                                              //Divider(color: ColorConstants.AppColorPrimary,height: 0.3,)
                                            ],
                                          ),
                                        )),
                                        value: item['VillageautoID'].toString()       //Id that has to be passed that the dropdown has.....
                                    );
                                  }).toList(),
                                  onChanged: (String? newVal) {
                                    setState((){
                                      villageId = newVal!;
                                      getPrasavLisingAPI(villageId);
                                    });
                                  },
                                  value: villageId,                 //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                      ],
                    ),
                  ),
                  _myListView()
                ],
              ),
            ),
          ),
          showbtn == false
              ?
          Container()
              :
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HRPExpandDetails(ANCRegID:response_listing[index]['ancregid'].toString(),
                  MotherID: response_listing[index]['motherid'].toString()),
            ),
          );
        },
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 5,bottom: 2,right: 5),
                          child: Text(
                            Strings.pcts_id_title,
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : response_listing[index]['pctsid'].toString()}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text(
                            Strings.mahila_ka_naam,
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : response_listing[index]['name'].toString()+ " w/o " +response_listing[index]['Husbname'].toString()}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text(
                            Strings.panjikaran_ki_tithi,
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : getFormattedDate(response_listing[index]['regdate'].toString())}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text(
                            Strings.aakhri_mahaveer_ki_tithi,
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : getFormattedDate(response_listing[index]['lmpdate'].toString())}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text(
                            Strings.age,
                            style: TextStyle(
                                fontSize: 13,
                                color:ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : response_listing[index]['age'].toString()}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5),
                          child: Text(
                            Strings.anc_ki_tithi,
                            style: TextStyle(
                                fontSize: 13,
                                color:ColorConstants.AppColorPrimary,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('${response_listing == null ? "" : getFormattedDate(response_listing[index]['lmpdate'].toString())}',
                      style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                  ))
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                children: [
                  Text(Strings.click_info,
                    style: TextStyle(
                        fontSize: 13,
                        color: ColorConstants.AppColorPrimary,
                        fontWeight: FontWeight.normal),),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: 50,
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

              Divider(
                height: 0,
                color: ColorConstants.app_yellow_color,
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
                            findPrasavDataByIDAPI(pctsIdController.text.toString().trim());
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