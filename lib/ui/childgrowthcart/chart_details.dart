import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/ApiUrl.dart';
import '../../constant/MyAppColor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../pcts/pctsids/model/GetChildWeightDetailData.dart';

String getFormattedDate(String date) {
  if(date != "null"){
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());
    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }else{
    return "";
  }
}

class ChartDetails extends StatefulWidget {
  ChartDetails({Key? key,
    required this.infantId,
    required this.name,
    required this.childname,
    required this.dob,
    required this.childsex,
    required this.Mahilaname,
  }) : super(key: key);


  final String infantId;
  final String name;
  final String childname;
  final String dob;
  final String childsex;
  final String Mahilaname;

  @override
  State<StatefulWidget> createState() => _ChartDetails();

}

class _ChartDetails extends State<ChartDetails> {

  var _mahilaName="";
  var _child_weight_details_url = AppConstants.app_base_url+"WeightDetail";
  SharedPreferences? preferences;
  List child_weight_response = [];
  double lastValueweight=0.0;//get from last weight from api resonse listing
  int lastAgeValue=36;//fixed last age value
  /*
  * API FOR MAHILA VIVRAN
  * */
  List<CustomFunctionalList> functionalList=[];
  List<ResponseChartData> child_data_list=[];
  Future<String> getChildDetailsAPI() async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('infantId ${widget.infantId}');
    var response = await post(Uri.parse(_child_weight_details_url), body: {
      "InfantID": widget.infantId
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetChildWeightDetailData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        child_weight_response = resBody['ResposeData'];
        print('child.len ${child_weight_response.length}');
        for (int i = 0; i < child_weight_response.length; i++){
          functionalList.add(
            CustomFunctionalList(
              xvalue:double.parse(child_weight_response[i]['age'].toString()),
              yvalue:double.parse(child_weight_response[i]['weight'].toString()),
              sex:child_weight_response[i]['sex'].toString() == "1" ?
              "(लड़का)":child_weight_response[i]['sex'].toString() == "2" ?
              "(लड़की)" : child_weight_response[i]['sex'].toString() == "3" ?
              "(Transgender)" : "",
              sexVal:child_weight_response[i]['sex'].toString(),
              childName:child_weight_response[i]['ChildName'].toString() == "null" ? "" : child_weight_response[i]['ChildName'].toString(),
              birthDate:child_weight_response[i]['Birth_date'].toString()
            ),
          );
        }
        print('func.len ${functionalList.length}');
        _mahilaName=widget.Mahilaname;
        showPopupMsgFunctionality(functionalList);

      } else {
        Fluttertoast.showToast(
            msg:resBody['Message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black);
      }
      EasyLoading.dismiss();
    });
    //print('response:${apiResponse.message}');
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    getChildDetailsAPI();
  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    ftts.stop();
  }
  final List<ChartDataDemo> chartDataed = <ChartDataDemo>[
    ChartDataDemo(0.0, 0),
    ChartDataDemo(2.0, 2),
    ChartDataDemo(3.0, 3),
    ChartDataDemo(4.0, 4),
    ChartDataDemo(5.0, 9),
    ChartDataDemo(6.0, 17),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: ColorConstants.AppColorPrimary,// status bar color
      //  brightness: Brightness.light, // status bar brightness
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              color: ColorConstants.light_yellow_color,
              //height: 50,
              child: Column(
                children: [
                  Center(child: Text('${widget.Mahilaname}',
                    softWrap: false,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),)),
                  Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${Strings.sishu_ka_naam} ${widget.childname} ${Strings.shishu_ki_ling} : ${widget.childsex == "1" ? Strings.boy_title_with_bracket : widget.childsex == "2" ? Strings.girl_title_with_bracket : widget.childsex == "3" ? Strings.transgender_with_bracket : widget.childsex == "" ? "" : widget.childsex}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                      SizedBox(
                        width: 0,
                      ),
                    ],
                  )),
                  Text('${Strings.janm_tithi} ${getFormattedDate(widget.dob)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),)

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              color: ColorConstants.grey_bgcolor,
              //height: 50,
              child: Column(
                children: [
                  Center(child: Text('${Strings.bachai_ka_growth_chart}',textAlign: TextAlign.center,style: TextStyle(color: ColorConstants.redTextColor,fontWeight: FontWeight.bold,fontSize: 13),)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DottedBorder(
                      dashPattern: [6, 6, 6, 6],
                      color: ColorConstants.AppColorPrimary,
                      strokeWidth: 2,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(0),
                      padding: EdgeInsets.all(6),
                  child: Container(
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(child: Text(Strings.samanya,style:TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),)),
                            Expanded(child: Image.asset("Images/img_green.jpg",width: 20,height: 20,))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(Strings.madhyam_kam_vajan,style:TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold))),
                            Expanded(child: Image.asset("Images/img_yellow.png",width: 20,height: 20,))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(Strings.gambhir_kam_vajan,style:TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold))),
                            Expanded(child: Image.asset("Images/img_orange.webp",width: 13,height: 13,))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 400,
              child: Row(
                children:<Widget> [
                  Container(
                    width: 50,
                    color: Colors.white,
                    height: double.infinity,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Center(child: Text(Strings.bachai_ka_bhar_kilogram,style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: 350,
                        height: 400,
                        child: SfCartesianChart(
                            series: <CartesianSeries>[
                              AreaSeries<ChartData, double>(
                                dataSource: [
                                  // Bind data source
                                  ChartData(0 ,3),
                                  ChartData(1,4.5),
                                  ChartData(2,5.5),
                                  ChartData(3,6.4),
                                  ChartData(4,7),
                                  ChartData(5,7.5),
                                  ChartData(6,7.9),
                                  ChartData(6,8.2),
                                  ChartData(8,8.5),
                                  ChartData(9,8.9),
                                  ChartData(10,9.2),
                                  ChartData(11,9.4),
                                  ChartData(12,9.6),
                                  ChartData(13,9.9),
                                  ChartData(14,10.1),
                                  ChartData(15,10.3),
                                  ChartData(16,10.5),
                                  ChartData(17,10.6),
                                  ChartData(18,10.9),
                                  ChartData(19,11.1),
                                  ChartData(20,11.3),
                                  ChartData(21,11.5),
                                  ChartData(22,11.7),
                                  ChartData(23,12),
                                  ChartData(24,12.1),
                                  ChartData(25,12.3),
                                  ChartData(26,12.5),
                                  ChartData(27,12.7),
                                  ChartData(28,12.9),
                                  ChartData(29,13.1),
                                  ChartData(30,13.3),
                                  ChartData(31,13.5),
                                  ChartData(32,13.6),
                                  ChartData(33,13.8),
                                  ChartData(34,14),
                                  ChartData(35,14.1),
                                  ChartData(36,14.2),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                borderWidth: 2,
                                borderColor:  ColorConstants.map_green_border_color,
                                color: ColorConstants.map_green_color,
                              ),
                              AreaSeries<ChartData, double>(
                                dataSource: [
                                  // Bind data source
                                  ChartData(0 ,2.5),
                                  ChartData(1,3.4),
                                  ChartData(2,4.3),
                                  ChartData(3,5),
                                  ChartData(4,5.5),
                                  ChartData(5,6),
                                  ChartData(6,6.4),
                                  ChartData(6,6.6),
                                  ChartData(8,6.9),
                                  ChartData(9,7.1),
                                  ChartData(10,7.4),
                                  ChartData(11,7.5),
                                  ChartData(12,7.7),
                                  ChartData(13,7.9),
                                  ChartData(14,8.1),
                                  ChartData(15,8.3),
                                  ChartData(16,8.5),
                                  ChartData(17,8.6),
                                  ChartData(18,8.8),
                                  ChartData(19,9),
                                  ChartData(20,9.1),
                                  ChartData(21,9.3),
                                  ChartData(22,9.4),
                                  ChartData(23,9.5),
                                  ChartData(24,9.6),
                                  ChartData(25,9.9),
                                  ChartData(26,10),
                                  ChartData(27,10.1),
                                  ChartData(28,10.3),
                                  ChartData(29,10.4),
                                  ChartData(30,10.5),
                                  ChartData(31,10.6),
                                  ChartData(32,10.8),
                                  ChartData(33,10.9),
                                  ChartData(34,11),
                                  ChartData(35,11.2),
                                  ChartData(36,11.3),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                borderWidth: 2,
                                borderColor: Colors.yellow,
                                color: ColorConstants.map_yellow_color,
                              ),
                              AreaSeries<ChartData, double>(
                                dataSource: [
                                  // Bind data source
                                  ChartData(0 ,2.1),
                                  ChartData(1,3),
                                  ChartData(2,3.9),
                                  ChartData(3,4.5),
                                  ChartData(4,4.9),
                                  ChartData(5,5.3),
                                  ChartData(6,5.6),
                                  ChartData(6,5.7),
                                  ChartData(8,6.4),
                                  ChartData(9,6.5),
                                  ChartData(10,6.7),
                                  ChartData(11,6.8),
                                  ChartData(12,7),
                                  ChartData(13,7.1),
                                  ChartData(14,7.2),
                                  ChartData(15,7.4),
                                  ChartData(16,7.5),
                                  ChartData(17,7.6),
                                  ChartData(18,7.8),
                                  ChartData(19,8),
                                  ChartData(20,8.1),
                                  ChartData(21,8.2),
                                  ChartData(22,8.3),
                                  ChartData(23,8.4),
                                  ChartData(24,8.6),
                                  ChartData(25,8.7),
                                  ChartData(26,8.9),
                                  ChartData(27,9),
                                  ChartData(28,9.1),
                                  ChartData(29,9.3),
                                  ChartData(30,9.4),
                                  ChartData(31,9.5),
                                  ChartData(32,9.6),
                                  ChartData(33,9.7),
                                  ChartData(34,9.8),
                                  ChartData(35,9.9),
                                  ChartData(36,10),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                borderWidth: 2,
                                borderColor: ColorConstants.map_orange_border_color,
                                color: ColorConstants.map_orange_color,
                              ),
                              StackedLineSeries<CustomFunctionalList, double>(
                                  markerSettings: MarkerSettings(
                                      height: 30,
                                      width: 30,
                                      // Scatter will render in diamond shape
                                      shape: DataMarkerType.circle,
                                      color: ColorConstants.redTextColor,
                                  ),
                                  width: 2,
                                  color: Colors.black,
                                  dataSource: functionalList,
                                  xValueMapper: (CustomFunctionalList data, _) => data.xvalue,
                                  yValueMapper: (CustomFunctionalList data, _) => data.yvalue
                              ),
                              ScatterSeries<CustomFunctionalList, double>(
                                  dataSource: functionalList,
                                  xValueMapper: (CustomFunctionalList data, _) => data.xvalue,
                                  yValueMapper: (CustomFunctionalList data, _) => data.yvalue,
                                  markerSettings: MarkerSettings(
                                      height: 6,
                                      width: 6,
                                      // Scatter will render in diamond shape
                                      shape: DataMarkerType.circle,
                                      //borderColor: Colors.white,
                                      color: Colors.white

                                  )
                              )
                            ]
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),

    );
  }



  void showPopupMsgFunctionality(List<CustomFunctionalList> functionalList) {
    lastValueweight = functionalList[(functionalList.length - 1)].yvalue!;
    print('lastWeightValue $lastValueweight');
    print('lastAgeValue $lastAgeValue');
    print('sex ${functionalList[0].sexVal.toString()}');

    if(functionalList[0].sexVal.toString() == "1"){
      if(lastAgeValue == 0){
        if (lastValueweight <= 2.1) {
          infant0to6("1");
        } else if (lastValueweight > 2.1 && lastValueweight <= 2.5) {
          infant0to6("2");
        } else if (lastValueweight > 2.5 && lastValueweight <= 3.5) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 1){
        if (lastValueweight <= 3) {
          infant0to6("1");

        } else if (lastValueweight > 3 && lastValueweight <= 3.5) {
          infant0to6("2");
        } else if (lastValueweight > 3.5 && lastValueweight <= 4.5) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 2){
        if (lastValueweight <= 3.9) {
          infant0to6("1");

        } else if (lastValueweight > 3.9 && lastValueweight <= 4.4) {
          infant0to6("2");
        } else if (lastValueweight > 4.4 && lastValueweight <= 5.6) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 3){
        if (lastValueweight <= 4.5) {
          infant0to6("1");

        } else if (lastValueweight > 4.5 && lastValueweight <= 5.5) {
          infant0to6("2");
        } else if (lastValueweight > 5.5 && lastValueweight <= 7) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 4){
        if (lastValueweight <= 5.3) {
          infant0to6("1");
        } else if (lastValueweight > 5.3 && lastValueweight <= 6) {
          infant0to6("2");

        } else if (lastValueweight > 6 && lastValueweight <= 7.5) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 5){
        if (lastValueweight <= 5.3) {
          infant0to6("1");

        } else if (lastValueweight > 5.3 && lastValueweight <= 6) {
          infant0to6("2");
        } else if (lastValueweight > 6 && lastValueweight <= 7.5) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 6){
        if (lastValueweight <= 5.4) {
          infant0to6("1");

        } else if (lastValueweight > 5.4 && lastValueweight <= 6.5) {
          infant0to6("2");
        } else if (lastValueweight > 6.5 && lastValueweight <= 8) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 7){
        if (lastValueweight <= 6) {
          infant7to12("1");
        } else if (lastValueweight > 6 && lastValueweight <= 6.5) {
          infant7to12("2");
        } else if (lastValueweight > 6.5 && lastValueweight <= 8.4) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 8){
        if (lastValueweight <= 6.2) {
          infant7to12("1");

        } else if (lastValueweight > 6.2 && lastValueweight <= 7) {
          infant7to12("2");
        } else if (lastValueweight > 7 && lastValueweight <= 8.5) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 9){
        if (lastValueweight <= 6.5) {
          infant7to12("1");

        } else if (lastValueweight > 6.5 && lastValueweight <= 7.2) {
          infant7to12("2");
        } else if (lastValueweight > 7.2 && lastValueweight <= 8.9) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 10){
        if (lastValueweight <= 6.5) {
          infant7to12("1");

        } else if (lastValueweight > 6.5 && lastValueweight <= 7.4) {
          infant7to12("2");
        } else if (lastValueweight > 7.4 && lastValueweight <= 9.1) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 11){
        if (lastValueweight <= 6.5) {
          infant7to12("1");

        } else if (lastValueweight > 6.5 && lastValueweight <= 7.4) {
          infant7to12("2");
        } else if (lastValueweight > 7.4 && lastValueweight <= 9.1) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 12){
        if (lastValueweight <= 7) {
          infant7to12("1");

        } else if (lastValueweight > 7 && lastValueweight <= 7.6) {
          infant7to12("2");
        } else if (lastValueweight > 7.4 && lastValueweight <= 9.5) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 13){
        if (lastValueweight <= 7.1) {
          infant13to24("1");

        } else if (lastValueweight > 7.1 && lastValueweight <= 7.6) {
          infant13to24("2");
        } else if (lastValueweight > 7.6 && lastValueweight <= 9.5) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 14){
        if (lastValueweight <= 7.2) {
          infant13to24("1");

        } else if (lastValueweight > 7.2 && lastValueweight <= 8.2) {
          infant13to24("2");
        } else if (lastValueweight > 8.2 && lastValueweight <= 10) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 15){
        if (lastValueweight <= 7.5) {
          infant13to24("1");

        } else if (lastValueweight > 7.5 && lastValueweight <= 8.2) {
          infant13to24("2");
        } else if (lastValueweight > 8.2 && lastValueweight <= 10.3) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 16){
        if (lastValueweight <= 7.5) {
          infant13to24("1");

        } else if (lastValueweight > 7.5 && lastValueweight <= 8.5) {
          infant13to24("2");
        } else if (lastValueweight > 8.5 && lastValueweight <= 10.5) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 17){
        if (lastValueweight <= 7.6) {
          infant13to24("1");

        } else if (lastValueweight > 7.6 && lastValueweight <= 8.6) {
          infant13to24("2");
        } else if (lastValueweight > 8.6 && lastValueweight <= 10.6) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 18){
        if (lastValueweight <= 7.8) {
          infant13to24("1");

        } else if (lastValueweight > 7.8 && lastValueweight <=8.7) {
          infant13to24("2");
        } else if (lastValueweight > 8.7 && lastValueweight <= 10.8) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 19){
        if (lastValueweight <= 8) {
          infant13to24("1");

        } else if (lastValueweight > 8 && lastValueweight <=9) {
          infant13to24("2");
        } else if (lastValueweight >9 && lastValueweight <= 11) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 20){
        if (lastValueweight <= 8.1) {
          infant13to24("1");

        } else if (lastValueweight > 8.1 && lastValueweight <=9.1) {
          infant13to24("2");
        } else if (lastValueweight >9.1 && lastValueweight <= 11.2) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 21){
        if (lastValueweight <= 8.3) {
          infant13to24("1");

        } else if (lastValueweight > 8.3 && lastValueweight <=9.3) {
          infant13to24("2");
        } else if (lastValueweight >9.3 && lastValueweight <= 11.5) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 22){
        if (lastValueweight <= 8.3) {
          infant13to24("1");

        } else if (lastValueweight > 8.3 && lastValueweight <=9.4) {
          infant13to24("2");
        } else if (lastValueweight >9.4 && lastValueweight <= 11.8) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 23){
        if (lastValueweight <= 8.4) {
          infant13to24("1");

        } else if (lastValueweight > 8.4 && lastValueweight <=9.5) {
          infant13to24("2");
        } else if (lastValueweight >9.5 && lastValueweight <= 12) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 24){
        if (lastValueweight <= 8.6) {
          infant13to24("1");

        } else if (lastValueweight > 8.6 && lastValueweight <=9.7) {
          infant13to24("2");
        } else if (lastValueweight >9.7 && lastValueweight <= 12.1) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 25){
        if (lastValueweight <= 8.7) {
          infant25to36("1");

        } else if (lastValueweight > 8.7 && lastValueweight <=9.9) {
          infant25to36("2");
        } else if (lastValueweight >9.9 && lastValueweight <= 12.3) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 26){
        if (lastValueweight <= 8.9) {
          infant25to36("1");

        } else if (lastValueweight > 8.9 && lastValueweight <=10) {
          infant25to36("2");
        } else if (lastValueweight >10 && lastValueweight <= 12.5) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 27){
        if (lastValueweight <= 9) {
          infant25to36("1");

        } else if (lastValueweight > 9 && lastValueweight <=10) {
          infant25to36("2");
        } else if (lastValueweight >10 && lastValueweight <= 12.7) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 28){
        if (lastValueweight <= 9.1) {
          infant25to36("1");

        } else if (lastValueweight > 9.1 && lastValueweight <=10.3) {
          infant25to36("2");
        } else if (lastValueweight >10.3 && lastValueweight <= 12.9) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 29){
        if (lastValueweight <= 9.3) {
          infant25to36("1");

        } else if (lastValueweight > 9.3 && lastValueweight <=10.4) {
          infant25to36("2");
        } else if (lastValueweight >10.4 && lastValueweight <= 13.1) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 30){
        if (lastValueweight <= 9.4) {
          infant25to36("1");

        } else if (lastValueweight > 9.4 && lastValueweight <=10.5) {
          infant25to36("2");
        } else if (lastValueweight >10.5 && lastValueweight <= 13.3) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 31){
        if (lastValueweight <= 9.5) {
          infant25to36("1");

        } else if (lastValueweight > 9.5 && lastValueweight <=10.6) {
          infant25to36("2");
        } else if (lastValueweight >10.6 && lastValueweight <= 13.5) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 32){
        if (lastValueweight <= 9.6) {
          infant25to36("1");

        } else if (lastValueweight > 9.6 && lastValueweight <=10.8) {
          infant25to36("2");
        } else if (lastValueweight >10.8 && lastValueweight <= 13.6) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 33){
        if (lastValueweight <= 9.7) {
          infant25to36("1");

        } else if (lastValueweight > 9.7 && lastValueweight <=10.9) {
          infant25to36("2");
        } else if (lastValueweight >10.9 && lastValueweight <= 13.8) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 34){
        if (lastValueweight <= 9.8) {
          infant25to36("1");

        } else if (lastValueweight > 9.8 && lastValueweight <=11) {
          infant25to36("2");
        } else if (lastValueweight >11 && lastValueweight <= 14) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 35){
        if (lastValueweight <= 9.9) {
          infant25to36("1");

        } else if (lastValueweight > 9.9 && lastValueweight <=11.2) {
          infant25to36("2");
        } else if (lastValueweight >11.2 && lastValueweight <= 14.1) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 36){
        if (lastValueweight <= 10) {
          infant25to36("1");
        } else if (lastValueweight > 10 && lastValueweight <=11.3) {
          infant25to36("2");
        } else if (lastValueweight >11.3 && lastValueweight <= 14.2) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }
    }else{
      if(lastAgeValue == 0){
        if (lastValueweight <= 2) {
          infant0to6("1");
        } else if (lastValueweight > 2 && lastValueweight <= 2.5) {
          infant0to6("2");
        } else if (lastValueweight > 2.5 && lastValueweight <= 3.3) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 1){
        if (lastValueweight <= 2.6) {
          infant0to6("1");

        } else if (lastValueweight >2.6 && lastValueweight <= 3.1) {
          infant0to6("2");
        } else if (lastValueweight > 3.1 && lastValueweight <= 4.1) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 2){
        if (lastValueweight <= 3.5) {
          infant0to6("1");

        } else if (lastValueweight > 3.5 && lastValueweight <= 3.9) {
          infant0to6("2");
        } else if (lastValueweight > 3.9 && lastValueweight <= 5) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 3){
        if (lastValueweight <= 4) {
          infant0to6("1");

        } else if (lastValueweight > 4 && lastValueweight <= 4.5) {
          infant0to6("2");
        } else if (lastValueweight > 4.5 && lastValueweight<=5.7) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 4){
        if (lastValueweight <= 4.4) {
          infant0to6("1");

        } else if (lastValueweight >4.4 && lastValueweight <= 5) {
          infant0to6("2");
        } else if (lastValueweight > 5 && lastValueweight <= 6.4) {
          infant0to6("3");

        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 5){
        if (lastValueweight <= 4.8) {
          infant0to6("1");

        } else if (lastValueweight >4.8 && lastValueweight <= 5.4) {
          infant0to6("2");
        } else if (lastValueweight > 5.4 && lastValueweight <= 6.9) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 6){
        if (lastValueweight <= 5) {
          infant0to6("1");

        } else if (lastValueweight > 5 && lastValueweight <= 5.7) {
          infant0to6("2");
        } else if (lastValueweight > 5.7 && lastValueweight <= 7.2) {
          infant0to6("3");
        }
        else {
          infant0to6("4");
        }
      }else if(lastAgeValue == 7){
        if (lastValueweight <= 5.4) {
          infant7to12("1");

        } else if (lastValueweight > 5.4 && lastValueweight <= 6) {
          infant7to12("2");
        } else if (lastValueweight > 6 && lastValueweight <= 7.6) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 8){
        if (lastValueweight <= 5.6) {
          infant7to12("1");

        } else if (lastValueweight > 5.6 && lastValueweight <= 6.3) {
          infant7to12("2");
        } else if (lastValueweight > 6.3 && lastValueweight <= 7.9) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 9){
        if (lastValueweight <= 5.8) {
          infant7to12("1");

        } else if (lastValueweight > 5.8 && lastValueweight <= 6.5) {
          infant7to12("2");
        } else if (lastValueweight >6.5 && lastValueweight <= 8.2) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 10){
        if (lastValueweight <= 6) {
          infant7to12("1");

        } else if (lastValueweight > 6 && lastValueweight <= 6.7) {
          infant7to12("2");
        } else if (lastValueweight > 6.7 && lastValueweight <= 8.5) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 11){
        if (lastValueweight <= 6.2) {
          infant7to12("1");

        } else if (lastValueweight > 6.2 && lastValueweight <= 6.9) {
          infant7to12("2");
        } else if (lastValueweight > 6.9 && lastValueweight <= 8.7) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 12){
        if (lastValueweight <= 6.4) {
          infant7to12("1");

        } else if (lastValueweight > 6.4 && lastValueweight <= 7) {
          infant7to12("2");
        } else if (lastValueweight > 7 && lastValueweight <= 9) {
          infant7to12("3");
        }
        else {
          infant7to12("4");
        }
      }else if(lastAgeValue == 13){
        if (lastValueweight <= 6.5) {
          infant13to24("1");

        } else if (lastValueweight > 6.5 && lastValueweight <= 7.2) {
          infant13to24("2");
        } else if (lastValueweight > 7.2 && lastValueweight <= 9.1) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 14){
        if (lastValueweight <= 6.6) {
          infant13to24("1");

        } else if (lastValueweight > 6.6 && lastValueweight <= 7.4) {
          infant13to24("2");
        } else if (lastValueweight >7.4 && lastValueweight <= 9.4) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 15){
        if (lastValueweight <= 6.8) {
          infant13to24("1");

        } else if (lastValueweight > 6.8 && lastValueweight <= 7.6) {
          infant13to24("2");
        } else if (lastValueweight >7.6 && lastValueweight <= 9.6) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 16){
        if (lastValueweight <= 6.9) {
          infant13to24("1");

        } else if (lastValueweight > 6.9 && lastValueweight <= 7.7) {
          infant13to24("2");
        } else if (lastValueweight > 7.7 && lastValueweight <= 9.8) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 17){
        if (lastValueweight <= 7.1) {
          infant13to24("1");

        } else if (lastValueweight > 7.1 && lastValueweight <= 7.9) {
          infant13to24("2");
        } else if (lastValueweight > 7.9 && lastValueweight <= 10) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 18){
        if (lastValueweight <= 7.3) {
          infant13to24("1");

        } else if (lastValueweight > 7.3 && lastValueweight <=8.1) {
          infant13to24("2");
        } else if (lastValueweight > 8.1 && lastValueweight <= 10.1) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 19){
        if (lastValueweight <= 7.4) {
          infant13to24("1");

        } else if (lastValueweight > 7.4 && lastValueweight <=8.2) {
          infant13to24("2");
        } else if (lastValueweight >8.2 && lastValueweight <= 10.4) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 20){
        if (lastValueweight <= 7.5) {
          infant13to24("1");

        } else if (lastValueweight > 7.5 && lastValueweight <=8.4) {
          infant13to24("2");
        } else if (lastValueweight >8.4 && lastValueweight <= 10.6) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 21){
        if (lastValueweight <= 7.7) {
          infant13to24("1");

        } else if (lastValueweight > 7.7 && lastValueweight <=8.6) {
          infant13to24("2");
        } else if (lastValueweight >8.6 && lastValueweight <= 10.9) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 22){
        if (lastValueweight <= 7.8) {
          infant13to24("1");

        } else if (lastValueweight > 7.8 && lastValueweight <=8.8) {
          infant13to24("2");
        } else if (lastValueweight >8.8 && lastValueweight <= 11.1) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 23){
        if (lastValueweight <= 8) {
          infant13to24("1");

        } else if (lastValueweight > 8 && lastValueweight <=8.9) {
          infant13to24("2");
        } else if (lastValueweight >8.9 && lastValueweight <= 11.3) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 24){
        if (lastValueweight <= 8.1) {
          infant13to24("1");

        } else if (lastValueweight > 8.1 && lastValueweight <=9) {
          infant13to24("2");
        } else if (lastValueweight >9 && lastValueweight <= 11.5) {
          infant13to24("3");
        }
        else {
          infant13to24("4");
        }
      }else if(lastAgeValue == 25){
        if (lastValueweight <= 8.2) {
          infant25to36("1");

        } else if (lastValueweight > 8.2 && lastValueweight <=9.2) {
          infant25to36("2");
        } else if (lastValueweight >9.2 && lastValueweight <= 11.7) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 26){
        if (lastValueweight <= 8.4) {
          infant25to36("1");

        } else if (lastValueweight > 8.4 && lastValueweight <=9.4) {
          infant25to36("2");
        } else if (lastValueweight >9.4 && lastValueweight <=11.9) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 27){
        if (lastValueweight <= 8.5) {
          infant25to36("1");

        } else if (lastValueweight > 8.5 && lastValueweight <=9.5) {
          infant25to36("2");
        } else if (lastValueweight >9.5 && lastValueweight <= 12.1) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 28){
        if (lastValueweight <= 8.6) {
          infant25to36("1");

        } else if (lastValueweight > 8.6 && lastValueweight <=9.6) {
          infant25to36("2");
        } else if (lastValueweight >9.6 && lastValueweight <= 12.4) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 29){
        if (lastValueweight <= 8.8) {
          infant25to36("1");

        } else if (lastValueweight > 8.8 && lastValueweight <=9.8) {
          infant25to36("2");
        } else if (lastValueweight >9.8 && lastValueweight <= 12.5) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 30){
        if (lastValueweight <= 8.9) {
          infant25to36("1");

        } else if (lastValueweight > 8.9 && lastValueweight <=10) {
          infant25to36("2");
        } else if (lastValueweight >10 && lastValueweight <= 12.7) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 31){
        if (lastValueweight <= 9) {
          infant25to36("1");

        } else if (lastValueweight > 9 && lastValueweight <=10.1) {
          infant25to36("2");
        } else if (lastValueweight >10.1 && lastValueweight <= 13) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 32){
        if (lastValueweight <= 9.1) {
          infant25to36("1");

        } else if (lastValueweight > 9.1 && lastValueweight <=10.3) {
          infant25to36("2");
        } else if (lastValueweight >10.3 && lastValueweight <= 13.1) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 33){
        if (lastValueweight <= 9.3) {
          infant25to36("1");

        } else if (lastValueweight > 9.3 && lastValueweight <=10.4) {
          infant25to36("2");
        } else if (lastValueweight >10.4 && lastValueweight <= 13.4) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 34){
        if (lastValueweight <= 9.4) {
          infant25to36("1");

        } else if (lastValueweight > 9.4 && lastValueweight <=10.6) {
          infant25to36("2");
        } else if (lastValueweight >10.6 && lastValueweight <= 13.5) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 35){
        if (lastValueweight <= 9.5) {
          infant25to36("1");

        } else if (lastValueweight > 9.5 && lastValueweight <=10.7) {
          infant25to36("2");
        } else if (lastValueweight >10.7 && lastValueweight <= 13.7) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }else if(lastAgeValue == 36){
        if (lastValueweight <= 9.6) {
          infant25to36("1");

        } else if (lastValueweight > 9.6 && lastValueweight <=10.8) {
          infant25to36("2");
        } else if (lastValueweight >10.8 && lastValueweight <= 13.9) {
          infant25to36("3");
        }
        else {
          infant25to36("4");
        }
      }
    }
  }

  void infant25to36(String flag) {
    if (flag == "1") {
      String msg = _mahilaName + " जी,आपके शिशु के स्वास्थ्य में कोई सुधार नहीं हुआ है। शिशु का वजन उम्र के अनुसार नहीं बढ़ रहा है, शिशु अति कुपोषित\n" +
          "है। शिशु को घरेलू संभाल के साथ चिकित्सकीय उपचार की आवश्यकता है।\n" +
          "शिशु की उम्र 2 वर्ष से अधिक है –\n" +
          "\uF0B7 घर में जो बना हो वह खिलाएं\n" +
          "\uF0B7 ज्याद मिर्च मसाला न हो\n" +
          "\uF0B7 दिन में 5 बार कुछ खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 2 साल से बड़े बच्चे को एक गोली देनी है।\n" +
          "\uF0B7 शिशु की एमयूएसी टेप से जांच करें, 115 एमएम से कम होने पर शिशु को आंगनवाड़ी केन्द्र पर रेफर करें\n" +
          "एवं पैरों में सूजन की जांच करें। शिशु के पैरों में सूजन की जांच करें, लक्षण नजर आने पर तुरन्त शिशु को MTC में रेफर करें।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
      textSpeech(msg);
    } else if (flag == "2") {
      String msg = _mahilaName + " जी,आपके शिशु के स्वास्थ्य में पूर्व की तुलना में बहुत सुधार हुआ है लेकिन अभी भी शिशु पूरी तरह से ठीक नहीं है। शिशु\n" +
          "अभी भी कुपोषण की श्रेणी में है। शिशु का विशेष ध्यान रखना जारी रखें।\n" +
          "शिशु की उम्र 2 वर्ष से अधिक है –\n" +
          "\uF0B7 घर में जो बना हो वह खिलाएं\n" +
          "\uF0B7 ज्याद मिर्च मसाला न हो\n" +
          "\uF0B7 दिन में 5 बार कुछ खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 2 साल से बड़े बच्चे को एक गोली देनी है।\n" +
          "\uF0B7 शिशु की एमयूएसी टेप से जांच करें, 115 एमएम से कम होने पर शिशु को आंगनवाड़ी केन्द्र पर रेफर करें\n" +
          "एवं पैरों में सूजन की जांच करें। शिशु के पैरों में सूजन की जांच करें, लक्षण नजर आने पर तुरन्त शिशु को MTC में रेफर करें।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
      textSpeech(msg);
    } else if (flag == "3") {
      String msg = _mahilaName+ " जी,आपके शिशु का वजन उम्र के अनुसार सही है। शिशु के स्वास्थ्य में पूर्व की तुलना में बहुत सुधार हुआ है। शिशु का\n" +
          "विशेष ध्यान रखना जारी रखें।\n" +
          " शिशु की उम्र 2 वर्ष से अधिक है –\n" +
          "\uF0B7 घर में जो बना हो वह खिलाएं\n" +
          "\uF0B7 ज्याद मिर्च मसाला न हो\n" +
          "\uF0B7 दिन में 5 बार कुछ खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 2 साल से बड़े बच्चे को एक गोली देनी है।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
      textSpeech(msg);
    } else if (flag == "4") {
      String msg = _mahilaName +
          " जी,आपके शिशु का वजन उम्र के अनुसार सही है। शिशु के स्वास्थ्य में पूर्व की तुलना में बहुत सुधार हुआ है। शिशु का\n" +
          "विशेष ध्यान रखना जारी रखें।\n" +
          "शिशु की उम्र एक वर्ष से 2 वर्ष के बीच है –\n" +
          "\uF0B7 जितनी बार भी बच्चा चाहे स्तनपान कराएँ\n" +
          "\uF0B7 हर बार निम्न में से 1½ कटोरी भोज्य पदार्थ खिलाएं\n" +
          "\uF0B7 रोटी / चावल / बिस्किट आदि मीठे दूध में मिला कर\n" +
          "\uF0B7 रोटी / चावल / खिचड़ी दाल में मिला कर साथ ओइल डालते हुए खिलायें\n" +
          "\uF0B7 सेवैयाँ / हलुआ / खीर अथवा दूध से बना भोजन\n" +
          "\uF0B7 उबले / तले हुए आलू व सब्जियां (कम मिर्च मसाले के साथ) केला / बिस्किट / फल\n" +
          "\uF0B7 दिन में 5 बार उक्त वस्तुओं में से कुछ अवश्य खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 1 से 2 साल के बच्चे को आधी गोली देनी है।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
      textSpeech(msg);
    }
  }

  void infant13to24(String flag) {
    if (flag == "1") {
      String msg = _mahilaName + " जी,आपके शिशु के स्वास्थ्य में कोई सुधार नहीं हुआ है। शिशु का वजन उम्र के अनुसार नहीं बढ़ रहा है, शिशु अति कुपोषित\n" +
          "है। शिशु को घरेलू संभाल के साथ चिकित्सकीय उपचार की आवश्यकता है।\n" +
          "शिशु की उम्र एक वर्ष से 2 वर्ष के बीच है –\n" +
          "\uF0B7 जितनी बार भी बच्चा चाहे स्तनपान कराएँ\n" +
          "\uF0B7 हर बार निम्न में से 1½ कटोरी भोज्य पदार्थ खिलाएं\n" +
          "\uF0B7 रोटी / चावल / बिस्किट आदि मीठे दूध में मिला कर\n" +
          "\uF0B7 रोटी / चावल / खिचड़ी दाल में मिला कर साथ ओइल डालते हुए खिलायें\n" +
          "\uF0B7 सेवैयाँ / हलुआ / खीर अथवा दूध से बना भोजन\n" +
          "\uF0B7 उबले / तले हुए आलू व सब्जियां (कम मिर्च मसाले के साथ) केला / बिस्किट / फल\n" +
          "\uF0B7 दिन में 5 बार उक्त वस्तुओं में से कुछ अवश्य खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 1 से 2 साल के बच्चे को आधी गोली देनी है।\n" +
          "\uF0B7 शिशु की एमयूएसी टेप से जांच करें, 115 एमएम से कम होने पर शिशु को आंगनवाड़ी केन्द्र पर रेफर करें\n" +
          "एवं पैरों में सूजन की जांच करें। शिशु के पैरों में सूजन की जांच करें, लक्षण नजर आने पर तुरन्त शिशु को MTC में रेफर करें।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);

    } else if (flag == "2") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार ठीक तरह से नहीं बढ़ रहा है। शिशु कुपोषण की श्रेणी में चल रहा है। शिशु का\n" +
          "विशेष ध्यान रखने की आवश्यकता है।\n" +
          "शिशु की उम्र एक वर्ष से 2 वर्ष के बीच है –\n" +
          "\uF0B7 जितनी बार भी बच्चा चाहे स्तनपान कराएँ\n" +
          "\uF0B7 हर बार निम्न में से 1½ कटोरी भोज्य पदार्थ खिलाएं\n" +
          "\uF0B7 रोटी / चावल / बिस्किट आदि मीठे दूध में मिला कर\n" +
          "\uF0B7 रोटी / चावल / खिचड़ी दाल में मिला कर साथ ओइल डालते हुए खिलायें\n" +
          "\uF0B7 सेवैयाँ / हलुआ / खीर अथवा दूध से बना भोजन\n" +
          "\uF0B7 उबले / तले हुए आलू व सब्जियां (कम मिर्च मसाले के साथ) केला / बिस्किट / फल\n" +
          "\uF0B7 दिन में 5 बार उक्त वस्तुओं में से कुछ अवश्य खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 1 से 2 साल के बच्चे को आधी गोली देनी है।\n" +
          "\uF0B7 शिशु की एमयूएसी टेप से जांच करें, 115 एमएम से कम होने पर शिशु को आंगनवाड़ी केन्द्र पर रेफर\n" +
          "करें एवं पैरों में सूजन की जांच करें। शिशु के पैरों में सूजन की जांच करें, लक्षण नजर आने पर तुरन्त शिशु को MTC में रेफर करें।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    } else if (flag == "3") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार सही है।\n" +
          "शिशु की उम्र एक वर्ष से 2 वर्ष के बीच है –\n" +
          "\uF0B7 जितनी बार भी बच्चा चाहे स्तनपान कराएँ\n" +
          "\uF0B7 हर बार निम्न में से 1½ कटोरी भोज्य पदार्थ खिलाएं\n" +
          "\uF0B7 रोटी / चावल / बिस्किट आदि मीठे दूध में मिला कर\n" +
          "\uF0B7 रोटी / चावल / खिचड़ी दाल में मिला कर साथ ओइल डालते हुए खिलायें\n" +
          "\uF0B7 सेवैयाँ / हलुआ / खीर अथवा दूध से बना भोजन\n" +
          "\uF0B7 उबले / तले हुए आलू व सब्जियां (कम मिर्च मसाले के साथ) केला / बिस्किट / फल\n" +
          "\uF0B7 दिन में 5 बार उक्त वस्तुओं में से कुछ अवश्य खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 1 से 2 साल के बच्चे को आधी गोली देनी है।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);

    } else if (flag == "4") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार सही है। शिशु के स्वास्थ्य में पूर्व की तुलना में बहुत सुधार हुआ है। शिशु का\n" +
          "विशेष ध्यान रखना जारी रखें।\n" +
          "\uF0FC शिशु की उम्र एक वर्ष से 2 वर्ष के बीच है –\n" +
          "\uF0B7 जितनी बार भी बच्चा चाहे स्तनपान कराएँ\n" +
          "\uF0B7 हर बार निम्न में से 1½ कटोरी भोज्य पदार्थ खिलाएं\n" +
          "\uF0B7 रोटी / चावल / बिस्किट आदि मीठे दूध में मिला कर\n" +
          "\uF0B7 रोटी / चावल / खिचड़ी दाल में मिला कर साथ ओइल डालते हुए खिलायें\n" +
          "\uF0B7 सेवैयाँ / हलुआ / खीर अथवा दूध से बना भोजन\n" +
          "\uF0B7 उबले / तले हुए आलू व सब्जियां (कम मिर्च मसाले के साथ) केला / बिस्किट / फल\n" +
          "\uF0B7 दिन में 5 बार उक्त वस्तुओं में से कुछ अवश्य खिलाएं\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 साल में 2 बार कृमिनाशक दवा एल्बेण्डाजोल 1 से 2 साल के बच्चे को आधी गोली देनी है।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    }
  }

  void infant7to12(String flag) {
    if (flag == "1") {
      String msg = _mahilaName + " जी,आपके शिशु के स्वास्थ्य में कोई सुधार नहीं हुआ है। शिशु का वजन उम्र के अनुसार नहीं बढ़ रहा है,शिशु अति कुपोषित है। शिशु को घरेलू संभाल के साथ चिकित्सकीय उपचार की आवश्यकता है।\n" +
          "शिशु की उम्र 6 माह से एक वर्ष के बीच है –\n" +
          "\uF0B7 थोड़ी थोड़ी मात्रा मे मुलायम, मसले हुए अनाज, दाल, सब्जियाँ और फल खिलाना जारी रखें।\n" +
          "\uF0B7 धीरे धीरे उसकी आहार की मात्रा, बारम्बारता, विविधता एवम गाड़ापन बढ़ाये।\n" +
          "\uF0B7 बच्चे को रोज 4 से 5 बार आहार दे एवम स्तनपान जारी रखें।\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।\n" +
          "\uF0B7 शिशु की एमयूएसी टेप से जांच करें, 115 एमएम से कम होने पर शिशु को आंगनवाड़ी केन्द्र पर रेफर करें एवं पैरों में सूजन की जांच करें। शिशु के पैरों में सूजन की जांच करें,\n" +
          "लक्षण नजर आने पर तुरन्त शिशु को MTC में रेफर करें।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    } else if (flag == "2") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार ठीक तरह से नहीं बढ़ रहा है। शिशु कुपोषण की श्रेणी में जा रहा है।\n" +
          "शिशु की उम्र 6 माह से एक वर्ष के बीच है –\n" +
          "\uF0B7 थोड़ी थोड़ी मात्रा मे मुलायम, मसले हुए अनाज, दाल, सब्जियाँ और फल खिलाना जारी रखें।\n" +
          "\uF0B7 धीरे धीरे उसकी आहार की मात्रा, बारम्बारता, विविधता एवम गाड़ापन बढ़ाये।\n" +
          "\uF0B7 बच्चे को रोज 4 से 5 बार आहार दे एवम स्तनपान जारी रखें।\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    } else if (flag == "3") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार सही रूप से बढ़ना प्रारम्भ हो गया है। शिशु का विशेष ध्यान रखें।\n" +
          "शिशु की उम्र 6 माह से एक वर्ष के बीच है –\n" +
          "\uF0B7 थोड़ी थोड़ी मात्रा मे मुलायम, मसले हुए अनाज, दाल, सब्जियाँ और फल खिलाना जारी रखें।\n" +
          "\uF0B7 धीरे धीरे उसकी आहार की मात्रा, बारम्बारता, विविधता एवम गाड़ापन बढ़ाये।\n" +
          "\uF0B7 बच्चे को रोज 4 से 5 बार आहार दे एवम स्तनपान जारी रखें।\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);

    } else if (flag == "4") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार सही है। शिशु के स्वास्थ्य में पूर्व की तुलना में बहुत सुधार हुआ है। शिशु का विशेष ध्यान रखना जारी रखें।\n" +
          "शिशु की उम्र 6 माह से एक वर्ष के बीच है –\n" +
          "\uF0B7 थोड़ी थोड़ी मात्रा मे मुलायम, मसले हुए अनाज, दाल, सब्जियाँ और फल खिलाना जारी रखें।\n" +
          "\uF0B7 धीरे धीरे उसकी आहार की मात्रा, बारम्बारता, विविधता एवम गाड़ापन बढ़ाये।\n" +
          "\uF0B7 बच्चे को रोज 4 से 5 बार आहार दे एवम स्तनपान जारी रखें।\n" +
          "\uF0B7 शिशु को आंगनवाड़ी पर ले जाएँ एवं 100 दिन तक सप्ताह में 2 बार, 1 मिली आइएफए सीरप पिलाये।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    }
  }

  void infant0to6(String flag) {
    if (flag == "1") {
      String msg = _mahilaName + " जी,आपके शिशु के स्वास्थ्य में कोई सुधार नहीं हुआ है। शिशु का वजन उम्र के अनुसार नहीं बढ़ रहा है, शिशु अति कुपोषित है। शिशु को घरेलू संभाल के साथ चिकित्सकीय उपचार की आवश्यकता है।\n" +
          "\uF0FC 6 माह से छोटे शिशु को स्तनपान कराना जारी रखें, दूसरा कुछ (पानी भी) नहीं दें, शिशु को प्रत्येक 2 घंटे में स्तनपान कराएँ।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);

    } else if (flag == "2") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार ठीक तरह से नहीं बढ़ रहा है। शिशु कुपोषण की श्रेणी में जा रहा है।  6 माह से छोटे शिशु को स्तनपान कराना जारी रखें, दूसरा कुछ (पानी भी) नहीं दें, 24 घंटे में कम से कम 8 से 10 बार स्तनपान कराएँ।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    } else if (flag == "3") {
      String msg = _mahilaName + " जी, आपके शिशु का वजन उम्र के अनुसार सही रूप से बढ़ना प्रारम्भ हो गया है। शिशु का विशेष ध्यान रखें।\n" +
          "6 माह से छोटे शिशु को स्तनपान कराना जारी रखें, दूसरा कुछ (पानी भी) नहीं दें,\n" +
          "24 घंटे में कम से कम 8 से 10 बार स्तनपान कराएँ।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    } else if (flag == "4") {
      String msg = _mahilaName + " जी,आपके शिशु का वजन उम्र के अनुसार सही है।\n" +
          "\uF0FC 6 माह से छोटे शिशु को स्तनपान कराना जारी रखें, दूसरा कुछ (पानी भी) नहीं दें, 24 घंटे में कम से कम 8 से 10 बार स्तनपान कराएँ।";
      _showSuccessPopup(msg,ColorConstants.AppColorPrimary);
    }

  }

  FlutterTts ftts = FlutterTts();
  Future<void> textSpeech(String msg) async {
    //your custom configuration
    //await ftts.setLanguage("en-US");
    await ftts.setLanguage("hi");
    await ftts.setSpeechRate(0.5); //speed of speech
    await ftts.setVolume(2.0); //volume of speech
    await ftts.setPitch(1); //pitc of sound

    //play text to speech
    var result = await ftts.speak(msg);
    if(result == 1){
      //speaking

    }else{
      //not speaking
    }
  }
  Future<void> _showSuccessPopup(String msg,Color _color) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          // title: Text('Message',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: ColorConstants.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      msg,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _color,
                          fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          //Navigator.pop(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: ColorConstants.AppColorPrimary,
                              ),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text('OK',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontSize: 14)),
                                  ))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}



class CustomFunctionalList {
  double? xvalue;
  double? yvalue;
  String? sex;
  String? sexVal;
  String? childName;
  String? birthDate;

  CustomFunctionalList({
    this.xvalue,
    this.yvalue,
    this.sex,
    this.sexVal,
    this.childName,
    this.birthDate
  });
}

class ResponseChartData {
  ResponseChartData(this.xvalue, this.yvalue);
  final double? xvalue;
  final double? yvalue;
}
class ChartData {
  ChartData(this.x, this.y);
  final double? x;
  final double? y;
}

class ChartDataDemo {
  ChartDataDemo(this.x, this.y);
  final double x;
  final double? y;
}