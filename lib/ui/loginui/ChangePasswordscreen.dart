import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/ui/loginui/sa_mobile_register.dart';
import 'package:pcts/ui/splashnew.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/CheckOtpmodel.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/DialogUtils.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import 'model/ChangePasswordModel.dart';
import 'model/SendSmsModel.dart';

class ChangePasswordscreen extends StatefulWidget {
  ChangePasswordscreen({
    Key? key,
    required this.Mobileno,
    required this.Deviceid,
    required this.Token,
    required this.Userid,
  }) : super(key: key);
  final String Mobileno;
  final String Deviceid;
  final String Token;
  final String Userid;

  void main() {
    runApp(ChangePasswordscreen(
      Mobileno: 'Mobileno',
      Deviceid: 'Deviceid',
      Token: 'Token',
      Userid: 'Userid',
    ));
  }

  @override
  State<StatefulWidget> createState() => _ChangePasswordscreen();


}

class _ChangePasswordscreen extends State<ChangePasswordscreen> {
  TextEditingController _newpasswordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  var otpvalue;
  late SharedPreferences preferences;
  String currentText = "";
  var urlcheckotp = AppConstants.app_base_url + "uspPostChangePassword";
  var PostSentSMSANM_url = AppConstants.app_base_url + "PostSentSMS";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postSendOtp();

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
        title: Text('पासवर्ड बदलें ',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: Container(
        color: ColorConstants.white,
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                height: 80,
                child: TextField(
                  onChanged: (text) {},
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLines: 1,
                  //grow automatically
                  controller: _newpasswordcontroller,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      border: InputBorder.none,
                      labelText: 'नया पासवर्ड दर्ज करें',
                      hintText: ''),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                height: 80,
                child: TextField(
                  onChanged: (text) {},
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  maxLines: 1,
                  //grow automatically
                  controller: _confirmpasswordcontroller,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      border: InputBorder.none,
                      labelText: 'कन्फर्म पासवर्ड दर्ज करें',
                      hintText: ''),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.Mobileno.substring(0, 2) + "******" + widget.Mobileno.substring(8, 10)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ColorConstants.AppColorPrimary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' पर प्राप्त OTP दर्ज करें |',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: ColorConstants.black),
                  textAlign: TextAlign.center,
                ),
              ],
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
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
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
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              margin: EdgeInsets.only(left: 60, right: 60, top: 10),
            ),
            GestureDetector(
              onTap: () {
                if (_newpasswordcontroller.text.toString().isEmpty) {
                  DialogUtils.showCustomDialog(context,
                      message: "नया पासवर्ड दर्ज करें |");
                } else if (_confirmpasswordcontroller.text.toString().isEmpty) {
                  DialogUtils.showCustomDialog(context,
                      message: "कन्फर्म पासवर्ड दर्ज करें |");
                }else if(textEditingController.text.toString().isEmpty){

                  DialogUtils.showCustomDialog(context,
                      message: "प्राप्त OTP दर्ज करें |");
                }else{
                  postDataForChangePassword(textEditingController.text);


                }

              },
              child: Container(
                width: 250,
                height: 40,
                color: ColorConstants.AppColorPrimary,
                child: Center(
                  child: Text(
                    "पासवर्ड बदलें",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> postDataForChangePassword(String otp) async {
    preferences = await SharedPreferences.getInstance();

    var bytes1 = utf8.encode(_newpasswordcontroller.text); // data being hashed
    var digest1 = sha512.convert(bytes1);

    var bytes2 = utf8.encode(_confirmpasswordcontroller.text); // data being hashed
    var digest2 = sha512.convert(bytes2);
    print("DeviceID=> ${widget.Deviceid}");
    print("Password=> ${digest1.toString()}");
    print("ConfirmPassword=> ${digest2.toString()}");
    print("OTP=> ${otp}");
    print("TokenNo=> ${preferences.get('Token')}");
    print("UserID=> ${widget.Mobileno}");
    print("widget.Userid=> ${widget.Userid}");
/* .setBodyParameter("DeviceID", DeviceID)
                    .setBodyParameter("Password", password)
                    .setBodyParameter("ConfirmPassword", confirmpassword)
                    .setBodyParameter("OTP", otp)
                    .setBodyParameter("TokenNo", TokenNo)
                    .setBodyParameter("UserID",Mobile )*/
    var response = await post(Uri.parse(urlcheckotp), body: {
      "DeviceID":widget.Deviceid,
      "Password":digest1.toString(),
      "ConfirmPassword":digest2.toString(),
      "OTP": otp,
      "TokenNo": widget.Token,
      "UserID": widget.Userid == '' ? widget.Mobileno : widget.Userid,
    });


    var resBody = json.decode(response.body);
    final apiResponse = ChangePasswordModel.fromJson(resBody);
    var checkotp = apiResponse.resposeData;
    bool? Status = apiResponse.status;
    var message = apiResponse.message.toString();
    print("approleid=> ${preferences.getString("AppRoleID")}");
    if (Status == true) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SplashNew(),//ANM/ASHA
          ),
        );
      } else {
      DialogUtils.showCustomDialog(context, message: message);

      }
    return "Success";
  }

  Future<String> postSendOtp() async {

    var response = await post(Uri.parse(PostSentSMSANM_url), body: {
     "SmsFlag":"4",
      "MobileNo": widget.Mobileno,
      "TokenNo": widget.Token,
    });

    var resBody = json.decode(response.body);
    final apiResponse = SendSmsModel.fromJson(resBody);
    bool? Status = apiResponse.status;
    var message = apiResponse.message.toString();
    print("Message=> ${message}");
    if (Status == true) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);

    }
    return "Success";
  }
}
