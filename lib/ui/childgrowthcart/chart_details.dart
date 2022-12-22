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

import '../pcts/pctsids/model/GetChildWeightDetailData.dart';

String getFormattedDate(String date) {
  if(date != "null"){
    var localDate = DateTime.parse(date).toLocal();
    var inputFormat = DateFormat("yyyy-MM-dd");
    var inputDate = inputFormat.parse(localDate.toString());
    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('yyyy-MM-dd');
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

  var _child_weight_details_url = AppConstants.app_base_url+"WeightDetail";
  SharedPreferences? preferences;
  List child_weight_response = [];
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
    print('inside api methond.....');
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
                yvalue:double.parse(child_weight_response[i]['weight'].toString())
            ),
          );
        }
        print('func.len ${functionalList.length}');
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
        brightness: Brightness.light, // status bar brightness
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
                  Center(child: Text('${widget.Mahilaname}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),)),
                  Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${Strings.sishu_ka_naam} ${widget.childname} ${Strings.shishu_ki_ling} : ${widget.childsex == "1" ? Strings.boy_title_with_bracket : widget.childsex == "2" ? Strings.girl_title_with_bracket : widget.childsex == "3" ? Strings.transgender_with_bracket : widget.childsex == "" ? "" : widget.childsex}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                      SizedBox(
                        width: 10,
                      ),
                      Text('${Strings.janm_tithi} ${getFormattedDate(widget.dob)}',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                    ],
                  )),
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
                                  width: 2,
                                  color: Colors.black,
                                  dataSource: functionalList,
                                  /*dataSource: [
                                    // Bind data source
                                    ResponseChartData(0, 2.5),
                                    ResponseChartData(4, 2.5),
                                    ResponseChartData(6, 2.5),
                                    ResponseChartData(10, 2.5)
                                  ],*/
                                  /*dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      useSeriesColor: true
                                  ),*/
                                  xValueMapper: (CustomFunctionalList data, _) => data.xvalue,
                                  yValueMapper: (CustomFunctionalList data, _) => data.yvalue
                              ),

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


}
class CustomFunctionalList {
  double? xvalue;
  double? yvalue;

  CustomFunctionalList({
    this.xvalue,
    this.yvalue
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