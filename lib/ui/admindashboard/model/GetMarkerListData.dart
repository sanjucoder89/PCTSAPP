class GetMarkerListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetMarkerListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetMarkerListData.fromJson(Map<String, dynamic> json) {
    appVersion = json['AppVersion'];
    message = json['Message'];
    status = json['Status'];
    if (json['ResposeData'] != null) {
      resposeData = <ResposeData>[];
      json['ResposeData'].forEach((v) {
        resposeData!.add(new ResposeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppVersion'] = this.appVersion;
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.resposeData != null) {
      data['ResposeData'] = this.resposeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResposeData {
  String? unitcode;
  String? unitname;
  int? unittype;
  String? latitude;
  String? longitude;
  String? unitDescription;

  ResposeData(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.latitude,
        this.longitude,
        this.unitDescription});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    unitDescription = json['UnitDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['UnitDescription'] = this.unitDescription;
    return data;
  }
}
