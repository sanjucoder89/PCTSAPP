class GetPNCDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetPNCDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetPNCDetailsData.fromJson(Map<String, dynamic> json) {
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
  int? motherid;
  int? child1IsLive;
  int? child1InfantID;
  double? child1Weight;
  int? child1Comp;
  int? child2IsLive;
  int? child2InfantID;
  double? child2Weight;
  int? child2Comp;
  int? child3IsLive;
  int? child3InfantID;
  double? child3Weight;
  int? child3Comp;
  int? child4IsLive;
  int? child4InfantID;
  double? child4Weight;
  int? child4Comp;
  int? child5IsLive;
  int? child5InfantID;
  double? child5Weight;
  int? child5Comp;
  int? pNCComp;
  String? entrydate;
  String? pNCDate;
  int? ashaautoid;
  int? freeze;
  int? pNCFlag;
  int? aNMautoid;
  String? anmname;
  String? ashaName;
  int? referUnitType;
  String? referDistrictCode;
  String? referUnitCode;
  String? referUniName;
  String? pctsid;
  String? mobileno;
  String? name;
  String? husbname;
  String? address;
  int? age;
  String? eCID;
  String? regDate;
  String? deliveryAbortionDate;
  int? delplaceCode;
  int? villageAutoID;
  int? regUnitID;
  int? regUnittype;
  String? dischargeDT;
  int? media;
  int? aNMVerify;

  ResposeData(
      {this.ancregid,
        this.motherid,
        this.child1IsLive,
        this.child1InfantID,
        this.child1Weight,
        this.child1Comp,
        this.child2IsLive,
        this.child2InfantID,
        this.child2Weight,
        this.child2Comp,
        this.child3IsLive,
        this.child3InfantID,
        this.child3Weight,
        this.child3Comp,
        this.child4IsLive,
        this.child4InfantID,
        this.child4Weight,
        this.child4Comp,
        this.child5IsLive,
        this.child5InfantID,
        this.child5Weight,
        this.child5Comp,
        this.pNCComp,
        this.entrydate,
        this.pNCDate,
        this.ashaautoid,
        this.freeze,
        this.pNCFlag,
        this.aNMautoid,
        this.anmname,
        this.ashaName,
        this.referUnitType,
        this.referDistrictCode,
        this.referUnitCode,
        this.referUniName,
        this.pctsid,
        this.mobileno,
        this.name,
        this.husbname,
        this.address,
        this.age,
        this.eCID,
        this.regDate,
        this.deliveryAbortionDate,
        this.delplaceCode,
        this.villageAutoID,
        this.regUnitID,
        this.regUnittype,
        this.dischargeDT,
        this.media,
        this.aNMVerify});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ancregid = json['ancregid'];
    motherid = json['Motherid'];
    child1IsLive = json['Child1_IsLive'];
    child1InfantID = json['Child1_InfantID'];
    child1Weight = json['Child1_Weight'];
    child1Comp = json['Child1_Comp'];
    child2IsLive = json['Child2_IsLive'];
    child2InfantID = json['Child2_InfantID'];
    child2Weight = json['Child2_Weight'];
    child2Comp = json['Child2_Comp'];
    child3IsLive = json['Child3_IsLive'];
    child3InfantID = json['Child3_InfantID'];
    child3Weight = json['Child3_Weight'];
    child3Comp = json['Child3_Comp'];
    child4IsLive = json['Child4_IsLive'];
    child4InfantID = json['Child4_InfantID'];
    child4Weight = json['Child4_Weight'];
    child4Comp = json['Child4_Comp'];
    child5IsLive = json['Child5_IsLive'];
    child5InfantID = json['Child5_InfantID'];
    child5Weight = json['Child5_Weight'];
    child5Comp = json['Child5_Comp'];
    pNCComp = json['PNCComp'];
    entrydate = json['entrydate'];
    pNCDate = json['PNCDate'];
    ashaautoid = json['Ashaautoid'];
    freeze = json['Freeze'];
    pNCFlag = json['PNCFlag'];
    aNMautoid = json['ANMautoid'];
    anmname = json['anmname'];
    ashaName = json['AshaName'];
    referUnitType = json['ReferUnitType'];
    referDistrictCode = json['ReferDistrictCode'];
    referUnitCode = json['ReferUnitCode'];
    referUniName = json['ReferUniName'];
    pctsid = json['pctsid'];
    mobileno = json['Mobileno'];
    name = json['Name'];
    husbname = json['Husbname'];
    address = json['Address'];
    age = json['Age'];
    eCID = json['ECID'];
    regDate = json['RegDate'];
    deliveryAbortionDate = json['DeliveryAbortionDate'];
    delplaceCode = json['DelplaceCode'];
    villageAutoID = json['VillageAutoID'];
    regUnitID = json['RegUnitID'];
    regUnittype = json['RegUnittype'];
    dischargeDT = json['DischargeDT'];
    media = json['Media'];
    aNMVerify = json['ANMVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ancregid'] = this.ancregid;
    data['Motherid'] = this.motherid;
    data['Child1_IsLive'] = this.child1IsLive;
    data['Child1_InfantID'] = this.child1InfantID;
    data['Child1_Weight'] = this.child1Weight;
    data['Child1_Comp'] = this.child1Comp;
    data['Child2_IsLive'] = this.child2IsLive;
    data['Child2_InfantID'] = this.child2InfantID;
    data['Child2_Weight'] = this.child2Weight;
    data['Child2_Comp'] = this.child2Comp;
    data['Child3_IsLive'] = this.child3IsLive;
    data['Child3_InfantID'] = this.child3InfantID;
    data['Child3_Weight'] = this.child3Weight;
    data['Child3_Comp'] = this.child3Comp;
    data['Child4_IsLive'] = this.child4IsLive;
    data['Child4_InfantID'] = this.child4InfantID;
    data['Child4_Weight'] = this.child4Weight;
    data['Child4_Comp'] = this.child4Comp;
    data['Child5_IsLive'] = this.child5IsLive;
    data['Child5_InfantID'] = this.child5InfantID;
    data['Child5_Weight'] = this.child5Weight;
    data['Child5_Comp'] = this.child5Comp;
    data['PNCComp'] = this.pNCComp;
    data['entrydate'] = this.entrydate;
    data['PNCDate'] = this.pNCDate;
    data['Ashaautoid'] = this.ashaautoid;
    data['Freeze'] = this.freeze;
    data['PNCFlag'] = this.pNCFlag;
    data['ANMautoid'] = this.aNMautoid;
    data['anmname'] = this.anmname;
    data['AshaName'] = this.ashaName;
    data['ReferUnitType'] = this.referUnitType;
    data['ReferDistrictCode'] = this.referDistrictCode;
    data['ReferUnitCode'] = this.referUnitCode;
    data['ReferUniName'] = this.referUniName;
    data['pctsid'] = this.pctsid;
    data['Mobileno'] = this.mobileno;
    data['Name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Address'] = this.address;
    data['Age'] = this.age;
    data['ECID'] = this.eCID;
    data['RegDate'] = this.regDate;
    data['DeliveryAbortionDate'] = this.deliveryAbortionDate;
    data['DelplaceCode'] = this.delplaceCode;
    data['VillageAutoID'] = this.villageAutoID;
    data['RegUnitID'] = this.regUnitID;
    data['RegUnittype'] = this.regUnittype;
    data['DischargeDT'] = this.dischargeDT;
    data['Media'] = this.media;
    data['ANMVerify'] = this.aNMVerify;
    return data;
  }
}
