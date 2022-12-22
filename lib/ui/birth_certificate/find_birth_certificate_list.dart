import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/birth_certificate/pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import 'model/GetBirthCertificateFindListData.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


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


class FindBirthCertificateList extends StatefulWidget {
  FindBirthCertificateList({Key? key,
    required this.pctsid
  }) : super(key: key);
  final String pctsid;
  @override
  State<StatefulWidget> createState() => _FindBirthCertificateList();


}

class _FindBirthCertificateList extends State<FindBirthCertificateList> {

  var _child_growth_list_url = AppConstants.app_base_url + "PostPCTSID";
  late SharedPreferences preferences;
  List find_child_birthcerti_list = [];
  /*
  * API FOR Child Find Birth List
  * */
  Future<String> getFindChildBirthCertiListAPI() async {
    preferences = await SharedPreferences.getInstance();
    print('login-unit-id ${preferences.getString('UnitID')}');
    print('login-unit-code ${preferences.getString('UnitCode')}');

    var response = await post(Uri.parse(_child_growth_list_url), body: {
     //PCTSID:01010900404991090
      // TagName:3
      // TokenNo:fc9b1a5a-2593-4bbe-ab40-b70b7785a041
      // UserID:0101010020201
      "PCTSID":widget.pctsid,
      "TagName":"3",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetBirthCertificateFindListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        find_child_birthcerti_list = resBody['ResposeData'];
        print('find_child_birthcerti_list.len ${find_child_birthcerti_list.length}');
      } else {
        find_child_birthcerti_list.clear();
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
  ScrollController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFindChildBirthCertiListAPI();

  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  int getLength() {
    if(find_child_birthcerti_list.isNotEmpty){
      return find_child_birthcerti_list.length;
    }else{
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Strings.shishu_ka_janam_patra,style: TextStyle(fontSize: 13,color: Colors.white),),
            Text(widget.pctsid,style: TextStyle(fontSize: 13,color: Colors.white),)
          ],
        ),
        backgroundColor: ColorConstants.AppColorPrimary,// status bar color
        brightness: Brightness.light, // status bar brightness
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: getLength(),
                    itemBuilder: _itemBuilder,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true
                )
            ),
          ),
        ),
      ),
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
                                  '${find_child_birthcerti_list[index]['name']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
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
                                  '${find_child_birthcerti_list[index]['Husbname']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
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
                                  '${find_child_birthcerti_list[index]['Mobileno']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
                        itemCount: find_child_birthcerti_list[index]['infantList'].length,
                        itemBuilder: (context, childindex) {
                          return GestureDetector(
                            onTap: (){
                              if(find_child_birthcerti_list[index]['infantList'][childindex]['PehchanRegFlag'] == 0){
                                showPopupDialog();
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewer(infantId: find_child_birthcerti_list[index]['infantList'][childindex]['InfantID']),
                                  ),
                                );
                              }
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
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  '${find_child_birthcerti_list[index]['infantList'][childindex]['ChildName'] == null ? "-" :find_child_birthcerti_list[index]['infantList'][childindex]['ChildName']}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
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
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  getFormattedDate(find_child_birthcerti_list[index]['infantList'][childindex]['Birth_date'].toString()),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
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
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  find_child_birthcerti_list[index]['infantList'][childindex]['Sex'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
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
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(//${_mahila_vivaran_response.length == 0 ? "": getFormattedDate(_mahila_vivaran_response[index]['RegDate'].toString())}
                                                  find_child_birthcerti_list[index]['infantList'][childindex]['ChildID'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
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

  Future<void> showPopupDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Strings.no_data_found,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.appNewBrowne,fontSize: 13),),
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
                          Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child:Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text("OK",style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
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
}