import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class UpdateAppDialoge extends StatelessWidget {
  UpdateAppDialoge();
  static const APP_STORE_URL = 'https://apps.apple.com/us/app/appname/idAPP-ID';
  static const PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.pcts.pcts.nic';
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
                Text("Alert", style: TextStyle(color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Text("There is a newer version of app available please update it now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: Size(100, 40), //////// HERE
                    ),
                    child: Text("Update"),
                    onPressed: () {
                      Navigator.pop(context);
                      if(Platform.isAndroid == true){
                        _launchURL(PLAY_STORE_URL);
                      }else if(Platform.isIOS ==  true){
                        _launchURL(APP_STORE_URL);
                      }
                    },
                    /*color: Colors.black,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                    splashColor: Colors.cyan,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),*/
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

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}