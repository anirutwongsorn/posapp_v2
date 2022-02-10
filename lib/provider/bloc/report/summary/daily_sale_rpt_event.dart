part of 'daily_sale_rpt_bloc.dart';

@immutable
abstract class DailySaleRptEvent {}

class GetDailySaleReport extends DailySaleRptEvent {
  final String dbName;

  GetDailySaleReport({required this.dbName});
}

class ResetDailySaleState extends DailySaleRptEvent {}
