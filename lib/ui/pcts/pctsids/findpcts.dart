import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ripple/flutter_ripple.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'findpcts_details.dart';
import 'model/DistrictListData.dart';
import 'model/FindPCTSIDListData.dart';
import 'model/GetUnitNameByUnitIdData.dart';
import 'model/UnitNameListData.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


void main(){
  runApp(FindPCTSIDScreen());
}

class FindPCTSIDScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FindPCTSIDScreen();

}

class _FindPCTSIDScreen extends State<FindPCTSIDScreen> {
  //API URL
  var _district_list_url = AppConstants.app_base_url+"postDistdata";
  var _unitname_list_url = AppConstants.app_base_url+"PostUnitName";
  var _findPCTSIDD_list_url = AppConstants.app_base_url+"PostOtherUnitDetails";
  var _postunitnamebyunitcode_url = AppConstants.app_base_url+"PostUnitNamebyunitcode";

  late SharedPreferences preferences;
  List response_list = [];
  List district_list = [];
  List unitname_list = [];//list with API Response
  List<Continent> _unitNameListResp=[];// List with Custom Response
  late String districtId="";
  var _postUnitCode="";
  var _totalFindCode=0;
  ScrollController? _controller;
  TextEditingController fieldTextEditingController = TextEditingController();
  TextEditingController _enterUnitCode = TextEditingController();
  TextEditingController _enterWifeName = TextEditingController();
  TextEditingController _enterHusbandName = TextEditingController();
  TextEditingController _enterAge1 = TextEditingController();
  TextEditingController _enterAge2 = TextEditingController();
  TextEditingController _enterMobileNumber = TextEditingController();

  int getResLength() {
    if(response_list.isNotEmpty){
      return response_list.length;
    }else{
      return 0;
    }
  }

  int getDistrictLength() {
    if (district_list.isNotEmpty) {
      return district_list.length;
    } else {
      return 0;
    }
  }
  /*
  * API FOR DISTRICT LISTING
  * */
  Future<String> getDistrictListAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_district_list_url), body: {
      "refunittype": "3",
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = DistrictListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        district_list = resBody['ResposeData'];
        districtId=resBody['ResposeData'][0]['unitcode'].toString();
        //print('d.len ${district_list.length}');
       // _enterUnitCode.text=district_list[0]['unitcode'].toString();
        //getUnitNameListAPI(_enterUnitCode.text.toString().substring(0, 4));
        getUnitNameListAPI(districtId.toString().substring(0, 4));
      } else {
        //reLoginDialog();
      }
      EasyLoading.dismiss();
    });
     //print('response:${apiResponse.message}');
    return "Success";
  }

  Future<String> getUnitNamebyUnitCodeAPI() async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    var response = await post(Uri.parse(_postunitnamebyunitcode_url), body: {
      //unitcode:01010900702
      // TokenNo:f526a608-8f10-47bc-b599-ccbcd09a79eb
      // UserID:0101065030203
      "unitcode": _enterUnitCode.text.toString().trim(),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetUnitNameByUnitIdData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        fieldTextEditingController.text=apiResponse.resposeData!.unitName.toString().trim();

      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
      EasyLoading.dismiss();
    });
     print('response:${apiResponse.message}');
    return "Success";
  }
  /*
  * API FOR UNIT NAME LISTING
  * */
  Future<String> getUnitNameListAPI(String distCode) async {
    preferences = await SharedPreferences.getInstance();
    print('distCode ${distCode}');
    var response = await post(Uri.parse(_unitname_list_url), body: {
      "unitcode": distCode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = UnitNameListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        unitname_list = resBody['ResposeData'];
        //districtId=resBody['ResponseData'][0]['Code'].toString();
        _unitNameListResp.clear();
        for (int i = 0; i < unitname_list.length; i++){
          _unitNameListResp.add(
            Continent(
                uname: unitname_list[i]['uname'].toString(),
                UnitType: unitname_list[i]['UnitType'],
                UnitCode: unitname_list[i]['UnitCode'].toString()
            ),
          );
        }
        print('unmefinal.len ${_unitNameListResp.length}');
      } else {
        _unitNameListResp.clear();
        //reLoginDialog();
      }
    });
    return "Success";
  }
  /*
  * API FOR FIND PCTS ID'S LISTING
  * */
  Future<String> getPCTSIDListAPI(String unitCode) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('unitcode ${unitCode}');
    print('wifename ${_enterWifeName.text.toString().trim()}');
    print('husbname ${_enterHusbandName.text.toString().trim()}');
    print('mobile ${_enterMobileNumber.text.toString().trim()}');
    print('age1  ${_enterAge1.text.toString().trim()}');
    print('age2  ${_enterAge2.text.toString().trim()}');
    var response = await post(Uri.parse(_findPCTSIDD_list_url), body: {
      //unitcode:01015200000
      // Name:
      // HusbName:
      // Mobile:
      // AgeFrom:
      // AgeTo:
      // TokenNo:33ab9249-75a4-4c2c-b2cf-385750b97577
      // UserID:0101065030203
      "unitcode": unitCode,
      "Name": _enterWifeName.text.toString().trim(),
      "HusbName":_enterHusbandName.text.toString().trim(),
      "Mobile": _enterMobileNumber.text.toString().trim(),
      "AgeFrom": _enterAge1.text.toString().trim(),
      "AgeTo": _enterAge2.text.toString().trim(),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = FindPCTSIDListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        response_list = resBody['ResposeData'];
        //districtId=resBody['ResponseData'][0]['Code'].toString();
        print('response_list.len ${response_list.length}');
        if(response_list.length > 0){
          _totalFindCode=response_list.length;
        }
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
    getDistrictListAPI();
  }


  @override
  Future<void> dispose() async {
    await EasyLoading.dismiss();
    print('EasyLoading dismiss');
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
          title: Text('पीसीटीएस आईडी ढूँढे',style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: ColorConstants.AppColorPrimary,
        ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children:<Widget> [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.appNewBrowne,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                width: double.infinity,
                //olor: Colors.red,
                height: 30,
                child: Center(child: Text('केस को ढूंढ़ने के लिए कृपया निम्लिखित डाले',style: TextStyle(fontSize: 12,color: Colors.white),)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child:Text('नोट :-कृपया आवश्यक इकाई प्राप्त करने के लिए यूनिट कोड या यूनिट\nनाम के पहले 3 अक्षर दर्ज करें |',textAlign:TextAlign.left,style: TextStyle(fontSize: 12,color: ColorConstants.redTextColor),),
              )
            ),
            Container(
            decoration: BoxDecoration(
                color: Colors.white,
                ///border: Border.all(color: Colors.black)
            ),
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(3),
            height: 30,
            child: Row(
              children: [
                Container(
                  width: 100,
                  child: Text('जिला',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                ),
                Expanded(child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)
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
                      hint: new Text("Select District"),
                      items: district_list.map((item) {
                        return DropdownMenuItem(
                            child: Row(
                              children: [
                                new Flexible(child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    item['unitNameHindi'],    //Names that the api dropdown contains
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                )),
                              ],
                            ),
                            value: item['unitcode'].toString()       //Id that has to be passed that the dropdown has.....
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState((){
                          districtId = newVal!;
                          print('unitcode:$districtId');
                         // _enterUnitCode.text=districtId.toString();
                          if(_enterUnitCode.text.toString().isNotEmpty){
                            getUnitNameListAPI(_enterUnitCode.text.toString().substring(0,4));
                          }
                        });
                      },
                      value: districtId,                 //pasing the default id that has to be viewed... //i havnt used something ... //you can place some (id)
                    ),
                  ),
                ))

              ],
            ),
          ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('यूनिट का कोड',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                        ),
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 36,
                          child: TextField(
                            controller: _enterUnitCode,
                            maxLines: 1,
                            style: TextStyle(fontSize: 13,color: Colors.black),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(0))),
                              fillColor:Colors.white,
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              /*suffixIcon: IconButton(
                                padding: EdgeInsets.only(bottom: 3.0),
                                onPressed: (){
                                  getUnitNamebyUnitCodeAPI();
                                },
                                icon: Icon(Icons.clear,color: Colors.black,),
                              )*/
                            ),
                            onChanged: (value) {
                              print('value $value');
                              setState(() {
                                for (int i = 0; i < _unitNameListResp.length; i++){
                                  if(value.toString().length == 11){
                                    if(_unitNameListResp[i].UnitCode.toString() == value.toString()){
                                      print(' yes founded! UnitCode ${_unitNameListResp[i].UnitCode.toString()}');
                                      print(' yes founded! uname ${_unitNameListResp[i].uname.toString()}');
                                      fieldTextEditingController.text=_unitNameListResp[i].uname.toString();
                                      //print(' yes founded! B  ${value.toString()}');
                                    }
                                  }
                                }
                              });
                            }
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('यूनिट का नाम\n(संस्था जहां महिला पंजीकृत हुई)',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                        ),
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Autocomplete<Continent>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
                                return const Iterable<Continent>.empty();
                              }
                              return _unitNameListResp.where((Continent option) {
                                return option.uname.contains(textEditingValue.text);
                              });
                            },
                            onSelected: (Continent selection) {
                              //print('You just selected ${selection.UnitCode.toString()}');
                              debugPrint('You just selected $selection');
                              setState(() {
                                _postUnitCode=selection.UnitCode.toString();
                                _enterUnitCode.text=_postUnitCode;
                              });
                            },
                            displayStringForOption: (Continent option) => option.uname+" "+option.UnitCode,
                            fieldViewBuilder: (
                                BuildContext context,
                                TextEditingController fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted
                                ) {
                              return TextField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left:5),
                                  hintText: 'Enter a unit code',
                                  //suffixIconConstraints: BoxConstraints(maxHeight: 10),
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.only(bottom: 3.0),
                                    onPressed: fieldTextEditingController.clear,
                                    icon: Icon(Icons.clear,color: Colors.black,),
                                  ),
                                ),
                                style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.black),
                              );
                            },
                          )
                          /*Autocomplete<Continent>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              return _unitNameListResp
                                  .where((Continent continent) => continent.uname.toLowerCase()
                                  .startsWith(textEditingValue.text.toLowerCase()))
                                  .toList();
                            },
                            displayStringForOption: (Continent option) => option.uname,
                            fieldViewBuilder: (
                                BuildContext context,
                                TextEditingController fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted
                                ) {
                              return TextField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left:5),
                                  hintText: 'Enter a unit code',
                                  //suffixIconConstraints: BoxConstraints(maxHeight: 10),
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.only(bottom: 3.0),
                                    onPressed: fieldTextEditingController.clear,
                                    icon: Icon(Icons.clear,color: Colors.black,),
                                  ),
                                ),
                                style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.black),
                              );
                            },
                            onSelected: (Continent selection) {
                              print('Selected-uname: ${selection.uname}');
                              print('Selected-UnitCode: ${selection.UnitCode}');
                              _enterUnitCode.text=selection.UnitCode;
                              print('UnitCode ${_enterUnitCode.text.toString()}');
                              //_findPCTSCode=selection.UnitCode;
                            },
                            optionsViewBuilder: (
                                BuildContext context,
                                AutocompleteOnSelected<Continent> onSelected,
                                Iterable<Continent> options
                                ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  child: Container(
                                    width: 300,
                                    color: Colors.white,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(8.0),
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final Continent option = options.elementAt(index);

                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option.uname, style: const TextStyle(color: Colors.black,fontSize: 13)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          )*/,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('महिला का नाम',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                        ),
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 36,
                          child: TextField(
                            controller:  _enterWifeName,
                            maxLines: 1,
                            style: TextStyle(fontSize: 13),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(0))),
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                            ),
                          ),
                        )
                      ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('पति का नाम',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                        ),
                        height: 30,
                          child: Container(
                            padding: EdgeInsets.only(left: 5),
                            height: 36,
                            child: TextField(
                              controller:  _enterHusbandName,
                              maxLines: 1,
                              style: TextStyle(fontSize: 13),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(0))),
                                fillColor:Colors.white,
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                              ),
                            ),
                          )
                      ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('${Strings.age}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        height: 30,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  color: Colors.transparent,
                                ),
                                width: 50,
                                padding: EdgeInsets.only(left: 5),
                                height: 36,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  controller:  _enterAge1,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 13),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(Radius.circular(0))),
                                    fillColor:Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: '',
                                    counterText: ''
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('To'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  color: Colors.transparent,
                                ),
                                width: 50,
                                padding: EdgeInsets.only(left: 5),
                                height: 36,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 2,
                                  controller:  _enterAge2,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 13),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(Radius.circular(0))),
                                    fillColor:Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: '',
                                    counterText: ''
                                  ),
                                ),
                              ),
                            ],
                          )
                      ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children:<Widget> [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text('मोबाइल नं. दर्ज करें',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 12),),
                      ),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                        ),
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 36,
                          child: TextField(
                            maxLength: 10,
                            keyboardType:TextInputType.number,
                            controller:  _enterMobileNumber,
                            maxLines: 1,
                            style: TextStyle(fontSize: 13),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(0))),
                              fillColor: ColorConstants.white,
                              contentPadding: EdgeInsets.only(left: 5),
                              hintText: '',
                              counterText: "",
                            ),
                          ),
                        )
                      ))
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
              print('_unitcode id: ${_enterUnitCode.text.toString().trim()}');
              if(_postUnitCode != "0"){
                postRequest(_postUnitCode);
              }else{
                postRequest(_enterUnitCode.text.toString().trim());
              }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    decoration: new BoxDecoration(
                      color: ColorConstants.buttonColor,
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
                    //color: ColorConstants.buttonColor,
                    width: 150,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('ढूँढने के लिए क्लिक करें',style: TextStyle(color: Colors.white,fontSize: 13),)),
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              height: 40,
              width: double.infinity,
              color: ColorConstants.buttonColor,
              //alignment: Alignment.centerLeft,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  )),Expanded(child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                            'महिला का विवरण',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  )),
                  Expanded(child: Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            '${_totalFindCode == 0 ? "" : "(${_totalFindCode})"}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ))
                ],

              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              color: ColorConstants.listbgColor,
              child: _myListView()
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView(){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            controller: _controller,
            itemCount: getResLength(),
            itemBuilder: _itemBuilder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true
        )
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild!.unfocus();
          }
          Navigator.push(context,MaterialPageRoute(builder: (context) => FindPCTSDetails(pctsID: response_list[index]['pctsid'].toString(), ))
          ).then((value) { setState(() {
           /// EasyLoading.show(status: 'loading...');
            ///getFeedbackListAPI();
          });});
        },
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                bottom: BorderSide(width: 2.0, color: ColorConstants.dark_yellow_color),
              ),
             // color: ColorConstants.CardBoxColor,
              color: (index % 2 == 0) ? ColorConstants.CardBoxColor :ColorConstants.listbgColor,
            ),
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
                              'पीसीटीएस आईडी',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('${response_list == null ? "" : response_list[index]['pctsid'].toString()}',
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),),
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
                              'नाम (आयु)',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('${response_list == null ? "" : response_list[index]['name'].toString()}',
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),),
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
                              'पति का नाम',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('${response_list == null ? "" : response_list[index]['Husbname'].toString()}',
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),),
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
                              'मोबाइल नं. दर्ज करें',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('${response_list == null ? "" : response_list[index]['mobileno'].toString() == "null" ? "" : response_list[index]['mobileno'].toString()}',
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),),
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
                              'गाँव/वार्ड ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('${response_list == null ? "" : response_list[index]['VillageName'].toString()}',
                        style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal),),
                    ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  height: 40,
                  width: double.infinity,
                  color: ColorConstants.transparent,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                                'उक्त पीसीटीएस आईडी के विवरण हेतु क्लिक करें',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.textBlueColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                      )),
                      Container(
                        width: 80,
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [
                            FlutterRipple(
                              radius: 15,
                              child: Image.asset('Images/cursor_click.png'),
                              rippleColor: ColorConstants.dark_yellow_color,
                              onTap: () {
                                print("hello");
                              },
                            ),
                            /*Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset('Images/cursor_click.png'),
                              ),
                            )*/
                          ],
                        ),
                      )
                    ],

                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void postRequest(String _unitcode) {
    if(_unitcode.isEmpty){
      _showErrorPopup("यूनिट कोड दर्ज करें ",ColorConstants.AppColorPrimary);
    }else if(_unitcode.length < 11){
      _showErrorPopup("यूनिट कोड के कम से कम 11 अंक दर्ज करें|",ColorConstants.AppColorPrimary);
    }else if(_enterHusbandName.text.toString().isEmpty && _enterWifeName.text.toString().isEmpty && _enterAge1.text.toString().isEmpty && _enterAge2.text.toString().isEmpty && _enterMobileNumber.text.toString().isEmpty){
      _showErrorPopup("केस ढूँढने के लिए कृपया एक और फील्ड में डाटा भरें",ColorConstants.AppColorPrimary);
    }else if(_enterWifeName.text.toString().length > 0 && _enterWifeName.text.toString().length < 3){
      _showErrorPopup("महिला के नाम में कम से कम 3 अक्षर भरें",ColorConstants.AppColorPrimary);
    }else if(_enterHusbandName.text.toString().length > 0 && _enterHusbandName.text.toString().length < 3){
      _showErrorPopup("पति के नाम में कम से कम 3 अक्षर भरें",ColorConstants.AppColorPrimary);
    }else{
      FocusScope.of(context).requestFocus(FocusNode());
      getPCTSIDListAPI(_unitcode);
    }

  }

  Future<void> _showErrorPopup(String msg,Color _color) async {
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
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

class Continent {
  const Continent({
    required this.uname,
    required this.UnitType,
    required this.UnitCode,
  });

  final String uname;
  final int UnitType;
  final String UnitCode;

  @override
  String toString() {
    return '$uname ($UnitType) $UnitCode';
  }
}