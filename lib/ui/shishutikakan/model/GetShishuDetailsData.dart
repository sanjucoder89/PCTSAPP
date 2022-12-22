class GetShishuDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetShishuDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetShishuDetailsData.fromJson(Map<String, dynamic> json) {
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
  int? infantid;
  int? immucode;
  String? immudate;
  String? immuname;
  int? ashaautoid;
  String? ashaName;
  int? villageAutoID;
  int? regUnitID;
  String? birthDate;
  int? clickable;
  String? unitcode;
  int? dPTFlag;
  double? weight;
  int? freezeImmu;
  int? freezeDBooster;
  int? freezeDBooster2;

  ResposeData(
      {this.infantid,
        this.immucode,
        this.immudate,
        this.immuname,
        this.ashaautoid,
        this.ashaName,
        this.villageAutoID,
        this.regUnitID,
        this.birthDate,
        this.clickable,
        this.unitcode,
        this.dPTFlag,
        this.weight,
        this.freezeImmu,
        this.freezeDBooster,
        this.freezeDBooster2});

  ResposeData.fromJson(Map<String, dynamic> json) {
    infantid = json['infantid'];
    immucode = json['immucode'];
    immudate = json['immudate'];
    immuname = json['immuname'];
    ashaautoid = json['ashaautoid'];
    ashaName = json['AshaName'];
    villageAutoID = json['VillageAutoID'];
    regUnitID = json['RegUnitID'];
    birthDate = json['Birth_date'];
    clickable = json['clickable'];
    unitcode = json['unitcode'];
    dPTFlag = json['DPTFlag'];
    weight = json['weight'];
    freezeImmu = json['Freeze_Immu'];
    freezeDBooster = json['Freeze_DBooster'];
    freezeDBooster2 = json['Freeze_DBooster2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['infantid'] = this.infantid;
    data['immucode'] = this.immucode;
    data['immudate'] = this.immudate;
    data['immuname'] = this.immuname;
    data['ashaautoid'] = this.ashaautoid;
    data['AshaName'] = this.ashaName;
    data['VillageAutoID'] = this.villageAutoID;
    data['RegUnitID'] = this.regUnitID;
    data['Birth_date'] = this.birthDate;
    data['clickable'] = this.clickable;
    data['unitcode'] = this.unitcode;
    data['DPTFlag'] = this.dPTFlag;
    data['weight'] = this.weight;
    data['Freeze_Immu'] = this.freezeImmu;
    data['Freeze_DBooster'] = this.freezeDBooster;
    data['Freeze_DBooster2'] = this.freezeDBooster2;
    return data;
  }
}
