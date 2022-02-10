part of 'daily_employee_bloc.dart';

@immutable
abstract class DailyEmployeeState {}

class DailyEmployeeInitial extends DailyEmployeeState {}

class DailyEmployeeWaiting extends DailyEmployeeState {}

class DailyEmployeeError extends DailyEmployeeState {
  final String errMsg;

  DailyEmployeeError({required this.errMsg});
}

class DailyEmployeeSuccess extends DailyEmployeeState {
  final List<WorkOrderMain> model;

  DailyEmployeeSuccess({required this.model});
}
