class GetAanganBadiListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetAanganBadiListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetAanganBadiListData.fromJson(Map<String, dynamic> json) {
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
  String? nameH;
  String? nameE;
  int? anganwariNo;
  String? lastUpdated;

  ResposeData({this.nameH, this.nameE, this.anganwariNo, this.lastUpdated});

  ResposeData.fromJson(Map<String, dynamic> json) {
    nameH = json['NameH'];
    nameE = json['NameE'];
    anganwariNo = json['AnganwariNo'];
    lastUpdated = json['LastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NameH'] = this.nameH;
    data['NameE'] = this.nameE;
    data['AnganwariNo'] = this.anganwariNo;
    data['LastUpdated'] = this.lastUpdated;
    return data;
  }
}
