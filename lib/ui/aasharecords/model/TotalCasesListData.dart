class TotalCasesListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  TotalCasesListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  TotalCasesListData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? husbName;
  String? childName;
  String? pCTSID;
  String? childID;
  String? villageName;
  String? regDate;
  String? prasavDate;
  int? motherID;
  int? aNCRegID;
  int? infantID;
  String? flag;
  String? ancPncImmuDeathDate;
  String? birthDate;
  int? aNMVerify;
  String? immuCode;
  String? villageAutoID;
  String? regUnitID;
  String? weight;
  String? unitCode;
  String? aNMVerificationDate;

  ResposeData(
      {this.name,
        this.husbName,
        this.childName,
        this.pCTSID,
        this.childID,
        this.villageName,
        this.regDate,
        this.prasavDate,
        this.motherID,
        this.aNCRegID,
        this.infantID,
        this.flag,
        this.ancPncImmuDeathDate,
        this.birthDate,
        this.aNMVerify,
        this.immuCode,
        this.villageAutoID,
        this.regUnitID,
        this.weight,
        this.unitCode,
        this.aNMVerificationDate});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    husbName = json['HusbName'];
    childName = json['ChildName'];
    pCTSID = json['PCTSID'];
    childID = json['ChildID'];
    villageName = json['VillageName'];
    regDate = json['RegDate'];
    prasavDate = json['Prasav_date'];
    motherID = json['MotherID'];
    aNCRegID = json['ANCRegID'];
    infantID = json['InfantID'];
    flag = json['Flag'];
    ancPncImmuDeathDate = json['AncPncImmuDeathDate'];
    birthDate = json['BirthDate'];
    aNMVerify = json['ANMVerify'];
    immuCode = json['ImmuCode'];
    villageAutoID = json['VillageAutoID'];
    regUnitID = json['RegUnitID'];
    weight = json['Weight'];
    unitCode = json['UnitCode'];
    aNMVerificationDate = json['ANMVerificationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['HusbName'] = this.husbName;
    data['ChildName'] = this.childName;
    data['PCTSID'] = this.pCTSID;
    data['ChildID'] = this.childID;
    data['VillageName'] = this.villageName;
    data['RegDate'] = this.regDate;
    data['Prasav_date'] = this.prasavDate;
    data['MotherID'] = this.motherID;
    data['ANCRegID'] = this.aNCRegID;
    data['InfantID'] = this.infantID;
    data['Flag'] = this.flag;
    data['AncPncImmuDeathDate'] = this.ancPncImmuDeathDate;
    data['BirthDate'] = this.birthDate;
    data['ANMVerify'] = this.aNMVerify;
    data['ImmuCode'] = this.immuCode;
    data['VillageAutoID'] = this.villageAutoID;
    data['RegUnitID'] = this.regUnitID;
    data['Weight'] = this.weight;
    data['UnitCode'] = this.unitCode;
    data['ANMVerificationDate'] = this.aNMVerificationDate;
    return data;
  }
}
