class UnitNameListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  UnitNameListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  UnitNameListData.fromJson(Map<String, dynamic> json) {
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
  String? uname;
  int? unitType;
  String? unitCode;

  ResposeData({this.uname, this.unitType, this.unitCode});

  ResposeData.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    unitType = json['UnitType'];
    unitCode = json['UnitCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['UnitType'] = this.unitType;
    data['UnitCode'] = this.unitCode;
    return data;
  }
}
