import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import '../ui/dashboard/model/GetHelpDeskData.dart';
import '../ui/dashboard/model/LogoutData.dart';
import '../ui/dashboard/model/UpdateLatLngData.dart';
import 'ApiUrl.dart';

class UpdateLatLngDialog extends StatelessWidget {
  UpdateLatLngDialog();

  var _updatelatlng_url = AppConstants.app_base_url + "PutLatitudeLongitude";
  late SharedPreferences preferences;



  Future<String> updateLocation(BuildContext context) async {
    preferences = await SharedPreferences.getInstance();
    print('UnitID:....> ${preferences.getString("UnitID")}');
    print('_latitude:....> ${_latitude}');
    print('_longitude:....> ${_longitude}');
    var response = await put(Uri.parse(_updatelatlng_url), body: {
      //UnitID:250
      // AppLatitude:26.9061183
      // AppLongitude:75.7979983
      // TokenNo:b9248923-17f0-4010-873b-d58a3a6571a2
      // UserID:0101065030203
      "UnitID":preferences.getString("UnitID"),
      "AppLatitude":_latitude,
      "AppLongitude":_longitude,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = UpdateLatLngData.fromJson(resBody);
      if (apiResponse.status == true) {
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
    return "Success";
  }

  var _latitude="0.0";
  var _longitude="0.0";

  Future _getLocation(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Location location = new Location();
    LocationData _pos = await location.getLocation();
    print('curr lat ${_pos.latitude}');
    print('curr lng ${_pos.longitude}');
    if(_pos.latitude != null){
      _latitude=_pos.latitude.toString();
    }
    if(_pos.longitude != null){
      _longitude=_pos.longitude.toString();
    }
    print('live loc lat $_latitude');
    print('live loc lng $_longitude');
    updateLocation(context);
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
                            child: Text(Strings.updatelatlng_msg,
                              style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 12,fontWeight: FontWeight.bold),),
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
                          _getLocation(context);
                          //updateLocation(context);
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