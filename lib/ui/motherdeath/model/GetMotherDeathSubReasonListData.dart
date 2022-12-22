class GetMotherDeathSubReasonListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetMotherDeathSubReasonListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetMotherDeathSubReasonListData.fromJson(Map<String, dynamic> json) {
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
  String? reasonName;
  int? reasonID;
  int? deathType;

  ResposeData({this.reasonName, this.reasonID, this.deathType});

  ResposeData.fromJson(Map<String, dynamic> json) {
    reasonName = json['ReasonName'];
    reasonID = json['ReasonID'];
    deathType = json['DeathType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReasonName'] = this.reasonName;
    data['ReasonID'] = this.reasonID;
    data['DeathType'] = this.deathType;
    return data;
  }
}
