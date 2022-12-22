/// AppVersion : 0
/// Message : "Data Received successfully"
/// Status : true
/// ResposeData : [{"Name":"1-आईवी आयरन सुक्रोज"},{"Name":"2-ब्लड ट्रांस्फुजन"},{"Name":"3-एंटी हाईपरटेंसिव"},{"Name":"4-अन्‍य"}]

class TreatmentListData {
  TreatmentListData({
      int? appVersion, 
      String? message, 
      bool? status, 
      List<ResposeData>? resposeData,}){
    _appVersion = appVersion;
    _message = message;
    _status = status;
    _resposeData = resposeData;
}

  TreatmentListData.fromJson(dynamic json) {
    _appVersion = json['AppVersion'];
    _message = json['Message'];
    _status = json['Status'];
    if (json['ResposeData'] != null) {
      _resposeData = [];
      json['ResposeData'].forEach((v) {
        _resposeData?.add(ResposeData.fromJson(v));
      });
    }
  }
  int? _appVersion;
  String? _message;
  bool? _status;
  List<ResposeData>? _resposeData;
TreatmentListData copyWith({  int? appVersion,
  String? message,
  bool? status,
  List<ResposeData>? resposeData,
}) => TreatmentListData(  appVersion: appVersion ?? _appVersion,
  message: message ?? _message,
  status: status ?? _status,
  resposeData: resposeData ?? _resposeData,
);
  int? get appVersion => _appVersion;
  String? get message => _message;
  bool? get status => _status;
  List<ResposeData>? get resposeData => _resposeData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AppVersion'] = _appVersion;
    map['Message'] = _message;
    map['Status'] = _status;
    if (_resposeData != null) {
      map['ResposeData'] = _resposeData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// Name : "1-आईवी आयरन सुक्रोज"

class ResposeData {
  ResposeData({
      String? name,}){
    _name = name;
}

  ResposeData.fromJson(dynamic json) {
    _name = json['Name'];
  }
  String? _name;
ResposeData copyWith({  String? name,
}) => ResposeData(  name: name ?? _name,
);
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    return map;
  }

}