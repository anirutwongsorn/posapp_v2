class MemberModel {
  String memberCD;
  String memberDesc;
  String branch;
  String address;
  String initDB;
  String dbName;

  MemberModel(
      {this.memberCD = '',
      this.memberDesc = '',
      this.branch = '',
      this.address = '',
      this.initDB = '',
      this.dbName = ''});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberCD: json["CUST_CD"],
      memberDesc: json["CUS_DESC"],
      branch: json["BRANCH"],
      address: json["ADDRSS"],
      initDB: json["INITDB"],
      dbName: json["DBNAME"],
    );
  }
//

}
