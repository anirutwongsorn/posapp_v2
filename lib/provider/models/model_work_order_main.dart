class WorkOrderMain {
  String billCd;
  String billDt;
  String billTm;
  String employee;
  String amount;
  String discount;
  String grandTotal;
  String pCd;
  String pDesc;
  String uom;
  String qty;
  String price;
  String pdAmount;
  String itemDiscount;
  String billQty;

  WorkOrderMain({
    this.billCd = '',
    this.billDt = '',
    this.billTm = '',
    this.employee = '',
    this.amount = '',
    this.discount = '',
    this.grandTotal = '',
    this.pCd = '',
    this.pDesc = '',
    this.uom = '',
    this.qty = '',
    this.price = '',
    this.pdAmount = '',
    this.itemDiscount = '',
    this.billQty = '',
  });

  factory WorkOrderMain.fromJson(Map<String, dynamic> json) {
    return WorkOrderMain(
      billCd: json["BILLCD"] == null ? '' : json["BILLCD"],
      billDt: json["BILLDT"] == null ? '' : json["BILLDT"],
      billTm: json["BILLTM"] == null ? '' : json["BILLTM"],
      employee: json["EMP"] == null ? '' : json["EMP"],
      amount: json["AMNT"] == null ? '0' : json["AMNT"],
      discount: json["DISCNT"] == null ? '0' : json["DISCNT"],
      grandTotal: json["GTOTAL"] == null ? '0' : json["GTOTAL"],
      pCd: json["PCD"] == null ? '' : json["PCD"],
      pDesc: json["PDESC"] == null ? '' : json["PDESC"],
      uom: json["UOM"] == null ? '' : json["UOM"],
      qty: json["QTY"] == null ? '0' : json["QTY"],
      price: json["PRCS"] == null ? '0' : json["PRCS"],
      pdAmount: json["ITMAMNT"] == null ? '0' : json["ITMAMNT"],
      itemDiscount: json["ITMDISCNT"] == null ? '0' : json["ITMDISCNT"],
      billQty: json["BILLQTY"] == null ? '0' : json["BILLQTY"],
    );
  }
}
