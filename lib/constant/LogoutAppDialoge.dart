import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:pcts/ui/splashnew.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/dashboard/model/GetHelpDeskData.dart';
import '../ui/dashboard/model/LogoutData.dart';
import 'ApiUrl.dart';

class LogoutAppDialoge extends StatelessWidget {
  LogoutAppDialoge(BuildContext _context);

  var _logout_url = AppConstants.app_base_url + "LogoutToken";
  late SharedPreferences preferences;


  Future<String> logoutSession(BuildContext _context) async {
    preferences = await SharedPreferences.getInstance();
    print('UserID:....> ${preferences.getString("UserId")}');
    print('DeviceID:....> ${preferences.getString("deviceId")}');
    var response = await post(Uri.parse(_logout_url), body: {
      "UserID":preferences.getString("UserId"),
      "DeviceID":preferences.getString("deviceId")
    });
    var resBody = json.decode(response.body);
    final apiResponse = LogoutData.fromJson(resBody);
      if (apiResponse.status == true) {
        preferences.setString("isLogin", "false");
        print('isLogin ${preferences.getString("isLogin").toString()}');
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);

        /*Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => SplashNew(),
          ),
              (route) => false,//if you want to disable back feature set to false
        );*/
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SplashNew()),
                (route) => false);*/
        Navigator.pop(_context);
        Navigator.push(
            _context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  SplashNew(),//TabViewScreen ,VideoScreen
            ));

       /* Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => SplashNew()),
                (route) => false);*/
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SplashNew()
            ),
            ModalRoute.withName("/Home")
        );*/
        /*Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SplashNew(),//TabViewScreen ,VideoScreen
              ));*/

          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        //             SplashNew()), (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            margin: EdgeInsets.only(top: 10),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("", style: TextStyle(color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),),
                Container(margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: Text(Strings.logout_msg,
                              style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
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
                          logoutSession(context);
                          //close popup dialoge
                          Navigator.pop(context);
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
                                child: Text(Strings.yes,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
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
                                child: Text(Strings.no,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 14)),
                              ))

                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }}