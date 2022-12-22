class AnmBlockListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  AnmBlockListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  AnmBlockListData.fromJson(Map<String, dynamic> json) {
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
  String? unitName;
  String? unitCode;

  ResposeData({this.unitName, this.unitCode});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitName = json['UnitName'];
    unitCode = json['UnitCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitName'] = this.unitName;
    data['UnitCode'] = this.unitCode;
    return data;
  }
}
