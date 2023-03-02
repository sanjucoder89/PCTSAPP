class GetUnitNameByUnitIdData {
  int? appVersion;
  String? message;
  bool? status;
  ResposeData? resposeData;

  GetUnitNameByUnitIdData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetUnitNameByUnitIdData.fromJson(Map<String, dynamic> json) {
    appVersion = json['AppVersion'];
    message = json['Message'];
    status = json['Status'];
    resposeData = json['ResposeData'] != null
        ? new ResposeData.fromJson(json['ResposeData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppVersion'] = this.appVersion;
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.resposeData != null) {
      data['ResposeData'] = this.resposeData!.toJson();
    }
    return data;
  }
}

class ResposeData {
  int? unitType;
  String? unitCode;
  String? unitName;

  ResposeData({this.unitType, this.unitCode, this.unitName});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitType = json['UnitType'];
    unitCode = json['UnitCode'];
    unitName = json['UnitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitType'] = this.unitType;
    data['UnitCode'] = this.unitCode;
    data['UnitName'] = this.unitName;
    return data;
  }
}
