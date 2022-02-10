part of 'daily_bill_main_bloc.dart';

@immutable
abstract class DailyBillMainState {}

class DailyBillMainInitial extends DailyBillMainState {}

class DailyBillMainWaiting extends DailyBillMainState {}

class DailyBillMainLoadError extends DailyBillMainState {
  final String errMsg;

  DailyBillMainLoadError({required this.errMsg});
}

class DailyBillMainLoadSuccess extends DailyBillMainState {
  final List<WorkOrderMain> model;

  DailyBillMainLoadSuccess({required this.model});
}
