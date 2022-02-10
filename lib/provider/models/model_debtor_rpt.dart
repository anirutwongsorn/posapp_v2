class DebtorRptModel {
  String billCD;
  String billDT;
  String cusCD;
  String cusDesc;
  String amtTxt;
  String paidTxt;
  String unpaidTxt;
  String totalAmt;

  DebtorRptModel(
      {this.billCD = '',
      this.billDT = '',
      this.cusCD = '',
      this.cusDesc = '',
      this.amtTxt = '',
      this.paidTxt = '',
      this.unpaidTxt = '',
      this.totalAmt = ''});

  factory DebtorRptModel.fromJson(Map<String, dynamic> json) {
    return DebtorRptModel(
      billCD: json["BILLCD"],
      billDT: json["BILLDT"],
      cusCD: json["CUSCD"],
      cusDesc: json["CUSDESC"],
      amtTxt: json["AMT_TXT"],
      paidTxt: json["PAID_TXT"],
      unpaidTxt: json["UNPAID_TXT"],
      totalAmt: json["TOTALTXT"],
    );
  }
//

}
