class GetHBYCSUBListData {
  int? unitID;
  String? unitName;
  String? unitCode;

  GetHBYCSUBListData({this.unitID, this.unitName, this.unitCode});

  GetHBYCSUBListData.fromJson(Map<String, dynamic> json) {
    unitID = json['UnitID'];
    unitName = json['UnitName'];
    unitCode = json['UnitCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnitID'] = this.unitID;
    data['UnitName'] = this.unitName;
    data['UnitCode'] = this.unitCode;
    return data;
  }
}
