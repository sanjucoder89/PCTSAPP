import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';

class AboutAppDialoge extends StatelessWidget {
  AboutAppDialoge();

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
                Text("About App", style: TextStyle(color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),),
                Container(margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(Strings.app_launch_date_title,
                            style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),),
                          Expanded(child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(Strings.app_launch_date,
                              style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(Strings.app_release_date_title,
                            style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),),
                          Expanded(child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(Strings.app_release_date,
                              style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(Strings.current_version_title,
                            style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),),
                          Expanded(child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("05/10/2019",
                              style: TextStyle(color: ColorConstants.AppColorPrimary, fontSize: 13,fontWeight: FontWeight.bold),),
                          ),)
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: ColorConstants.AppColorPrimary,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                    /*color: ColorConstants.AppColorPrimary,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                    splashColor: ColorConstants.side_menu_color,
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