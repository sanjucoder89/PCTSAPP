import 'package:flutter/material.dart';

import 'MyAppColor.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /*final Color backgroundColor;
  final Image img1;
  final Image img2;*/

/*  const CustomAppBar({
    required this.img1,
    required this.img2,
    required this.backgroundColor,
  }) ;*/

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Image.asset("Images/pcts_logo1.png",width: 100,height: 80,),


      actions: <Widget>[
        new GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(
              //builder: (context) => ChangeCountry(),));
            },
            child:Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(right: 10),
              child:Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    child: Image.asset("Images/nationalem.png")//widget.country_img
                ),
                alignment: Alignment.centerRight,

              ),
            )
        ),

      ],
      backgroundColor: ColorConstants.AppColorPrimary,
     // brightness: Brightness.light, // status bar brightness
    );


    /*AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Image.asset("Images/pcts_logo1.png",width: 100,height: 80,),


      actions: <Widget>[
        new GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(
              //builder: (context) => ChangeCountry(),));
            },
            child:Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(right: 10),
              child:Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    child: Image.asset("Images/nationalem.png")//widget.country_img
                ),
                alignment: Alignment.centerRight,

              ),
            )
        ),

      ],
      backgroundColor: Colors.blueAccent, // status bar color
      brightness: Brightness.light, // status bar brightness
    ),*/
  }
}
