class GetMotherDeathDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetMotherDeathDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetMotherDeathDetailsData.fromJson(Map<String, dynamic> json) {
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
  String? husbname;
  String? address;
  int? age;
  Null? eCID;
  int? height;
  int? motherid;
  int? ancregid;
  String? regdate;
  int? villageAutoID;
  int? regUnitid;
  String? prasavDate;
  Null? deathDate;
  Null? entryDate;
  Null? deathPlace;
  Null? relativeName;
  Null? masterMobile;
  Null? reasonID;
  Null? deathReportDate;
  Null? unitName;
  Null? deathPlaceUnitcode;
  Null? deathPlaceUnittype;
  Null? deathUnitID;
  Null? districtName;
  String? regDistrictName;
  int? ashaautoid;
  String? regUntcode;
  String? mobileno;
  Null? parentReasonId;

  ResposeData(
      {this.name,
        this.husbname,
        this.address,
        this.age,
        this.eCID,
        this.height,
        this.motherid,
        this.ancregid,
        this.regdate,
        this.villageAutoID,
        this.regUnitid,
        this.prasavDate,
        this.deathDate,
        this.entryDate,
        this.deathPlace,
        this.relativeName,
        this.masterMobile,
        this.reasonID,
        this.deathReportDate,
        this.unitName,
        this.deathPlaceUnitcode,
        this.deathPlaceUnittype,
        this.deathUnitID,
        this.districtName,
        this.regDistrictName,
        this.ashaautoid,
        this.regUntcode,
        this.mobileno,
        this.parentReasonId});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    husbname = json['Husbname'];
    address = json['Address'];
    age = json['Age'];
    eCID = json['ECID'];
    height = json['Height'];
    motherid = json['Motherid'];
    ancregid = json['ancregid'];
    regdate = json['regdate'];
    villageAutoID = json['VillageAutoID'];
    regUnitid = json['RegUnitid'];
    prasavDate = json['Prasav_date'];
    deathDate = json['DeathDate'];
    entryDate = json['EntryDate'];
    deathPlace = json['deathPlace'];
    relativeName = json['Relative_Name'];
    masterMobile = json['MasterMobile'];
    reasonID = json['ReasonID'];
    deathReportDate = json['DeathReportDate'];
    unitName = json['UnitName'];
    deathPlaceUnitcode = json['deathPlaceUnitcode'];
    deathPlaceUnittype = json['deathPlaceUnittype'];
    deathUnitID = json['DeathUnitID'];
    districtName = json['DistrictName'];
    regDistrictName = json['RegDistrictName'];
    ashaautoid = json['ashaautoid'];
    regUntcode = json['regUntcode'];
    mobileno = json['Mobileno'];
    parentReasonId = json['ParentReasonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Address'] = this.address;
    data['Age'] = this.age;
    data['ECID'] = this.eCID;
    data['Height'] = this.height;
    data['Motherid'] = this.motherid;
    data['ancregid'] = this.ancregid;
    data['regdate'] = this.regdate;
    data['VillageAutoID'] = this.villageAutoID;
    data['RegUnitid'] = this.regUnitid;
    data['Prasav_date'] = this.prasavDate;
    data['DeathDate'] = this.deathDate;
    data['EntryDate'] = this.entryDate;
    data['deathPlace'] = this.deathPlace;
    data['Relative_Name'] = this.relativeName;
    data['MasterMobile'] = this.masterMobile;
    data['ReasonID'] = this.reasonID;
    data['DeathReportDate'] = this.deathReportDate;
    data['UnitName'] = this.unitName;
    data['deathPlaceUnitcode'] = this.deathPlaceUnitcode;
    data['deathPlaceUnittype'] = this.deathPlaceUnittype;
    data['DeathUnitID'] = this.deathUnitID;
    data['DistrictName'] = this.districtName;
    data['RegDistrictName'] = this.regDistrictName;
    data['ashaautoid'] = this.ashaautoid;
    data['regUntcode'] = this.regUntcode;
    data['Mobileno'] = this.mobileno;
    data['ParentReasonId'] = this.parentReasonId;
    return data;
  }
}
