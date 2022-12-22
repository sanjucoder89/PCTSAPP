class GetChartCHCPHCData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChartCHCPHCData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChartCHCPHCData.fromJson(Map<String, dynamic> json) {
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
  int? clickable;

  ResposeData(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.blockName,
        this.cases,
        this.clickable});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    blockName = json['BlockName'];
    cases = json['Cases'];
    clickable = json['clickable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['BlockName'] = this.blockName;
    data['Cases'] = this.cases;
    data['clickable'] = this.clickable;
    return data;
  }
}
