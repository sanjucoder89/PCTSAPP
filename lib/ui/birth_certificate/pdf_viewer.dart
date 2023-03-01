import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import 'model/GenerateBirthCertificateData.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({Key? key, required this.infantId}) : super(key: key);
  final String infantId;

  @override
  State<StatefulWidget> createState() => _PDFViewer();
}

class _PDFViewer extends State<PDFViewer> {
  var _birth_certificate_url = AppConstants.app_base_url + "birthcertificates";
  late SharedPreferences preferences;
  var pdf_url="";
  /*
  * API FOR Village  LISTING
  * */
  Future<String> generateBirthCertificateAPI() async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    //print('previous infantid ${widget.infantId}');
    var response = await post(Uri.parse(_birth_certificate_url), body: {
      /*"infantid": "8731872",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')*/
      //test pdf generate working
      "infantid":widget.infantId,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GenerateBirthCertificateData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        //pdf_url=AppConstants.birth_certification_url+apiResponse.resposeData!.url.toString();
        pdf_url="https://docs.google.com/viewer?url="+AppConstants.birth_certification_url+apiResponse.resposeData!.url.toString();
        //https://docs.google.com/viewer?url=https://yourdomain.com/yourpdffile.pdf
        print('certi-url ${pdf_url}');
      } else {
        //reLoginDialog();
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    //dismiss loader
    await EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    generateBirthCertificateAPI();
  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
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
          title: Text('',style: TextStyle(color: Colors.white, fontSize: 18)),
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
          backgroundColor: ColorConstants.AppColorPrimary,// status bar color
          brightness: Brightness.light, // status bar brightness
        ),
        body: Container(//http://10.130.16.143/PCTSApp/BirthCertificates/13941592.pdf
            child: const PDF().fromUrl(
              pdf_url == "" ? "" : pdf_url,
              placeholder: (double progress) => Center(child: Text('$progress %')),
              errorWidget: (dynamic error) => Center(child: Text(error.toString())),
            )

          /*PDF().cachedFromUrl(
              pdf_url == "" ? "" : pdf_url,
              maxAgeCacheObject:Duration(days: 30), //duration of cache
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            )*/
        )
    );
  }


}
class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF From Url'),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}