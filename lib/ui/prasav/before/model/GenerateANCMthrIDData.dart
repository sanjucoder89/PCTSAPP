class GenerateANCMthrIDData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GenerateANCMthrIDData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GenerateANCMthrIDData.fromJson(Map<String, dynamic> json) {
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
  int? ancregid;
  int? motherID;
  int? status;

  ResposeData({this.ancregid, this.motherID, this.status});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ancregid = json['ancregid'];
    motherID = json['MotherID'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ancregid'] = this.ancregid;
    data['MotherID'] = this.motherID;
    data['Status'] = this.status;
    return data;
  }
}
