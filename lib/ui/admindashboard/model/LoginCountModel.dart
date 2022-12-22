class LoginCountModel {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  LoginCountModel(
      {this.appVersion, this.message, this.status, this.resposeData});

  LoginCountModel.fromJson(Map<String, dynamic> json) {
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
  String? unitname;
  String? anmname;
  String? unitcode;
  int? ancCount;
  int? pncCount;
  int? immuCount;
  int? maternalDeathount;
  int? infantDeathount;
  String? phone;
  String? phcchcname;

  ResposeData(
      {this.unitname,
        this.anmname,
        this.unitcode,
        this.ancCount,
        this.pncCount,
        this.immuCount,
        this.maternalDeathount,
        this.infantDeathount,
        this.phone,
        this.phcchcname});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitname = json['unitname'];
    anmname = json['anmname'];
    unitcode = json['unitcode'];
    ancCount = json['ancCount'];
    pncCount = json['pncCount'];
    immuCount = json['immuCount'];
    maternalDeathount = json['maternalDeathount'];
    infantDeathount = json['infantDeathount'];
    phone = json['Phone'];
    phcchcname = json['phcchcname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitname'] = this.unitname;
    data['anmname'] = this.anmname;
    data['unitcode'] = this.unitcode;
    data['ancCount'] = this.ancCount;
    data['pncCount'] = this.pncCount;
    data['immuCount'] = this.immuCount;
    data['maternalDeathount'] = this.maternalDeathount;
    data['infantDeathount'] = this.infantDeathount;
    data['Phone'] = this.phone;
    data['phcchcname'] = this.phcchcname;
    return data;
  }
}
