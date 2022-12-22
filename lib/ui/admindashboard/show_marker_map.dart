import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:pcts/constant/ApiUrl.dart';
import 'package:pcts/constant/MyAppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'model/GetMarkerListData.dart';

class MarketCentrePoints extends StatefulWidget {
  const MarketCentrePoints({Key? key}) : super(key: key);

  @override
  State<MarketCentrePoints> createState() => _MarketCentrePointsState();
}

class _MarketCentrePointsState extends State<MarketCentrePoints> {
  late SharedPreferences preferences;
  var _marker_points_url = AppConstants.app_base_url + "PostLatitudeLongitudeUnit";
  List marker_response_listing = [];
  String latitude = "26.4571",longitude = "74.6372";
  String title="";
  late final List<LatLng> _latLen;
  var count=0;
  Future<String> getMarkerPointsAPI() async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitType ${preferences.getString("UnitType")}');
    print('LoginUnitCode ${preferences.getString("UnitCode")}');
    print('TokenNo ${preferences.getString("Token")}');
    print('UserID ${preferences.getString("UserId")}');
    var response = await post(Uri.parse(_marker_points_url), body: {
      //LoginUnitCode:00000000000
      // LoginUnitType:1
      // TokenNo:d99dc77f-7c78-4b2b-ba73-e520b23b4c73
      // UserID:sa
      "LoginUnitType": preferences.getString("UnitType"),
      "LoginUnitCode": preferences.getString("UnitCode"),
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetMarkerListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        marker_response_listing = resBody['ResposeData'];
        if(resBody['ResposeData'].length > 0){
          latitude = resBody['ResposeData'][0]['Latitude'].toString();
          longitude = resBody['ResposeData'][0]['Longitude'].toString();
          title = resBody['ResposeData'][0]['unitname'].toString();
          if(MarkerListData != null)MarkerListData.clear();
          for (int i = 0; i < marker_response_listing.length; i++) {
            MarkerListData.add(MarkerData(marker_response_listing[i]['unitcode'].toString(),
                marker_response_listing[i]['unitname'].toString(),
                marker_response_listing[i]['unittype'].toString(),
                marker_response_listing[i]['Latitude'].toString() == "null" ? "0.0" : marker_response_listing[i]['Latitude'].toString().isEmpty ? "0.0": marker_response_listing[i]['Latitude'].toString(),
                marker_response_listing[i]['Longitude'].toString() == "null" ? "0.0" : marker_response_listing[i]['Longitude'].toString().isEmpty ? "0.0" : marker_response_listing[i]['Longitude'].toString(),
                marker_response_listing[i]['UnitDescription'].toString() == "null" ? "" : marker_response_listing[i]['UnitDescription'].toString(),
                'Images/blue_marker.png'
            ));
          }
          print('newlen.Lat ${MarkerListData[0].Latitude}');
          print('newlen.Long ${MarkerListData[0].Longitude}');
          print('newlen.size ${MarkerListData.length}');
          _loading=true;
          // initialize loadData method
          loadData();

        }
      } else {
        _loading=true;
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

    });
    return "Success";
  }

  Future<String> getMarkerPointsAPI2(String _unitcode,String _unittype,) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preferences = await SharedPreferences.getInstance();
    print('LoginUnitType ${_unitcode}');
    print('LoginUnitCode ${_unittype}');
    print('TokenNo ${preferences.getString("Token")}');
    print('UserID ${preferences.getString("UserId")}');
    var response = await post(Uri.parse(_marker_points_url), body: {
      "LoginUnitType": _unittype,
      "LoginUnitCode": _unitcode,
      "TokenNo": preferences.getString('Token'),
      "UserID": preferences.getString('UserId')
    });
    var resBody = json.decode(response.body);
    final apiResponse = GetMarkerListData.fromJson(resBody);
    setState(() {
      if (apiResponse.status == true) {
        marker_response_listing = resBody['ResposeData'];
        if(resBody['ResposeData'].length > 0){
          _markers.clear();
          latitude = resBody['ResposeData'][0]['Latitude'].toString();
          longitude = resBody['ResposeData'][0]['Longitude'].toString();
          title = resBody['ResposeData'][0]['unitname'].toString();

          print('title ${title}');

          if(MarkerListData != null)MarkerListData.clear();
          for (int i = 0; i < marker_response_listing.length; i++) {
            MarkerListData.add(MarkerData(marker_response_listing[i]['unitcode'].toString(),
                marker_response_listing[i]['unitname'].toString(),
                marker_response_listing[i]['unittype'].toString(),
                marker_response_listing[i]['Latitude'].toString() == "null" ? "0.0" : marker_response_listing[i]['Latitude'].toString(),
                marker_response_listing[i]['Longitude'].toString() == "null" ? "0.0" : marker_response_listing[i]['Longitude'].toString(),
                marker_response_listing[i]['UnitDescription'].toString() == "null" ? "" : marker_response_listing[i]['UnitDescription'].toString(),
                'Images/blue_marker.png'
            ));
          }
          print('newlen.size ${MarkerListData.length}');
          // initialize loadData method
          loadData();

        }
      } else {
        Fluttertoast.showToast(
            msg:apiResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }

    });
    return "Success";
  }

  // created method for displaying custom markers according to index
  loadData() async{
    for(int i=0 ;i<marker_response_listing.length; i++){
      final Uint8List markIcons = await getImages(MarkerListData[i].images, 100);
      // makers added according to index
      _markers.add(
          Marker(
            // given marker id
            markerId: MarkerId(i.toString()),
            // given marker icon
            icon: BitmapDescriptor.fromBytes(markIcons),
            // given position
           // position: _latLen[i],
            position: LatLng(double.parse(MarkerListData[i].Latitude),double.parse(MarkerListData[i].Longitude)),
            infoWindow: InfoWindow(
              // given title for marker
              title: ''+MarkerListData[i].unitname.toString(),
              onTap: (){
                  if(count == 0){
                    count=1;
                    getMarkerPointsAPI2(MarkerListData[i].unitcode,MarkerListData[i].unittype);
                  }else if(count==1){
                    count=2;
                    getMarkerPointsAPI2(MarkerListData[i].unitcode,MarkerListData[i].unittype);
                  }else{
                    print("stop.....");
                  }
              }
            )

          )
      );
      setState(() {
        EasyLoading.dismiss();
      });
    }
  }


  // created controller for displaying Google Maps
  Completer<GoogleMapController> _controller = Completer();

// given camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(26.4571,74.6372),
    zoom: 8,
  );

  Uint8List? marketimages;
  List<String> images = ['Images/map.png','Images/map.png', 'Images/map.png', 'Images/map.png', 'Images/map.png'];

  // created empty list of markers
  final List<Marker> _markers = <Marker>[];


  var _loading=false;
// declared method to get Images
  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }
  List<MarkerData> MarkerListData=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              _loading == false ? const Center(
                child: CircularProgressIndicator(color: ColorConstants.AppColorPrimary),
              ) :
              GoogleMap(
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                // given camera position
                //  initialCameraPosition: _kGoogle,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(MarkerListData.length == 0 ? 20.5937 : double.parse(MarkerListData[0].Latitude),MarkerListData.length == 0 ? 78.9629 :double.parse(MarkerListData[0].Longitude)),
                    zoom: 6,
                  ),
                  // set markers on google map
                  markers: Set<Marker>.of(_markers),
                  // on below line we have given map type
                  mapType: MapType.normal,
                  // on below line we have enabled location
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  // on below line we have enabled compass
                  compassEnabled: true,
                  // below line displays google map in our app
                  onMapCreated: (GoogleMapController controller){
                    _controller.complete(controller);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMarkerPointsAPI();
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
    EasyLoading.dismiss();
  }
}
class MarkerData {
  MarkerData(this.unitcode,this.unitname,this.unittype,this.Latitude,this.Longitude,this.UnitDescription,this.images);
  final String unitcode;
  final String unitname;
  final String unittype;
  final String Latitude;
  final String Longitude;
  final String UnitDescription;
  final String images;
}