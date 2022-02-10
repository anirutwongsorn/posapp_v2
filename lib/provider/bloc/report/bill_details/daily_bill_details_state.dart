part of 'daily_bill_details_bloc.dart';

@immutable
abstract class DailyBillDetailsState {}

class DailyBillDetailsInitial extends DailyBillDetailsState {}

class DailyBillDetailsWaiting extends DailyBillDetailsState {}

class DailyBillDetailsLoadError extends DailyBillDetailsState {
  final String errMsg;

  DailyBillDetailsLoadError({required this.errMsg});
}

class DailyBillDetailsLoadSuccess extends DailyBillDetailsState {
  final List<WorkOrderMain> model;

  DailyBillDetailsLoadSuccess({required this.model});
}