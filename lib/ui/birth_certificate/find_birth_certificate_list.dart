import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/birth_certificate/pdf_viewer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import '../loginui/model/OTPSentData.dart';
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

  var _get_otp_url = AppConstants.app_base_url + "PostSentSMS";
  var _check_otp_url = AppConstants.app_base_url + "PostCheckOTP";

  TextEditingController enterOTPController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var _resentMobileReq="";
  var _resentInfantIdReq="";
  Future<String> getOTPAPI(_mobileno,_infantID) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    _resentMobileReq=_mobileno;
    _resentInfantIdReq=_infantID;
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
        enterOTPController.text="";

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
                                  '${find_child_birthcerti_list[index]['name'].toString()}',
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
                                  '${find_child_birthcerti_list[index]['Husbname'].toString()}',
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
                                  '${find_child_birthcerti_list[index]['Mobileno'].toString()}',
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
                                getOTPAPI(find_child_birthcerti_list[index]['Mobileno'],find_child_birthcerti_list[index]['infantList'][childindex]['InfantID'].toString());

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
                        child: Text(Strings.recv_otp2,textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstants.appNewBrowne,fontSize: 13),),
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
                              //print("Completed$v");
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
                              //print("Allowing to paste $text");
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
                            //width: 50,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:ColorConstants.AppColorPrimary,
                              ),
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(5.0),
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
                          getOTPAPI(_resentMobileReq,_resentInfantIdReq);
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
}