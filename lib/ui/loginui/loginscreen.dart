import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:pcts/Model/PostSaltData.dart';
import 'package:pcts/Model/UserAuthModel.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/DialogUtils.dart';
import 'package:pcts/ui/loginui/otplogin.dart';
import 'package:pcts/ui/loginui/sa_mobile_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../utils/ShowCustomDialoge.dart';
import 'ChangePasswordscreen.dart';
import 'model/PostCheckAshaModel.dart';

void main(){
  //runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  LoginScreen(
      {Key? key,
        required this.Saltvalue,
        required this.DeviceID,
        required this.TokenNo,
        required this.Imei})
      : super(key: key);

  final String Saltvalue;
  final String DeviceID;
  final String TokenNo;
  final String Imei;

  @override
  State<StatefulWidget> createState() => _LoginScreen();

}

class _LoginScreen extends State<LoginScreen> {
  late SharedPreferences preferences;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  late final String UnitCode;
  var url = AppConstants.app_base_url + "HelpDesk";

  var uuid = Uuid();
  List<ResposeDataSalt>? saltdata = [];
  var saltdatastirng;
  var _MobileNo;
  String regexMobile = '^[5-9]{1}[0-9]{9}';


  @override
  Widget build(BuildContext context) {
    print('Saltvalue:${widget.Saltvalue}');
    saltdatastirng = widget.Saltvalue;
    print('DeviceID:${widget.DeviceID}');
    print('TokenNo:${widget.TokenNo}');
    print('Imei:${widget.Imei}');
    String pattern = r'^[5-9]{1}[0-9]{9}$';
    RegExp regExp = new RegExp(pattern);
    return Scaffold(
      body: SafeArea(child: Column(
        children:<Widget> [
          Expanded(child: Container(
            //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Images/bg_login.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  margin: EdgeInsets.only(left: 20,right: 20,top: 180),
                  color: Colors.transparent,
                  //height: 200,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextField(
                          maxLength: 20,
                          onChanged: (text){
                            if(text.length==10 && regExp.hasMatch(text)){
                              getCheckPostAsha(widget.DeviceID, widget.TokenNo, _username.text.toString());
                              print("text some here: $text");
                            }
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          controller: _username,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              border: InputBorder.none,
                              labelText: 'यूजर आई डी दर्ज करे',
                              hintText: '',
                              counterText: ''

                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          maxLines: 1,
                          controller: _password,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              border: InputBorder.none,
                              labelText: 'पासवर्ड दर्ज करें',
                              hintText: ''

                          ),),
                      ),
                      Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (_username.text.toString().isEmpty) {
                                DialogUtils.showCustomDialog(context,
                                    message: "यूजर आई डी दर्ज करें ");
                              } else if (_password.text.toString().isEmpty) {
                                DialogUtils.showCustomDialog(context,
                                    message: "पासवर्ड दर्ज करें");
                              } else {
                                var result = await Connectivity().checkConnectivity();
                                if(result == ConnectivityResult.mobile) {
                                  chekConnectivity();
                                }else if(result == ConnectivityResult.wifi) {
                                  chekConnectivity();
                                }else if(result == ConnectivityResult.none){
                                  print("No internet connection");
                                  showInternetDialoge();
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: 100,
                              child: const Center(
                                child: Text(
                                  'लॉगइन करें',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueAccent,
                                boxShadow: const [
                                  BoxShadow(color: Colors.greenAccent, spreadRadius: 2),
                                ],
                              ),
                              height: 30,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      )),
    );
  }
  void chekConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile) {
      getUserAuth(
          _username.text.toString(),
          _password.text.toString(),
          widget.DeviceID,
          widget.TokenNo,
          widget.DeviceID);
    }else if(result == ConnectivityResult.wifi) {
      getUserAuth(
          _username.text.toString(),
          _password.text.toString(),
          widget.DeviceID,
          widget.TokenNo,
          widget.DeviceID);
    }else if(result == ConnectivityResult.none){
      showInternetDialoge();
    }
  }
  showInternetDialoge() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CustomInvaildRequestDialoge(),
    );
  }
  Future<String> getUserAuth(
      String username,
      String pass,
      String deviceid,
      String TokenId,
      String Imei,
      ) async {
    //print(' ${"Asha"+"$\"+"123"}');
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var bytes1 = utf8.encode(pass); // data being hashed
    var digest1 = sha512.convert(bytes1); // Hashing Process
    //print("Digest as hex string: $digest1");
   // print("saltdatastirng $saltdatastirng");
    //var passslat = saltdatastirng + digest1;
    String pass1 = saltdatastirng.toString() + digest1.toString();
    print("pass $pass1");
    var bytes2 = utf8.encode(pass1);

    var pass512data = sha512.convert(bytes2);
    print("password512 $pass512data");
    /* var pass512data = sha512.convert(passslat);
    print("password512 $passslat");*/

    preferences = await SharedPreferences.getInstance();
    var urlpostUserAuthenticate = AppConstants.app_base_url + "postUserAuthenticate";
    var response = await post(Uri.parse(urlpostUserAuthenticate), body: {
      "UserID": username.toString(),
      "Password": pass512data.toString(),
      "DeviceID": deviceid.toString(),
      "TokenNo": TokenId.toString(),
      "Imei": Imei.toString(),
    });
    print("UserID=> ${username.toString()}");
    print("Password=> ${pass512data.toString()}");
    print("DeviceID=> ${Imei.toString()}");
    print("TokenNo=> $TokenId");
    print("Imei=> ${Imei.toString()}");
    var resBody = json.decode(response.body);
    final apiResponse = UserAuthModel.fromJson(resBody);

    bool? Status = apiResponse.status;
    var message = apiResponse.message;

    if (Status == true) {
      var _UnitCode = apiResponse.resposeData![0].unitCode.toString();
      var _UnitID = apiResponse.resposeData![0].unitID.toString();
      var _ANMName = apiResponse.resposeData![0].aNMName.toString();
      var _ANMAutoID = apiResponse.resposeData![0].aNMAutoID.toString();
      var _UnitName = apiResponse.resposeData![0].unitName.toString();
      var _Resetpwd = apiResponse.resposeData![0].resetpwd.toString();
      var _AppRoleID = apiResponse.resposeData![0].appRoleID.toString();
      var _UnitType = apiResponse.resposeData![0].unitType.toString();
      _MobileNo = apiResponse.resposeData![0].mobileNo.toString();
      var _VaildMobileFlag = apiResponse.resposeData![0].vaildMobileFlag.toString();
      var _UserNo = apiResponse.resposeData![0].userNo.toString();
      var _Token = apiResponse.resposeData![0].token.toString();
      var _DistrictName = apiResponse.resposeData![0].districtName.toString();
      var _BlockName = apiResponse.resposeData![0].blockName.toString();
      var _AnganwariHindi =
      apiResponse.resposeData![0].anganwariHindi.toString();
      var _UnitAbbr = apiResponse.resposeData![0].unitAbbr.toString();

      //"UnitCode": "01010650302",
      //             "UnitID": "250",
      //             "ANMName": "pinki  shekhawat",
      //             "UnitName": "कालानाडा",
      //             "Resetpwd": "0",
      //             "UnitType": "11",
      //             "AppRoleID": "33",
      //             "MobileNo": "7976119833",
      //             "UserNo": "47130",
      //             "DistrictName": "अजमेर",
      //             "BlockName": "अरॉई",
      //             "PCHCHCName": "अरॉई",
      //             "PCHCHCAbbr": "CHC",
      //             "UnitAbbr": "SC",
      //             "IsExp": "0",
      //             "Token": "e0b013bf-59dc-4e9b-b4e8-b2fb97aac9e7",
      //             "ANMAutoID": "104991",
      //             "VaildMobileFlag": "5",
      //             "AnganwariEnglish": "dholpuria",
      //             "AnganwariHindi": "धौलपुरिया"
      preferences.setString("UnitCode", _UnitCode);
      preferences.setString("DistrictName", _DistrictName);
      preferences.setString("BlockName", _BlockName);
      preferences.setString("Token", _Token);
      preferences.setString("AnganwariHindi", _AnganwariHindi);
      preferences.setString("UserId", username);
      preferences.setString("AppRoleID", _AppRoleID);
      preferences.setString("UserNo", _UserNo);
      preferences.setString("UnitType", _UnitType);
      preferences.setString("UnitID", _UnitID);
      preferences.setString("ANMName", _ANMName);
      preferences.setString("ANMAutoID", _ANMAutoID);
      preferences.setString("UnitName", _UnitName);


      var topName = '';
      if (_DistrictName != null) {
        topName = _DistrictName;
      }

      if (_BlockName != null && _BlockName != 'null') {
        topName = topName + " -> " + _BlockName;
      }
      topName = topName + " -> " + _UnitName + " (" + _UnitAbbr + ")";
      //print('topName:....> $topName');

      print('AppRoleID:....> ${preferences.getString("AppRoleID").toString()}');
      preferences.setString('topName', topName);

      if (_AppRoleID == '99' || _AppRoleID == '98') {
        DialogUtils.showCustomDialog(context,
            message: "यह यूजर आईडी एप्लीकेशन के लिए अमान्य है |");
      } else if (_Resetpwd == '1') {
        //move to change password
      // for change password
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChangePasswordscreen(
                Mobileno: _MobileNo,
                Deviceid:Imei.toString(),
                Token:TokenId,
              Userid:username.toString()
              //   Val_Flag: valFlag,
            ),
          ),
        );
      } else {
        // VaildMobileFlag = 1 for blank or null
        // VaildMobileFlag = 2 for mobile no not valid
        // VaildMobileFlag = 3 for mobile more than 1 user
        // VaildMobileFlag = 4 for sms not send
        // VaildMobileFlag = 5 for sms send success
        print("_VaildMobileFlag ${int.parse(_VaildMobileFlag)}");
        if (int.parse(_VaildMobileFlag) > 0) {
          if (_VaildMobileFlag == '1' ||
              _VaildMobileFlag == '2' ||
              _VaildMobileFlag == '3') {
            _openMyPage(message.toString(),_VaildMobileFlag);
          } else if (_VaildMobileFlag == '5') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    OtpLoginPage(Mobileno: _MobileNo,Val_Flag: _VaildMobileFlag,),
              ),
            );
          }
        }
      }
      EasyLoading.dismiss();
    }
    else {
      EasyLoading.dismiss();
      DialogUtils.showCustomDialog(context, message: message.toString());
    }
    return "Success";
  }

  Future<String> getCheckPostAsha(
      String deviceid,
      String TokenId,
      String Mobileno,
      ) async {
    //print(' ${"Asha"+"$\"+"123"}');
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('deviceid.toString() ${deviceid.toString()}');
    print('TokenNo ${TokenId.toString()}');
    print('MobileNo1 ${Mobileno}');
    var PostCheckAsha_url = AppConstants.app_base_url + "PostCheckAsha";
    var response = await post(Uri.parse(PostCheckAsha_url), body: {
      "DeviceID": deviceid.toString(),
      "TokenNo": TokenId.toString(),
      "MobileNo1": Mobileno,
    });
    var resBody = json.decode(response.body);
    final apiResponse = PostCheckAsha.fromJson(resBody);
    bool? Status = apiResponse.status;
    var message = apiResponse.message;

    if (Status == true) {//7976119833
      print('on sucesss');

      var Password = apiResponse.resposeData![0].password.toString();
      if (Password == "true") {
      } else {
        // for change password
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChangePasswordscreen(
                Mobileno: Mobileno,
                Deviceid:deviceid,
                Token:TokenId,
                Userid: '',
              //   Val_Flag: valFlag,
            ),
          ),
        );
      }

    } else {
      // intent to change password to asha

      DialogUtils.showCustomDialog(context, message: message.toString());
    }
    EasyLoading.dismiss();
    return "Success";
  }

  void _openMyPage(String msg,String valFlag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SaMobileRegister( Message: msg,Val_Flag: valFlag,),
      ),
    );
  }




}