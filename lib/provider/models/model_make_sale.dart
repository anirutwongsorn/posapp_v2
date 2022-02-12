class MakeSale {
  String? billDate;
  double? actualSale;
  double? makeSale;
  bool? isActive;
  DateTime? lastActivity;

  MakeSale(
      {this.billDate,
      this.actualSale,
      this.makeSale,
      this.isActive,
      this.lastActivity});

  factory MakeSale.fromJson(Map<String, dynamic> json) {
    return MakeSale(
      billDate: json["BILLDT"].toString(),
      actualSale: json["ActSale"] as double,
      makeSale: json["MakeSale"] as double,
      isActive: json["ISACTV"] as bool,
      lastActivity: DateTime.parse(json["LSACTV"]),
    );
  }
}
