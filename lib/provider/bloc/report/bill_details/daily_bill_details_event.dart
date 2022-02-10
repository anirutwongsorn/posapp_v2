part of 'daily_bill_details_bloc.dart';

@immutable
abstract class DailyBillDetailsEvent {}

class GetDailyBillDetails extends DailyBillDetailsEvent {
  final String dbName;
  final String billCd;

  GetDailyBillDetails({required this.dbName, required this.billCd});
}
