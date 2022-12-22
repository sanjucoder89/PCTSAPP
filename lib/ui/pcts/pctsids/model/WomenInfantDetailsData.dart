class WomenInfantDetailsData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  WomenInfantDetailsData(
      {this.appVersion, this.message, this.status, this.resposeData});

  WomenInfantDetailsData.fromJson(Map<String, dynamic> json) {
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
  int? pNCFlag;
  String? pNCDate;
  String? referUniName;
  String? pNCComp;
  int? child1IsLive;
  String? childName1;
  String? chilsID1;
  double? child1Weight;
  String? child1Compl;
  int? child2IsLive;
  String? childName2;
  String? chilsID2;
  double? child2Weight;
  String? child2Compl;
  int? child3IsLive;
  String? childName3;
  String? chilsID3;
  double? child3Weight;
  String? child3Compl;
  int? child4IsLive;
  String? childName4;
  String? chilsID4;
  double? child4Weight;
  String? child4Compl;
  int? child5IsLive;
  String? childName5;
  String? chilsID5;
  double? child5Weight;
  String? child5Compl;

  ResposeData(
      {this.pNCFlag,
        this.pNCDate,
        this.referUniName,
        this.pNCComp,
        this.child1IsLive,
        this.childName1,
        this.chilsID1,
        this.child1Weight,
        this.child1Compl,
        this.child2IsLive,
        this.childName2,
        this.chilsID2,
        this.child2Weight,
        this.child2Compl,
        this.child3IsLive,
        this.childName3,
        this.chilsID3,
        this.child3Weight,
        this.child3Compl,
        this.child4IsLive,
        this.childName4,
        this.chilsID4,
        this.child4Weight,
        this.child4Compl,
        this.child5IsLive,
        this.childName5,
        this.chilsID5,
        this.child5Weight,
        this.child5Compl});

  ResposeData.fromJson(Map<String, dynamic> json) {
    pNCFlag = json['PNCFlag'];
    pNCDate = json['PNCDate'];
    referUniName = json['ReferUniName'];
    pNCComp = json['PNCComp'];
    child1IsLive = json['Child1_IsLive'];
    childName1 = json['ChildName1'];
    chilsID1 = json['ChilsID1'];
    child1Weight = json['Child1_Weight'];
    child1Compl = json['Child1_Compl'];
    child2IsLive = json['Child2_IsLive'];
    childName2 = json['ChildName2'];
    chilsID2 = json['ChilsID2'];
    child2Weight = json['Child2_Weight'];
    child2Compl = json['Child2_Compl'];
    child3IsLive = json['Child3_IsLive'];
    childName3 = json['ChildName3'];
    chilsID3 = json['ChilsID3'];
    child3Weight = json['Child3_Weight'];
    child3Compl = json['Child3_Compl'];
    child4IsLive = json['Child4_IsLive'];
    childName4 = json['ChildName4'];
    chilsID4 = json['ChilsID4'];
    child4Weight = json['Child4_Weight'];
    child4Compl = json['Child4_Compl'];
    child5IsLive = json['Child5_IsLive'];
    childName5 = json['ChildName5'];
    chilsID5 = json['ChilsID5'];
    child5Weight = json['Child5_Weight'];
    child5Compl = json['Child5_Compl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PNCFlag'] = this.pNCFlag;
    data['PNCDate'] = this.pNCDate;
    data['ReferUniName'] = this.referUniName;
    data['PNCComp'] = this.pNCComp;
    data['Child1_IsLive'] = this.child1IsLive;
    data['ChildName1'] = this.childName1;
    data['ChilsID1'] = this.chilsID1;
    data['Child1_Weight'] = this.child1Weight;
    data['Child1_Compl'] = this.child1Compl;
    data['Child2_IsLive'] = this.child2IsLive;
    data['ChildName2'] = this.childName2;
    data['ChilsID2'] = this.chilsID2;
    data['Child2_Weight'] = this.child2Weight;
    data['Child2_Compl'] = this.child2Compl;
    data['Child3_IsLive'] = this.child3IsLive;
    data['ChildName3'] = this.childName3;
    data['ChilsID3'] = this.chilsID3;
    data['Child3_Weight'] = this.child3Weight;
    data['Child3_Compl'] = this.child3Compl;
    data['Child4_IsLive'] = this.child4IsLive;
    data['ChildName4'] = this.childName4;
    data['ChilsID4'] = this.chilsID4;
    data['Child4_Weight'] = this.child4Weight;
    data['Child4_Compl'] = this.child4Compl;
    data['Child5_IsLive'] = this.child5IsLive;
    data['ChildName5'] = this.childName5;
    data['ChilsID5'] = this.chilsID5;
    data['Child5_Weight'] = this.child5Weight;
    data['Child5_Compl'] = this.child5Compl;
    return data;
  }
}
