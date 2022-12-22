class PostSaltData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeDataSalt>? resposeData;

  PostSaltData({this.appVersion, this.message, this.status, this.resposeData});

  PostSaltData.fromJson(Map<String, dynamic> json) {
    appVersion = json['AppVersion'];
    message = json['Message'];
    status = json['Status'];
    if (json['ResposeData'] != null) {
      resposeData = <ResposeDataSalt>[];
      json['ResposeData'].forEach((v) {
        resposeData!.add(new ResposeDataSalt.fromJson(v));
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

class ResposeDataSalt {
  String? saltvalue;

  ResposeDataSalt({this.saltvalue});

  ResposeDataSalt.fromJson(Map<String, dynamic> json) {
    saltvalue = json['Saltvalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Saltvalue'] = this.saltvalue;
    return data;
  }
}