class GetAashaRecordListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetAashaRecordListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetAashaRecordListData.fromJson(Map<String, dynamic> json) {
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
  int? ashaAutoID;
  String? ashaName;
  int? totalVerifiedCases;
  int? totalUnVerifiedCases;
  int? totalCases;

  ResposeData(
      {this.ashaAutoID,
        this.ashaName,
        this.totalVerifiedCases,
        this.totalUnVerifiedCases,
        this.totalCases});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ashaAutoID = json['ashaAutoID'];
    ashaName = json['AshaName'];
    totalVerifiedCases = json['TotalVerifiedCases'];
    totalUnVerifiedCases = json['TotalUnVerifiedCases'];
    totalCases = json['TotalCases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ashaAutoID'] = this.ashaAutoID;
    data['AshaName'] = this.ashaName;
    data['TotalVerifiedCases'] = this.totalVerifiedCases;
    data['TotalUnVerifiedCases'] = this.totalUnVerifiedCases;
    data['TotalCases'] = this.totalCases;
    return data;
  }
}
