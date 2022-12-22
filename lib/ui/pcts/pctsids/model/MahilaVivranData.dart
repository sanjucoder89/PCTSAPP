class MahilaVivranData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  MahilaVivranData(
      {this.appVersion, this.message, this.status, this.resposeData});

  MahilaVivranData.fromJson(Map<String, dynamic> json) {
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
  String? pctsid;
  String? villageName;
  String? name;
  String? husbname;
  String? mobileno;
  String? eCID;
  int? height;
  int? age;
  String? bPL;
  String? locationRajasthan;
  String? ghamantu;
  String? regDate;
  int? anccount;
  String? deliveryDate;
  String? abortionDate;
  String? outcome;
  String? abortionType;
  String? dischargeDT;
  int? pnccount;
  int? aNCRegID;
  int? motherID;
  String? motherCast;
  String? deathDate;
  String? reasonName;
  int? liveChild;

  ResposeData(
      {this.pctsid,
        this.villageName,
        this.name,
        this.husbname,
        this.mobileno,
        this.eCID,
        this.height,
        this.age,
        this.bPL,
        this.locationRajasthan,
        this.ghamantu,
        this.regDate,
        this.anccount,
        this.deliveryDate,
        this.abortionDate,
        this.outcome,
        this.abortionType,
        this.dischargeDT,
        this.pnccount,
        this.aNCRegID,
        this.motherID,
        this.motherCast,
        this.deathDate,
        this.reasonName,
        this.liveChild});

  ResposeData.fromJson(Map<String, dynamic> json) {
    pctsid = json['pctsid'];
    villageName = json['VillageName'];
    name = json['name'];
    husbname = json['Husbname'];
    mobileno = json['Mobileno'];
    eCID = json['ECID'];
    height = json['Height'];
    age = json['Age'];
    bPL = json['BPL'];
    locationRajasthan = json['Location_Rajasthan'];
    ghamantu = json['Ghamantu'];
    regDate = json['RegDate'];
    anccount = json['anccount'];
    deliveryDate = json['deliveryDate'];
    abortionDate = json['Abortion_date'];
    outcome = json['outcome'];
    abortionType = json['AbortionType'];
    dischargeDT = json['DischargeDT'];
    pnccount = json['pnccount'];
    aNCRegID = json['ANCRegID'];
    motherID = json['MotherID'];
    motherCast = json['motherCast'];
    deathDate = json['DeathDate'];
    reasonName = json['ReasonName'];
    liveChild = json['LiveChild'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pctsid'] = this.pctsid;
    data['VillageName'] = this.villageName;
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Mobileno'] = this.mobileno;
    data['ECID'] = this.eCID;
    data['Height'] = this.height;
    data['Age'] = this.age;
    data['BPL'] = this.bPL;
    data['Location_Rajasthan'] = this.locationRajasthan;
    data['Ghamantu'] = this.ghamantu;
    data['RegDate'] = this.regDate;
    data['anccount'] = this.anccount;
    data['deliveryDate'] = this.deliveryDate;
    data['Abortion_date'] = this.abortionDate;
    data['outcome'] = this.outcome;
    data['AbortionType'] = this.abortionType;
    data['DischargeDT'] = this.dischargeDT;
    data['pnccount'] = this.pnccount;
    data['ANCRegID'] = this.aNCRegID;
    data['MotherID'] = this.motherID;
    data['motherCast'] = this.motherCast;
    data['DeathDate'] = this.deathDate;
    data['ReasonName'] = this.reasonName;
    data['LiveChild'] = this.liveChild;
    return data;
  }
}
