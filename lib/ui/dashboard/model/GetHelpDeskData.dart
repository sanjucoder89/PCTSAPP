class GetHelpDeskData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetHelpDeskData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetHelpDeskData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? mobile;
  String? time;

  ResposeData({this.name, this.mobile, this.time});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    mobile = json['Mobile'];
    time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Mobile'] = this.mobile;
    data['Time'] = this.time;
    return data;
  }
}
