class AnmListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  AnmListData({this.appVersion, this.message, this.status, this.resposeData});

  AnmListData.fromJson(Map<String, dynamic> json) {
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
  String? ashaName;
  int? ashaAutoID;
  String? ashaPhone;

  ResposeData({this.ashaName, this.ashaAutoID, this.ashaPhone});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ashaName = json['AshaName'];
    ashaAutoID = json['ashaAutoID'];
    ashaPhone = json['AshaPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AshaName'] = this.ashaName;
    data['ashaAutoID'] = this.ashaAutoID;
    data['AshaPhone'] = this.ashaPhone;
    return data;
  }
}
