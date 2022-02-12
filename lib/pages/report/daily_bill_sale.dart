import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_global/global_error_alert.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/pages/report/daily_bill_sale_details.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/bill/daily_bill_main_bloc.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

class DailyBillMainPage extends StatefulWidget {
  const DailyBillMainPage({Key? key}) : super(key: key);

  @override
  _DailyBillMainPageState createState() => _DailyBillMainPageState();
}

class _DailyBillMainPageState extends State<DailyBillMainPage>
    with AutomaticKeepAliveClientMixin {
  DailyBillMainBloc? _billMainBloc;

  MemberBloc? _memberBloc;

  LoginBloc? _loginBloc;

  String dbname = "", branch = "";

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc!.add(CheckLogin());

    _memberBloc = BlocProvider.of<MemberBloc>(context);
    if (_memberBloc!.state is! MemberLoadSuccess) {
      _memberBloc!.add(GetMember());
    }

    _billMainBloc = BlocProvider.of<DailyBillMainBloc>(context);

    getDatabaseName();

    super.initState();
  }

  Future<void> getDatabaseName() async {
    dbname = await NetworkService().getInitDB();
    branch = await NetworkService().getBranch();
    if (_billMainBloc!.state is! DailyBillMainLoadSuccess) {
      _billMainBloc!.add(GetDailyBillMain(dbName: dbname));
    }
  }

  Future _handleRefresh() async {
    // await Future.delayed(Duration(
    //   seconds: 2,
    // ));
    await getDatabaseName();
    _billMainBloc!.add(GetDailyBillMain(dbName: dbname));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: SOFT_BLUE,
      body: _buildMainUI(),
    );
  }

  _buildMainUI() {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginLoggedOut) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginPage(),
              ),
              (Route<dynamic> route) => route is LoginPage);
        }
      },
      child: SafeArea(
        child: _buildLoadDataFromServer(),
      ),
    );
  }

  _buildLoadDataFromServer() {
    return BlocBuilder(
      bloc: _billMainBloc,
      builder: (context, state) {
        if (state is DailyBillMainLoadSuccess) {
          var _data = state.model;
          return _buildBillList(model: _data);
        }

        if (state is DailyBillMainLoadError) {
          return _showDialog();
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildTitleHeader() {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      decoration: buildBlackDecoration(),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ประวัติบิลขาย',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          buildAppDivider(),
          Text(
            branch == "" ? _memberBloc!.branch : branch,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  _buildBillList({required List<WorkOrderMain> model}) {
    var _data = model;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 80, top: 8),
        children: [
          _buildTitleHeader(),
          SizedBox(height: 8),
          Container(
            decoration: buildBlackDecoration(),
            child: ListView.separated(
              padding: EdgeInsets.only(top: 8),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DailyBillDetailsPage(billCd: _data[index].billCd),
                      ),
                    );
                  },
                  child: ListTile(
                    title: _buildTextRow(
                        leading: 'เลขที่', trailing: _data[index].billCd),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextRow(
                            txtSize: 14,
                            leading: 'วันที่',
                            trailing: _data[index].billDt +
                                ' ' +
                                _data[index].billTm),
                        _buildText(
                            txt: _data[index].employee,
                            txtSize: 14,
                            color: Colors.white70)
                      ],
                    ),
                    trailing: Text(
                      _data[index].grandTotal,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.lightGreenAccent),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.white.withOpacity(.5),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildText(
      {String txt = '', Color color = Colors.white, double txtSize = 16}) {
    return Text(
      txt,
      style: TextStyle(color: color, fontSize: txtSize),
    );
  }

  _buildTextRow(
      {String leading = '',
      String trailing = '',
      Color color = Colors.white,
      double txtSize = 16}) {
    return Row(
      children: [
        Text(
          leading + ' : ',
          style: TextStyle(color: color.withOpacity(.7), fontSize: txtSize),
        ),
        Text(
          trailing,
          style: TextStyle(color: color, fontSize: txtSize),
        ),
      ],
    );
  }

  _showDialog() {
    return showDialog(
      context: context,
      builder: (context) => ErrorAlertDialog(
        title: 'ผิดพลาด',
        content: 'โหลดข้อมูลผิดพลาด',
      ),
    );
  }
}
