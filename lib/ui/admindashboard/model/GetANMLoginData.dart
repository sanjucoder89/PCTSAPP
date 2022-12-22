class GetANMLoginData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetANMLoginData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetANMLoginData.fromJson(Map<String, dynamic> json) {
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
  int? unitid;
  String? unitcode;
  String? unitname;
  String? districtName;
  String? blockName;
  String? pCHCHCName;
  String? pCHCHCAbbr;
  String? unitAbbr;
  int? unitType;
  int? aNMAutoID;

  ResposeData(
      {this.ashaName,
        this.unitid,
        this.unitcode,
        this.unitname,
        this.districtName,
        this.blockName,
        this.pCHCHCName,
        this.pCHCHCAbbr,
        this.unitAbbr,
        this.unitType,
        this.aNMAutoID});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ashaName = json['AshaName'];
    unitid = json['unitid'];
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    districtName = json['DistrictName'];
    blockName = json['BlockName'];
    pCHCHCName = json['PCHCHCName'];
    pCHCHCAbbr = json['PCHCHCAbbr'];
    unitAbbr = json['UnitAbbr'];
    unitType = json['UnitType'];
    aNMAutoID = json['ANMAutoID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AshaName'] = this.ashaName;
    data['unitid'] = this.unitid;
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['DistrictName'] = this.districtName;
    data['BlockName'] = this.blockName;
    data['PCHCHCName'] = this.pCHCHCName;
    data['PCHCHCAbbr'] = this.pCHCHCAbbr;
    data['UnitAbbr'] = this.unitAbbr;
    data['UnitType'] = this.unitType;
    data['ANMAutoID'] = this.aNMAutoID;
    return data;
  }
}
