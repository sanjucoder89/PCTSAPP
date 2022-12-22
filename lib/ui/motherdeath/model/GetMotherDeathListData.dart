class GetMotherDeathListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetMotherDeathListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetMotherDeathListData.fromJson(Map<String, dynamic> json) {
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
  String? mothername;
  String? husbname;
  int? age;
  String? pctsid;
  int? motherID;
  String? deathDate;
  String? reasonName;
  String? deathReport;
  String? deathPlaces;
  int? deathPlace;

  ResposeData(
      {this.mothername,
        this.husbname,
        this.age,
        this.pctsid,
        this.motherID,
        this.deathDate,
        this.reasonName,
        this.deathReport,
        this.deathPlaces,
        this.deathPlace});

  ResposeData.fromJson(Map<String, dynamic> json) {
    mothername = json['mothername'];
    husbname = json['Husbname'];
    age = json['Age'];
    pctsid = json['pctsid'];
    motherID = json['MotherID'];
    deathDate = json['DeathDate'];
    reasonName = json['ReasonName'];
    deathReport = json['DeathReport'];
    deathPlaces = json['deathPlaces'];
    deathPlace = json['deathPlace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mothername'] = this.mothername;
    data['Husbname'] = this.husbname;
    data['Age'] = this.age;
    data['pctsid'] = this.pctsid;
    data['MotherID'] = this.motherID;
    data['DeathDate'] = this.deathDate;
    data['ReasonName'] = this.reasonName;
    data['DeathReport'] = this.deathReport;
    data['deathPlaces'] = this.deathPlaces;
    data['deathPlace'] = this.deathPlace;
    return data;
  }
}
