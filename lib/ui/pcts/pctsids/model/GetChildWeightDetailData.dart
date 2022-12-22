class GetChildWeightDetailData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetChildWeightDetailData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetChildWeightDetailData.fromJson(Map<String, dynamic> json) {
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
  int? motherid;
  String? infantid;
  int? age;
  int? sex;
  double? weight;
  String? birthDate;
  String? childName;
  Null? tokenNo;
  Null? mobileNo;
  Null? userID;

  ResposeData(
      {this.motherid,
        this.infantid,
        this.age,
        this.sex,
        this.weight,
        this.birthDate,
        this.childName,
        this.tokenNo,
        this.mobileNo,
        this.userID});

  ResposeData.fromJson(Map<String, dynamic> json) {
    motherid = json['motherid'];
    infantid = json['infantid'];
    age = json['age'];
    sex = json['sex'];
    weight = json['weight'];
    birthDate = json['Birth_date'];
    childName = json['ChildName'];
    tokenNo = json['TokenNo'];
    mobileNo = json['MobileNo'];
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['motherid'] = this.motherid;
    data['infantid'] = this.infantid;
    data['age'] = this.age;
    data['sex'] = this.sex;
    data['weight'] = this.weight;
    data['Birth_date'] = this.birthDate;
    data['ChildName'] = this.childName;
    data['TokenNo'] = this.tokenNo;
    data['MobileNo'] = this.mobileNo;
    data['UserID'] = this.userID;
    return data;
  }
}
