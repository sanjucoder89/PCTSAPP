class GetAnmRankData {
  int? appVersion;
  String? message;
  bool? status;
  List<ResposeData>? resposeData;

  GetAnmRankData(
      {this.appVersion, this.message, this.status, this.resposeData});

  GetAnmRankData.fromJson(Map<String, dynamic> json) {
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
  int? districtWiseRCHRank;
  int? blockWiseRCHRank;
  int? districtWiseRankANC3;
  int? districtWiseRankInstDel;
  int? districtWiseRankFullImmu;
  int? districtWiseRankIUD;
  int? districtWiseRankSter;
  int? blockWiseRankANC3;
  int? blockWiseRankInstDel;
  int? blockWiseRankFullImmu;
  int? blockWiseRankIUD;
  int? blockWiseRankSter;
  int? districtWiseTotalUnit;
  int? blockWiseRankTotalUnit;
  int? stateWiseTotalUnit;
  int? stateWiseRCHRank;
  int? stateWiseRankANC3;
  int? stateWiseRankInstDel;
  int? stateWiseRankFullImmu;
  int? stateWiseRankIUD;
  int? stateWiseRankSter;
  int? stateWiseEmoji;
  int? districtWiseEmoji;
  int? blockWiseEmoji;

  ResposeData(
      {this.districtWiseRCHRank,
        this.blockWiseRCHRank,
        this.districtWiseRankANC3,
        this.districtWiseRankInstDel,
        this.districtWiseRankFullImmu,
        this.districtWiseRankIUD,
        this.districtWiseRankSter,
        this.blockWiseRankANC3,
        this.blockWiseRankInstDel,
        this.blockWiseRankFullImmu,
        this.blockWiseRankIUD,
        this.blockWiseRankSter,
        this.districtWiseTotalUnit,
        this.blockWiseRankTotalUnit,
        this.stateWiseTotalUnit,
        this.stateWiseRCHRank,
        this.stateWiseRankANC3,
        this.stateWiseRankInstDel,
        this.stateWiseRankFullImmu,
        this.stateWiseRankIUD,
        this.stateWiseRankSter,
        this.stateWiseEmoji,
        this.districtWiseEmoji,
        this.blockWiseEmoji});

  ResposeData.fromJson(Map<String, dynamic> json) {
    districtWiseRCHRank = json['DistrictWiseRCHRank'];
    blockWiseRCHRank = json['BlockWiseRCHRank'];
    districtWiseRankANC3 = json['DistrictWiseRank_ANC3'];
    districtWiseRankInstDel = json['DistrictWiseRank_InstDel'];
    districtWiseRankFullImmu = json['DistrictWiseRank_FullImmu'];
    districtWiseRankIUD = json['DistrictWiseRank_IUD'];
    districtWiseRankSter = json['DistrictWiseRank_Ster'];
    blockWiseRankANC3 = json['BlockWiseRank_ANC3'];
    blockWiseRankInstDel = json['BlockWiseRank_InstDel'];
    blockWiseRankFullImmu = json['BlockWiseRank_FullImmu'];
    blockWiseRankIUD = json['BlockWiseRank_IUD'];
    blockWiseRankSter = json['BlockWiseRank_Ster'];
    districtWiseTotalUnit = json['DistrictWise_TotalUnit'];
    blockWiseRankTotalUnit = json['BlockWiseRank_TotalUnit'];
    stateWiseTotalUnit = json['StateWiseTotalUnit'];
    stateWiseRCHRank = json['StateWiseRCHRank'];
    stateWiseRankANC3 = json['StateWiseRank_ANC3'];
    stateWiseRankInstDel = json['StateWiseRank_InstDel'];
    stateWiseRankFullImmu = json['StateWiseRank_FullImmu'];
    stateWiseRankIUD = json['StateWiseRank_IUD'];
    stateWiseRankSter = json['StateWiseRank_Ster'];
    stateWiseEmoji = json['StateWiseEmoji'];
    districtWiseEmoji = json['DistrictWiseEmoji'];
    blockWiseEmoji = json['BlockWiseEmoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DistrictWiseRCHRank'] = this.districtWiseRCHRank;
    data['BlockWiseRCHRank'] = this.blockWiseRCHRank;
    data['DistrictWiseRank_ANC3'] = this.districtWiseRankANC3;
    data['DistrictWiseRank_InstDel'] = this.districtWiseRankInstDel;
    data['DistrictWiseRank_FullImmu'] = this.districtWiseRankFullImmu;
    data['DistrictWiseRank_IUD'] = this.districtWiseRankIUD;
    data['DistrictWiseRank_Ster'] = this.districtWiseRankSter;
    data['BlockWiseRank_ANC3'] = this.blockWiseRankANC3;
    data['BlockWiseRank_InstDel'] = this.blockWiseRankInstDel;
    data['BlockWiseRank_FullImmu'] = this.blockWiseRankFullImmu;
    data['BlockWiseRank_IUD'] = this.blockWiseRankIUD;
    data['BlockWiseRank_Ster'] = this.blockWiseRankSter;
    data['DistrictWise_TotalUnit'] = this.districtWiseTotalUnit;
    data['BlockWiseRank_TotalUnit'] = this.blockWiseRankTotalUnit;
    data['StateWiseTotalUnit'] = this.stateWiseTotalUnit;
    data['StateWiseRCHRank'] = this.stateWiseRCHRank;
    data['StateWiseRank_ANC3'] = this.stateWiseRankANC3;
    data['StateWiseRank_InstDel'] = this.stateWiseRankInstDel;
    data['StateWiseRank_FullImmu'] = this.stateWiseRankFullImmu;
    data['StateWiseRank_IUD'] = this.stateWiseRankIUD;
    data['StateWiseRank_Ster'] = this.stateWiseRankSter;
    data['StateWiseEmoji'] = this.stateWiseEmoji;
    data['DistrictWiseEmoji'] = this.districtWiseEmoji;
    data['BlockWiseEmoji'] = this.blockWiseEmoji;
    return data;
  }
}
