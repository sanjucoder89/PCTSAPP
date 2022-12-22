class GetChildDeathDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChildDeathDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChildDeathDetailsData.fromJson(Map<String, dynamic> json) {
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
  String? eCID;
  int? height;
  int? motherid;
  int? villageAutoID;
  int? ancregid;
  String? regdate;
  int? regUnitid;
  String? prasavDate;
  String? deathDate;
  String? entryDate;
  int? bfeed;
  String? birthDate;
  int? bloodGroup;
  String? childName;
  int? infantID;
  int? vikrtiCode;
  int? nBCCNBSU;
  int? sex;
  double? weight;
  int? status;
  String? deathPlaceUnitcode;
  int? deathPlaceUnittype;
  int? deathUnitID;
  String? regDistrictName;
  int? ashaautoid;
  String? regUntcode;
  int? deathPlace;
  int? ageType;
  int? immucode;
  String? relativeName;
  String? masterMobile;
  int? reasonID;
  String? deathReportDate;
  int? freeze;
  int? flag;
  int? aNMVerify;

  ResposeData(
      {this.name,
        this.husbname,
        this.address,
        this.age,
        this.eCID,
        this.height,
        this.motherid,
        this.villageAutoID,
        this.ancregid,
        this.regdate,
        this.regUnitid,
        this.prasavDate,
        this.deathDate,
        this.entryDate,
        this.bfeed,
        this.birthDate,
        this.bloodGroup,
        this.childName,
        this.infantID,
        this.vikrtiCode,
        this.nBCCNBSU,
        this.sex,
        this.weight,
        this.status,
        this.deathPlaceUnitcode,
        this.deathPlaceUnittype,
        this.deathUnitID,
        this.regDistrictName,
        this.ashaautoid,
        this.regUntcode,
        this.deathPlace,
        this.ageType,
        this.immucode,
        this.relativeName,
        this.masterMobile,
        this.reasonID,
        this.deathReportDate,
        this.freeze,
        this.flag,
        this.aNMVerify});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    husbname = json['Husbname'];
    address = json['Address'];
    age = json['Age'];
    eCID = json['ECID'];
    height = json['Height'];
    motherid = json['Motherid'];
    villageAutoID = json['VillageAutoID'];
    ancregid = json['ancregid'];
    regdate = json['regdate'];
    regUnitid = json['RegUnitid'];
    prasavDate = json['Prasav_date'];
    deathDate = json['DeathDate'];
    entryDate = json['EntryDate'];
    bfeed = json['Bfeed'];
    birthDate = json['Birth_date'];
    bloodGroup = json['BloodGroup'];
    childName = json['ChildName'];
    infantID = json['InfantID'];
    vikrtiCode = json['VikrtiCode'];
    nBCCNBSU = json['NBCC_NBSU'];
    sex = json['Sex'];
    weight = json['Weight'];
    status = json['Status'];
    deathPlaceUnitcode = json['deathPlaceUnitcode'];
    deathPlaceUnittype = json['deathPlaceUnittype'];
    deathUnitID = json['DeathUnitID'];
    regDistrictName = json['RegDistrictName'];
    ashaautoid = json['ashaautoid'];
    regUntcode = json['regUntcode'];
    deathPlace = json['deathPlace'];
    ageType = json['AgeType'];
    immucode = json['immucode'];
    relativeName = json['Relative_Name'];
    masterMobile = json['MasterMobile'];
    reasonID = json['ReasonID'];
    deathReportDate = json['DeathReportDate'];
    freeze = json['Freeze'];
    flag = json['flag'];
    aNMVerify = json['ANMVerify'];
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
    data['VillageAutoID'] = this.villageAutoID;
    data['ancregid'] = this.ancregid;
    data['regdate'] = this.regdate;
    data['RegUnitid'] = this.regUnitid;
    data['Prasav_date'] = this.prasavDate;
    data['DeathDate'] = this.deathDate;
    data['EntryDate'] = this.entryDate;
    data['Bfeed'] = this.bfeed;
    data['Birth_date'] = this.birthDate;
    data['BloodGroup'] = this.bloodGroup;
    data['ChildName'] = this.childName;
    data['InfantID'] = this.infantID;
    data['VikrtiCode'] = this.vikrtiCode;
    data['NBCC_NBSU'] = this.nBCCNBSU;
    data['Sex'] = this.sex;
    data['Weight'] = this.weight;
    data['Status'] = this.status;
    data['deathPlaceUnitcode'] = this.deathPlaceUnitcode;
    data['deathPlaceUnittype'] = this.deathPlaceUnittype;
    data['DeathUnitID'] = this.deathUnitID;
    data['RegDistrictName'] = this.regDistrictName;
    data['ashaautoid'] = this.ashaautoid;
    data['regUntcode'] = this.regUntcode;
    data['deathPlace'] = this.deathPlace;
    data['AgeType'] = this.ageType;
    data['immucode'] = this.immucode;
    data['Relative_Name'] = this.relativeName;
    data['MasterMobile'] = this.masterMobile;
    data['ReasonID'] = this.reasonID;
    data['DeathReportDate'] = this.deathReportDate;
    data['Freeze'] = this.freeze;
    data['flag'] = this.flag;
    data['ANMVerify'] = this.aNMVerify;
    return data;
  }
}
