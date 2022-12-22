class UnitTypeListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  UnitTypeListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  UnitTypeListData.fromJson(Map<String, dynamic> json) {
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
  int? unitTypeCode;
  String? unittypeNameHindi;

  ResposeData({this.unitTypeCode, this.unittypeNameHindi});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitTypeCode = json['UnitTypeCode'];
    unittypeNameHindi = json['UnittypeNameHindi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitTypeCode'] = this.unitTypeCode;
    data['UnittypeNameHindi'] = this.unittypeNameHindi;
    return data;
  }
}
