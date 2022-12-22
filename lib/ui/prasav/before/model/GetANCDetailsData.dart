class GetANCDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetANCDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetANCDetailsData.fromJson(Map<String, dynamic> json) {
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
  int? covidCase;
  String? covidFromDate;
  int? covidForeignTrip;
  int? covidRelativePossibility;
  int? covidRelativePositive;
  int? covidQuarantine;
  int? covidIsolation;
  String? pctsid;
  String? mobileno;
  int? motherID;
  String? name;
  String? husbname;
  String? address;
  int? age;
  String? eCID;
  int? villageAutoID;
  String? regDate;
  String? lMPDT;
  String? anganwariName;
  String? aNCDate;
  int? aNCFlag;
  String? tT1;
  double? weight;
  String? compL;
  int? rTI;
  String? tT2;
  String? tTB;
  String? iFA;
  double? hB;
  int? bloodPressureD;
  int? bloodPressureS;
  String? ashaName;
  String? referUnitCode;
  String? cAL500;
  String? aLBE400;
  int? urineA;
  int? urineS;
  int? treatmentCode;
  String? referDistrictCode;
  int? referUnitType;
  String? referUniName;
  int? ashaAutoID;
  String? ironSucrose1;
  String? ironSucrose2;
  String? ironSucrose3;
  String? ironSucrose4;
  int? normalLodingIronSucrose1;
  int? height;
  int? freezeANC3Checkup;
  int? regUnitID;
  int? regUnittype;
  int? deliveryComplication;
  int? anganwariNo;

  ResposeData(
      {this.covidCase,
        this.covidFromDate,
        this.covidForeignTrip,
        this.covidRelativePossibility,
        this.covidRelativePositive,
        this.covidQuarantine,
        this.covidIsolation,
        this.pctsid,
        this.mobileno,
        this.motherID,
        this.name,
        this.husbname,
        this.address,
        this.age,
        this.eCID,
        this.villageAutoID,
        this.regDate,
        this.lMPDT,
        this.anganwariName,
        this.aNCDate,
        this.aNCFlag,
        this.tT1,
        this.weight,
        this.compL,
        this.rTI,
        this.tT2,
        this.tTB,
        this.iFA,
        this.hB,
        this.bloodPressureD,
        this.bloodPressureS,
        this.ashaName,
        this.referUnitCode,
        this.cAL500,
        this.aLBE400,
        this.urineA,
        this.urineS,
        this.treatmentCode,
        this.referDistrictCode,
        this.referUnitType,
        this.referUniName,
        this.ashaAutoID,
        this.ironSucrose1,
        this.ironSucrose2,
        this.ironSucrose3,
        this.ironSucrose4,
        this.normalLodingIronSucrose1,
        this.height,
        this.freezeANC3Checkup,
        this.regUnitID,
        this.regUnittype,
        this.deliveryComplication,
        this.anganwariNo});

  ResposeData.fromJson(Map<String, dynamic> json) {
    covidCase = json['CovidCase'];
    covidFromDate = json['CovidFromDate'];
    covidForeignTrip = json['CovidForeignTrip'];
    covidRelativePossibility = json['CovidRelativePossibility'];
    covidRelativePositive = json['CovidRelativePositive'];
    covidQuarantine = json['CovidQuarantine'];
    covidIsolation = json['CovidIsolation'];
    pctsid = json['pctsid'];
    mobileno = json['Mobileno'];
    motherID = json['MotherID'];
    name = json['Name'];
    husbname = json['Husbname'];
    address = json['Address'];
    age = json['Age'];
    eCID = json['ECID'];
    villageAutoID = json['VillageAutoID'];
    regDate = json['RegDate'];
    lMPDT = json['LMPDT'];
    anganwariName = json['AnganwariName'];
    aNCDate = json['ANCDate'];
    aNCFlag = json['ANCFlag'];
    tT1 = json['TT1'];
    weight = json['weight'];
    compL = json['CompL'];
    rTI = json['RTI'];
    tT2 = json['TT2'];
    tTB = json['TTB'];
    iFA = json['IFA'];
    hB = json['HB'];
    bloodPressureD = json['BloodPressureD'];
    bloodPressureS = json['BloodPressureS'];
    ashaName = json['AshaName'];
    referUnitCode = json['ReferUnitCode'];
    cAL500 = json['CAL500'];
    aLBE400 = json['ALBE400'];
    urineA = json['UrineA'];
    urineS = json['UrineS'];
    treatmentCode = json['TreatmentCode'];
    referDistrictCode = json['ReferDistrictCode'];
    referUnitType = json['ReferUnitType'];
    referUniName = json['ReferUniName'];
    ashaAutoID = json['ashaAutoID'];
    ironSucrose1 = json['IronSucrose1'];
    ironSucrose2 = json['IronSucrose2'];
    ironSucrose3 = json['IronSucrose3'];
    ironSucrose4 = json['IronSucrose4'];
    normalLodingIronSucrose1 = json['NormalLodingIronSucrose1'];
    height = json['Height'];
    freezeANC3Checkup = json['Freeze_ANC3Checkup'];
    regUnitID = json['RegUnitID'];
    regUnittype = json['RegUnittype'];
    deliveryComplication = json['DeliveryComplication'];
    anganwariNo = json['anganwariNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CovidCase'] = this.covidCase;
    data['CovidFromDate'] = this.covidFromDate;
    data['CovidForeignTrip'] = this.covidForeignTrip;
    data['CovidRelativePossibility'] = this.covidRelativePossibility;
    data['CovidRelativePositive'] = this.covidRelativePositive;
    data['CovidQuarantine'] = this.covidQuarantine;
    data['CovidIsolation'] = this.covidIsolation;
    data['pctsid'] = this.pctsid;
    data['Mobileno'] = this.mobileno;
    data['MotherID'] = this.motherID;
    data['Name'] = this.name;
    data['Husbname'] = this.husbname;
    data['Address'] = this.address;
    data['Age'] = this.age;
    data['ECID'] = this.eCID;
    data['VillageAutoID'] = this.villageAutoID;
    data['RegDate'] = this.regDate;
    data['LMPDT'] = this.lMPDT;
    data['AnganwariName'] = this.anganwariName;
    data['ANCDate'] = this.aNCDate;
    data['ANCFlag'] = this.aNCFlag;
    data['TT1'] = this.tT1;
    data['weight'] = this.weight;
    data['CompL'] = this.compL;
    data['RTI'] = this.rTI;
    data['TT2'] = this.tT2;
    data['TTB'] = this.tTB;
    data['IFA'] = this.iFA;
    data['HB'] = this.hB;
    data['BloodPressureD'] = this.bloodPressureD;
    data['BloodPressureS'] = this.bloodPressureS;
    data['AshaName'] = this.ashaName;
    data['ReferUnitCode'] = this.referUnitCode;
    data['CAL500'] = this.cAL500;
    data['ALBE400'] = this.aLBE400;
    data['UrineA'] = this.urineA;
    data['UrineS'] = this.urineS;
    data['TreatmentCode'] = this.treatmentCode;
    data['ReferDistrictCode'] = this.referDistrictCode;
    data['ReferUnitType'] = this.referUnitType;
    data['ReferUniName'] = this.referUniName;
    data['ashaAutoID'] = this.ashaAutoID;
    data['IronSucrose1'] = this.ironSucrose1;
    data['IronSucrose2'] = this.ironSucrose2;
    data['IronSucrose3'] = this.ironSucrose3;
    data['IronSucrose4'] = this.ironSucrose4;
    data['NormalLodingIronSucrose1'] = this.normalLodingIronSucrose1;
    data['Height'] = this.height;
    data['Freeze_ANC3Checkup'] = this.freezeANC3Checkup;
    data['RegUnitID'] = this.regUnitID;
    data['RegUnittype'] = this.regUnittype;
    data['DeliveryComplication'] = this.deliveryComplication;
    data['anganwariNo'] = this.anganwariNo;
    return data;
  }
}
