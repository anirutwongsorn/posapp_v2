import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_constants/app_error_widgets.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/employee/daily_employee_bloc.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

class DailySaleEmployeePage extends StatefulWidget {
  const DailySaleEmployeePage({Key? key}) : super(key: key);

  @override
  _DailySaleEmployeePageState createState() => _DailySaleEmployeePageState();
}

class _DailySaleEmployeePageState extends State<DailySaleEmployeePage>
    with AutomaticKeepAliveClientMixin {
  String dbname = "", branch = "";

  MemberBloc? _memberBLOC;

  DailyEmployeeBloc? _employeeBloc;

  Color _black = Colors.black.withOpacity(.5);
  Color _black2 = Colors.black.withOpacity(.3);

  @override
  bool get wantKeepAlive => true;

  Future<void> getDatabaseName() async {
    dbname = await NetworkService().getInitDB();
    branch = await NetworkService().getBranch();

    if (_employeeBloc!.state is! DailyEmployeeSuccess) {
      _employeeBloc!.add(GetDailyEmployee(dbName: dbname));
    }
  }

  Future _handleRefresh() async {
    // await Future.delayed(Duration(
    //   seconds: 2,
    // ));
    await getDatabaseName();
    _employeeBloc!.add(GetDailyEmployee(dbName: dbname));
  }

  @override
  void initState() {
    getDatabaseName();

    _employeeBloc = BlocProvider.of<DailyEmployeeBloc>(context);

    _memberBLOC = BlocProvider.of<MemberBloc>(context);
    if (_memberBLOC!.state is! MemberLoadSuccess) {
      _memberBLOC!.add(GetMember());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildMainUI();
  }

  _buildMainUI() {
    return Container(
      decoration: buildGradientColor(
          borderR: 0, color1: PRIMARY_COLOR, color2: SOFT_BLUE),
      child: SafeArea(
        child: _buildLoadDataFromServer(),
      ),
    );
  }

  BlocBuilder<DailyEmployeeBloc, DailyEmployeeState>
      _buildLoadDataFromServer() {
    return BlocBuilder<DailyEmployeeBloc, DailyEmployeeState>(
      bloc: _employeeBloc,
      builder: (context, state) {
        if (state is DailyEmployeeSuccess) {
          var _data = state.model;
          return _buildBillList(model: _data);
        }

        if (state is DailyEmployeeError) {
          return AppErrorPage(
            callBack: _handleRefresh,
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildBillList({required List<WorkOrderMain> model}) {
    var _data = model;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 80),
        children: [
          _buildTitleHeader(),
          ListView.builder(
            padding: EdgeInsets.only(top: 8),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                decoration: buildGradientColor(
                    color1: _black2, color2: _black2, borderR: 12),
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListTile(
                    title: buildAppText(
                        txt: _data[index].employee,
                        fontSize: 16,
                        color: Colors.white),
                    subtitle: buildAppText(
                        txt: 'จำนวนบิล : ' + _data[index].billQty,
                        color: Colors.white),
                    trailing: buildAppText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      txt: _data[index].grandTotal,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _buildTitleHeader() {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      decoration:
          buildGradientColor(color1: _black, color2: _black, borderR: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'รายงานการขาย (พนักงาน)',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          buildAppDivider(),
          Text(
            branch == "" ? _memberBLOC!.branch : branch,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
