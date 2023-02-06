class FindPCTSIDData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  FindPCTSIDData(
      {this.appVersion, this.message, this.status, this.resposeData});

  FindPCTSIDData.fromJson(Map<String, dynamic> json) {
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
  int? ancregid;
  int? motherid;
  String? villagename;
  String? ecid;
  String? name;
  String? husbname;
  int? age;
  String? regdate;
  String? lmpdate;
  String? mobileno;
  int? villageAutoID;
  String? dueANC;
  int? dueANCFlag;

  ResposeData(
      {this.pctsid,
        this.ancregid,
        this.motherid,
        this.villagename,
        this.ecid,
        this.name,
        this.husbname,
        this.age,
        this.regdate,
        this.lmpdate,
        this.mobileno,
        this.villageAutoID,
        this.dueANC,
        this.dueANCFlag});

  ResposeData.fromJson(Map<String, dynamic> json) {
    pctsid = json['pctsid'];
    ancregid = json['ancregid'];
    motherid = json['MotherID'];
    villagename = json['villagename'];
    ecid = json['ecid'];
    name = json['name'];
    husbname = json['Husbname'];
    age = json['Age'];
    regdate = json['regdate'];
    lmpdate = json['lmpdate'];
    mobileno = json['mobileno'];
    villageAutoID = json['VillageAutoID'];
    dueANC = json['DueANC'];
    dueANCFlag = json['DueANCFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pctsid'] = this.pctsid;
    data['ancregid'] = this.ancregid;
    data['motherid'] = this.motherid;
    data['villagename'] = this.villagename;
    data['ecid'] = this.ecid;
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Age'] = this.age;
    data['regdate'] = this.regdate;
    data['lmpdate'] = this.lmpdate;
    data['mobileno'] = this.mobileno;
    data['VillageAutoID'] = this.villageAutoID;
    data['DueANC'] = this.dueANC;
    data['DueANCFlag'] = this.dueANCFlag;
    return data;
  }
}
