import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_global/global_variable.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/inventory/product_inventory_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/bill/daily_bill_main_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/summary/daily_sale_rpt_bloc.dart';
import 'package:posapp_v2/provider/models/model_member.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  MemberBloc? _memberBloc;

  LoginBloc? _loginBloc;

  DailyBillMainBloc? _billMainBloc;

  ProductInventoryBloc? _inventoryBloc;

  DailySaleRptBloc? _dailySaleRptBloc;

  double _width = 0;

  Color _black = Colors.black.withOpacity(.4);

  Future<void> getInitDB() async {
    _memberBloc = BlocProvider.of<MemberBloc>(context);
    if (_memberBloc!.state is! MemberLoadSuccess) {
      _memberBloc!.add(GetMember());
    }
  }

  Future<void> changedDB(
      {required String dbname, required String branch}) async {
    _memberBloc!.add(SetChangedBranch(dbname: dbname, branch: branch));
    getInitDB();
  }

  Future<void> postLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(GlobalVariable.accessToken);
    prefs.remove(GlobalVariable.username);
    prefs.remove(GlobalVariable.dbName);
    prefs.remove(GlobalVariable.branch);

    _billMainBloc!.add(ResetBillMainState());

    _inventoryBloc!.add(ResetInventory());

    _dailySaleRptBloc!.add(ResetDailySaleState());
    _memberBloc!.add(ResetMemberState());

    _loginBloc!.add(CheckLogin());
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc!.add(CheckLogin());

    _memberBloc = BlocProvider.of<MemberBloc>(context);

    _billMainBloc = BlocProvider.of<DailyBillMainBloc>(context);
    _inventoryBloc = BlocProvider.of<ProductInventoryBloc>(context);
    _dailySaleRptBloc = BlocProvider.of<DailySaleRptBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _buildLoadMember(),
    );
  }

  _buildLoadMember() {
    return BlocListener(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginLoggedOut) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => route is LoginPage);
        }
      },
      child: BlocBuilder<MemberBloc, MemberState>(
        bloc: _memberBloc,
        builder: (context, state) {
          if (state is MemberInitial || state is MemberWaiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MemberLoadSuccess) {
            var model = state.model;

            return _buildMainUI(model: model);
          }

          return buildEmptySection(errMsg: 'ไม่พบข้อมูลที่ค้นหา');
        },
      ),
    );
  }

  _buildMainUI({required List<MemberModel> model}) {
    return Container(
      decoration: buildGradientColor(borderR: 0),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: double.infinity,
                  width: _width,
                  decoration:
                      buildGradientColor(color2: _black, color1: _black),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          // decoration: buildGradientColor(
                          //     color1: _black, color2: _black),
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'ข้อมูลสมาชิก/สาขา',
                            style: buildAppTextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: model.length,
                            itemBuilder: (context, index) {
                              var _data = model[index];
                              return InkWell(
                                onTap: () {
                                  changedDB(
                                      dbname: _data.dbName,
                                      branch: _data.branch);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.check_box,
                                    color: _data.dbName == _memberBloc!.initDB
                                        ? DARK_GREEN
                                        : SOFT_GREY,
                                  ),
                                  title: Container(
                                    width: _width / 1.3,
                                    child: Text(
                                      _data.branch,
                                      overflow: TextOverflow.clip,
                                      style: buildAppTextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  subtitle: Container(
                                    width: _width / 1.3,
                                    child: Text(
                                      _data.address,
                                      style: buildAppTextStyle(
                                          color: Colors.white, fontSize: 16),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Divider(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      icon: Icon(Icons.lock),
                      label: Text(
                        'ออกจากระบบ',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        showMyDialogLoading();
                        postLoggedOut();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialogLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(title),
          content: SingleChildScrollView(
            child: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
