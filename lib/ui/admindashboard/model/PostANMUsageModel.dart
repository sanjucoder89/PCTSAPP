class PostANMUsage {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  PostANMUsage({this.appVersion, this.message, this.status, this.resposeData});

  PostANMUsage.fromJson(Map<String, dynamic> json) {
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
  String? unitcode;
  String? unitname;
  int? unittype;
  int? anmcount;
  int? totalANMNotEnterd;
  int? totalANMNotUseApp;

  ResposeData(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.anmcount,
        this.totalANMNotEnterd,
        this.totalANMNotUseApp});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    anmcount = json['anmcount'];
    totalANMNotEnterd = json['totalANMNotEnterd'];
    totalANMNotUseApp = json['totalANMNotUseApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['anmcount'] = this.anmcount;
    data['totalANMNotEnterd'] = this.totalANMNotEnterd;
    data['totalANMNotUseApp'] = this.totalANMNotUseApp;
    return data;
  }
}
