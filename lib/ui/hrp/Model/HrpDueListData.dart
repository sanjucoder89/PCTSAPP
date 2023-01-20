class HrpDueListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  HrpDueListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  HrpDueListData.fromJson(Map<String, dynamic> json) {
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
  String? pctsid;
  int? motherid;
  String? villagename;
  int? villageautoid;
  String? name;
  String? husbname;
  int? age;
  String? ecid;
  String? regdate;
  String? lmpdate;

  ResposeData(
      {this.ancregid,
        this.pctsid,
        this.motherid,
        this.villagename,
        this.villageautoid,
        this.name,
        this.husbname,
        this.age,
        this.ecid,
        this.regdate,
        this.lmpdate});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ancregid = json['ancregid'];
    pctsid = json['pctsid'];
    motherid = json['motherid'];
    villagename = json['villagename'];
    villageautoid = json['villageautoid'];
    name = json['name'];
    husbname = json['Husbname'];
    age = json['age'];
    ecid = json['ecid'];
    regdate = json['regdate'];
    lmpdate = json['lmpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ancregid'] = this.ancregid;
    data['pctsid'] = this.pctsid;
    data['motherid'] = this.motherid;
    data['villagename'] = this.villagename;
    data['villageautoid'] = this.villageautoid;
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['age'] = this.age;
    data['ecid'] = this.ecid;
    data['regdate'] = this.regdate;
    data['lmpdate'] = this.lmpdate;
    return data;
  }
}
