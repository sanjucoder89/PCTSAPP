class GetChildDeathListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChildDeathListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChildDeathListData.fromJson(Map<String, dynamic> json) {
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
  String? childName;
  String? birthDate;
  int? infantID;
  String? childid;
  String? sex;

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
        this.deathPlace,
        this.childName,
        this.birthDate,
        this.infantID,
        this.childid,
        this.sex});

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
    childName = json['ChildName'];
    birthDate = json['Birth_date'];
    infantID = json['InfantID'];
    childid = json['childid'];
    sex = json['Sex'];
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
    data['ChildName'] = this.childName;
    data['Birth_date'] = this.birthDate;
    data['InfantID'] = this.infantID;
    data['childid'] = this.childid;
    data['Sex'] = this.sex;
    return data;
  }
}
