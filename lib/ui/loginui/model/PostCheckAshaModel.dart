class PostCheckAsha {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  PostCheckAsha({this.appVersion, this.message, this.status, this.resposeData});

  PostCheckAsha.fromJson(Map<String, dynamic> json) {
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
  String? password;

  ResposeData({this.password});

  ResposeData.fromJson(Map<String, dynamic> json) {
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Password'] = this.password;
    return data;
  }
}
