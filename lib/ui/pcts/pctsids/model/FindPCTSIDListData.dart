class FindPCTSIDListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  FindPCTSIDListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  FindPCTSIDListData.fromJson(Map<String, dynamic> json) {
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
  String? pctsid;
  String? name;
  String? villageName;
  String? husbname;
  int? age;
  String? ecid;
  String? regDate;
  String? expDeliveryDate;
  String? mobileno;

  ResposeData(
      {this.ancregid,
        this.motherid,
        this.pctsid,
        this.name,
        this.villageName,
        this.husbname,
        this.age,
        this.ecid,
        this.regDate,
        this.expDeliveryDate,
        this.mobileno});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ancregid = json['ancregid'];
    motherid = json['motherid'];
    pctsid = json['pctsid'];
    name = json['name'];
    villageName = json['VillageName'];
    husbname = json['Husbname'];
    age = json['age'];
    ecid = json['ecid'];
    regDate = json['regDate'];
    expDeliveryDate = json['expDeliveryDate'];
    mobileno = json['mobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ancregid'] = this.ancregid;
    data['motherid'] = this.motherid;
    data['pctsid'] = this.pctsid;
    data['name'] = this.name;
    data['VillageName'] = this.villageName;
    data['Husbname'] = this.husbname;
    data['age'] = this.age;
    data['ecid'] = this.ecid;
    data['regDate'] = this.regDate;
    data['expDeliveryDate'] = this.expDeliveryDate;
    data['mobileno'] = this.mobileno;
    return data;
  }
}
