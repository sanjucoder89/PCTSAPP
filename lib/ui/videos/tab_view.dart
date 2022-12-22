import 'package:flutter/material.dart';
import 'package:pcts/constant/LocaleString.dart';
import 'package:pcts/ui/videos/tab1_view.dart';
import 'package:pcts/ui/videos/tab2_view.dart';
import 'package:pcts/ui/videos/tab3_view.dart';
import '../../constant/MyAppColor.dart';

void main(){
  runApp(TabViewScreen());
}

class TabViewScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _TabViewScreen();
  
  
}

class _TabViewScreen extends State<TabViewScreen> with SingleTickerProviderStateMixin{

  // List of Tabs
  final List<Tab> myTabs = <Tab>[
    Tab(text: Strings.anc_title),
    Tab(text: Strings.hbnc_title),
    Tab(text: Strings.tikakarn_title),
  ];


  // controller object
  late TabController _tabController;




  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: Text('वीडियो',style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: ColorConstants.AppColorPrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
          labelColor: ColorConstants.white,
          unselectedLabelColor: Colors.black,
          indicatorColor: ColorConstants.AppColorPrimary,
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TabOneScreen(),
          TabTwoScreen(),
          TabThreeScreen(),
        ],
      ),
    );
  }
}