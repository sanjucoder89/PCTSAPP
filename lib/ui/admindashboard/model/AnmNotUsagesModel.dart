class AnmNotUsagesModel {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  AnmNotUsagesModel(
      {this.appVersion, this.message, this.status, this.resposeData});

  AnmNotUsagesModel.fromJson(Map<String, dynamic> json) {
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
  String? unitname;
  String? anmname;
  String? unitcode;
  String? phone;
  String? phcchcname;

  ResposeData(
      {this.unitname,
        this.anmname,
        this.unitcode,
        this.phone,
        this.phcchcname});

  ResposeData.fromJson(Map<String, dynamic> json) {
    unitname = json['unitname'];
    anmname = json['anmname'];
    unitcode = json['unitcode'];
    phone = json['Phone'];
    phcchcname = json['phcchcname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitname'] = this.unitname;
    data['anmname'] = this.anmname;
    data['unitcode'] = this.unitcode;
    data['Phone'] = this.phone;
    data['phcchcname'] = this.phcchcname;
    return data;
  }
}
