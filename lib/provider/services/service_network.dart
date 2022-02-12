import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posapp_v2/app_global/global_variable.dart';
import 'package:posapp_v2/provider/models/model_daily_sale_rpt.dart';
import 'package:posapp_v2/provider/models/model_daily_summary.dart';
import 'package:posapp_v2/provider/models/model_debtor_rpt.dart';
import 'package:posapp_v2/provider/models/model_login.dart';
import 'package:posapp_v2/provider/models/model_make_sale.dart';
import 'package:posapp_v2/provider/models/model_member.dart';
import 'package:posapp_v2/provider/models/model_product_Inventory.dart';
import 'package:posapp_v2/provider/models/model_register.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  NetworkService._instant();
  static final NetworkService _internal = NetworkService._instant();
  factory NetworkService() => _internal;

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _accessToken = prefs.getString(GlobalVariable.accessToken);
    if (_accessToken == null) {
      return "";
    }
    return _accessToken;
  }

  Future<String> getInitDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _initDB = prefs.getString(GlobalVariable.dbName);
    if (_initDB == null) {
      return "";
    }
    return _initDB;
  }

  Future<String> getBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _initDB = prefs.getString(GlobalVariable.branch);
    if (_initDB == null) {
      return "";
    }
    return _initDB;
  }

  Future<void> setBranch(
      {required String initDB, required String branch}) async {
    print('initDB :$initDB, branch: $branch');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(GlobalVariable.dbName);
    await prefs.remove(GlobalVariable.branch);
    await prefs.setString(GlobalVariable.dbName, initDB);
    await prefs.setString(GlobalVariable.branch, branch);
  }

  Future<List<DailySummary>> getDailySummary({required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/daily_summary_allIncome?dbname=$dbname";

    print(_url);
    List<DailySummary> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['DAILYSUMMARY'];
        _db = list.map((m) => DailySummary.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DailySaleRptModel>> getDailySalesReport(
      {required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/daily_summary_v2?dbname=$dbname";
    print(_url);
    List<DailySaleRptModel> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['dailyrpt'];
        _db = list.map((m) => DailySaleRptModel.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<DebtorRptModel>> getDebtorReport({required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/daily_report_with_paid?dbname=$dbname";
    print(_url);
    List<DebtorRptModel> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['dailypaidrpt'];
        _db = list.map((m) => DebtorRptModel.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ProductInvModel>> getInventory({required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/getProductInv?dbname=$dbname";
    print(_url);
    List<ProductInvModel> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['model'];
        _db = list.map((m) => ProductInvModel.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ProductInvModel>> getInventoryV2(
      {required String dbname, required String filterWord}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/getProductInvV2?dbname=$dbname&filterWord=$filterWord";
    print(_url);
    List<ProductInvModel> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['model'];
        _db = list.map((m) => ProductInvModel.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> postModifyPrice(
      {required ProductInvModel model, required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/postProductPrice?dbname=$dbname";
    print(_url);

    final _body = {
      "PCD": model.pcd,
      "PDESC": model.pdDesc,
      "UOM": "",
      "MTRL_TYPE": "METAL",
      "PRCS_L1": model.price,
      "BLQTY": "0",
      "LASTACTV": "",
    };
    print(_body);
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      var response = await http.post(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"},
          body: _body);
      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        var isOk = jsonRes['isOK'];
        if (isOk != 'OK') {
          throw Exception('ข้อมูลสินค้าไม่ถูกต้อง');
        }
        return true;
      }
    } catch (e) {
      throw e;
    }
    return false;
  }

  Future<List<MemberModel>> getMember() async {
    var _url = GlobalVariable.SERVER_URL + "api/member/data";
    print(_url);
    List<MemberModel> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['MemberBranch'];
        _db = list.map((m) => MemberModel.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> checkTokenExpired() async {
    List<MemberModel> _memberDB = [];
    try {
      _memberDB = await getMember();
      if (_memberDB.length == 0) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<WorkOrderMain>> getDailyBill({required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/bill_workorder_main?dbname=$dbname";

    print(_url);
    //List<WorkOrderMain> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print(_token);
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['billwo'];
        var _db = list.map((m) => WorkOrderMain.fromJson(m)).toList();
        print(_db.length);
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<WorkOrderMain>> getDailyBillDetails(
      {required String dbname, required String billCd}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/bill_workorder_details?billcd=$billCd&dbname=$dbname";

    print(_url);
    List<WorkOrderMain> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['billwo'];
        _db = list.map((m) => WorkOrderMain.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<WorkOrderMain>> getDailyBillEmployee(
      {required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/bill_workorder_main_employee?dbname=$dbname";

    print(_url);
    List<WorkOrderMain> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['billwo'];
        _db = list.map((m) => WorkOrderMain.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  //===============Account=================

  Future<bool> postLogin({required LoginModel model}) async {
    var _url = GlobalVariable.SERVER_URL + "api/account/Login";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(GlobalVariable.accessToken);
    prefs.remove(GlobalVariable.username);
    prefs.remove(GlobalVariable.dbName);
    prefs.remove(GlobalVariable.branch);

    print(_url);
    //bool isOk = false;
    final _body = {
      "USER_NAME": model.username,
      "PASSWORD": model.password,
    };
    print(_body);
    try {
      var url = Uri.parse(_url);
      var response = await http.post(url, body: _body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        var _err = jsonRes['err'] as String;
        print('isSuccess : ${response.statusCode}');
        if (_err != "") {
          throw Exception(jsonRes['err']);
        }
        var _token = jsonRes['accessToken'] as String;
        print(_token);
        await prefs.setString(GlobalVariable.username, model.username);
        await prefs.setString(GlobalVariable.accessToken, _token);
        var _userList = await getMember();
        if (_userList.length > 0) {
          await prefs.setString(GlobalVariable.dbName, _userList[0].initDB);
          await prefs.setString(GlobalVariable.branch, _userList[0].branch);
        }
        return true;
      }
    } catch (e) {
      throw e;
    }
    return false;
  }

  Future<void> postRegister({required RegisterModel model}) async {
    var _url = GlobalVariable.SERVER_URL + "api/account/register";
    print(_url);
    final _body = {
      "username": model.username,
      "password": model.password,
      "shopname": model.shop,
      "address": model.address,
      "dbname": model.dbname,
    };
    print(_body);
    try {
      var url = Uri.parse(_url);
      var response = await http.post(url, body: _body);
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw 'Server error status ${response.statusCode}';
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<MakeSale>> getMakeSale({required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/get_make_sale?dbname=$dbname";
    print(_url);
    List<MakeSale> _db = [];
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      http.Response resp = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        var jsonRes = json.decode(resp.body);
        List list = jsonRes['data'];
        print(list);

        _db = list.map((m) => MakeSale.fromJson(m)).toList();
        return _db;
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      print('error: ' + e.toString());
      throw e.toString();
    }
  }

  Future<void> postMakeSale(
      {required MakeSale model, required String dbname}) async {
    var _url = GlobalVariable.SERVER_URL +
        "api/manitexpert/post_make_sale?dbname=$dbname";
    print(_url);
    try {
      var url = Uri.parse(_url);
      var _token = await getAccessToken();
      var _body = {
        "BILLDT": '${model.billDate}',
        "ActSale": '0',
        "MakeSale": '${model.makeSale}',
        "ISACTV": 'false',
        "LSACTV": DateTime.now().toString()
      };
      print(_body);
      http.Response resp = await http.post(url,
          body: _body,
          headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
      print('statusCode :${resp.statusCode}');
      if (resp.statusCode == 200) {
        print('Success');
      } else {
        throw Exception('กรุณาลงชื่อเข้าสู่ระบบ');
      }
    } catch (e) {
      print('error: ' + e.toString());
      throw e.toString();
    }
  }
}
