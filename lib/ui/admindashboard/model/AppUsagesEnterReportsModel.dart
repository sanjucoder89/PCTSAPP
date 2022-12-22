class AppUsagesEnterReportsModel {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  AppUsagesEnterReportsModel(
      {this.appVersion, this.message, this.status, this.resposeData});

  AppUsagesEnterReportsModel.fromJson(Map<String, dynamic> json) {
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
  int? ancCasesCount;
  int? pncCasesCount;
  int? immuCount;
  int? matDeathCount;
  int? infantDeathCount;

  ResposeData(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.ancCasesCount,
        this.pncCasesCount,
        this.immuCount,
        this.matDeathCount,
        this.infantDeathCount});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    ancCasesCount = json['ancCasesCount'];
    pncCasesCount = json['pncCasesCount'];
    immuCount = json['immuCount'];
    matDeathCount = json['matDeathCount'];
    infantDeathCount = json['infantDeathCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['ancCasesCount'] = this.ancCasesCount;
    data['pncCasesCount'] = this.pncCasesCount;
    data['immuCount'] = this.immuCount;
    data['matDeathCount'] = this.matDeathCount;
    data['infantDeathCount'] = this.infantDeathCount;
    return data;
  }
}
