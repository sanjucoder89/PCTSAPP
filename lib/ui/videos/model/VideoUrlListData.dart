class VideoUrlListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  VideoUrlListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  VideoUrlListData.fromJson(Map<String, dynamic> json) {
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
  int? videoId;
  int? videoType;
  String? videoTypeName;
  String? videoName;
  String? descrption;
  String? imageName;

  ResposeData(
      {this.videoId,
        this.videoType,
        this.videoTypeName,
        this.videoName,
        this.descrption,
        this.imageName});

  ResposeData.fromJson(Map<String, dynamic> json) {
    videoId = json['VideoId'];
    videoType = json['VideoType'];
    videoTypeName = json['VideoTypeName'];
    videoName = json['VideoName'];
    descrption = json['Descrption'];
    imageName = json['ImageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VideoId'] = this.videoId;
    data['VideoType'] = this.videoType;
    data['VideoTypeName'] = this.videoTypeName;
    data['VideoName'] = this.videoName;
    data['Descrption'] = this.descrption;
    data['ImageName'] = this.imageName;
    return data;
  }
}
