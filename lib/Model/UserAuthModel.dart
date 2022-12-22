class UserAuthModel {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  UserAuthModel({this.appVersion, this.message, this.status, this.resposeData});

  UserAuthModel.fromJson(Map<String, dynamic> json) {
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
  String? unitCode;
  String? unitID;
  String? aNMName;
  String? unitName;
  String? resetpwd;
  String? unitType;
  String? appRoleID;
  String? mobileNo;
  String? userNo;
  String? districtName;
  String? blockName;
  String? pCHCHCName;
  String? pCHCHCAbbr;
  String? unitAbbr;
  String? isExp;
  String? token;
  String? aNMAutoID;
  String? vaildMobileFlag;
  String? anganwariEnglish;
  String? anganwariHindi;

  ResposeData(
      {this.unitCode,
      this.unitID,
      this.aNMName,
      this.unitName,
      this.resetpwd,
      this.unitType,
      this.appRoleID,
      this.mobileNo,
      this.userNo,
      this.districtName,
      this.blockName,
      this.pCHCHCName,
      this.pCHCHCAbbr,
      this.unitAbbr,
      this.isExp,
      this.token,
      this.aNMAutoID,
      this.vaildMobileFlag,
      this.anganwariEnglish,
      this.anganwariHindi});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitCode = json['UnitCode'];
    unitID = json['UnitID'];
    aNMName = json['ANMName'];
    unitName = json['UnitName'];
    resetpwd = json['Resetpwd'];
    unitType = json['UnitType'];
    appRoleID = json['AppRoleID'];
    mobileNo = json['MobileNo'];
    userNo = json['UserNo'];
    districtName = json['DistrictName'];
    blockName = json['BlockName'];
    pCHCHCName = json['PCHCHCName'];
    pCHCHCAbbr = json['PCHCHCAbbr'];
    unitAbbr = json['UnitAbbr'];
    isExp = json['IsExp'];
    token = json['Token'];
    aNMAutoID = json['ANMAutoID'];
    vaildMobileFlag = json['VaildMobileFlag'];
    anganwariEnglish = json['AnganwariEnglish'];
    anganwariHindi = json['AnganwariHindi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitCode'] = this.unitCode;
    data['UnitID'] = this.unitID;
    data['ANMName'] = this.aNMName;
    data['UnitName'] = this.unitName;
    data['Resetpwd'] = this.resetpwd;
    data['UnitType'] = this.unitType;
    data['AppRoleID'] = this.appRoleID;
    data['MobileNo'] = this.mobileNo;
    data['UserNo'] = this.userNo;
    data['DistrictName'] = this.districtName;
    data['BlockName'] = this.blockName;
    data['PCHCHCName'] = this.pCHCHCName;
    data['PCHCHCAbbr'] = this.pCHCHCAbbr;
    data['UnitAbbr'] = this.unitAbbr;
    data['IsExp'] = this.isExp;
    data['Token'] = this.token;
    data['ANMAutoID'] = this.aNMAutoID;
    data['VaildMobileFlag'] = this.vaildMobileFlag;
    data['AnganwariEnglish'] = this.anganwariEnglish;
    data['AnganwariHindi'] = this.anganwariHindi;
    return data;
  }
}
