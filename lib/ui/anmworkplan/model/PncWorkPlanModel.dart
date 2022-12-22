class PncWorkPlanModel {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  PncWorkPlanModel(
      {this.appVersion, this.message, this.status, this.resposeData});

  PncWorkPlanModel.fromJson(Map<String, dynamic> json) {
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
  String? villagename;
  String? pctsid;
  Null? lMPDT;
  Null? ancdue;
  String? deliveryDate;
  String? pNCDueDate;
  Null? expDeliveryDate;
  Null? livechild;
  Null? immudue;
  int? motherid;
  int? ancregid;
  Null? infantid;

  ResposeData(
      {this.name,
        this.husbname,
        this.villagename,
        this.pctsid,
        this.lMPDT,
        this.ancdue,
        this.deliveryDate,
        this.pNCDueDate,
        this.expDeliveryDate,
        this.livechild,
        this.immudue,
        this.motherid,
        this.ancregid,
        this.infantid});

  ResposeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    husbname = json['Husbname'];
    villagename = json['villagename'];
    pctsid = json['pctsid'];
    lMPDT = json['LMPDT'];
    ancdue = json['ancdue'];
    deliveryDate = json['deliveryDate'];
    pNCDueDate = json['PNCDueDate'];
    expDeliveryDate = json['ExpDeliveryDate'];
    livechild = json['livechild'];
    immudue = json['immudue'];
    motherid = json['motherid'];
    ancregid = json['ancregid'];
    infantid = json['infantid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['Husbname'] = this.husbname;
    data['villagename'] = this.villagename;
    data['pctsid'] = this.pctsid;
    data['LMPDT'] = this.lMPDT;
    data['ancdue'] = this.ancdue;
    data['deliveryDate'] = this.deliveryDate;
    data['PNCDueDate'] = this.pNCDueDate;
    data['ExpDeliveryDate'] = this.expDeliveryDate;
    data['livechild'] = this.livechild;
    data['immudue'] = this.immudue;
    data['motherid'] = this.motherid;
    data['ancregid'] = this.ancregid;
    data['infantid'] = this.infantid;
    return data;
  }
}
