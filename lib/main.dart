import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/provider/bloc/bloc_observer.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/inventory/product_inventory_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/management/product_manager_bloc.dart';
import 'package:posapp_v2/provider/bloc/register/register_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/bill/daily_bill_main_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/bill_details/daily_bill_details_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/employee/daily_employee_bloc.dart';
import 'package:posapp_v2/provider/bloc/report/summary/daily_sale_rpt_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<MemberBloc>(create: (context) => MemberBloc()),
        BlocProvider<DailySaleRptBloc>(create: (context) => DailySaleRptBloc()),
        BlocProvider<ProductInventoryBloc>(
            create: (context) => ProductInventoryBloc()),
        BlocProvider<DailyEmployeeBloc>(
            create: (context) => DailyEmployeeBloc()),
        BlocProvider<DailyBillDetailsBloc>(
            create: (context) => DailyBillDetailsBloc()),
        BlocProvider<DailyBillMainBloc>(
            create: (context) => DailyBillMainBloc()),
        BlocProvider<ProductManagerBloc>(
            create: (context) => ProductManagerBloc()),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
      ],
      child: MaterialApp(
        title: 'MPOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Kanit',
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
