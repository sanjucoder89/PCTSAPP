class GetChartSubCenterData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChartSubCenterData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChartSubCenterData.fromJson(Map<String, dynamic> json) {
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
  String? blockName;
  num? cases;
  int? infantdeathCount;
  int? maternalDeathCount;
  int? bcgCount;
  int? pentaCount;
  int? oPVCount;
  int? measlCount;
  int? hBCount;

  ResposeData(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.blockName,
        this.cases,
        this.infantdeathCount,
        this.maternalDeathCount,
        this.bcgCount,
        this.pentaCount,
        this.oPVCount,
        this.measlCount,
        this.hBCount});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    blockName = json['BlockName'];
    cases = json['Cases'];
    infantdeathCount = json['infantdeathCount'];
    maternalDeathCount = json['maternalDeathCount'];
    bcgCount = json['BcgCount'];
    pentaCount = json['PentaCount'];
    oPVCount = json['OPVCount'];
    measlCount = json['MeaslCount'];
    hBCount = json['HBCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['BlockName'] = this.blockName;
    data['Cases'] = this.cases;
    data['infantdeathCount'] = this.infantdeathCount;
    data['maternalDeathCount'] = this.maternalDeathCount;
    data['BcgCount'] = this.bcgCount;
    data['PentaCount'] = this.pentaCount;
    data['OPVCount'] = this.oPVCount;
    data['MeaslCount'] = this.measlCount;
    data['HBCount'] = this.hBCount;
    return data;
  }
}
