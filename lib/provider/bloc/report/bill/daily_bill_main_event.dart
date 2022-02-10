part of 'daily_bill_main_bloc.dart';

@immutable
abstract class DailyBillMainEvent {}

class GetDailyBillMain extends DailyBillMainEvent {
  final String dbName;

  GetDailyBillMain({required this.dbName});
}

class ResetBillMainState extends DailyBillMainEvent {}
