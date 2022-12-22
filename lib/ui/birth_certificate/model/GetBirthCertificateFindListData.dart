class GetBirthCertificateFindListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetBirthCertificateFindListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetBirthCertificateFindListData.fromJson(Map<String, dynamic> json) {
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
  String? mobileno;
  Null? pctsId;
  List<InfantList>? infantList;

  ResposeData(
      {this.name, this.husbname, this.mobileno, this.pctsId, this.infantList});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    husbname = json['Husbname'];
    mobileno = json['Mobileno'];
    pctsId = json['PctsId'];
    if (json['infantList'] != null) {
      infantList = <InfantList>[];
      json['infantList'].forEach((v) {
        infantList!.add(new InfantList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Mobileno'] = this.mobileno;
    data['PctsId'] = this.pctsId;
    if (this.infantList != null) {
      data['infantList'] = this.infantList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InfantList {
  Null? childName;
  String? birthDate;
  int? sex;
  int? infantID;
  String? childID;
  int? pehchanRegFlag;

  InfantList(
      {this.childName,
        this.birthDate,
        this.sex,
        this.infantID,
        this.childID,
        this.pehchanRegFlag});

  InfantList.fromJson(Map<String, dynamic> json) {
    childName = json['ChildName'];
    birthDate = json['Birth_date'];
    sex = json['Sex'];
    infantID = json['InfantID'];
    childID = json['ChildID'];
    pehchanRegFlag = json['PehchanRegFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ChildName'] = this.childName;
    data['Birth_date'] = this.birthDate;
    data['Sex'] = this.sex;
    data['InfantID'] = this.infantID;
    data['ChildID'] = this.childID;
    data['PehchanRegFlag'] = this.pehchanRegFlag;
    return data;
  }
}
