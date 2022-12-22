class DeathCountData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  DeathCountData(
      {this.appVersion, this.message, this.status, this.resposeData});

  DeathCountData.fromJson(Map<String, dynamic> json) {
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
  int? maternalDayCount;
  int? maternalTwodaysCount;
  int? maternalWeekCount;
  int? maternalMonthCount;
  int? maternalYearCount;
  int? infantDayCount;
  int? infantTwodaysCount;
  int? infantWeekCount;
  int? infantMonthCount;
  int? infantYearCount;
  String? unitname;
  String? unitcode;
  String? mobileno;
  int? finyear;

  ResposeData(
      {this.maternalDayCount,
        this.maternalTwodaysCount,
        this.maternalWeekCount,
        this.maternalMonthCount,
        this.maternalYearCount,
        this.infantDayCount,
        this.infantTwodaysCount,
        this.infantWeekCount,
        this.infantMonthCount,
        this.infantYearCount,
        this.unitname,
        this.unitcode,
        this.mobileno,
        this.finyear});

  ResposeData.fromJson(Map<String, dynamic> json) {
    maternalDayCount = json['maternalDayCount'];
    maternalTwodaysCount = json['maternalTwodaysCount'];
    maternalWeekCount = json['maternalWeekCount'];
    maternalMonthCount = json['maternalMonthCount'];
    maternalYearCount = json['maternalYearCount'];
    infantDayCount = json['infantDayCount'];
    infantTwodaysCount = json['infantTwodaysCount'];
    infantWeekCount = json['infantWeekCount'];
    infantMonthCount = json['infantMonthCount'];
    infantYearCount = json['infantYearCount'];
    unitname = json['unitname'];
    unitcode = json['unitcode'];
    mobileno = json['mobileno'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maternalDayCount'] = this.maternalDayCount;
    data['maternalTwodaysCount'] = this.maternalTwodaysCount;
    data['maternalWeekCount'] = this.maternalWeekCount;
    data['maternalMonthCount'] = this.maternalMonthCount;
    data['maternalYearCount'] = this.maternalYearCount;
    data['infantDayCount'] = this.infantDayCount;
    data['infantTwodaysCount'] = this.infantTwodaysCount;
    data['infantWeekCount'] = this.infantWeekCount;
    data['infantMonthCount'] = this.infantMonthCount;
    data['infantYearCount'] = this.infantYearCount;
    data['unitname'] = this.unitname;
    data['unitcode'] = this.unitcode;
    data['mobileno'] = this.mobileno;
    data['finyear'] = this.finyear;
    return data;
  }
}
