import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'daily_employee_event.dart';
part 'daily_employee_state.dart';

class DailyEmployeeBloc extends Bloc<DailyEmployeeEvent, DailyEmployeeState> {
  DailyEmployeeBloc() : super(DailyEmployeeInitial()) {
    on<DailyEmployeeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDailyEmployee>((event, emit) async {
      await _getDailyEmployee(event, emit);
    });
  }

  Future<void> _getDailyEmployee(GetDailyEmployee event, Emitter emit) async {
    emit(DailyEmployeeWaiting());
    try {
      var model = await NetworkService()
          .getDailyBillEmployee(dbname: event.dbName)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw 'เชื่อมจ่อฐานข้อมูลล้มเหลว !';
      });
      emit(DailyEmployeeSuccess(model: model));
    } catch (e) {
      emit(DailyEmployeeError(errMsg: e.toString()));
    }
  }
}
