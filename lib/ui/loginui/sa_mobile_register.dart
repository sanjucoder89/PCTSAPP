import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:pcts/ui/dashboard/dashboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/ApiUrl.dart';
import '../admindashboard/admin_dashboard.dart';
import 'model/OTPSentData.dart';
import 'model/ValidateOTPData.dart';



class SaMobileRegister extends StatefulWidget {
  SaMobileRegister(
      {Key? key,
        required this.Message,
        required this.Val_Flag})
      : super(key: key);

  final String Message;
  final String Val_Flag;
  @override
  State<StatefulWidget> createState() => _SaMobileRegister();
}

class _SaMobileRegister extends State<SaMobileRegister> {

  var _mobile_register_url = AppConstants.app_base_url + "PostSentSMS";
  var _validate_otp = AppConstants.app_base_url + "PostCheckOTP";
  late SharedPreferences preferences;


  Future<String> validateOTPAPI() async {
    preferences = await SharedPreferences.getInstance();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    print('mobileno ${_mobilenumber.text.toString().trim()}');

    print('SmsFlag 4');
    print('OTP ${textEditingController.text.toString().trim()}');
    print('TokenNo ${preferences.getString("Token")}');
    print('UserID ${preferences.getString("UserId")}');
    var response = await post(Uri.parse(_validate_otp), body: {
      "MobileNo":_mobilenumber.text.toString().trim(),
      "SmsFlag":"4",
      "OTP":textEditingController.text.toString().trim(),
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = ValidateOTPData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        print("checkRoleID ${preferences.getString("AppRoleID").toString()}");//checkRoleID 4
        if(preferences.getString("AppRoleID").toString() == "31" || preferences.getString("AppRoleID").toString() == "32" || preferences.getString("AppRoleID").toString() == "33"){
          //save login type session
          preferences.setString("LoginType","anmpanel");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DashboardScreen(),//ANM or ASHA
            ),
          );
        }else{
          //save login type session
          preferences.setString("LoginType","superadmin");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AdminDashboard(),//(Report Viewer)super admin login
            ),
          );
        }
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
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
  List response_list = [];

  Future<String> mobileRegisterAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_mobile_register_url), body: {
      //MobileNo:8619592540
      // SmsFlag:4
      // TokenNo:0074b655-a1a8-4446-bb60-e2ea57e932ad
      // UserID:sa
      "MobileNo":_mobilenumber.text.toString().trim(),
      "SmsFlag":"4",
      "TokenNo":preferences.getString("Token"),
      "UserID":preferences.getString("UserId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = OTPSentData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        setState(() {
          showOtpView = true;
          isRegisterCall=true;
        });
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        isRegisterCall=false;
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

  TextEditingController _mobilenumber = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  bool showOtpView = false;
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  var isRegisterCall=false;
  var _appRoleID="";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    checkRegisterno();
  }


  @override
  void dispose() {
    errorController!.close();
    super.dispose();
    EasyLoading.dismiss();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: ColorConstants.light_bluebg,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'पीसीटीएस ऐप पर मोबाइल रजिस्ट्रशन अनिवार्य कर दिया गया है |\n कृपया अपना मोबाइल नं. रजिस्टर करें |',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.deepOrange),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _mobilenumber,
                        maxLength: 10,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: ColorConstants.AppColorPrimary),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "मोबाइल नं. दर्ज करें",
                          counterText: ''
                        ),
                        // style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                        visible: showOtpView,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'OTP दर्ज करें',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: ColorConstants.AppColorPrimary),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              child: Form(
                                key: formKey,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 30),
                                    child: PinCodeTextField(
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
                                          return "I'm from validator";
                                        } else {
                                          return null;
                                        }
                                      },
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius: BorderRadius.circular(5),
                                        fieldHeight: 50,
                                        fieldWidth: 40,
                                        activeFillColor: Colors.white,
                                      ),
                                      cursorColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 300),
                                      enableActiveFill: true,
                                      errorAnimationController: errorController,
                                      controller: textEditingController,
                                      keyboardType: TextInputType.number,
                                      boxShadows: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black12,
                                          blurRadius: 10,
                                        )
                                      ],
                                      onCompleted: (v) {
                                        print("Completed");
                                      },
                                      // onTap: () {
                                      //   print("Pressed");
                                      // },
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          currentText = value;

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
                              margin: EdgeInsets.only(left: 60,right: 60),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? "*Please fill up all the cells properly" : "",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 50),
                      child: ButtonTheme(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            print('isRegisterCall ${isRegisterCall}');
                            if(isRegisterCall == true){
                              if(textEditingController.text.toString().isEmpty){
                                Fluttertoast.showToast(
                                    msg:"${Strings.enter_otp}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white);
                              }else{
                                print('validateOTPAPI callingg........');
                                validateOTPAPI();
                              }
                            }else{
                              print('mobileRegisterAPI callingg........');
                              mobileRegisterAPI();
                            }
                          },
                          child: Center(
                              child: Text(
                            "OK".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: ColorConstants.AppColorDark,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: ColorConstants.AppColorLight,
                                offset: Offset(1, -2),
                                blurRadius: 5),
                            BoxShadow(
                                color: ColorConstants.AppColorLightShadow,
                                offset: Offset(-1, 2),
                                blurRadius: 5)
                          ]),
                    )
                  ],
                )),
            Image.asset(
              "Images/footerpcts.jpg",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }

  void checkRegisterno() {
    print('widget.Val_Flag  ${widget.Val_Flag }');
    if(widget.Val_Flag != '5'){
      _showErrorPopup(widget.Message, Colors.black);
    }

  }

  Future<void> _showErrorPopup(String msg,Color _color) async {
    await Future.delayed(Duration(milliseconds: 50));
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
