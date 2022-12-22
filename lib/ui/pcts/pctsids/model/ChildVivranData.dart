class ChildVivranData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  ChildVivranData(
      {this.appVersion, this.message, this.status, this.resposeData});

  ChildVivranData.fromJson(Map<String, dynamic> json) {
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
  int? infantid;
  String? childid;
  String? name;
  String? husbname;
  String? childName;
  int? sex;
  String? birthDate;
  String? mobileno;
  int? motherID;

  ResposeData(
      {this.infantid,
        this.childid,
        this.name,
        this.husbname,
        this.childName,
        this.sex,
        this.birthDate,
        this.mobileno,
        this.motherID});

  ResposeData.fromJson(Map<String, dynamic> json) {
    infantid = json['infantid'];
    childid = json['childid'];
    name = json['name'];
    husbname = json['Husbname'];
    childName = json['ChildName'];
    sex = json['Sex'];
    birthDate = json['Birth_date'];
    mobileno = json['Mobileno'];
    motherID = json['MotherID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['infantid'] = this.infantid;
    data['childid'] = this.childid;
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['ChildName'] = this.childName;
    data['Sex'] = this.sex;
    data['Birth_date'] = this.birthDate;
    data['Mobileno'] = this.mobileno;
    data['MotherID'] = this.motherID;
    return data;
  }
}
