import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/Model/CheckOtpmodel.dart';
import 'package:pcts/constant/CustomAppBar.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/admindashboard/admin_dashboard.dart';
import 'package:pcts/ui/dashboard/mainsliderpage.dart';
import 'package:pcts/ui/loginui/sa_mobile_register.dart';
import 'package:pcts/utils/ShowCustomDialoge.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import '../dashboard/dashboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(OtpLoginPage(
    Mobileno: 'Mobileno',
    Val_Flag: 'Val_Flag',
  ));
}

class OtpLoginPage extends StatefulWidget {
  OtpLoginPage({
    Key? key,
    required this.Mobileno,
    required this.Val_Flag,
  }) : super(key: key);
  final String Mobileno;
  final String Val_Flag;

  @override
  State<StatefulWidget> createState() => _OtpLoginPage();
}

class _OtpLoginPage extends State<OtpLoginPage> {
  var otpvalue;
  late SharedPreferences preferences;
  TextEditingController _mobilenumber = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  var urlcheckotp = AppConstants.app_base_url + "PostCheckOTP";
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  String message = '';

  // List<ResposeData>? checkotp = [];

  //var Mobileno="79******33";
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();

    /*FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild!.unfocus();
    }*/
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

  Future<String> getCheckOtp(String otp) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();

    var response = await post(Uri.parse(urlcheckotp), body: {
      "MobileNo": widget.Mobileno,
      "SmsFlag": '4',
      "OTP": otp,
      "TokenNo": preferences.get('Token'),
      "UserID": preferences.get('UserId'),
    });
    var resBody = json.decode(response.body);
    final apiResponse = CheckOtpmodel.fromJson(resBody);
    var checkotp = apiResponse.resposeData;
    bool? Status = apiResponse.status;
    message = apiResponse.message.toString();
    print("approleid=> ${preferences.getString("AppRoleID")}");
    if (Status == true) {
      if (preferences.getString("AppRoleID").toString() == '31' ||
          preferences.getString('AppRoleID').toString() == "32" ||
          preferences.getString("AppRoleID").toString() == '33') {
        //save login type session
        preferences.setString("LoginType","anmpanel");
        preferences.setString("isLogin", "true");
        print('isLogin ${preferences.getString("isLogin").toString()}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen(),//ANM/ASHA
          ),
        );
      } else {
        //save login type session
        preferences.setString("LoginType","superadmin");
        preferences.setString("isLogin", "true");
        print('isLogin ${preferences.getString("isLogin").toString()}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AdminDashboard(),//(Report Viewer)super admin login
          ),
        );
      }
    } else {
      preferences.setString("isLogin", "false");
      Fluttertoast.showToast(
          msg:message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    EasyLoading.dismiss();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: ColorConstants.white,
        child: Column(
          children:<Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '${Strings.verify_enter_mobile_no}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.Mobileno.substring(0, 2) + "******" + widget.Mobileno.substring(8, 10)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorConstants.AppColorPrimary),
                    textAlign: TextAlign.center,
                  ),
                  Text(' पर प्राप्त OTP दर्ज करें |',
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
                          //print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),
                margin: EdgeInsets.only(left: 60,right: 60,top: 20),
              ),
              GestureDetector(
                onTap:() async {
                  formKey.currentState!.validate();
                  // conditions for validating
                  if (currentText.length != 4) {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  } else {
                    var result = await Connectivity().checkConnectivity();
                    if(result == ConnectivityResult.mobile) {
                      setState(() {
                        hasError = false;
                        getCheckOtp(otpvalue);
                        //  snackBar("OTP Verified!!");
                      },
                      );
                    }else if(result == ConnectivityResult.wifi) {
                      setState(() {
                        hasError = false;
                        getCheckOtp(otpvalue);
                        //  snackBar("OTP Verified!!");
                      },
                      );
                    }else if(result == ConnectivityResult.none){
                      print("No internet connection");
                      showInternetDialoge();
                    }

                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:ColorConstants.AppColorPrimary,
                    ),
                    width: 100,
                    height: 40,
                    child: Center(child: Text('${Strings.next_}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>SaMobileRegister( Message: message,Val_Flag: widget.Val_Flag,),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red, //                   <--- border color
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,

                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('पंजीकृत मोबाइल नंबर ',style: TextStyle(color: Colors.red,fontSize: 12),),
                      ),Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('${widget.Mobileno.substring(0, 2) + "******" + widget.Mobileno.substring(8, 10)}',style: TextStyle(color:ColorConstants.text_green,fontSize: 12),),
                      ),Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(' को बदलने के लिए क्लिक करें |',style: TextStyle(color:Colors.red,fontSize: 12),),
                      )
                    ],
                  ),

                ),
              )
            ],)),
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
  showInternetDialoge() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CustomInvaildRequestDialoge(),
    );
  }
}
