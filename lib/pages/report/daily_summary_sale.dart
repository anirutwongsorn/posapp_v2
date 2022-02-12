import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_constants/app_error_widgets.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/pages/make_sale/make_sale_page.dart';
import 'package:posapp_v2/pages/report/chart_component.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/summary/daily_sale_rpt_bloc.dart';
import 'package:posapp_v2/provider/models/model_daily_sale_rpt.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

class DailySaleReportPage extends StatefulWidget {
  const DailySaleReportPage({Key? key}) : super(key: key);

  @override
  _DailySaleReportPageState createState() => _DailySaleReportPageState();
}

class _DailySaleReportPageState extends State<DailySaleReportPage>
    with AutomaticKeepAliveClientMixin {
  DailySaleRptBloc? _dailySaleRptBloc;

  LoginBloc? _loginBloc;

  MemberBloc? _memberBLOC;

  String dbname = "", branch = "";

  Future _handleRefresh() async {
    // await Future.delayed(Duration(
    //   seconds: 2,
    // ));
    await _getDatabaseName();
    _dailySaleRptBloc!.add(GetDailySaleReport(dbName: this.dbname));
  }

  Future<void> _getDatabaseName() async {
    dbname = await NetworkService().getInitDB();
    branch = await NetworkService().getBranch();
    print('dbname :$dbname');
    print('branch :$branch');
    if (_dailySaleRptBloc!.state is! DailySaleRptLoadSuccess) {
      _dailySaleRptBloc!.add(GetDailySaleReport(dbName: this.dbname));
    }
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _dailySaleRptBloc = BlocProvider.of<DailySaleRptBloc>(context);

    _memberBLOC = BlocProvider.of<MemberBloc>(context);
    if (_memberBLOC!.state is! MemberLoadSuccess) {
      _memberBLOC!.add(GetMember());
    }

    _getDatabaseName();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // _width = MediaQuery.of(context).size.width;
    // _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PRIMARY_COLOR, SOFT_BLUE],
            stops: [0.3, 0.95],
          ),
        ),
        child: _buildLoadReportFromServer(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakeSalePage(),
            ),
          );
        },
      ),
    );
  }

  _buildLoadReportFromServer() {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginLoggedOut) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => route is LoginPage);
        }
      },
      child: BlocBuilder<DailySaleRptBloc, DailySaleRptState>(
        bloc: _dailySaleRptBloc,
        builder: (context, state) {
          if (state is DailySaleRptLoadSuccess) {
            return _buildSaleRptWidgets(model: state.model);
          }

          if (state is DailySaleRptWaiting || state is DailySaleRptInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return AppErrorPage(callBack: _handleRefresh);
        },
      ),
    );
  }

  _buildSaleRptWidgets({required List<DailySaleRptModel> model}) {
    return Container(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 80),
          children: [
            _buildHeaderSection(model: model),
            SizedBox(height: 8),
            _buildListView(model: model),
          ],
        ),
      ),
    );
  }

  SafeArea _buildHeaderSection({required List<DailySaleRptModel> model}) {
    return SafeArea(
      child: Container(
        decoration: buildBlackDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              'รายงานยอดขาย',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              branch == "" ? _memberBLOC!.branch : branch,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            buildAppDivider(),
            _buildHeaderSummary(model: model),
          ],
        ),
      ),
    );
  }

  _buildHeaderSummary({required List<DailySaleRptModel> model}) {
    return ListTile(
      title: Text(
        model.length == 0 ? '-' : model[0].amtTxt,
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
          color: DARK_GREEN,
        ),
      ),
      subtitle: Text(
        model.length == 0 ? '-' : model[0].billDt,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      trailing: Text(
        model.length == 0 ? '-' : model[0].amtChanged,
        style: TextStyle(fontSize: 20, color: Colors.red.withOpacity(.7)),
      ),
    );
  }

  _buildListView({required List<DailySaleRptModel> model}) {
    return Container(
      decoration: buildBlackDecoration(),
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  model[index].isPlus == "Y"
                      ? Icons.arrow_circle_up_outlined
                      : Icons.arrow_circle_down,
                  color: model[index].isPlus == "Y" ? LIGHT_GREEN : SOFT_ORANGE,
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model[index].billDt,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      model[index].amtChanged,
                      style: TextStyle(
                        fontSize: 14,
                        color: model[index].isPlus == "Y"
                            ? LIGHT_GREEN
                            : SOFT_ORANGE,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Text(
              model[index].amtTxt,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.white60,
          );
        },
      ),
    );
  }
}
