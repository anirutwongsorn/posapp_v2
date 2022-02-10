class DailySaleRptModel {
  String billDt;
  String amtTxt;
  double? amt;
  String amtChanged;
  String isPlus;
  String lastActivity;

  DailySaleRptModel(
      {this.billDt = '',
      this.amtTxt = '',
      this.amt = 0,
      this.amtChanged = '',
      this.isPlus = '',
      this.lastActivity = ''});

  factory DailySaleRptModel.fromJson(Map<String, dynamic> json) {
    return DailySaleRptModel(
        billDt: json["BILLDT"] == null ? '' : json["BILLDT"],
        amtTxt: json["AMT_TXT"] == null ? '0' : json["AMT_TXT"],
        amtChanged: json["AMT_CHNGD"] == null ? '0' : json["AMT_CHNGD"],
        isPlus: json["isPlus"] == null ? '0' : json["isPlus"],
        lastActivity: json["LSTACTV"] == null ? '' : json["LSTACTV"],
        amt: double.tryParse(json["AMT_TXT"].toString().replaceAll(',', '')));
  }
//

}
