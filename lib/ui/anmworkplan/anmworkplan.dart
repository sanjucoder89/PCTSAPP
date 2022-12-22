import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/MyAppColor.dart';

void main() {
  runApp(AnmWorkPlan());
}

class AnmWorkPlan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnmWorkPlan();
}

class _AnmWorkPlan extends State<AnmWorkPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late String monthid;
  late String id = "0";

  List<MonthList> month_list = [
    MonthList(
      index: "0",
      month: "चुनें",
    ),
    MonthList(
      index: "1",
      month: "जनवरी",
    ),
    MonthList(
      index: "2",
      month: "फरवरी",
    ),
   /* MonthList(
      index: 3,
      month: "मार्च",
    ),
    MonthList(
      index: 4,
      month: "अप्रैल",
    ), MonthList(
      index: 5,
      month: "मई",
    ), MonthList(
      index: 6,
      month: "जून",
    ), MonthList(
      index: 7,
      month: "जुलाई",
    ), MonthList(
      index: 8,
      month: "अगस्त",
    ), MonthList(
      index: 9,
      month: "सितम्बर",
    ), MonthList(
      index: 10,
      month: "अक्टूबर",
    ), MonthList(
      index: 11,
      month: "नवम्बर",
    ), MonthList(
      index: 12,
      month: "दिसम्बर",
    ),*/
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 29),
              color: ColorConstants.AppColorDark,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: new Image.asset(
                                'Images/backarrow.png',
                                height: 25.0,
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 3),
                      child: new Image.asset(
                        'Images/more.png',
                        width: 20,
                        height: 25.0,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Container(
              color: ColorConstants.appNewBrowne,
              height: 40,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(left: 3, top: 3),
                                  child: Text(
                                    "एएनएम :",
                                    style: TextStyle(
                                        color: ColorConstants.app_yellow_color,
                                        fontSize: 15),
                                  ),
                                ),
                              ))),
                      Expanded(
                          child: Container(
                        child: Text("gfuhgdhfgxdgsfdghg",
                            style: TextStyle(
                              color: ColorConstants.app_yellow_color,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 3, right: 3),
                          child: Text("संस्था :",
                              style: TextStyle(
                                  color: ColorConstants.app_yellow_color,
                                  fontSize: 15)),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        child: Text("gfuhgdhfg",
                            style: TextStyle(
                              color: ColorConstants.app_yellow_color,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            Container(

                decoration: BoxDecoration(
                  color: Colors.white,

                  ///border: Border.all(color: Colors.black)
                ),
                padding: EdgeInsets.all(1),
                margin: EdgeInsets.all(3),
                height: 30,
               child: Container(
                 height: 30,
                 child: Row(
                   children: [
                     Expanded(child: Container(child: Row(
                       children: [
                         Container(
                           width: 50,
                           child: Text('माह',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                         ),
                         Container(
                           color: Colors.grey,
                           height: 30,
                           child: DropdownButtonHideUnderline(
                             child: DropdownButton(
                               iconSize: 15,
                               elevation: 11,
                               style: TextStyle(color: Colors.black),
                               isExpanded: true,

                               icon: Padding(
                                 padding: const EdgeInsets.only(right: 10),
                                 child: Image.asset('Images/ic_down.png',
                                   height: 12,
                                   alignment: Alignment.centerRight,
                                 ),
                               ),
                               items: month_list.map((item) {
                                 return DropdownMenuItem(
                                     child: Row(
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(2.0),
                                           child: Text(
                                             item.month,
                                             //Names that the api dropdown contains
                                             style: TextStyle(
                                               color: Colors.black,
                                                 fontSize: 12.0,
                                                 fontWeight: FontWeight.bold),
                                           ),
                                         ),


                                       ],
                                     ),
                                     value: item.index//Id that has to be passed that the dropdown has.....
                                 );
                               }).toList(),
                               onChanged: (String? newVal) {
                                 setState(() {
                                   id = newVal!;
                                   print('monthid:$id');
                                 });
                               },
                             ),
                           ),
                         )
                       ],
                     ),)) ,
                    /* Expanded(child: Container(child: Row(
                       children: [
                         Container(
                           width: 100,
                           child: Text('वर्ष',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                         ),
                         DropdownButtonHideUnderline(
                           child: DropdownButton(
                             items: month_list.map((item) {
                               return DropdownMenuItem(
                                   child: Row(
                                     children: [
                                       new Flexible(
                                           child: Padding(
                                             padding: const EdgeInsets.all(2.0),
                                             child: Text(
                                               item.month,
                                               //Names that the api dropdown contains
                                               style: TextStyle(
                                                   fontSize: 12.0,
                                                   fontWeight: FontWeight.bold),
                                             ),
                                           )),
                                     ],
                                   ),
                                   value: item.index
                                       .toString() //Id that has to be passed that the dropdown has.....
                               );
                             }).toList(),
                             onChanged: (String? newVal) {
                               setState(() {
                                 monthid = newVal!;
                                 print('monthid:$monthid');
                               });
                             },
                           ),
                         )
                       ],
                     ),))*/
                   ],
                 ),
               ),
               ),
               /* child: Row(
                  children: [

                    Container(
                      width: 100,
                      child: Text('माह',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: month_list.map((item) {
                          return DropdownMenuItem(
                              child: Row(
                                children: [
                                  new Flexible(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      item['unitNameHindi'],
                                      //Names that the api dropdown contains
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ],
                              ),
                              value: item['unitcode']
                                  .toString() //Id that has to be passed that the dropdown has.....
                              );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            monthid = newVal!;
                            print('monthid:$monthid');
                          });
                        },
                      ),
                    ),


                  ],
                ))*/
          ],
        ),
      ),
    );
  }


}
class MonthList {
  String month;
  String  index;
  MonthList({required this.month, required this.index});
}
