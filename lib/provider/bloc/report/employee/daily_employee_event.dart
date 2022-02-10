part of 'daily_employee_bloc.dart';

@immutable
abstract class DailyEmployeeEvent {}

class GetDailyEmployee extends DailyEmployeeEvent {
  final String dbName;

  GetDailyEmployee({required this.dbName});
}
