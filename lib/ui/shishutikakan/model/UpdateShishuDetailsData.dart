class UpdateShishuDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  int? resposeData;

  UpdateShishuDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  UpdateShishuDetailsData.fromJson(Map<String, dynamic> json) {
    appVersion = json['AppVersion'];
    message = json['Message'];
    status = json['Status'];
    resposeData = json['ResposeData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppVersion'] = this.appVersion;
    data['Message'] = this.message;
    data['Status'] = this.status;
    data['ResposeData'] = this.resposeData;
    return data;
  }
}
