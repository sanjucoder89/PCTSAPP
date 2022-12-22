class GetRemainingTikaiListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetRemainingTikaiListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetRemainingTikaiListData.fromJson(Map<String, dynamic> json) {
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
  String? immuName;
  String? immucode;
  int? dueDays;
  int? maxDays;

  ResposeData({this.immuName, this.immucode, this.dueDays, this.maxDays});

  ResposeData.fromJson(Map<String, dynamic> json) {
    immuName = json['ImmuName'];
    immucode = json['Immucode'];
    dueDays = json['DueDays'];
    maxDays = json['MaxDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImmuName'] = this.immuName;
    data['Immucode'] = this.immucode;
    data['DueDays'] = this.dueDays;
    data['MaxDays'] = this.maxDays;
    return data;
  }
}
