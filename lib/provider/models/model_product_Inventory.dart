class ProductInvModel {
  String pcd;
  String pdDesc;
  String uom;
  String price;
  String pdType;
  String invBalance;
  String lastActivity;

  ProductInvModel(
      {this.pcd = '',
      this.pdDesc = '',
      this.uom = '',
      this.price = '',
      this.pdType = '',
      this.invBalance = '',
      this.lastActivity = ''});

  factory ProductInvModel.fromJson(Map<String, dynamic> json) {
    return ProductInvModel(
      pcd: json["PCD"],
      pdDesc: json["PDESC"],
      uom: json["UOM"],
      price: json["PRCS_L1"],
      pdType: json["MTRL_TYPE"],
      invBalance: json["BLQTY"],
      lastActivity: json["LASTACTV"],
    );
  }
//

}
