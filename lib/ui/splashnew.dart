import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcts/Model/PostSaltData.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/loginui/loginscreen.dart';
import 'package:pcts/ui/pcts/pctsids/findpcts.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Model/HelpDeskNo.dart';
import '../constant/ApiUrl.dart';
import '../constant/ImageDialog.dart';
import '../constant/MyAppColor.dart';
import '../utils/ShowCustomDialoge.dart';
import '../utils/ShowPlayStoreDialoge.dart';
import 'admindashboard/admin_dashboard.dart';
import 'anmworkplan/anmworkplan_list.dart';
import 'dashboard/dashboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:location/location.dart';

class SplashNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashNew> {
  late SharedPreferences preferences;
  var urlhelpdesk = AppConstants.app_base_url + "HelpDesk";
  var urlsaltdata = AppConstants.app_base_url + "postSalt";
  var res_status;
  List<ResposeData>? helpdeskno = [];
  List<ResposeDataSalt>? saltdata = [];
  List<String> customMarquelist = [];
  var helpno = '';
  var textfinal = '';
  var saltvalue="";
  var deviceId;

  var Imei;

  String packageName = '';
  var uuid = Uuid();
  var Token;

  @override
  void initState() {
    super.initState();
    //chekConnectivity();
    _getLocation();
    _navigateToHome();
    getHelpDeskNo();
    getVersionName();
    getSaltData();
  }
  var _latitude="0.0";
  var _longitude="0.0";
  Future _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Location location = new Location();
    LocationData _pos = await location.getLocation();
    //print('curr lat ${_pos.latitude}');
    //print('curr lng ${_pos.longitude}');
    if(_pos.latitude != null){
      _latitude=_pos.latitude.toString();
    }
    if(_pos.longitude != null){
      _longitude=_pos.longitude.toString();
    }
    //print('live loc lat $_latitude');
    //print('live loc lng $_longitude');
    setState(() {
      prefs.setString("latitude", _latitude);
      prefs.setString("longitude", _longitude);
    });
  }
  void chekConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile) {
      print("Internet connection is from Mobile data");
      _navigateToHome();
      getHelpDeskNo();
      getVersionName();
      getSaltData();
    }else if(result == ConnectivityResult.wifi) {
      print("internet connection is from wifi");
      _navigateToHome();
      getHelpDeskNo();
      getVersionName();
      getSaltData();
    }else if(result == ConnectivityResult.none){
      print("No internet connection");
      showInternetDialoge();
    }
  }

  Future<String> getHelpDeskNo() async {
    var response = await post(Uri.parse(urlhelpdesk), body: {
      "type": "1",
    });
    var resBody = json.decode(response.body);
    final apiResponse = HelpDeskNo.fromJson(resBody);
    helpdeskno = apiResponse.resposeData;
    if(helpdeskno != null){
      for (int i = 0; i < helpdeskno!.length; i++) {
        var helpno1 = helpdeskno![i].time.toString();
        helpno = 'कार्यालय का समय ( $helpno1 ) हेल्प डेस्क नं. ->';
        customMarquelist.add(" " +
            helpdeskno![i].name.toString() +
            " " +
            helpdeskno![i].mobile.toString() +
            " ");
      }
      setState(() {
        textfinal = helpno + customMarquelist.join(",");
        //print('amitdata:$textfinal');
      });
    }
    return "Success";
  }

  var _loader=false;

  Future<String> getSaltData() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("Appversion", packageName);
    deviceId = await PlatformDeviceId.getDeviceId;
    preferences.setString("deviceId", deviceId);
    //Imei =await DeviceInformation.deviceIMEINumber;
    print('Imei:....> $Imei');
    print('deviceId:....> $deviceId');
    Token = uuid.v4();
    var response = await post(Uri.parse(urlsaltdata), body: {
      "DeviceID": deviceId,
      "TokenNo": Token,
      //"AppVersion": preferences.getString("Appversion"),
      "AppVersion": '5.5.5.22',
      ///"AppVersion": '5.6.9.22',
    });
    var resBody = json.decode(response.body);
    final apiResponse = PostSaltData.fromJson(resBody);
    saltdata = apiResponse.resposeData;
    var AppVersion = apiResponse.appVersion;
    // var AppVersion = '1';

    bool? Status = apiResponse.status;
    var message = apiResponse.message;
    if(apiResponse.resposeData!= null){
      saltvalue = apiResponse.resposeData![0].saltvalue.toString();
      //saltvalue = apiResponse.resposeData?.length;
      //print('StatusValue:....> $Status');
       print('new saltdata:....> $saltvalue');
      print('Appversion:....> $AppVersion');
      if (AppVersion == 0) {
        if (Status == true) {
          setState(() {
            _loader=true;
          });
        } else {
          setState(() {
            _loader=true;
          });
        }
      } else {
        reLoginDialog();
      }
    }
    return "Success";
  }

  reLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UpdateAppDialoge(),
    );
  }

  void _openMyPage() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile) {
      print("Internet connection is from Mobile data");
      /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DashboardScreen()
      ),
      );*/
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(
              Saltvalue: saltvalue,
              DeviceID: deviceId.toString(),
              TokenNo: Token,
              Imei: deviceId.toString()),
        ),
      );
    }else if(result == ConnectivityResult.wifi) {
      print("internet connection is from wifi");
      /*Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DashboardScreen()
      ),
      );*/
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(
              Saltvalue: saltvalue,
              DeviceID: deviceId.toString(),
              TokenNo: Token,
              Imei: deviceId.toString()),
        ),
      );
    }else if(result == ConnectivityResult.none){
      print("No internet connection");
      showInternetDialoge();
    }
  }

  void getVersionName() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      //  packageName = packageInfo.packageName;
      packageName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Images/splashscreen_new.jpg'),
                  fit: BoxFit.fill, // -> 02
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Image(image: AssetImage('Images/finalSplashScreen.jpg')),
                   Text(
                    'Version :$packageName',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  _loader == false ? Center(child: CircularProgressIndicator(color: ColorConstants.AppColorPrimary,)) :TextButton(
                    onPressed: () async {
                      if(saltvalue.isNotEmpty){
                        var result = await Connectivity().checkConnectivity();
                        if(result == ConnectivityResult.mobile) {
                          _openMyPage();
                        }else if(result == ConnectivityResult.wifi) {
                          _openMyPage();
                        }else if(result == ConnectivityResult.none){
                          print("No internet connection");
                          showInternetDialoge();
                        }
                      }
                    },
                    child: const Text(
                      "आगे बढ़ने के लिए क्लिक करें",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                          context: context, builder: (_) => const ImageDialog());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'Images/trophy.gif',
                          height: 40,
                          width: 40,
                        ),
                        Image.asset(
                          'Images/appaward.png',
                          height: 40,
                          width: 250,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    //margin: const EdgeInsets.only(bottom: 52),
                    color: Colors.red,
                    height: 18,
                    child: Column(children: [
                      Expanded(
                          child: Marquee(
                            child: Text(
                              textfinal,
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      /* FittedBox(
                          child: Image.asset('Images/footerpcts.jpg',
                              fit: BoxFit.cover),
                        ),*/
                    ]),
                  ),
                  Container(
                    child: Image.asset(
                      "Images/footerpcts.jpg",
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomLeft,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    )
      ,onWillPop: () async {
      bool willLeave = false;
      Navigator.pop(
          context, true); // It worked for me instead of above line
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return willLeave;
    },);
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
  }


  showInternetDialoge() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CustomInvaildRequestDialoge(),
    );
  }

  void callSplashAPI()async {
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile) {
      print("Internet connection is from Mobile data");
      _navigateToHome();
      getHelpDeskNo();
      getVersionName();
      getSaltData();
      _openMyPage();
    }else if(result == ConnectivityResult.wifi) {
      print("internet connection is from wifi");
      _navigateToHome();
      getHelpDeskNo();
      getVersionName();
      getSaltData();
      _openMyPage();
    }else if(result == ConnectivityResult.none){
      print("No internet connection");
      showInternetDialoge();
    }

  }


}
