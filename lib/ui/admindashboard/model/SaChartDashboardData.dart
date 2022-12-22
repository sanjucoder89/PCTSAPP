class SaChartDashboardData {
  int? appVersion;
  String? message;
  bool? status;
  ResposeData? resposeData;

  SaChartDashboardData(
      {this.appVersion, this.message, this.status, this.resposeData});

  SaChartDashboardData.fromJson(Map<String, dynamic> json) {
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
  List<AncRegDashboard>? ancRegDashboard;
  List<BirthDetails>? birthDetails;
  List<DeliveryDetails>? deliveryDetails;
  List<ImmunizationDetails>? immunizationDetails;
  List<Top7DistrictPerformance>? top7DistrictPerformance;
  List<IndicatorWisePerformance>? indicatorWisePerformance;
  List<Top7BlockPerformance>? top7BlockPerformance;
  List<MaternalDeaths>? maternalDeaths;
  List<InfantDeaths>? infantDeaths;
  List<Sterlization>? sterlization;
  List<SexRatio>? sexRatio;
  List<VaccineRequirement>? vaccineRequirement;
  List<HighRisk>? highRisk;
  Null? abortion;
  Null? iud;

  ResposeData(
      {this.ancRegDashboard,
        this.birthDetails,
        this.deliveryDetails,
        this.immunizationDetails,
        this.top7DistrictPerformance,
        this.indicatorWisePerformance,
        this.top7BlockPerformance,
        this.maternalDeaths,
        this.infantDeaths,
        this.sterlization,
        this.sexRatio,
        this.vaccineRequirement,
        this.highRisk,
        this.abortion,
        this.iud});

  ResposeData.fromJson(Map<String, dynamic> json) {
    if (json['ancRegDashboard'] != null) {
      ancRegDashboard = <AncRegDashboard>[];
      json['ancRegDashboard'].forEach((v) {
        ancRegDashboard!.add(new AncRegDashboard.fromJson(v));
      });
    }
    if (json['birthDetails'] != null) {
      birthDetails = <BirthDetails>[];
      json['birthDetails'].forEach((v) {
        birthDetails!.add(new BirthDetails.fromJson(v));
      });
    }
    if (json['deliveryDetails'] != null) {
      deliveryDetails = <DeliveryDetails>[];
      json['deliveryDetails'].forEach((v) {
        deliveryDetails!.add(new DeliveryDetails.fromJson(v));
      });
    }
    if (json['immunizationDetails'] != null) {
      immunizationDetails = <ImmunizationDetails>[];
      json['immunizationDetails'].forEach((v) {
        immunizationDetails!.add(new ImmunizationDetails.fromJson(v));
      });
    }
    if (json['top7DistrictPerformance'] != null) {
      top7DistrictPerformance = <Top7DistrictPerformance>[];
      json['top7DistrictPerformance'].forEach((v) {
        top7DistrictPerformance!.add(new Top7DistrictPerformance.fromJson(v));
      });
    }
    if (json['indicatorWisePerformance'] != null) {
      indicatorWisePerformance = <IndicatorWisePerformance>[];
      json['indicatorWisePerformance'].forEach((v) {
        indicatorWisePerformance!.add(new IndicatorWisePerformance.fromJson(v));
      });
    }
    if (json['top7BlockPerformance'] != null) {
      top7BlockPerformance = <Top7BlockPerformance>[];
      json['top7BlockPerformance'].forEach((v) {
        top7BlockPerformance!.add(new Top7BlockPerformance.fromJson(v));
      });
    }
    if (json['maternalDeaths'] != null) {
      maternalDeaths = <MaternalDeaths>[];
      json['maternalDeaths'].forEach((v) {
        maternalDeaths!.add(new MaternalDeaths.fromJson(v));
      });
    }
    if (json['infantDeaths'] != null) {
      infantDeaths = <InfantDeaths>[];
      json['infantDeaths'].forEach((v) {
        infantDeaths!.add(new InfantDeaths.fromJson(v));
      });
    }
    if (json['sterlization'] != null) {
      sterlization = <Sterlization>[];
      json['sterlization'].forEach((v) {
        sterlization!.add(new Sterlization.fromJson(v));
      });
    }
    if (json['sexRatio'] != null) {
      sexRatio = <SexRatio>[];
      json['sexRatio'].forEach((v) {
        sexRatio!.add(new SexRatio.fromJson(v));
      });
    }
    if (json['vaccineRequirement'] != null) {
      vaccineRequirement = <VaccineRequirement>[];
      json['vaccineRequirement'].forEach((v) {
        vaccineRequirement!.add(new VaccineRequirement.fromJson(v));
      });
    }
    if (json['highRisk'] != null) {
      highRisk = <HighRisk>[];
      json['highRisk'].forEach((v) {
        highRisk!.add(new HighRisk.fromJson(v));
      });
    }
    abortion = json['abortion'];
    iud = json['iud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ancRegDashboard != null) {
      data['ancRegDashboard'] =
          this.ancRegDashboard!.map((v) => v.toJson()).toList();
    }
    if (this.birthDetails != null) {
      data['birthDetails'] = this.birthDetails!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryDetails != null) {
      data['deliveryDetails'] =
          this.deliveryDetails!.map((v) => v.toJson()).toList();
    }
    if (this.immunizationDetails != null) {
      data['immunizationDetails'] =
          this.immunizationDetails!.map((v) => v.toJson()).toList();
    }
    if (this.top7DistrictPerformance != null) {
      data['top7DistrictPerformance'] =
          this.top7DistrictPerformance!.map((v) => v.toJson()).toList();
    }
    if (this.indicatorWisePerformance != null) {
      data['indicatorWisePerformance'] =
          this.indicatorWisePerformance!.map((v) => v.toJson()).toList();
    }
    if (this.top7BlockPerformance != null) {
      data['top7BlockPerformance'] =
          this.top7BlockPerformance!.map((v) => v.toJson()).toList();
    }
    if (this.maternalDeaths != null) {
      data['maternalDeaths'] =
          this.maternalDeaths!.map((v) => v.toJson()).toList();
    }
    if (this.infantDeaths != null) {
      data['infantDeaths'] = this.infantDeaths!.map((v) => v.toJson()).toList();
    }
    if (this.sterlization != null) {
      data['sterlization'] = this.sterlization!.map((v) => v.toJson()).toList();
    }
    if (this.sexRatio != null) {
      data['sexRatio'] = this.sexRatio!.map((v) => v.toJson()).toList();
    }
    if (this.vaccineRequirement != null) {
      data['vaccineRequirement'] =
          this.vaccineRequirement!.map((v) => v.toJson()).toList();
    }
    if (this.highRisk != null) {
      data['highRisk'] = this.highRisk!.map((v) => v.toJson()).toList();
    }
    data['abortion'] = this.abortion;
    data['iud'] = this.iud;
    return data;
  }
}

class AncRegDashboard {
  int? totalANCReg;
  int? aNCRegTrimister;
  String? finyear;
  String? unitcode;
  int? unittype;

  AncRegDashboard(
      {this.totalANCReg,
        this.aNCRegTrimister,
        this.finyear,
        this.unitcode,
        this.unittype});

  AncRegDashboard.fromJson(Map<String, dynamic> json) {
    totalANCReg = json['TotalANCReg'];
    aNCRegTrimister = json['ANCRegTrimister'];
    finyear = json['finyear'];
    unitcode = json['unitcode'];
    unittype = json['unittype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalANCReg'] = this.totalANCReg;
    data['ANCRegTrimister'] = this.aNCRegTrimister;
    data['finyear'] = this.finyear;
    data['unitcode'] = this.unitcode;
    data['unittype'] = this.unittype;
    return data;
  }
}

class BirthDetails {
  int? totalBirth;
  int? liveMaleBirth;
  int? liveFeMaleBirth;
  int? stillBirth;
  String? finyear;
  String? unitcode;
  int? unittype;

  BirthDetails(
      {this.totalBirth,
        this.liveMaleBirth,
        this.liveFeMaleBirth,
        this.stillBirth,
        this.finyear,
        this.unitcode,
        this.unittype});

  BirthDetails.fromJson(Map<String, dynamic> json) {
    totalBirth = json['totalBirth'];
    liveMaleBirth = json['liveMaleBirth'];
    liveFeMaleBirth = json['liveFeMaleBirth'];
    stillBirth = json['stillBirth'];
    finyear = json['finyear'];
    unitcode = json['unitcode'];
    unittype = json['unittype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBirth'] = this.totalBirth;
    data['liveMaleBirth'] = this.liveMaleBirth;
    data['liveFeMaleBirth'] = this.liveFeMaleBirth;
    data['stillBirth'] = this.stillBirth;
    data['finyear'] = this.finyear;
    data['unitcode'] = this.unitcode;
    data['unittype'] = this.unittype;
    return data;
  }
}

class DeliveryDetails {
  int? totalDelivery;
  int? delPublic;
  int? delPrivate;
  int? delHome;
  String? finyear;
  String? unitcode;
  int? unittype;

  DeliveryDetails(
      {this.totalDelivery,
        this.delPublic,
        this.delPrivate,
        this.delHome,
        this.finyear,
        this.unitcode,
        this.unittype});

  DeliveryDetails.fromJson(Map<String, dynamic> json) {
    totalDelivery = json['totalDelivery'];
    delPublic = json['delPublic'];
    delPrivate = json['delPrivate'];
    delHome = json['delHome'];
    finyear = json['finyear'];
    unitcode = json['unitcode'];
    unittype = json['unittype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDelivery'] = this.totalDelivery;
    data['delPublic'] = this.delPublic;
    data['delPrivate'] = this.delPrivate;
    data['delHome'] = this.delHome;
    data['finyear'] = this.finyear;
    data['unitcode'] = this.unitcode;
    data['unittype'] = this.unittype;
    return data;
  }
}

class ImmunizationDetails {
  int? totalChilderenReg;
  int? fullyImmunized;
  int? partImmunized;
  int? notImmunized;
  String? finyear;
  String? unitcode;
  int? unittype;

  ImmunizationDetails(
      {this.totalChilderenReg,
        this.fullyImmunized,
        this.partImmunized,
        this.notImmunized,
        this.finyear,
        this.unitcode,
        this.unittype});

  ImmunizationDetails.fromJson(Map<String, dynamic> json) {
    totalChilderenReg = json['totalChilderenReg'];
    fullyImmunized = json['fullyImmunized'];
    partImmunized = json['partImmunized'];
    notImmunized = json['notImmunized'];
    finyear = json['finyear'];
    unitcode = json['unitcode'];
    unittype = json['unittype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalChilderenReg'] = this.totalChilderenReg;
    data['fullyImmunized'] = this.fullyImmunized;
    data['partImmunized'] = this.partImmunized;
    data['notImmunized'] = this.notImmunized;
    data['finyear'] = this.finyear;
    data['unitcode'] = this.unitcode;
    data['unittype'] = this.unittype;
    return data;
  }
}

class Top7DistrictPerformance {
  String? unitcode;
  String? unitname;
  int? unittype;
  double? performacePer;
  int? maxValueDistrict;
  String? finyear;

  Top7DistrictPerformance(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.performacePer,
        this.maxValueDistrict,
        this.finyear});

  Top7DistrictPerformance.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    performacePer = json['performacePer'];
    maxValueDistrict = json['maxValueDistrict'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['performacePer'] = this.performacePer;
    data['maxValueDistrict'] = this.maxValueDistrict;
    data['finyear'] = this.finyear;
    return data;
  }
}

class IndicatorWisePerformance {
  String? unitcode;
  String? unitname;
  int? unittype;
  String? indicatorName;
  String? indicatorNameH;
  String? indicatorValue;
  String? finyear;
  int? indicatorFlag;

  IndicatorWisePerformance(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.indicatorName,
        this.indicatorNameH,
        this.indicatorValue,
        this.finyear,
        this.indicatorFlag});

  IndicatorWisePerformance.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    indicatorName = json['indicatorName'];
    indicatorNameH = json['indicatorNameH'];
    indicatorValue = json['indicatorValue'];
    finyear = json['finyear'];
    indicatorFlag = json['indicatorFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['indicatorName'] = this.indicatorName;
    data['indicatorNameH'] = this.indicatorNameH;
    data['indicatorValue'] = this.indicatorValue;
    data['finyear'] = this.finyear;
    data['indicatorFlag'] = this.indicatorFlag;
    return data;
  }
}

class Top7BlockPerformance {
  String? unitcode;
  String? unitname;
  int? unittype;
  double? performacePer;
  int? maxValueBlock;
  String? finyear;

  Top7BlockPerformance(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.performacePer,
        this.maxValueBlock,
        this.finyear});

  Top7BlockPerformance.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    performacePer = json['performacePer'];
    maxValueBlock = json['maxValueBlock'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['performacePer'] = this.performacePer;
    data['maxValueBlock'] = this.maxValueBlock;
    data['finyear'] = this.finyear;
    return data;
  }
}

class MaternalDeaths {
  String? unitcode;
  String? unitname;
  int? unittype;
  int? deathCount;
  String? finyear;

  MaternalDeaths(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.deathCount,
        this.finyear});

  MaternalDeaths.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    deathCount = json['deathCount'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['deathCount'] = this.deathCount;
    data['finyear'] = this.finyear;
    return data;
  }
}

class InfantDeaths {
  String? unitcode;
  String? unitname;
  int? unittype;
  int? deathCount;
  String? finyear;

  InfantDeaths(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.deathCount,
        this.finyear});

  InfantDeaths.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    deathCount = json['deathCount'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['deathCount'] = this.deathCount;
    data['finyear'] = this.finyear;
    return data;
  }
}

class Sterlization {
  String? unitcode;
  String? unitname;
  int? unittype;
  String? monthName;
  String? monthValue;
  int? sterlizationCount;
  String? finyear;

  Sterlization(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.monthName,
        this.monthValue,
        this.sterlizationCount,
        this.finyear});

  Sterlization.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    monthName = json['monthName'];
    monthValue = json['monthValue'];
    sterlizationCount = json['sterlizationCount'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['monthName'] = this.monthName;
    data['monthValue'] = this.monthValue;
    data['sterlizationCount'] = this.sterlizationCount;
    data['finyear'] = this.finyear;
    return data;
  }
}

class SexRatio {
  String? unitcode;
  String? unitname;
  int? unittype;
  String? monthName;
  int? monthValue;
  int? girlsRatio;
  String? finyear;

  SexRatio(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.monthName,
        this.monthValue,
        this.girlsRatio,
        this.finyear});

  SexRatio.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    monthName = json['monthName'];
    monthValue = json['monthValue'];
    girlsRatio = json['girlsRatio'];
    finyear = json['finyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['monthName'] = this.monthName;
    data['monthValue'] = this.monthValue;
    data['girlsRatio'] = this.girlsRatio;
    data['finyear'] = this.finyear;
    return data;
  }
}

class VaccineRequirement {
  String? unitcode;
  String? unitname;
  int? unittype;
  String? immuName;
  int? vaccineReqCount;
  int? vaccFlag;
  String? finyear;
  String? immuNameH;

  VaccineRequirement(
      {this.unitcode,
        this.unitname,
        this.unittype,
        this.immuName,
        this.vaccineReqCount,
        this.vaccFlag,
        this.finyear,
        this.immuNameH});

  VaccineRequirement.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unitname = json['unitname'];
    unittype = json['unittype'];
    immuName = json['immuName'];
    vaccineReqCount = json['vaccineReqCount'];
    vaccFlag = json['vaccFlag'];
    finyear = json['finyear'];
    immuNameH = json['immuNameH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unitname'] = this.unitname;
    data['unittype'] = this.unittype;
    data['immuName'] = this.immuName;
    data['vaccineReqCount'] = this.vaccineReqCount;
    data['vaccFlag'] = this.vaccFlag;
    data['finyear'] = this.finyear;
    data['immuNameH'] = this.immuNameH;
    return data;
  }
}

class HighRisk {
  String? unitcode;
  int? unittype;
  String? finyear;
  String? highRiskName;
  String? highRiskNameH;
  double? highRiskValue;

  HighRisk(
      {this.unitcode,
        this.unittype,
        this.finyear,
        this.highRiskName,
        this.highRiskNameH,
        this.highRiskValue});

  HighRisk.fromJson(Map<String, dynamic> json) {
    unitcode = json['unitcode'];
    unittype = json['unittype'];
    finyear = json['finyear'];
    highRiskName = json['highRiskName'];
    highRiskNameH = json['highRiskNameH'];
    highRiskValue = json['highRiskValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitcode'] = this.unitcode;
    data['unittype'] = this.unittype;
    data['finyear'] = this.finyear;
    data['highRiskName'] = this.highRiskName;
    data['highRiskNameH'] = this.highRiskNameH;
    data['highRiskValue'] = this.highRiskValue;
    return data;
  }
}
