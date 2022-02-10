class DailySummary {
  String title;
  String details;
  String billDt;
  String amt;
  String paid;
  String expends;
  String gTotal;

  DailySummary(
      {this.title = '',
      this.details = '',
      this.billDt = '',
      this.amt = '',
      this.paid = '',
      this.expends = '',
      this.gTotal = ''});

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      title: json["TITLE"],
      details: json["DETAILS"],
      billDt: json["BILLDT"],
      amt: json["AMT"],
      paid: json["PAID"],
      expends: json["EXPENDS"],
      gTotal: json["GTOTAL"],
    );
  }
}
