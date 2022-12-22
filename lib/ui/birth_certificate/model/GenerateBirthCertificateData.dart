class GenerateBirthCertificateData {
  int? appVersion;
  String? message;
  bool? status;
  ResposeData? resposeData;

  GenerateBirthCertificateData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GenerateBirthCertificateData.fromJson(Map<String, dynamic> json) {
    appVersion = json['AppVersion'];
    message = json['Message'];
    status = json['Status'];
    resposeData = json['ResposeData'] != null
        ? new ResposeData.fromJson(json['ResposeData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppVersion'] = this.appVersion;
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.resposeData != null) {
      data['ResposeData'] = this.resposeData!.toJson();
    }
    return data;
  }
}

class ResposeData {
  String? url;
  String? infantid;

  ResposeData({this.url, this.infantid});

  ResposeData.fromJson(Map<String, dynamic> json) {
    url = json['Url'];
    infantid = json['Infantid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Url'] = this.url;
    data['Infantid'] = this.infantid;
    return data;
  }
}
