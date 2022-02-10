part of 'daily_sale_rpt_bloc.dart';

@immutable
abstract class DailySaleRptState {}

class DailySaleRptInitial extends DailySaleRptState {}

class DailySaleRptWaiting extends DailySaleRptState {}

class DailySaleRptLoadError extends DailySaleRptState {
  final String errMsg;

  DailySaleRptLoadError({required this.errMsg});
}

class DailySaleRptLoadSuccess extends DailySaleRptState {
  final List<DailySaleRptModel> model;

  DailySaleRptLoadSuccess({required this.model});
}