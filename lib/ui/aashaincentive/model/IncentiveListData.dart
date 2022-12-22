class IncentiveListData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  IncentiveListData(
      {this.appVersion, this.message, this.status, this.resposeData});

  IncentiveListData.fromJson(Map<String, dynamic> json) {
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
  String? ashaname;
  String? ashaphone;
  String? accountno;
  String? ifscCode;
  String? bankName;
  String? paymentDate;
  int? totalAmount;
  int? serviceCode;
  int? amount;
  String? serviceEnglish;
  String? serviceHindi;
  List<Activitylist>? activitylist;

  ResposeData(
      {this.ashaname,
        this.ashaphone,
        this.accountno,
        this.ifscCode,
        this.bankName,
        this.paymentDate,
        this.totalAmount,
        this.serviceCode,
        this.amount,
        this.serviceEnglish,
        this.serviceHindi,
        this.activitylist});

  ResposeData.fromJson(Map<String, dynamic> json) {
    ashaname = json['Ashaname'];
    ashaphone = json['Ashaphone'];
    accountno = json['Accountno'];
    ifscCode = json['Ifsc_code'];
    bankName = json['Bank_Name'];
    paymentDate = json['PaymentDate'];
    totalAmount = json['TotalAmount'];
    serviceCode = json['ServiceCode'];
    amount = json['Amount'];
    serviceEnglish = json['ServiceEnglish'];
    serviceHindi = json['ServiceHindi'];
    if (json['Activitylist'] != null) {
      activitylist = <Activitylist>[];
      json['Activitylist'].forEach((v) {
        activitylist!.add(new Activitylist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Ashaname'] = this.ashaname;
    data['Ashaphone'] = this.ashaphone;
    data['Accountno'] = this.accountno;
    data['Ifsc_code'] = this.ifscCode;
    data['Bank_Name'] = this.bankName;
    data['PaymentDate'] = this.paymentDate;
    data['TotalAmount'] = this.totalAmount;
    data['ServiceCode'] = this.serviceCode;
    data['Amount'] = this.amount;
    data['ServiceEnglish'] = this.serviceEnglish;
    data['ServiceHindi'] = this.serviceHindi;
    if (this.activitylist != null) {
      data['Activitylist'] = this.activitylist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activitylist {
  String? serviceEnglish;
  String? serviceHindi;
  int? amount;

  Activitylist({this.serviceEnglish, this.serviceHindi, this.amount});

  Activitylist.fromJson(Map<String, dynamic> json) {
    serviceEnglish = json['ServiceEnglish'];
    serviceHindi = json['ServiceHindi'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServiceEnglish'] = this.serviceEnglish;
    data['ServiceHindi'] = this.serviceHindi;
    data['Amount'] = this.amount;
    return data;
  }
}
