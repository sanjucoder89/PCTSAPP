import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/ApiUrl.dart';
import 'video_view_screen.dart';
import 'model/VideoUrlListData.dart';

void main(){
  runApp(TabThreeScreen());
}

class TabThreeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TabThreeScreen();


}

class _TabThreeScreen extends State<TabThreeScreen> {

  ScrollController? _controller;
  var _video_list = AppConstants.app_base_url+"VideoUrl";
  late SharedPreferences preferences;
  List response_list = [];
  /*
  * API FOR VIDEO LISTING
  * */
  Future<String> getVideoTab1List() async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_video_list), body: {
      "VideoType": "3"
    });
    var resBody = json.decode(response.body);
    final apiResponse = VideoUrlListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        //districtId=resBody['ResponseData'][0]['Code'].toString();
        print('response_list.len ${response_list.length}');
      } else {
        //reLoginDialog();
      }

    });
    //dismiss loader
    //await EasyLoading.dismiss();
    print('response:${apiResponse.message}');
    return "Success";
  }

  int getResLength() {
    if(response_list.isNotEmpty){
      return response_list.length;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getVideoTab1List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            controller: _controller,
            itemCount: getResLength(),
            itemBuilder: _videoItemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true)
    );
  }
  Widget _videoItemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoViewScreen(video_path: AppConstants.birth_certification_url+response_list[index]['VideoName']),//VideoPlayerScreen  SamplePlayer, VideoPlayerApp
            ),
          );
        },
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: FadeInImage.assetNetwork(
                    placeholder: "Images/nationalem.png",
                    image: AppConstants.birth_certification_url+response_list[index]['ImageName']),
              ),
              /*Container(
                height: 100,
                width: 100,
                child: Center(
                    child: Text(
                      '${response_list == null ? "" : response_list[index]['ImageName']}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )),
              ),*/
              Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${response_list == null ? "" : response_list[index]['Descrption']}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }


}