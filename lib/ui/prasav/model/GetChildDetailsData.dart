class GetChildDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChildDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChildDetailsData.fromJson(Map<String, dynamic> json) {
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
  Null? childName;
  int? infantID;
  int? status;

  ResposeData({this.childName, this.infantID, this.status});

  ResposeData.fromJson(Map<String, dynamic> json) {
    childName = json['ChildName'];
    infantID = json['InfantID'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ChildName'] = this.childName;
    data['InfantID'] = this.infantID;
    data['Status'] = this.status;
    return data;
  }
}
