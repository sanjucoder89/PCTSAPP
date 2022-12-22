class GetCHCPHCData {
  String? unitCode;
  String? unitName;
  int? unitID;

  GetCHCPHCData({this.unitCode, this.unitName, this.unitID});

  GetCHCPHCData.fromJson(Map<String, dynamic> json) {
    unitCode = json['UnitCode'];
    unitName = json['UnitName'];
    unitID = json['UnitID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitCode'] = this.unitCode;
    data['UnitName'] = this.unitName;
    data['UnitID'] = this.unitID;
    return data;
  }
}
