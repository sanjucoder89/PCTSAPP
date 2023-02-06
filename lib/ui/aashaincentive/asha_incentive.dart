import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/ApiUrl.dart';
import '../../constant/LocaleString.dart';
import '../../constant/MyAppColor.dart';
import '../hbyc/hbyc_expand_details.dart';
import '../prasav/before/model/GetVillageListData.dart';
import 'model/IncentiveListData.dart';
import 'model/IncentiveMonthListData.dart';

class AshaIncentive extends StatefulWidget {
  const AshaIncentive({Key? key}) : super(key: key);

  @override
  State<AshaIncentive> createState() => _AshaIncentiveState();
}

class _AshaIncentiveState extends State<AshaIncentive> {

  var _get_incentive_mnthyr_list = AppConstants.app_base_url+"GetAshaSoftMthyr";
  var _get_incentive_list = AppConstants.app_base_url+"USPaAshaIncentives";
  late SharedPreferences preferences;
  List response_list = [];
  List mnthyr_list = [];
  late String mnthyrId="0";
  late String mnthyr_name="";
  ScrollController scrollController = ScrollController();


  bool expand = false;
  int? tapped;


  /*
  * API FOR Incentive Month/Year LISTING
  * */
  Future<String> getIncentiveMntYrAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('${preferences.getString("ANMAutoID").toString()}');
    var response = await get(Uri.parse(_get_incentive_mnthyr_list));
    var resBody = json.decode(response.body);
    final apiResponse = IncentiveMonthListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        // yearlist = apiResponse.resposeData!;
        mnthyr_list = resBody['ResposeData'];
        mnthyrId = apiResponse.resposeData![0].monthValue.toString();
        mnthyr_name = apiResponse.resposeData![0].monthName.toString();
        print('mnthyr_list.len ${mnthyr_list.length}');
        print('mnthyrId ${mnthyrId}');
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      getIncentiveListData(mnthyrId);
    });

    return "Success";
  }
  var isParentExpand=false;
  Future<String> getIncentiveListData(String _mnthyr) async {
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_get_incentive_list), body: {
      // ASHAAutoid:85821
      //"MthYr": "202202",
      "MthYr": _mnthyr,
      "ASHAAutoid": preferences.getString('ANMAutoID')
    });
    var resBody = json.decode(response.body);
    final apiResponse = IncentiveListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        print('response_list.len ${response_list.length}');
        last_pos=response_list.length-1;
      } else {
        response_list.clear();
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
    EasyLoading.dismiss();
    return "Success";
  }


  String number="=+911234567890";

  //String newNumber=number;


  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  String _mobNumberMasking(String number) {
    var newNumber = number;
    for(int i=6; i<number.length;i++){
      newNumber = replaceCharAt(newNumber, i, "*") ;
      //print("PHONE_NUMBER_LOOP:$newNumber");
    }
    //print("FinalNumber:$newNumber");
    return newNumber;
  }


  int getLength() {
    if(response_list.isNotEmpty){
      return response_list.length;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    getIncentiveMntYrAPI();
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
        title: Text('प्रोत्साहन राशि ',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: ColorConstants.prsav_header_color,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(Strings.month_year,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                        ),
                      ),
                    ),
                    Expanded(child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(3),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstants.spinner_bg_color,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12,left: 5),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              // border: Border.all(color: Colors.black)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('Images/ic_down.png',
                                    height: 12,
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                                iconSize: 15,
                                elevation: 11,
                                style: TextStyle(color: Colors.black),
                                isExpanded: true,
                                //hint: new Text("Select District"),
                                items: mnthyr_list.map((item) {
                                  return DropdownMenuItem(
                                      child: MediaQuery.removePadding(context: context, child: Container(
                                        height: 25,
                                        child: Column(
                                          children: [
                                            Text(
                                              item['MonthName'],    //Names that the api dropdown contains
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            ),
                                            //Divider(color: ColorConstants.AppColorPrimary,height: 0.3,)
                                          ],
                                        ),
                                      )),
                                      value: item['MonthValue'].toString()       //Id that has to be passed that the dropdown has.....
                                  );
                                }).toList(),
                                onChanged: (String? newVal) {
                                  setState((){
                                    mnthyrId = newVal!;
                                    print('mnthyrId:$mnthyrId');
                                    for(int i=0 ;i<mnthyr_list.length; i++) {
                                      if(mnthyrId == mnthyr_list[i]['MonthValue'].toString()){
                                        mnthyr_name= mnthyr_list[i]['MonthName'].toString();
                                        break;
                                      }
                                    }
                                    getIncentiveListData(mnthyrId);
                                  });
                                },
                                value: mnthyrId,                 //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: DottedBorder(
                  color: ColorConstants.AppColorPrimary,
                  strokeWidth: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.aasha_ka_naam,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${response_list.length == 0 ? "-" : response_list[0]['Ashaname'].toString()}',
                                style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.bank_ka_naam,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${response_list.length == 0 ? "-" : response_list[0]['Bank_Name'].toString()}',
                                style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.account_num,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${response_list.length == 0 ? "-" : response_list[0]['Accountno'].toString().length > 0 ? _mobNumberMasking(response_list[0]['Accountno'].toString()) : ""}',
                                style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.month,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${mnthyr_name == "" ? "-" : mnthyr_name}',
                                style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.payment_date,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('${response_list.length == 0 ? "-" : response_list[0]['PaymentDate'].toString() == "null" ? Strings.in_process : response_list[0]['PaymentDate'].toString() == "" ? Strings.in_process :  response_list[0]['PaymentDate'].toString()}',
                                style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.normal),),
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      Strings.total_pai_amt,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:ColorConstants.AppColorPrimary,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )),
                            Expanded(child: Container(
                              color: ColorConstants.grey,
                              child: Row(
                                children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('${response_list.length == 0 ? "-" : response_list[0]['TotalAmount'].toString()} ₹',
                                      style: TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.bold),),
                                  )),
                                  GestureDetector(
                                    onTap: (){
                                      print('before $isParentExpand');
                                      setState(() {
                                        if(isParentExpand){
                                          isParentExpand=false;
                                        }else{
                                          isParentExpand=true;
                                        }
                                        print('after $isParentExpand');
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      child: isParentExpand ?
                                      Image.asset(
                                        "Images/minus_sign.png", width: 20, height: 20,)
                                          :
                                      Image.asset(
                                        "Images/plus_button.png", width: 20, height: 20,),
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              isParentExpand == true ?
              Container(
                color: ColorConstants.prsav_header_color,
                height: 40,
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(Strings.krmank,textAlign:TextAlign.center,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1.5,
                      color: ColorConstants.app_yellow_color,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(Strings.seva_ka_naam,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1.5,
                      color: ColorConstants.app_yellow_color,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(Strings.gift_amount,style: TextStyle(color: ColorConstants.white,fontSize: 14),),
                        ),
                      ),
                    ),

                  ],
                ),
              )
                  :
              Container(),
              isParentExpand == true ?
              _myListView()
                  :
              Container()

            ],
          ),
        ),
      ),

    );
  }
  var last_pos=0;
  Widget _myListView(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: scrollController,
            itemCount: getLength(),
            //itemBuilder: _itemBuilder,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  //debugPrint('List item $index tapped $expand');
                  setState(() {
                    /// XOR operand returns when either or both conditions are true
                    /// `tapped == null` on initial app start, [tapped] is null
                    /// `index == tapped` initiate action only on tapped item
                    /// `!expand` should check previous expand action
                    expand = ((tapped == null) || ((index == tapped) || !expand)) ? !expand : expand;
                    /// This tracks which index was tapped
                    tapped = index;
                   // debugPrint('current expand state: $expand');
                  });
                },
                /// We set ExpandableListView to be a Widget
                /// for Home StatefulWidget to be able to manage
                /// ExpandableListView expand/retract actions
                child:expandableListView(
                  index,
                  index == tapped ? expand: false,
                ),
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true
        )
    );
  }

  Widget expandableListView(int list_index,bool isExpanded) {
    //debugPrint('List item build $list_index $isExpanded');
    //print('dfdfdff_pos ${list_index}');
    //print('dfdfdff ${response_list[list_index]['Activitylist']}');
    return Card(
      elevation: 5,
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 1.0),
        child: Column(
          children: <Widget>[
            Container(
              color: (list_index % 2 == 0) ? ColorConstants.white :ColorConstants.grey,
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 45,
                    child: Text(
                      '${list_index+1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(child:  Row(
                    children:<Widget> [
                      Text(
                        '${response_list[list_index]['ServiceHindi'].toString()}',
                        style: TextStyle(
                            color:Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )),
                  Expanded(child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget> [
                        Text(
                          '${response_list[list_index]['Amount'].toString()}',
                          style: TextStyle(
                              color:ColorConstants.AppColorPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    /// XOR operand returns when either or both conditions are true
                                    /// `tapped == null` on initial app start, [tapped] is null
                                    /// `index == tapped` initiate action only on tapped item
                                    /// `!expand` should check previous expand action
                                    expand = ((tapped == null) || ((list_index == tapped) || !expand)) ? !expand : expand;
                                    /// This tracks which index was tapped
                                    tapped = list_index;
                                    // debugPrint('current expand state: $expand');
                                  });

                                  expandableListView(
                                    list_index,
                                    list_index == tapped ? expand: false,
                                  );
                                },
                                child: Align(//visible: last_pos == list_index ? true : false,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    width: 20,
                                    height: 20,
                                    color: Colors.transparent,
                                    child:  isExpanded ?
                                    Image.asset(
                                      "Images/minus_sign.png", width: 20, height: 20,)
                                        :
                                    Image.asset(
                                      "Images/plus_button.png", width: 20, height: 20,),
                                  ),
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            ExpandableContainer(
                expanded: isExpanded,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int child_pos) {
                    return Container(
                      margin:EdgeInsets.only(left: 5,right: 5,top: 0,bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget> [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 45,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '${list_index+1}.${child_pos + 1}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color:Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 1.5,
                                color: ColorConstants.app_yellow_color,
                              ),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${response_list[list_index]['Activitylist'][child_pos]['ServiceHindi'].toString()}',
                                  style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                              )),
                              const VerticalDivider(
                                thickness: 1.5,
                                color: ColorConstants.app_yellow_color,
                              ),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${response_list[list_index]['Activitylist'][child_pos]['Amount'].toString()}',
                                  style: TextStyle(fontSize: 13,color:Colors.black,fontWeight: FontWeight.normal),),
                              ))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: response_list[list_index]['Activitylist'].length,
                  shrinkWrap: true,
                ))
          ],
        ),
      ),
    );
  }


}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 120.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        //decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}